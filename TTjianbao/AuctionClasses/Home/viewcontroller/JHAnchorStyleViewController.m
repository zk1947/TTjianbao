//
//  JHAnchorStyleViewController.m
//  TTjianbao
//
//  Created by mac on 2019/7/30.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAnchorStyleViewController.h"
#import "JHLiveWarnningViewController.h"
#import "JHPublishChannelTableViewCell.h"
#import "TTjianbaoBussiness.h"
#import "JXCategoryView.h"
#import "JHAnchorStyleListViewController.h"
#import "NSString+Common.h"
#import "JHGemmologistViewController.h"
#import "NTESAudienceLiveViewController.h"
#import "MBProgressHUD.h"

@interface JHAnchorStyleViewController ()<JXCategoryListContainerViewDelegate,JXCategoryViewDelegate>


@property (nonatomic, strong) NSMutableArray<JHRecommendAppraiserListModel *> *dataList;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) JXCategoryTitleView  *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) JHActionBlock refreshBlock;
@property (nonatomic, copy) JHActionBlock selectCellBlock;
//! 申请鉴定回调
@property (nonatomic, copy) JHActionBlock applyAuthenticateBlock;

@end

@implementation JHAnchorStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self  initToolsBar];
//    [self.navbar setTitle:@"选择鉴定师"];
//    self.view.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:[UIImage imageNamed:@"Custom Preset.png"] withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.navbar addrightBtn:@"提醒管理" withImage:nil withHImage:nil withFrame:CGRectMake(ScreenW-80,0,70,44)];
//    self.navbar.rightBtn.hidden = YES;
//    [self.navbar.rightBtn addTarget :self action:@selector(openLive) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"选择鉴定师"; //背景色有差异
    [self initRightButtonWithName:@"提醒管理" action:@selector(openLive)];
    [self.jhRightButton setHidden:YES];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
    [self initCategoryView];
   
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:self.fromSource ? : @"" forKey:@"from"];
    [JHGrowingIO trackPublicEventId:JHIdentifyActivityChooseFrom paramDict:dic];
    
    @weakify(self);
    self.refreshBlock = ^(id obj) {
        @strongify(self);
        [self recommendAppraiserList];
    };
    self.selectCellBlock = ^(id obj) {
        @strongify(self);
        [self getDetail:(NSString*)obj isAppraisal:NO];
    };
    self.applyAuthenticateBlock = ^(id obj) {
        @strongify(self);
        [self getDetail:(NSString*)obj isAppraisal:YES];
    };
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UserInfoRequestManager sharedInstance] getApplyMicInfoComplete:^{
        JHAnchorStyleListViewController *vc = (JHAnchorStyleListViewController *)[_listContainerView.validListDict objectForKey:@(_categoryView.selectedIndex)];
        [vc reloadData];
    }];
    
    //用户画像浏览时长:begin
    [JHUserStatistics noteEventType:kUPEventTypeIdentifyChooseListBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //用户画像浏览时长:end
    [JHUserStatistics noteEventType:kUPEventTypeIdentifyChooseListBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd}];
}

-(void)initCategoryView{
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight-1, ScreenW, 1)];
    shadowView.backgroundColor = UIColor.whiteColor;
    shadowView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0,2);
    shadowView.layer.shadowOpacity = 1;
    shadowView.layer.shadowRadius = 5;
    shadowView.layer.cornerRadius = 8;
    
    CGFloat categoryHeight = 54;
    //view
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerView.frame = CGRectMake(0, UI.statusAndNavBarHeight+categoryHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight-categoryHeight);
    self.listContainerView.hidden = YES;
    
    //categoryview
    JXCategoryTitleView *categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, ScreenW, categoryHeight)];
    categoryView.listContainer = self.listContainerView;
    categoryView.delegate = self;
    categoryView.titleColor = kColor666;
    categoryView.titleFont = [UIFont fontWithName:kFontNormal size:15];
    categoryView.titleSelectedColor = kColor333;
    categoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:15];
    categoryView.backgroundColor = [UIColor colorWithRGB:0XF5F6FA];
    categoryView.hidden = YES;
    self.categoryView = categoryView;
    
    JXCategoryIndicatorBackgroundView *indicatorView = [[JXCategoryIndicatorBackgroundView alloc] init];
    indicatorView.indicatorWidthIncrement = 26; //背景色块的额外宽度
    indicatorView.indicatorHeight = 26;
    indicatorView.indicatorCornerRadius = 13;
    indicatorView.indicatorColor = kColorMain;
    self.categoryView.indicators = @[indicatorView];

    [self.view insertSubview:shadowView belowSubview:self.jhNavView];
    [self.view insertSubview:self.categoryView belowSubview:shadowView];
    [self.view addSubview:self.listContainerView];
    [self recommendAppraiserList];
}

- (void)openLive {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            
        }];

        return;
    }
    
    
    JHLiveWarnningViewController *vc = [[JHLiveWarnningViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JXCategoryListContainerViewDelegate

-(id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    JHAnchorStyleListViewController *vc = [JHAnchorStyleListViewController new];
    vc.height = listContainerView.height;
    vc.selectCellBlock = self.selectCellBlock;
    vc.applyAuthenticateBlock = self.applyAuthenticateBlock;
    vc.refreshBlock = self.refreshBlock;
    vc.dataSource = [self.dataList objectAtIndex:index].recommendAppraiserInfoVoList;
    return vc;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
    
       NSString* tabName = [self.dataList objectAtIndex:index].tag;
    [JHGrowingIO trackEventId:JHIdentifyActivityChooseTabClick variables:@{@"TABname":tabName ? :@""}];
    
}
//- (BOOL)listContainerView:(JXCategoryListContainerView *)listContainerView canInitListAtIndex:(NSInteger)index {
//    if (index != self.currentIndex) {
//        self.currentIndex = index;
//        JHAnchorStyleListViewController *vc = (JHAnchorStyleListViewController *)[listContainerView.validListDict objectForKey:@(index)];
//        vc.selectCellBlock = self.selectCellBlock;
//        vc.applyAuthenticateBlock = self.applyAuthenticateBlock;
//        vc.refreshBlock = self.refreshBlock;
//        vc.dataSource = [self.dataList objectAtIndex:index].recommendAppraiserInfoVoList;
//        NSString* tabName = [self.dataList objectAtIndex:index].tag;
//        [JHGrowingIO trackEventId:JHIdentifyActivityChooseTabClick variables:@{@"TABname":tabName ? :@""}];
//    }
//    return YES;
//}

- (void)recommendAppraiserList {
    [SVProgressHUD show];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/channel/recommendAppraiserList") Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.dataList = [JHRecommendAppraiserListModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        
        NSMutableArray *titles = @[].mutableCopy;
        for (JHRecommendAppraiserListModel *model in self.dataList) {
            [titles addObject:model.tag];
        }
        self.titles = titles;
        self.categoryView.titles = titles;
        self.currentIndex = 0;
        self.categoryView.hidden = self.listContainerView.hidden = (self.dataList.count == 0);
        [self.categoryView reloadData];
        [SVProgressHUD dismiss];
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message];
        [SVProgressHUD dismiss];

    }];
}

-(void)getDetail:(NSString *)channelLocalId isAppraisal:(BOOL)isAppraisal {
    
    //crash判空处理,目前逻辑,如果异常可以return
    if([NSString isEmpty:channelLocalId])
        return;
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(channelLocalId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];

        if ([channel.status integerValue]==2)
        {
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.channel=channel;
            vc.applyApprassal=isAppraisal;
            vc.coverUrl = channel.coverImg;
         __block  NSInteger currentSelectIndex=0;
            vc.fromString = JHLiveFromhomeIdentify;

            NSArray *arr = [self.dataList objectAtIndex:0].recommendAppraiserInfoVoList;
            NSMutableArray * channelArr=[NSMutableArray array];
            
            for (JHRecommendAppraiserListItem * model in arr) {
                //直播中
                if (model.state == 1){
                    JHLiveRoomMode * channel = [[JHLiveRoomMode alloc] init];
                    channel.ID = model.channelId;
                    channel.coverImg = model.smallCoverImg;
                    [channelArr addObject:channel];
                }
                
            }
            [channelArr enumerateObjectsUsingBlock:^(JHLiveRoomMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj.ID isEqual:channel.channelLocalId]) {
                    currentSelectIndex=idx;
                    * stop=YES;
                }
            }];
            vc.currentSelectIndex=currentSelectIndex;
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
         
        
    } failureBlock:^(RequestModel *respondObject) {
      
        [MBProgressHUD  hideHUDForView:self.view animated:YES];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)dealloc {
    NSLog(@"%@*************被释放",[self class])
}
@end
