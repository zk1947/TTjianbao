//
//  JHHomeViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2019/2/22.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "JHAnniversaryBagView.h"
#import "JHHomeViewController.h"
#import "JHHomeCollectionViewCell.h"
#import "NTESAudienceLiveViewController.h"
#import "NTESLiveManager.h"
#import "JHWebViewController.h"
#import "JHGemmologistViewController.h"
#import "JHReportViewController.h"
#import "JHLiveRecordViewController.h"
#import "JHHomeAppraisalAnchorView.h"
#import "JHCouponListView.h"
#import "JHHomeHeaderView.h"
#import "JHAppraiseVideoViewController.h"
#import "JHHomeCollectionViewFlowLayout.h"
#import "JHAnchorStyleViewController.h"
#import "ChannelMode.h"
#import "AppraisalVideoRecordMode.h"
#import "VideoCateMode.h"
#import "JHLiveRoomMode.h"
#import "TTjianbaoUtil.h"
#import "JHStonePopViewHeader.h"
#import "GrowingManager.h"
#import "NSString+Common.h"
#import "JHMaskingManager.h"

#import "JHNimNotificationManager.h"
#import "JHMaskPopWindow.h"
#import "JHDefaultCollectionViewCell.h"
#import "JHAppAlertViewManger.h"
#import "JHCustomerInfoController.h"

#define pagesize 10
#define cellRate (float) 1334.f/750.f //240/170
#define bannerrate (float)70/355
#define topImageRate (float) 200/345
#define smallImageRate (float) 91/126
#define headerSegmentHeight 52
#define kDefaultHeaderHeight ((ScreenW-20)*topImageRate+10+5+(ScreenW-10-5-5)/2.5*smallImageRate+30+10+40+161)

@interface JHHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
     NSInteger PageNum;
     NSInteger headerHeight;
     RequestModel *resObject;
     BOOL isLoadCacheDataComplete;
     JHHomeHeaderMainAnchorView * lastAnchourView;
     BOOL  showDefaultImage;
     BOOL isActiveTheme;
}
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong) JHChannelData* channelData;
@property(nonatomic,strong) NSString* cateId;
@property(nonatomic,strong) NSMutableArray* appraisalVideoModes;
@property(nonatomic,strong) NSMutableArray* bannerModes;
@property(nonatomic,strong) JHHomeCollectionViewFlowLayout * customLayout;
@property(nonatomic,strong)  JHHomeHeaderView *headerView;
@property(nonatomic,strong)  JHHomeHeaderSegmentView *headerSegmentView;
@property(nonatomic,assign)  BOOL disableClick;
@property(nonatomic,assign)  NSInteger currentSelectIndex;

@end

@implementation JHHomeViewController
static NSString *const cellId = @"cellId";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";
- (instancetype)init{
    if (self = [super init]) {
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshThemeView:) name:kCelebrateRunningOrNotNotification object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHomePageActivityBtn) name:HomePageActivityABtnNotifaction object:nil];
        
    }
    return self;
}

-(void)showHomePageActivityBtn{
    User *user = [UserInfoRequestManager sharedInstance].user;
    if (user.type != 1 &&user.type != 2) {
        [self showActivityImage];
         [self.activityImage setImageWithURL:[NSURL URLWithString:[UserInfoRequestManager sharedInstance].homeActivityMode.homeActivityIcon.imgUrl] placeholder:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   // [self  pullStream];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    ///更新当前申请鉴定排麦位次
    [self getApplyMicInfo];
    
    [JHAppAlertViewManger showSuperRedPacketEnterWithSuperView:self.view];
    [JHAppAlertViewManger setShowSuperRedPacketEnterWithTop:ScreenH - 250];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self shutdown];
    lastAnchourView=nil;
    if ([JHMaskPopWindow defaultWindow].isPop) {
        [JHMaskPopWindow dismiss];
    }
}

-(void)getApplyMicInfo {
    [[UserInfoRequestManager sharedInstance] getApplyMicInfoComplete:^{
        [self.headerView updateAppraise];
    }];
   
}

- (void)viewDidLoad {
  
    [super viewDidLoad];
    headerHeight=kDefaultHeaderHeight;
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];

//    [self  initToolsBar];
//    self.navbar.ImageView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8];
//    [self.navbar addNavImage:[UIImage imageNamed:@"nav_title_appraisal"]];
//    [self.navbar setSpecialTitle:@"在线鉴定"];
    self.title = @"在线鉴定"; //背景色有差异
    PageNum=0;

    [self.collectionView addSubview:self.headerView];
    [self.collectionView addSubview:self.headerSegmentView];
    
    [self showBackTopImage];
    [self.backTopImage setHidden:YES];
    [self createAddMsgBtn];
    [self requestBanners];
    //用户画像浏览时长:begin
    if(![JHUserStatistics hasResumeBrowseEvent])
    {
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyHomeBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin} resumeBrowse:YES];
    }
}

- (void)trackUserProfilePage:(BOOL)isBegin
{
    if(isBegin)
    {
        //用户画像浏览时长:begin
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyHomeBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin} resumeBrowse:YES];
    }
    else
    {
        //用户画像浏览时长:end
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyHomeBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd} resumeBrowse:YES];
    }
}

- (void)refreshThemeView:(NSNotification*)notify
{
    NSNumber* isActivityTheme =(NSNumber*)notify.object;
    isActiveTheme = [isActivityTheme boolValue];
//    [self drawCelebrateTag];
    [self.headerView refreshThemeView:isActiveTheme];
}

-(void)loadHeaderCates{
    __block  NSArray  *arr;
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
             NSData * data=[FileUtils readDataFromFile:CateData];
             if (data) {
                 arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 if ([arr isKindOfClass:[NSArray class]]) {
                     if (arr.count>0) {
                        NSArray *cateArr=[VideoCateMode mj_objectArrayWithKeyValuesArray:arr];
                        [self.headerSegmentView setUpSegmentView:cateArr];
                         VideoCateMode *catemode=cateArr[0];
                         self.cateId=catemode.ID;
                         [self loadCacheData];
                     }
                 }
                 else{
                     JH_WEAK(self)
                     [[ UserInfoRequestManager sharedInstance]getVideoCate:^(RequestModel *respondObject) {
                         JH_STRONG(self)
                         NSArray *cateArr=[VideoCateMode mj_objectArrayWithKeyValuesArray:respondObject.data];
                         [self.headerSegmentView setUpSegmentView:cateArr];
                         if (cateArr.count>0) {
                             VideoCateMode *catemode=cateArr[0];
                             self.cateId=catemode.ID;
                            [self loadCacheData];
                         }

                     }];
                 }
                 //用户画像浏览时长:begin
                 [JHUserStatistics noteEventType:kUPEventTypeIdentifyVideoListBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin, @"group_id" : self.cateId ? : @""}];
             });
         });
}
-(void)loadCacheData{

    __block  NSArray  *arr;
    __block  NSDictionary  *dic;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData * data=[FileUtils readDataFromFile:AppraisalLivesData];
        if (data) {
          dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
        NSData  *listData=[FileUtils readDataFromFile:AppraisalRecordData];
        if (listData) {
            arr= [NSJSONSerialization JSONObjectWithData:listData options:NSJSONReadingMutableContainers error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic isKindOfClass: [NSDictionary class]]) {
                self.channelData=[JHChannelData mj_objectWithKeyValues: dic];
                [self.headerView setChanneData:self.channelData isCacheData:YES];
            }
            if ([arr isKindOfClass:[NSArray class]]) {
                   [self handleDataWithArr:arr];
            }
           //
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                   [self.collectionView.mj_header beginRefreshing];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableBarSelect:) name:TableBarSelectNotifaction object:nil];
                });
            });
            
        });
    });
}
- (void)loadNewData{
    
     PageNum=0;
    dispatch_group_t  group = dispatch_group_create();
     dispatch_group_enter(group);
     dispatch_group_enter(group);
    [self requestChannels:^{
        dispatch_group_leave(group);
    }];
    [self requestInfo:^{
        dispatch_group_leave(group);
    }];
     dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"完成!");
         [self.collectionView.mj_header endRefreshingWithCompletionBlock:^{
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_hOME_SCROLLVIEW_STOP_STATUS object:@YES];
             if (self.player) {
                [self shutdown] ;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     lastAnchourView=nil;
                     [self.headerView setChanneData:self.channelData isCacheData:NO];
                     [self handleDataWithArr:resObject.data];
                     [self pullStream];
                     self.shutdownHandler = nil;
                 });
             }
             else{
                 [self.headerView setChanneData:self.channelData isCacheData:NO];
                 [self handleDataWithArr:resObject.data];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     dispatch_async(dispatch_get_main_queue(), ^{
                       [self pullStream];
                     });
                 });
             }
         }];

    });
    
    //用户画像埋点
    [JHUserStatistics noteEventType:kUPEventTypeIdentifyHomeEntrance params:nil];
}
-(void)loadMoreData{
    
     PageNum++;
    [self requestInfo:^{
        [self endRefresh];
        [self handleDataWithArr:resObject.data];
    }];
}

- (void)requestBanners{
  
    [HttpRequestTool getWithURL: COMMUNITY_FILE_BASE_STRING(@"/ad/3") Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        self.bannerModes=[NSMutableArray arrayWithCapacity:10];
        self.bannerModes = [BannerCustomerModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        if (self.bannerModes.count>0){
            headerHeight+=(ScreenW-20)*bannerrate;
            self.customLayout.headerHeight=headerHeight+headerSegmentHeight;
            self.headerView.mj_h=headerHeight;
            self.headerSegmentView.y=headerHeight;
            [self.collectionView reloadData];
            [self.headerView setBanners:self.bannerModes];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}
-(void)requestInfo:(JHFinishBlock)complete{
    
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/appraiseRecord/video/authoptional?pageNo=%ld&pageSize=%ld&cateId=%@"),PageNum,pagesize,self.cateId];
    
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        resObject=respondObject;
        if (PageNum==0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                if ([FileUtils writeDataToFile:AppraisalRecordData data:[NSJSONSerialization dataWithJSONObject:resObject.data options:NSJSONWritingPrettyPrinted error:nil]]) {
                    NSLog(@"写入成功");
                }
            });
        }
         complete();
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        resObject=nil;
        complete();
    }];
}
-(void)requestChannels:(JHFinishBlock)complete{
    
    //
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/channel/all/appraise/authoptional") Parameters:nil successBlock:^(RequestModel *respondObject) {
          self.channelData = [JHChannelData mj_objectWithKeyValues: respondObject.data];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            if ([FileUtils writeDataToFile:AppraisalLivesData data:[NSJSONSerialization dataWithJSONObject:respondObject.data options:NSJSONWritingPrettyPrinted error:nil]]) {
                NSLog(@"写入成功");
            }
        });
        
           complete();
        
    } failureBlock:^(RequestModel *respondObject) {
          complete();
    }];
}
- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr = [AppraisalVideoRecordMode mj_objectArrayWithKeyValuesArray:array];
    NSMutableArray *models = [NSMutableArray array];
    int i = 0;
    for (AppraisalVideoRecordMode *model in arr) {
        CellSizeModel *size = [[CellSizeModel alloc] init];
        size.width = (ScreenW-25)/2.;
        size.height = [JHHomeCollectionViewCell heightCellWithModel:model];
        [models addObject:size];
        i++;
    }
    if (PageNum == 0) {
          self.appraisalVideoModes = [NSMutableArray arrayWithArray:arr];
        _customLayout.iconArray = models;

    }else {
        [self.appraisalVideoModes addObjectsFromArray:arr];
        [_customLayout.iconArray addObjectsFromArray:models];
    }
    
    
    
    if (self.appraisalVideoModes.count==0) {
        showDefaultImage=YES;
        CellSizeModel *size = [[CellSizeModel alloc] init];
        size.height = ScreenH;
        size.width = ScreenW;
        _customLayout.iconArray = @[size].mutableCopy;
    }
    else{
         showDefaultImage=NO;
    }
    _customLayout.showDefaultImage = showDefaultImage;
    
    
    if ([arr count]<pagesize) {
        
        self.collectionView.mj_footer.hidden=YES;
    }
    else{
        
        self.collectionView.mj_footer.hidden=NO;
    }
        
    [self.collectionView reloadData];

    
}
- (void)endRefresh {
    
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}
//MARK: get
//
//- (TLSwipeAnimator *)swipeAnimator{
//    if (!_swipeAnimator) {
//        _swipeAnimator = [TLSwipeAnimator animatorWithSwipeType:TLSwipeTypeInAndOut pushDirection:TLDirectionToLeft popDirection:TLDirectionToRight];
//        _swipeAnimator.transitionDuration = 0.25f;
//    }
//
//    return _swipeAnimator;
//
//}

- (JHHomeHeaderSegmentView *)headerSegmentView {
    if (!_headerSegmentView) {
        _headerSegmentView = [[JHHomeHeaderSegmentView alloc] initWithFrame:CGRectMake(0, headerHeight, ScreenW, headerSegmentHeight)];
        MJWeakSelf
        _headerSegmentView.clickeHeader = ^(VideoCateMode *catemode) {
            __strong typeof(weakSelf) sself = weakSelf;
            if(catemode.type == kHeaderTypeCateButton)
            {
                //展开分类
            }
            else {
                sself->PageNum=0;
                //用户画像浏览时长:end 「推荐页面创建,就记录第一个tab开始事件」
                [JHUserStatistics noteEventType:kUPEventTypeIdentifyVideoListBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd, @"group_id" : weakSelf.cateId ? : @""}];
                weakSelf.cateId=catemode.ID;
                [weakSelf requestInfo:^{
                    [weakSelf endRefresh];
                    [weakSelf handleDataWithArr:sself->resObject.data];
                }];
                //用户画像浏览时长:begin
                [JHUserStatistics noteEventType:kUPEventTypeIdentifyVideoListBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin, @"group_id" : weakSelf.cateId ? : @""}];
            }
        };

    }
    return _headerSegmentView;
}

///进入选择鉴定师界面
- (void)enterArchorStylePage {
    JHMicWaitMode *model = [JHNimNotificationManager sharedManager].micWaitMode;
    if (model && model.isWait) {
        if(0)
        {
            ///正在申请连麦中 点击跳转到对应直播间
            [JHRootController EnterLiveRoom:model.waitChannelLocalId fromString:JHEventOnlineauthenticate];
        }
        else
        {
            [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(model.waitChannelLocalId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
                ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
                NSString* httpPullUrl = channel.httpPullUrl;
                if([channel.status integerValue] != 2)
                {
                    httpPullUrl = nil;
                }
                NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:httpPullUrl];
                vc.channel=channel;
                vc.applyApprassal=NO;
                vc.coverUrl = channel.coverImg;
                vc.fromString = JHEventOnlineauthenticate;
                [self.tabBarController.navigationController pushViewController:vc animated:YES];
            } failureBlock:^(RequestModel *respondObject) {
            }];
        }
    }
    else {
        JHAnchorStyleViewController *vc = [[JHAnchorStyleViewController alloc] init];
        vc.fromSource = @"appraisePage";
//        @weakify(self);
//        vc.selectCellBlock = ^(NSString *roomId) {
//            @strongify(self);
//            [self getLiveRoomDetail:roomId isAppraisal:NO];
//        };
//
//        vc.applyAuthenticateBlock = ^(NSString *roomId){
//            @strongify(self);
//            [self getLiveRoomDetail:roomId isAppraisal:YES];
//            [JHGrowingIO trackEventId:JHIdentifyActivityChooseApplyClick];
//        };
        
        self.currentSelectIndex = 0;
        [self.navigationController pushViewController:vc animated:YES];
        [JHGrowingIO trackEventId:JHClickFreeAppraiseBtn];
    }
}

-(JHHomeHeaderView*)headerView{
    if (!_headerView) {
        _headerView=[[JHHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, kDefaultHeaderHeight)];
        @weakify(self);
        _headerView.selectedCell = ^(id obj){
            @strongify(self);
            NSInteger index = [obj integerValue];
            self.currentSelectIndex=index;
            //做判断
            JHLiveRoomMode *model = [self.channelData.channels objectAtIndex:index];
            if([model.canCustomize isEqualToString:@"1"]){
                if(model.status.intValue == 2){
                    [self getLiveRoomDetail:model.ID isAppraisal:NO];
                }else{
                    //定制直播间跳定制主页(在线鉴定)
                    JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
                    vc.roomId = model.roomId;
                    vc.anchorId = model.anchorId;
                    vc.channelLocalId = model.channelLocalId;
                    vc.fromSource = @"";
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                [self getLiveRoomDetail:model.ID isAppraisal:NO];
            }
        };
        _headerView.selectLiveBlock = ^{
            @strongify(self);
            [self enterArchorStylePage];
        };
    }
    return _headerView;
}
-(UICollectionView*)collectionView {
    if (!_collectionView) {
//        _customLayout =         [[JHHomeCollectionViewFlowLayout alloc] init];
        _customLayout = [[JHHomeCollectionViewFlowLayout alloc] initWithColoumn:2 data:@[].mutableCopy verticleMin:5 horizonMin:5 leftMargin:5 rightMargin:5 headerHeight:headerHeight];
        _customLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        _customLayout.sectionHeadersPinToVisibleBounds = YES;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,JHNavbarHeight, ScreenW, ScreenH-JHNavbarHeight) collectionViewLayout:_customLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0,JHSafeAreaBottomHeight+49, 0);
        _collectionView.backgroundColor = [CommHelp toUIColorByStr:@"#F5F6FA"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[JHHomeCollectionViewCell class] forCellWithReuseIdentifier:cellId];
        
        [_collectionView registerClass:[JHDefaultCollectionViewCell class] forCellWithReuseIdentifier:@"defaultcell"];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];

//        [_collectionView registerClass:[JHHomeHeaderSegmentView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
        
         // [_collectionView registerClass:[JHFooterDefaultView class]            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"JHFooterDefaultView"];
      
        @weakify(self);
        _collectionView.mj_header= [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self loadNewData];
        }];
        _collectionView.contentOffset = CGPointZero;
         _collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
         self.collectionView.mj_footer.hidden=YES;
        
    }
    return _collectionView;
    
}
//MARK:UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    if (showDefaultImage) {
         return  1;
    }
    return  self.appraisalVideoModes.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHHomeCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (showDefaultImage) {
      JHDefaultCollectionViewCell *defaultcell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"defaultcell" forIndexPath:indexPath];
        return defaultcell;
    }
    [cell setRecordMode:self.appraisalVideoModes[indexPath.row]];
    cell.cellIndex=indexPath.row;
    JH_WEAK(self)
   
    cell.cellClick = ^(BOOL isLaud, NSInteger index) {
        JH_STRONG(self)
        [self clickIndex:index isLaud:isLaud];
    };
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    view.layer.zPosition = 0.0;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
      
        if([kind isEqualToString:UICollectionElementKindSectionFooter])
        {
            UICollectionReusableView *view = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier: footerId forIndexPath:indexPath];
            return view;
        }
    }
    else{
        
        if([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
            
            UICollectionReusableView *view = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
            return view;
//            JHHomeHeaderSegmentView *view = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
//            MJWeakSelf
//            view.clickeHeader = ^(VideoCateMode *catemode) {
//                PageNum=0;
//                self.cateId=catemode.ID;
//                [weakSelf requestInfo:^{
//                    [weakSelf endRefresh];
//                    [weakSelf handleDataWithArr:resObject.data];
//                }];
//            };
//            return view;
        }
        
//        if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//
//            JHFooterDefaultView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"JHFooterDefaultView" forIndexPath:indexPath];
//
//            return view;
//
//        }
    }
   
    return nil;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout



//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (showDefaultImage) {
//         return (CGSize){self.view.width,350};
//    }
//    CGFloat heihgt = self.customLayout.iconArray[indexPath.row].height;
//    return (CGSize){(self.view.width-25)/2,heihgt};
//}
//
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,10,0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
   // return (CGSize){self.view.frame.size.width,headerHeight};
    if (section == 0) {
        
         return CGSizeMake(0, 0);
    }
    else{
        
          return  CGSizeMake(ScreenW, headerSegmentHeight);
    }
  
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        NSLog(@"headerHeight===%ld",headerHeight);
       return  CGSizeMake(ScreenW, headerHeight);
        
        
    }
    else{
        if (self.appraisalVideoModes.count > 0) {
            return  CGSizeMake(0, 0);
           
        }
         return  CGSizeMake(0, 0);
    }
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (showDefaultImage) {
        return;
    }
        
    JHAppraiseVideoViewController *vc = [[JHAppraiseVideoViewController alloc] init];
    vc.cateId = self.cateId;
    vc.from = JHLiveFromhomeIdentify;
    AppraisalVideoRecordMode *model = self.appraisalVideoModes[indexPath.row];
    vc.appraiseId = model.appraiseId;
    [self.navigationController pushViewController:vc animated:YES];

    
//
//    AppraisalVideoRecordMode* mode=self.appraisalVideoModes[indexPath.row];
//    JHReportViewController *vc = [[JHReportViewController alloc] init];
//    vc.appraiseRecordId = mode.appraiseId;
//    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (![self isRefreshing]) {
        if (lastAnchourView) {
            CGRect rect = [lastAnchourView convertRect:lastAnchourView.bounds toView:self.view];
            if (rect.origin.y<StatusBarH||rect.origin.y+rect.size.height>ScreenH-JHSafeAreaBottomHeight-49) {
                [self shutdown];
                lastAnchourView=nil;
            }
        }
    }

    if (scrollView.contentOffset.y>headerHeight) {
        self.headerSegmentView.mj_y = StatusBarAddNavigationBarH;
         self.headerSegmentView.backColor=HEXCOLOR(0xFFFFFF);
        [self.view addSubview:self.headerSegmentView];
    }else {
        self.headerSegmentView.mj_y = headerHeight;
        self.headerSegmentView.backColor = kColorF5F6FA;
        [self.collectionView addSubview:self.headerSegmentView];
    }

    [JHHomeTabController changeStatusWithMainScrollView:self.collectionView index:3];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_hOME_SCROLLVIEW_STOP_STATUS object:@NO];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        if (![self isRefreshing]) {
            [self  pullStream];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_hOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (![self isRefreshing]) {
        [self  pullStream];
    }
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_hOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }

}

-(BOOL)isRefreshing{
    
    if ([self.collectionView.mj_header isRefreshing]||self.collectionView.mj_header.state== MJRefreshStatePulling||[self.collectionView.mj_footer isRefreshing]||self.collectionView.mj_footer.state== MJRefreshStatePulling) {
        
        return YES;
    }
    return NO;
}
-(void)pullStream{
    
    if (lastAnchourView) {
        CGRect rect = [lastAnchourView convertRect:lastAnchourView.bounds toView:self.view];
        if (rect.origin.y>=StatusBarH&&rect.origin.y+rect.size.height<=ScreenH-JHSafeAreaBottomHeight-49) {
            return ;
        }
    }
//    if ( ![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
//        return;
//    }
    JHHomeHeaderMainAnchorView * anchorView=[self.headerView getNearlyAnchorView];

    if (anchorView) {
        if (anchorView.liveRoomMode.ID!=lastAnchourView.liveRoomMode.ID&&
            [anchorView.liveRoomMode.status integerValue]==2&&!self.viewDisAppear) {
            JH_WEAK(self)
            [self startPlay:anchorView.liveRoomMode.rtmpPullUrl inView:anchorView.content andTimeEndBlock:^{
                JH_STRONG(self)
                [self shutdown];
                lastAnchourView=nil;
            }];
            lastAnchourView=anchorView;
        }
    }
}
-(void)getLiveRoomDetail:(NSString *)selectLiveRoomId isAppraisal:(BOOL)isAppraisal {
    
    if (self.disableClick) {
        return;
    }
    _disableClick = YES;
    [self shutdown];
    [self getDetail:selectLiveRoomId isAppraisal:isAppraisal];
}

-(void)getDetail:(NSString *)selectLiveRoomId isAppraisal:(BOOL)isAppraisal {
    
    //crash判空处理,目前逻辑,如果异常可以return
    if([NSString isEmpty:selectLiveRoomId])
        return;
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(selectLiveRoomId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        if ([channel.status integerValue]==2)
        {
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.channel=channel;
            vc.applyApprassal=isAppraisal;
            vc.coverUrl = channel.coverImg;
            self.currentSelectIndex=0;
            //TODO jiang
            vc.audienceUserRoleType = JHAudienceUserRoleTypeAppraise;
            vc.fromString = JHLiveFromhomeIdentify;

            NSMutableArray * channelArr=[self.channelData.channels mutableCopy];
            for (JHLiveRoomMode * mode in self.channelData.channels) {
                if ([mode.status integerValue]!=2) {
                    [channelArr removeObject:mode];
                }
            }
            [channelArr enumerateObjectsUsingBlock:^(JHLiveRoomMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj.ID isEqual:channel.channelLocalId]) {
                    self.currentSelectIndex=idx;
                    * stop=YES;
                }
            }];
            vc.currentSelectIndex=self.currentSelectIndex;
            vc.channeArr=channelArr;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else  {
            JHGemmologistViewController *vc = [[JHGemmologistViewController alloc] init];
            vc.pageFrom = JHPageFromAppraiseRoom;
            vc.anchorId=channel.anchorId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
            [MBProgressHUD  hideHUDForView:self.view animated:YES];
           _disableClick=NO;
        
    } failureBlock:^(RequestModel *respondObject) {
      
        _disableClick=NO;
        [MBProgressHUD  hideHUDForView:self.view animated:YES];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)clickIndex:(NSInteger)index isLaud:(BOOL)laud{
    
    if ([self isLgoin]) {
    AppraisalVideoRecordMode * mode=[self.appraisalVideoModes objectAtIndex:index];
        NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/video/auth/viewerChangeStatusNew?channelRecordId=%@&status=%@"),mode.recordId,laud?@"0":@"1"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"lauds"] = mode.lauds;
          [HttpRequestTool getWithURL:url Parameters:params successBlock:^(RequestModel *respondObject) {
              [SVProgressHUD dismiss];
              mode.isLaud=!laud;
              int count=[mode.lauds intValue];
              if (!laud) {
                   count=count+1;
                  mode.lauds=[NSString stringWithFormat:@"%d",count];
              }
              else{
                count=count-1;
                  mode.lauds=[NSString stringWithFormat:@"%d",count];
              }
          
    JHHomeCollectionViewCell *cell =(JHHomeCollectionViewCell*) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:1]];
            
      [cell beginAnimation:mode];

        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [UITipView showTipStr:respondObject.message];
        }];
      //  [SVProgressHUD show];
    }
}
-(BOOL)isLgoin{
    
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result){
                
            }
        }];
        return  NO;
    }
    
    return  YES;
}
-(void)tableBarSelect:(NSNotification*)note{
    
    BaseTabBarController * tablebar=(BaseTabBarController*)note.object;
    if ([self isRefreshing]){
        return;
    }
    if (tablebar.selectedIndex==3) {
        
            [self.collectionView setContentOffset:CGPointMake(0,0) animated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                   [self.collectionView.mj_header beginRefreshing];
                });
            });
    }
    else{
        [self.collectionView setContentOffset:CGPointMake(0,0) animated:NO];
    }
}
- (void)backTop:(UIGestureRecognizer *)gestureRecognizer {
    
    [self.collectionView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark -
#pragma mark - 打赏礼物相关 -

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isLoadCacheDataComplete) {
         [self loadHeaderCates];
        isLoadCacheDataComplete=YES;
    }
    
    [self judgeWetherNeedShowGift];
    
    [JHAnniversaryBagView show];
    
    [JHHomeTabController changeStatusWithMainScrollView:self.collectionView index:3];
}

- (void)judgeWetherNeedShowGift {
    ///显示礼物
    if (![JHRootController isLogin] &&
        [UserInfoRequestManager sharedInstance].anniversaryType == 1) {
        [JHUserDefaults setBool:NO forKey:kWetherGrantGiftKey];
        [JHUserDefaults synchronize];
        ///未登录
        if ([CommHelp isFirstTodayForName:kNewUserFirstGiftKey]) {
            ///第一次显示
            [self showGiftView];
        }
        return;
    }
    ///已登录 并且是今天第一次显示礼物
    if ([JHRootController isLogin] &&
        ![JHUserDefaults boolForKey:kWetherGrantGiftKey] &&
        ([CommHelp isFirstTodayForName:kNewUserFirstGiftKey] || ![JHUserDefaults boolForKey:kLoginedFirstGiftKey])) {
        [self judgeUserGift];
    }
}

///判断用户是否领取过红包
- (void)judgeUserGift {
    [[JHMaskingManager shareApiManager] getUserGiftInfo:^(BOOL isNeedGrant, NSString *message) {
        if (isNeedGrant) {
            [self showGiftView];
        }
    }];
}

///展示新人礼物弹窗
- (void)showGiftView {
    [JHMaskingManager showPopWindowWithType:JHMaskPopWindowTypeGift];
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

- (void)dealloc {
    NSLog(@"JHHomeViewController dealloc.....");
}

@end
