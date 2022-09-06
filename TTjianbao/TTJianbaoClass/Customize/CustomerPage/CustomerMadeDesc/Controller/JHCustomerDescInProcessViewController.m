//
//  JHCustomerDescInProcessViewController.m
//  TTjianbao
//
//  Created by user on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerDescInProcessViewController.h"
#import "JHCustomerDescPicCollectionViewCell.h"
#import "JHCustomizeDescStuffInfoCollectionViewCell.h"
#import "JHCustomerDescInstroCollectionViewCell.h"
#import "JHCustomerProcessTitleCollectionViewCell.h"
#import "JHCustomerCommentCollectionViewCell.h"
//#import "JHCustomizeDescBottomViewCollectionViewCell.h"

#import "JHCustomerDescNavView.h"
#import "JHCustomerDescBottomView.h"
#import "JHCustomerAddCommentInfoViewController.h"
#import "SVProgressHUD.h"
#import "HttpRequestTool.h"
#import "JHCustomerDescInProcessModel.h"
#import "IQKeyboardManager.h"
#import "UITipView.h"
#import "JHCustomerDescInProcessBusiness.h"
#import "JHCustomerInfoController.h"
#import "JHEasyInputTextView.h"
#import "JHSQManager.h"
#import "JHSQModel.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>
#import "UIView+JHGradient.h"
#import <AVKit/AVKit.h>
#import "JHImagePickerPublishManager.h"
#import "JHCustomizeCheckStuffDetailViewController.h"
#import "JHGrowingIO.h"
#import "GrowingManager.h"
#import "UIScrollView+JHEmpty.h"
#import "UIView+Toast.h"
#import "JHBaseOperationView.h"

/// player
#import "ZFPlayerController.h"
#import "YDPlayerControlView.h"
#import "UITapImageView.h"
#import "ZFPlayer.h"
#import "ZFUtilities.h"
#import "ZFAVPlayerManager.h"
#import "AdressManagerViewController.h"
#import "YDMediaCarousel.h"
#import "YDMediaData.h"



@interface JHCustomerDescInProcessViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView         *descCollectionView;
@property (nonatomic, strong) NSMutableArray           *dataSourceArray;
@property (nonatomic, strong) JHCustomerDescBottomView *bottomView;
@property (nonatomic, strong) JHCustomerDescNavView    *navView;
@property (nonatomic, strong) NSMutableArray           *commentArray;
@property (nonatomic, assign) BOOL                      canPraise; /// 是否可以点赞
@property (nonatomic, strong) JHCustomerProcessTitleCollectionViewCell *cell3;
@property (nonatomic, strong) NSMutableArray<JHPostData *>         *postArray;
@property (nonatomic, assign) NSInteger                             bcCustomizeCommentId;/// 补充信息CommentId
@property (nonatomic, strong) NSMutableArray                       *showImgArray;
@property (nonatomic,   copy) NSString                             *anchorId;/// 主播id
@property (nonatomic,   copy) NSString                             *roomId;/// 直播间id
@property (nonatomic,   copy) NSString                             *channelLocalId;//deeplink 跳转主播页
@property (nonatomic, assign) BOOL                                  isOrderByYes;
@property (nonatomic, strong) NSString                             *mStatus;
@property (nonatomic, assign) NSInteger                             worksId;
@property (nonatomic, assign) BOOL                                  canPublish;/// 是否可以发布
@property (nonatomic, strong) JHCustomerDetailVOInfoShareDataModel *shareDataVO;
@property (nonatomic, assign) NSInteger                             praiseNum; /// 点赞数
@property (nonatomic, assign) NSInteger                             showFlag;    /// 是否展示：0-隐藏、1-展示
@property (nonatomic, assign) BOOL                                  showHideFlag; /// 是否有隐藏按钮
@property (nonatomic, strong) NSString                             *addCommentFlag; /// 是否可以添加沟通信息 0 不可以 1 可以
@property (nonatomic, strong) NSArray<JHAttachmentVOModel *> *materialAttachments; /// 原料图片
@property (nonatomic, strong) NSArray<JHAttachmentVOModel *> *worksAttachments;    /// 完成图片


//播放器属性
@property (nonatomic, strong) ZFPlayerController  *player;
@property (nonatomic, strong) YDPlayerControlView *playerControl;
@property (nonatomic, strong) UITapImageView      *playerContainerView;
@property (nonatomic, strong) CGoodsImgInfo       *videoInfo;
@property (nonatomic, assign) BOOL                 preVideoPlaying;//记录滑出视频区域时的播放状态

@property (nonatomic, strong) JHCustomerDescPicCollectionViewCell *cell0;
//@property (nonatomic, strong) JHCustomizeDescBottomViewCollectionViewCell *bottomCell;
@end

@implementation JHCustomerDescInProcessViewController

- (void)dealloc {
    [self.navView removeNavSubViews];
    [self.navView moreViewRelease];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    self.isOrderByYes = NO;
    [self removeNavView];
    [self setupViews];
    [self loadDetailInfoData];
    [JHGrowingIO trackEventId:@"dz_xq_in" from:NONNULL_STR(self.from)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportDuration:) name:JHGrowingNotify_AllPageBrowseDuration object:nil];
}

- (void)reportDuration:(NSNotification *)no {
    NSDictionary *dict = no.userInfo;
    [JHGrowingIO trackPublicEventId:@"dz_xq_duration" paramDict:dict];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [self.navView removeNavSubViews];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)setupViews {
    [self.view addSubview:self.descCollectionView];
    [self.descCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight- 59);
    }];
    [self setupNav];
    [self setupBottomView];
}


- (CGFloat)navViewHeight {
    CGFloat navHeight = UI.statusBarHeight + 44.f;
    return navHeight;
}

- (void)setupNav {
    self.navView = [[JHCustomerDescNavView alloc] init];
    
    self.navView.userInteractionEnabled = YES;
    
    self.navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo([self navViewHeight]);
    }];
    @weakify(self);
    [self.navView customerDescNavViewBtnAction:^(JHCustomerDescNavButtonStyle style) {
        @strongify(self);
        switch (style) {
            case JHCustomerDescNavButtonStyle_Back: {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case JHCustomerDescNavButtonStyle_Share: {
                [JHGrowingIO trackPublicEventId:@"dz_xq_share_click" paramDict:@{
                    @"Id":self.customizeOrderId, /// 定制ID
                    @"orderType":NONNULL_STR(self.mStatus)   /// 状态
                }];
                [self.navView removeNavSubViews];
                [self share];
            }
                break;
            case JHCustomerDescNavButtonStyle_Hidden: {
                if (IS_LOGIN) {
                    [self hiddenInfo];
                }
            }
                break;
            default:
                break;
        }
    }];
}

- (void)share {
    /// 分享
    JHShareInfo* info = [JHShareInfo new];
    info.title = self.shareDataVO.title;
    info.desc  = self.shareDataVO.desc;
    info.shareType = ShareObjectTypeCustomizeNormal;
    info.url = self.shareDataVO.url;
    info.img = self.shareDataVO.img;
    [JHBaseOperationView showShareView:info objectFlag:nil];
}


- (void)hiddenInfo {
    [self.navView removeNavSubViews];
    NSString *hideFlag = @"0";
    if (!self.showFlag) {
        hideFlag = @"1";
    }

    @weakify(self);
    [JHCustomerDescInProcessBusiness hiddenRequest:self.worksId hideFlag:hideFlag Completion:^(NSError * _Nullable error, RequestModel * _Nullable respondObject) {
        if (error) {
            @strongify(self);
            [self.view makeToast:respondObject.message duration:2.0 position:CSToastPositionCenter];
        } else {
            @strongify(self);
            if (!self.showFlag) {
                [self.view makeToast:@"已成功取消隐藏，所有人可见" duration:2.0 position:CSToastPositionCenter];
                [self.navView setMoreStatus:NO];
                self.showFlag = YES;
            } else {
                [self.view makeToast:@"已成功设置隐藏，仅自己可见" duration:2.0 position:CSToastPositionCenter];
                [self.navView setMoreStatus:YES];
                self.showFlag = NO;
            }
        }
    }];

}

- (void)setupBottomView {
    self.bottomView = [[JHCustomerDescBottomView alloc] init];
    [self.view addSubview:self.bottomView];
    CGFloat bottomHeight = UI.bottomSafeAreaHeight;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(bottomHeight +59.f);
    }];
    self.bottomView.hidden = YES;
    @weakify(self);
    [self.bottomView customerDescBtnAction:^(JHCustomerDescBottomBtnStyle style) {
        @strongify(self);
        if (style == JHCustomerDescBottomBtnStyle_Fav) {
            if (![JHRootController isLogin]) {
                [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {}];
            } else {
                if (!self.canPraise) {
                    [self _handleUnLikeEvent];
                } else {
                    [self _handleLikeEvent];
                }
            }
        } else {
            /// 分享
            [JHGrowingIO trackPublicEventId:@"dz_xq_share_click" paramDict:@{
                @"Id":self.customizeOrderId, /// 定制ID
                @"orderType":NONNULL_STR(self.mStatus)   /// 状态
            }];
            [self share];
        }
    }];
}

- (UICollectionView *)descCollectionView {
    if (!_descCollectionView) {
        UICollectionViewFlowLayout *layout                 = [[UICollectionViewFlowLayout alloc] init];
//        layout.minimumInteritemSpacing                     = 0.f;
        layout.minimumLineSpacing                          = 0.f;
        layout.scrollDirection                             = UICollectionViewScrollDirectionVertical;
        /// layout约束这边必须要用estimatedItemSize才能实现自适应,使用itemSzie无效
        layout.estimatedItemSize                           = CGSizeMake(kScreenWidth, 17.f);
        _descCollectionView                                = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _descCollectionView.backgroundColor                = HEXCOLOR(0xF5F6FA);
        _descCollectionView.delegate                       = self;
        _descCollectionView.dataSource                     = self;
        _descCollectionView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 10.0, *)) {
            _descCollectionView.prefetchingEnabled = NO;
        }
        if (@available(iOS 11.0, *)) {
            _descCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_descCollectionView registerClass:[JHCustomerDescPicCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCustomerDescPicCollectionViewCell class])];
        [_descCollectionView registerClass:[JHCustomizeDescStuffInfoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCustomizeDescStuffInfoCollectionViewCell class])];
        [_descCollectionView registerClass:[JHCustomerDescInstroCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCustomerDescInstroCollectionViewCell class])];
        [_descCollectionView registerClass:[JHCustomerProcessTitleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCustomerProcessTitleCollectionViewCell class])];
        [_descCollectionView registerClass:[JHCustomerCommentCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCustomerCommentCollectionViewCell class])];
//        [_descCollectionView registerClass:[JHCustomizeDescBottomViewCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCustomizeDescBottomViewCollectionViewCell class])];
        
    }
    return _descCollectionView;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)showImgArray {
    if (!_showImgArray) {
        _showImgArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _showImgArray;
}

- (void)loadDetailInfoData {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD show];
    [self.navView changeNavBackBlack:NO];
    NSString *url = FILE_BASE_STRING(@"/anon/appraisal/customizeWorks/findDetail");
    NSDictionary *parameters = @{
        @"customizeOrderId":NONNULL_STR(self.customizeOrderId)
    };
    @weakify(self);
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel *respondObject) {
        [JHDispatch ui:^{
            @strongify(self);
            [SVProgressHUD dismiss];
            if (!respondObject.data) {
                NSLog(@"错误页面");
                [self.descCollectionView jh_reloadDataWithEmputyView];
                [self.navView changeNavBackBlack:NO];
                return;
            }
            [self.navView changeNavBackBlack:YES];
            self.bottomView.hidden = NO;
            JHCustomizeDetailVOModel *detailModel = [JHCustomizeDetailVOModel mj_objectWithKeyValues:respondObject.data];
            self.worksId        = detailModel.worksId;
            self.canPraise      = detailModel.canPraise;
            self.shareDataVO    = detailModel.shareDataVO;
            self.canPublish     = detailModel.canPublish;
            self.isOrderByYes   = detailModel.orderBy;
            self.praiseNum      = detailModel.praiseNum;
            self.showFlag       = detailModel.showFlag;
            [self.navView setMoreStatus:!self.showFlag];
            
            self.showHideFlag   = detailModel.showHideFlag;
            [self.navView showHiddenButton:self.showHideFlag];
            
            self.addCommentFlag = detailModel.addCommentFlag;
            self.materialAttachments = detailModel.materialAttachments;
            self.worksAttachments = detailModel.worksAttachments;
            [self.bottomView setFavBtnStatus:!self.canPraise];
            [self.bottomView setFavBtnCount:self.praiseNum];
            [self dealWithData:detailModel];
            NSLog(@"成功");
        }];
    } failureBlock:^(RequestModel *respondObject) {
        [JHDispatch ui:^{
            @strongify(self);
            NSLog(@"失败");
            [SVProgressHUD dismiss];
            [self.descCollectionView jh_reloadDataWithEmputyView];
            [self.navView changeNavBackBlack:NO];
        }];
    }];
}

- (void)loadCommentData:(BOOL)isOrderByYes {
    [SVProgressHUD show];
    NSString *url = FILE_BASE_STRING(@"/anon/appraisal/customizeComment/timeline");
    NSDictionary *parameters = @{
        @"customizeOrderId":NONNULL_STR(self.customizeOrderId),
        @"orderBy":@(isOrderByYes)
    };
    @weakify(self);
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel *respondObject) {
        [JHDispatch ui:^{
            @strongify(self);
            [SVProgressHUD dismiss];
            if (!respondObject.data) {
                NSLog(@"错误提示");
            }
            NSMutableArray *arr = [JHCustomizeCommentInfoVOModel mj_objectArrayWithKeyValuesArray:respondObject.data];
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataSourceArray[self.dataSourceArray.count-2]];
            [array removeAllObjects];
            [array addObject:@[]];
            [array addObjectsFromArray:arr];
            [self.dataSourceArray removeLastObject];
            [self.dataSourceArray addObject:array];
            
            
//            [UIView setAnimationsEnabled:NO];
            [UIView performWithoutAnimation:^{
//                [self.descCollectionView reloadSections:[NSIndexSet indexSetWithIndex:self.dataSourceArray.count-2]];
                [self.descCollectionView reloadData];
            }];
//            [UIView setAnimationsEnabled:YES];
            
            NSLog(@"成功");
        }];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSLog(@"失败");
    }];
}

- (void)dealWithData:(JHCustomizeDetailVOModel *)model {
    [self.dataSourceArray removeAllObjects];
    /// TODO:
//    self.anchorId = model.
    self.channelLocalId = [NSString stringWithFormat:@"%ld",model.channelLocalId];
    self.mStatus = [NSString stringWithFormat:@"%ld",model.status];
    
    NSArray *imagesArr;
    if (model.status == 2) { /// 状态 1 进行中 2 已完成 0 其他未完成状态：比如用户未支付
        imagesArr = model.worksAttachments.count >0?model.worksAttachments:@[];
    } else {
        imagesArr = model.materialAttachments.count >0?model.materialAttachments:@[];
    }
    
    NSArray *arr = @[
        @[
            @{
                @"images":imagesArr,
                @"completeStatus":@(model.status),
                @"isChange":@(NO)
            },
            @{
                  @"worksDes":NONNULL_STR(model.worksDesc),
                  @"worksName":NONNULL_STR(model.worksName),
              }
        ],
        @[
            @{
                @"customizeUserName":NONNULL_STR(model.customizeUserName),
                @"customizeUserImg":NONNULL_STR(model.customizeUserImg),
                @"authCustomize":@(model.authCustomize),
                @"customizeTitle":NONNULL_STR(model.customizeTitle),
                @"channelStatus":NONNULL_STR(model.channelStatus)
            }
        ]
    ];
    [self.dataSourceArray addObjectsFromArray:arr];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:@[]];
    [array addObjectsFromArray:model.customizeCommentVOS];
    [self.dataSourceArray addObject:array];
//    [self.dataSourceArray addObject:@[]];
    [self.descCollectionView reloadData];
}

#pragma mark - 点赞
/// 点赞
- (void)_handleLikeEvent {
    if (IS_LOGIN) {
        [JHGrowingIO trackPublicEventId:@"dz_xq_landbtn_click" paramDict:@{
            @"Id":self.customizeOrderId, /// 定制ID
            @"orderType":NONNULL_STR(self.mStatus)   /// 状态
        }];
        @weakify(self);
        [JHCustomerDescInProcessBusiness customizeSendLikeRequest:self.customizeOrderId Completion:^(NSError * _Nullable error) {
            @strongify(self);
            if (error) {
                [UITipView showTipStr:@"点赞失败"];
                self.canPraise = YES;
            } else {
                [UITipView showTipStr:@"点赞成功"];
                self.canPraise = NO;
                self.praiseNum = self.praiseNum + 1;
                [self.bottomView setFavBtnStatus:YES];
                [self.bottomView setFavBtnCount:self.praiseNum];
            }
        }];
    }
}

/// 取消点赞
- (void)_handleUnLikeEvent {
    if (IS_LOGIN) {
        @weakify(self);
        [JHCustomerDescInProcessBusiness customizeCancleLikeRequest:self.customizeOrderId Completion:^(NSError * _Nullable error) {
            @strongify(self);
            if (error) {
                [UITipView showTipStr:@"取消点赞失败"];
                self.canPraise = NO;
            } else {
                self.canPraise = YES;
                [UITipView showTipStr:@"取消点赞成功"];
                self.praiseNum = (self.praiseNum-1)>0?(self.praiseNum-1):0;
                if (self.praiseNum > 0) {
                    [self.bottomView setFavBtnStatus:YES];
                } else {
                    [self.bottomView setFavBtnStatus:NO];
                }
                [self.bottomView setFavBtnCount:self.praiseNum];
            }
        }];
    }
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        return;
    }
    CGFloat alpah = MAX(0, MIN(1, scrollView.contentOffset.y / ScreenW));
    if (alpah>0.4) {
        [self.navView setNavImg:YES];
    } else {
        [self.navView setNavImg:NO];
    }
    self.navView.backgroundColor = HEXCOLORA(0xffffff, alpah);
}

#pragma mark - FlowLayoutDelegate DataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    if (section == self.dataSourceArray.count -2) {
//        return CGSizeMake(ScreenW, 0);
//    }
    if (section == self.dataSourceArray.count -1) {
        return CGSizeMake(ScreenW, 0);
    }
    return CGSizeMake(ScreenW, 10);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (section == self.dataSourceArray.count -1) {
//        return 1;
//    }
    NSArray *arr = self.dataSourceArray[section];
    return arr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.cell0 = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCustomerDescPicCollectionViewCell class]) forIndexPath:indexPath];
            if (!self.cell0) {
                self.cell0 = [[JHCustomerDescPicCollectionViewCell alloc] init];
            }
            @weakify(self);
            self.cell0.stuffBtnActionBlock = ^(BOOL isComplete) {
                @strongify(self);
                [SVProgressHUD show];
                [self.player stop];
                self.cell0.isPlayEnd = YES;
                /// 原料信息 - 跳转
                NSMutableArray *array0 = [NSMutableArray arrayWithArray:self.dataSourceArray[0]];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:array0[0]];
                if (isComplete) {
                    /// 状态 1 进行中 2 已完成
                    dict[@"images"] = self.materialAttachments;
                    dict[@"completeStatus"] = @(1);
                    dict[@"isChange"] = @(YES);
                    /// 原料信息
                } else {
                    /// 成品信息
                    dict[@"images"] = self.worksAttachments;
                    dict[@"completeStatus"] = @(2);
                    dict[@"isChange"] = @(YES);
                }
                [array0 removeFirstObject];
                [array0 insertObject:dict atIndex:0];
                [self.dataSourceArray removeFirstObject];
                [self.dataSourceArray insertObject:array0 atIndex:0];
                [self.descCollectionView reloadData];
                [SVProgressHUD dismiss];
            };
            
            self.cell0.bannerHasVideoBlock = ^(CGoodsImgInfo * _Nonnull videoInfo, UITapImageView * _Nonnull videoContainer) {
                @strongify(self);
                self.videoInfo = videoInfo;
                self.playerContainerView = videoContainer;
                [self configPlayer];
            };
            
            self.cell0.bannerPlayClickBlock = ^{
                @strongify(self);
                [self startPlaying];
            };
            
            [self.cell0 setViewModel:self.dataSourceArray[indexPath.section][indexPath.row]];
            return self.cell0;
        } else {
            JHCustomizeDescStuffInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCustomizeDescStuffInfoCollectionViewCell class]) forIndexPath:indexPath];
            if (!cell) {
                cell = [[JHCustomizeDescStuffInfoCollectionViewCell alloc] init];
            }
            [cell setViewModel:self.dataSourceArray[indexPath.section][indexPath.row]];
            return cell;
        }
    } else if (indexPath.section == 1) {
        JHCustomerDescInstroCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCustomerDescInstroCollectionViewCell class]) forIndexPath:indexPath];
        if (!cell) {
            cell = [[JHCustomerDescInstroCollectionViewCell alloc] init];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.section][indexPath.row]];
        @weakify(self);
        cell.iconImgAcitonBlock = ^{
            @strongify(self);
            /// 点击头像，直播状态跳转直播间，不直播跳转主页
            NSDictionary *dict = [NSDictionary cast:self.dataSourceArray[indexPath.section][indexPath.row]];
            if (dict && [dict[@"channelStatus"] isEqualToString:@"2"]) {
                [JHRootController EnterLiveRoom:self.channelLocalId fromString:@"dz_xq_in" isStoneDetail:NO isApplyConnectMic:NO];
            } else {
                /// 查看主页
                JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
                vc.roomId = self.roomId;
                vc.anchorId = self.anchorId;
                vc.channelLocalId = self.channelLocalId;
                vc.fromSource = @"dz_xq_in";
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        
        cell.checkMainBtnActionBlock = ^{
            @strongify(self);
            /// 查看主页
            JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
            vc.roomId = self.roomId;
            vc.anchorId = self.anchorId;
            vc.channelLocalId = self.channelLocalId;
            vc.fromSource = @"dz_xq_in";
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    } else {
        if (indexPath.row == 0) {
            self.cell3 = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCustomerProcessTitleCollectionViewCell class]) forIndexPath:indexPath];
            if (!self.cell3) {
                self.cell3 = [[JHCustomerProcessTitleCollectionViewCell alloc] init];
            }
            [self.cell3 setOrderStatus:self.isOrderByYes];
            if ([self.addCommentFlag isEqualToString:@"1"]) {
                [self.cell3 setViewModel:YES];
            } else {
                [self.cell3 setViewModel:NO];
            }
            @weakify(self);
            self.cell3.addBlock = ^{
                @strongify(self);
                NSLog(@"点击添加沟通信息");
                JHCustomerAddCommentInfoViewController *vc = [[JHCustomerAddCommentInfoViewController alloc] init];
                vc.customizeOrderId = self.customizeOrderId;
                vc.popAction = ^{
                    @strongify(self);
                    [self loadCommentData:self.isOrderByYes];
                };
                [self.navigationController pushViewController:vc animated:YES];
            };
            self.cell3.orderByBlock = ^(BOOL isOrderByYes) {
                @strongify(self);
                /// 选择正序倒叙
                self.isOrderByYes = isOrderByYes;
                [self loadCommentData:isOrderByYes];
            };
            return self.cell3;
        } else {
            JHCustomerCommentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCustomerCommentCollectionViewCell class]) forIndexPath:indexPath];
            if (!cell) {
                cell = [[JHCustomerCommentCollectionViewCell alloc] init];
            }
            [cell setViewModel:self.dataSourceArray[indexPath.section][indexPath.row]];
            if (indexPath.row == 1) {
                [cell reloadLineLayerFrame:JHCusDescInProCommentImgStatus_Yellow];
                JHCustomizeCommentInfoVOModel *model = [JHCustomizeCommentInfoVOModel cast:self.dataSourceArray[indexPath.section][indexPath.row]];
                if ([model.finishFlag isEqualToString:@"1"]) {
                    [cell setSupplementBtnShow:self.canPublish];
                } else {
                    [cell setSupplementBtnShow:NO];
                }
            } else {
                JHCustomizeCommentInfoVOModel *model = [JHCustomizeCommentInfoVOModel cast:self.dataSourceArray[indexPath.section][indexPath.row]];
                if ([model.finishFlag isEqualToString:@"1"]) {
                    [cell reloadLineLayerFrame:JHCusDescInProCommentImgStatus_GrayWithoutCenter];
                    [cell setSupplementBtnShow:self.canPublish];
                } else {
                    [cell reloadLineLayerFrame:JHCusDescInProCommentImgStatus_Gray];
                    [cell setSupplementBtnShow:NO];
                }
            }
            @weakify(self);
            cell.supplementBtnActionBlock = ^{
                @strongify(self);
                if (IS_LOGIN) {
                    /// 添加补充消息
                    JHCustomizeCommentInfoVOModel *voModel = self.dataSourceArray[indexPath.section][indexPath.row];
                    self.bcCustomizeCommentId = voModel.customizeCommentId;
                    JHEasyInputTextView *easyView = [[JHEasyInputTextView alloc] initInputTextViewWithFontSize:[UIFont fontWithName:kFontNormal size:13.f] limitNum:200 inputBackgroundColor:kColorF5F6FA maxNumbersOfLine:3 currentViewController:NSStringFromClass([JHRootController.currentViewController class])];
                    easyView.showLimitNum = YES;
                    [self.view addSubview:easyView];
                    [easyView show];
                    @weakify(easyView);
                    [easyView toPublish:^(NSDictionary * _Nonnull inputInfos) {
                        @strongify(easyView);
                        [easyView endEditing:YES];
                        [self didSendText:inputInfos];
                    }];
                }
            };
            
            cell.commentClickBlock = ^(NSInteger index, NSArray * _Nonnull imgArr) {
                @strongify(self);
                JHCustomizeCommentPublishImgList *model = [JHCustomizeCommentPublishImgList cast:imgArr[index]];
                if (model.type == 1) {
                    /// 视频
                    NSURL *url = [NSURL URLWithString:model.url];
                    AVPlayerViewController *ctrl = [AVPlayerViewController new];
                    ctrl.player = [[AVPlayer alloc]initWithURL:url];
                    [JHRootController presentViewController:ctrl animated:YES completion:nil];
                }

                NSMutableArray *photoList = [NSMutableArray array];
                for (JHCustomizeCommentPublishImgList *model in imgArr) {
                    if (model.type == 0) {
                        GKPhoto *photo = [[GKPhoto alloc]init];
                        photo.url = [NSURL URLWithString:model.url];
                        [photoList addObject:photo];
                    } else {
                        index = index-1>0?index-1:0;
                    }
                }
                
                GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoList currentIndex:index];
                browser.isStatusBarShow = YES;
                browser.isScreenRotateDisabled = YES;
                browser.showStyle = GKPhotoBrowserShowStyleNone;
                browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
                [browser showFromVC:self];
            };
            return cell;
        }
    }
//    else {
//        self.bottomCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCustomizeDescBottomViewCollectionViewCell class]) forIndexPath:indexPath];
//        if (!self.bottomCell) {
//            self.bottomCell = [[JHCustomizeDescBottomViewCollectionViewCell alloc] init];
//        }
//        @weakify(self);
//        [self.bottomCell customerDescBtnAction:^(JHCustomerDescBottomBtnStyle style) {
//            @strongify(self);
//            if (style == JHCustomerDescBottomBtnStyle_Fav) {
//                if (![JHRootController isLogin]) {
//                    [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {}];
//                } else {
//                    if (!self.canPraise) {
//                        [self _handleUnLikeEvent];
//                    } else {
//                        [self _handleLikeEvent];
//                    }
//                }
//            } else {
//                /// 分享
//                [JHGrowingIO trackPublicEventId:@"dz_xq_share_click" paramDict:@{
//                    @"Id":self.customizeOrderId, /// 定制ID
//                    @"orderType":NONNULL_STR(self.mStatus)   /// 状态
//                }];
//                [self share];
//            }
//        }];
//        return self.bottomCell;
//    }
}

#pragma mark -
#pragma mark - 视频播放相关
- (void)configPlayer {
    if (!_player) {
            ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
            playerManager.scalingMode = ZFPlayerScalingModeAspectFill;
            //player的tag值必须在cell里设置
            self.player = [ZFPlayerController playerWithScrollView:self.descCollectionView playerManager:playerManager containerView:_playerContainerView];
            self.player.playerDisapperaPercent = 1.0;
            self.player.playerApperaPercent = 0.0;
            self.player.controlView = self.playerControl;
            self.player.stopWhileNotVisible = NO;
            
            @weakify(self)
            self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
                @strongify(self)
                [self setNeedsStatusBarAppearanceUpdate];
                [UIViewController attemptRotationToDeviceOrientation];
                self.descCollectionView.scrollsToTop = !isFullScreen;
            };
            
            self.player.playerDidToEnd = ^(id  _Nonnull asset) {
                @strongify(self)
                [self.player stop];
                self.cell0.isPlayEnd = YES;
            };
    }
}

//开始播放
- (void)startPlaying {
    /// 在这里判断能否播放。。。
    self.player.currentPlayerManager.assetURL = [NSURL URLWithString:_videoInfo.video_url];
    [self.playerControl showTitle:@"" coverURLString:_videoInfo.url fullScreenMode:ZFFullScreenModePortrait];
    
    if (self.descCollectionView.contentOffset.y > ScreenWidth) {
        ///如果viewh划出超过图片的高度时
        [self.player addPlayerViewToKeyWindow];
    } else {
        [self.player addPlayerViewToContainerView:self.playerContainerView];
    }
}

- (YDPlayerControlView *)playerControl {
    if (!_playerControl) {
        _playerControl = [YDPlayerControlView new];
    }
    return _playerControl;
}

- (NSMutableArray<JHPostData *> *)postArray {
    if (!_postArray) {
        _postArray = [NSMutableArray new];
    }
    return _postArray;
}

- (void)didSendText:(NSDictionary *)dict {
    if ([JHSQManager needLogin]) {
        return;
    }
    JHCustomizeCommentRequestModel *model = [[JHCustomizeCommentRequestModel alloc] init];
    model.content            = NONNULL_STR(dict[@"content"]);
    model.customizeCommentId = self.bcCustomizeCommentId;
    model.customizeOrderId   = [self.customizeOrderId integerValue];
    NSArray *arr = dict[@"comment_images"];
    if (arr.count >0) {
        NSMutableArray<JHAttachmentVOModel *> *muArr = [arr jh_map:^id _Nonnull(NSString *_Nonnull obj, NSUInteger idx) {
            JHAttachmentVOModel *mo = [[JHAttachmentVOModel alloc] init];
            mo.url  = obj;
            mo.type = 0;
            return mo;
        }];
        model.imgList = muArr;
    }
    @weakify(self);
    [SVProgressHUD show];
    [JHCustomerDescInProcessBusiness addCommentRequest:model Completion:^(NSError * _Nullable error) {
        @strongify(self);
        [SVProgressHUD dismiss];
        if (error) {
            [UITipView showTipStr:@"发布失败"];
        } else {
            [UITipView showTipStr:@"发布成功"];
            [self loadCommentData:self.isOrderByYes];
        }
    }];
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
        vc.roomId = self.roomId;
        vc.anchorId = self.anchorId;
        vc.channelLocalId = self.channelLocalId;
        vc.fromSource = @"dz_xq_in";
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
