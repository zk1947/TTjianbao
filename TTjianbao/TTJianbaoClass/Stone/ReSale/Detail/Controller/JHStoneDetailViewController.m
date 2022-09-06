//
//  JHStoneDetailViewController.m
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//
#import "JHStoneDetailTopInfoCell.h"
#import "JHStoneDetailBidderCell.h"
#import "JHStoneDetailTotalCell.h"
#import "JHStoneDetailStoneChangeCell.h"
#import "JHStoneDetailSectionFooterView.h"
#import "JHStoneDetailSectionHeader.h"
#import "JHStoneDetailViewController.h"
#import "UIScrollView+JHEmpty.h"
#import "JHStoneDetailViewModel.h"
#import "JHOfferPriceViewController.h"
#import "JHGoodResaleListModel.h"
#import "JHOrderConfirmViewController.h"
#import "JHStoneDetailStoneActionBottomView.h"
#import "JHStoneDetailStoneBuyyerBottomView.h"
#import "JHStoneDetailHeader.h"
#import "JHStoneDetailFamilyCell.h"
#import "TTjianbaoMarcoKeyword.h"
#import "JHWebViewController.h"
#pragma mark ---------------------------- 媒体部分 ----------------------------
#import "YDPlayerControlView.h"
#import "ZFPlayer.h"
#import "ZFUtilities.h"
#import "ZFAVPlayerManager.h"
#import "UIImageView+ZFCache.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>
#import "JHWebView.h"
#import "PayMode.h"
#import "JHOrderDetailMode.h"
#import "JHOrderDetailViewController.h"
#import "JHOrderViewModel.h"
#import "JHLivePlaySMallView.h"
#import "JHLivePlayer.h"
#import "JHBaseOperationView.h"

@interface JHStoneDetailViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JHStoneDetailHeader *headerView;

@property (nonatomic, strong) JHStoneDetailViewModel *viewModel;

@property (nonatomic, strong) JHStoneDetailStoneActionBottomView *actionBottomView;

@property (nonatomic, strong) JHStoneDetailStoneBuyyerBottomView *buyyerBottomView;

#pragma mark ---------------------------- 媒体部分 ----------------------------
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) YDPlayerControlView *playerControl;
@property (nonatomic, strong) UITapImageView *playerContainer;
@property (nonatomic, strong) CAttachmentListData *videoData; //视频数据
@property (nonatomic, assign) BOOL preVideoPlaying; //记录滑出视频区域时的播放状态

@property (nonatomic, assign) CGFloat webViewHeight;
@end

@implementation JHStoneDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self tableView];
    
    [self setNavUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[JHLivePlayer sharedInstance] setMute:YES];
    [self.viewModel.requestCommand execute:nil];
    
    if(_type == 1)
    {
        [JHUserStatistics noteEventType:kUPEventTypeStoneDetailBrowse params:@{JHUPBrowseKey : JHUPBrowseBegin}];
    }
    else
    {
        [JHUserStatistics noteEventType:kUPEventTypeResaleStoneDetailBrowse params:@{JHUPBrowseKey : JHUPBrowseBegin}];
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[JHLivePlayer sharedInstance] setMute:NO];
    
    if(_type == 1)
    {
        [JHUserStatistics noteEventType:kUPEventTypeStoneDetailBrowse params:@{JHUPBrowseKey : JHUPBrowseEnd}];
    }
    else
    {
        [JHUserStatistics noteEventType:kUPEventTypeResaleStoneDetailBrowse params:@{JHUPBrowseKey : JHUPBrowseEnd}];
    }
}
#pragma mark ---------------------------- method ----------------------------
- (void)setNavUI
{
    UIButton *rightButton = [UIButton jh_buttonWithImage:@"stone_detail_share" target:self action:@selector(rightActionButton:) addToSuperView:self.view];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-7.f);
        make.top.equalTo(self.view).offset(UI.statusBarHeight + 3.5);
        make.size.mas_equalTo(CGSizeMake(37.f, 37.f));
    }];
    
    UIButton *leftButton = [UIButton jh_buttonWithImage:@"stone_detail_back" target:self action:@selector(backActionButton:) addToSuperView:self.view];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(7.f);
        make.top.height.width.equalTo(rightButton);
    }];
    
    [self jhBringSubviewToFront];
    self.jhLeftButton.jh_imageName(@"navi_icon_back_black");
    [self initRightButtonWithImageName:@"navi_icon_share_black" action:@selector(rightActionButton:)];
    self.jhNavView.hidden = YES;
}

-(void)pushConfigVCMethod:(id)respData
{
  
    JHGoodOrderSaveModel* model = [JHGoodOrderSaveModel mj_objectWithKeyValues:respData];
    JHOrderConfirmViewController * order = [[JHOrderConfirmViewController alloc]init];
    order.orderId = model.orderId;
    order.fromString = JHConfirmFromStoneDetail;
    [self.navigationController pushViewController:order animated:YES];
}

-(void)backActionButton:(UIButton *)sender
{
    [super backActionButton:sender];
    
    if(_complete){
        _complete(@(self.viewModel.isExplained));
    }
}

-(void)rightActionButton:(UIButton *)sender
{
    NSString *titleStr = [NSString stringWithFormat:@"哎呦，这原石不错哦，%@元的价格也挺合理的",self.viewModel.dataModel.price.stringValue] ;
    NSString *descStr  = self.viewModel.dataModel.goodsTitle;
    NSString *imageStr = nil;
    if (self.viewModel.dataModel.attachmentList.count) {
        CAttachmentListData *attach = self.viewModel.dataModel.attachmentList[0];
        if (attach.attachmentType == 1) {
            imageStr = attach.url;
        } else if (attach.attachmentType == 2) {
            imageStr = attach.coverUrl;
        }

    }
    NSString *urlStr   = [NSString stringWithFormat:@"%@stoneId=%@&channerlCategory=%@&customerId=%@&resaleType=0",[UMengManager shareInstance].shareStoneDetailUrl,self.viewModel.stoneId,self.channelCategory,self.viewModel.dataModel.saleCustomerId];
    if(self.viewModel.type == 1) {
        urlStr   = [NSString stringWithFormat:@"%@stoneId=%@&customerId=%@&resaleType=1",[UMengManager shareInstance].shareStoneDetailUrl,self.viewModel.stoneId,self.viewModel.dataModel.saleCustomerId];
    }
    
//    [[UMengManager shareInstance] showShareWithTarget:nil
//                                                title:titleStr
//                                                 text:descStr
//                                             thumbUrl:imageStr
//                                               webURL:urlStr
//                                                 type:ShareObjectTypeSocialArticial
//                                               object:nil];
    JHShareInfo* info = [JHShareInfo new];
    info.title = titleStr;
    info.desc = descStr;
    info.img = imageStr;
    info.shareType = ShareObjectTypeSocialArticial;
    info.url = urlStr;
    [JHBaseOperationView showShareView:info objectFlag:nil]; //TODO:Umeng share
}

-(void)updateUI
{
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSString *sellerId = self.viewModel.dataModel.saleCustomerId;
    ///已售
    if (self.viewModel.dataModel.buyerId.length > 1) {
        [self.buyyerBottomView.avatorView jh_setAvatorWithUrl:self.viewModel.dataModel.buyerImg];
        self.buyyerBottomView.nameLabel.text = [NSString stringWithFormat:@"买家：%@",self.viewModel.dataModel.buyerName];
        self.buyyerBottomView.priceLabel.text= [NSString stringWithFormat:@"￥%@",PRICE_FLOAT_TO_STRING(self.viewModel.dataModel.dealPrice)];
        
        self.buyyerBottomView.hidden = NO;
        self.actionBottomView.hidden = YES;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-[JHStoneDetailStoneActionBottomView viewHeight]);
        }];
    }//卖家
    else if([user.customerId isEqualToString:sellerId]) {
        self.buyyerBottomView.hidden = YES;
        self.actionBottomView.hidden = YES;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(0.f);
        }];
    }
    else if (self.viewModel.dataModel.showOfferButton)
    {//后台控制
        self.buyyerBottomView.hidden = YES;
        self.actionBottomView.hidden = NO;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-[JHStoneDetailStoneActionBottomView viewHeight]);
        }];
    }
    else
    {//不显示
        self.buyyerBottomView.hidden = YES;
        self.actionBottomView.hidden = YES;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(0.f);
        }];
    }
//    self.title = self.viewModel.dataModel.goodsTitle;
    self.headerView.dataList = self.viewModel.dataModel.attachmentList;

    [self.tableView reloadData];
    [self.tableView jh_endRefreshing];
}

#pragma mark ---------------------------- get set ----------------------------
-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStyleGrouped separatorStyle:UITableViewCellSeparatorStyleNone target:self addToSuperView:self.view];
        _tableView.backgroundColor     = RGB(248, 248, 248);
        _tableView.estimatedRowHeight  = 80.f;
        _tableView.sectionFooterHeight = 10.f;
        _tableView.estimatedSectionHeaderHeight = 40.f;
        _tableView.tableHeaderView     = self.headerView;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-[JHStoneDetailStoneActionBottomView viewHeight]);
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view);
        }];
        @weakify(self);
        [_tableView jh_headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel.requestCommand execute:nil];
        } footerWithRefreshingBlock:nil];
    }
    return _tableView;
}

- (JHStoneDetailViewModel *)viewModel
{
    if(!_viewModel)
    {
        _viewModel = [JHStoneDetailViewModel new];
        _viewModel.type = self.type;
        _viewModel.stoneId = self.stoneId;
        @weakify(self);
        [_viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self updateUI];
        }];
    }
    return _viewModel;
}

- (JHStoneDetailStoneActionBottomView *)actionBottomView
{
    if(!_actionBottomView){
        _actionBottomView = [JHStoneDetailStoneActionBottomView new];
        [self.view addSubview:_actionBottomView];
        _actionBottomView.explainButton.hidden = (self.viewModel.type == 1);
        [_actionBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.height.mas_equalTo([JHStoneDetailStoneActionBottomView viewHeight]);
        }];
        @weakify(self);
        _actionBottomView.bottonClickBlock = ^(NSInteger index) {
            @strongify(self);
            switch (index) {
                case 1:
                {
                    [JHRootController EnterLiveRoom:self.viewModel.dataModel.channelId fromString:@"" isStoneDetail:YES isApplyConnectMic:NO];
                    
                    if([JHRootController isLogin] && !self.viewModel.dataModel.selfSeek)
                    {
                        [self.viewModel explainAction:^{}];
                    }
                }
                    break;

                case 2:
                {
                    if(IS_LOGIN)
                    {
                        JHOfferPriceViewController *vc = [[JHOfferPriceViewController alloc] init];
                        vc.stoneRestoreId = self.stoneId;
                        vc.resaleFlag = (self.type == 1);
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
                    break;

                case 3:
                {
                    if(IS_LOGIN)
                    {
                        [self orderStatusRequest];
                    }
                }
                    break;

                default:
                    break;
            }
        };
    }
    return _actionBottomView;
}

- (JHStoneDetailStoneBuyyerBottomView *)buyyerBottomView {
    
    if(!_buyyerBottomView){
        _buyyerBottomView = [JHStoneDetailStoneBuyyerBottomView new];
        [self.view addSubview:_buyyerBottomView];
        [_buyyerBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.height.mas_equalTo([JHStoneDetailStoneBuyyerBottomView viewHeight]);
        }];
        _buyyerBottomView.explainButton.hidden = (self.viewModel.type == 1);
        @weakify(self);
        _buyyerBottomView.clickIntoLiveRoomBlock = ^{
            @strongify(self);
            [JHRootController EnterLiveRoom:self.viewModel.dataModel.channelId fromString:@"" isStoneDetail:YES isApplyConnectMic:NO];
        };
    }
    return _buyyerBottomView;
}

- (void)orderStatusRequest {
    
    JHGoodsOrderDetailReqModel * mode = [[JHGoodsOrderDetailReqModel alloc]init];
    if (self.viewModel.type==1) {
        //个人转售
         mode.orderCategory = @"resaleOrder";
         mode.goodsId = self.viewModel.dataModel.stoneResaleId;
         mode.orderType = @(JHOrderTypeStoneResell).stringValue;
    }
    else{
         mode.goodsId = self.viewModel.dataModel.goodsCode;
         mode.orderCategory = @"restoreOrder";
         mode.orderType = @(JHOrderTypeRestore).stringValue;
    }
     
       [JHOrderViewModel requestGoodsConfirmDetail:mode completion:^(RequestModel *respondObject, NSError *error) {
           [SVProgressHUD dismiss];
           if (!error) {
               JHOrderDetailMode *detail=[JHOrderDetailMode mj_objectWithKeyValues:respondObject.data];
               if (detail.orderId&&[detail.orderId length]>0) {
                   JHOrderDetailViewController *vc = [[JHOrderDetailViewController alloc] init];
                    vc.orderId = detail.orderId;
                   if (self.viewModel.type==1) {
                       //个人转售
                         vc.orderCategoryType=JHOrderCategoryResaleOrder;
                   }
                   else{
                         vc.orderCategoryType=JHOrderCategoryRestore;
                   }
                  
                    vc.stoneId = self.stoneId;
                   [self.navigationController pushViewController:vc animated:YES];
               }
               else{
                   ///进入确认订单界面
                   JHOrderConfirmViewController * order = [[JHOrderConfirmViewController alloc]init];
                   if (self.viewModel.type==1) {
                       //个人转售
                       order.orderCategory = @"resaleOrder";
                       order.orderType = JHOrderTypeStoneResell;
                       order.goodsId = self.viewModel.dataModel.stoneResaleId;
                   }
                   else{
                       order.orderCategory = @"restoreOrder";;
                       order.orderType = JHOrderTypeRestore;
                       order.goodsId = self.viewModel.dataModel.goodsCode;
                   }
                    order.activeConfirmOrder = YES;
                    order.parentOrderId = self.viewModel.dataModel.sourceOrderId;
                    order.fromString = JHConfirmFromStoneDetail;
                   [self.navigationController pushViewController:order animated:YES];
               }
           }
           else {
               if (respondObject.code == 40005) {
                  ///宝贝已经被买走了
                   CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:error.localizedDescription cancleBtnTitle:@"我知道了"];
                   [[UIApplication sharedApplication].keyWindow addSubview:alert];
               }
               else {
                   [self.view makeToast:respondObject.message duration:1.0f position:CSToastPositionCenter];
               }
           }
       }];
       [SVProgressHUD show];
    
}

- (JHStoneDetailHeader *)headerView {
    if (!_headerView) {
        _headerView = [[JHStoneDetailHeader alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW)];
        _headerView.autoPlay = YES;

        @weakify(self);
        _headerView.muteBlock = ^{
            @strongify(self);
            self.player.muted = self.headerView.isMute;
        };

        _headerView.playClickVideoBlock = ^(CAttachmentListData * _Nonnull videoData, UITapImageView * _Nonnull videoContainer) {
            @strongify(self);
            self.videoData = videoData;
            self.playerContainer = videoContainer;
            [self configPlayer];
            [self startPlaying];
            self.headerView.autoPlay = NO;
        };
        
        _headerView.didEndScrollingBlock = ^(BOOL isVideoIndex) {
            @strongify(self);
            if (isVideoIndex && self.preVideoPlaying) {
                [self.player.currentPlayerManager play];
                
            } else {
                if (self.player.currentPlayerManager.isPlaying) {
                    self.preVideoPlaying = self.player.currentPlayerManager.isPlaying;
                    [self.player.currentPlayerManager pause];
                }
            }
        };
    }
    return _headerView;
}

#pragma mark ---------------------------- 媒体视频播放相关 ----------------------------
- (void)configPlayer {
    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    playerManager.scalingMode = ZFPlayerScalingModeAspectFill;
    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerView:_playerContainer];
    self.player.playerDisapperaPercent = 1.0;
    self.player.playerApperaPercent = 0.0;
    self.player.controlView = self.playerControl;
    self.player.stopWhileNotVisible = NO;
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        [UIViewController attemptRotationToDeviceOrientation];
        self.tableView.scrollsToTop = !isFullScreen;
    };
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player stop];
        self.headerView.mPlayIcon.hidden = NO;
//        self.headerView.isPlayEnd = YES;
    };
}

//开始播放
- (void)startPlaying {
    /// 在这里判断能否播放。。。
    self.player.currentPlayerManager.assetURL = [NSURL URLWithString:_videoData.url];
    [self.playerControl showTitle:@"" coverURLString:_videoData.coverUrl fullScreenMode:ZFFullScreenModePortrait];

    if (self.tableView.contentOffset.y > self.headerView.frame.size.height) {
        [self.player addPlayerViewToKeyWindow];
    } else {
        [self.player addPlayerViewToContainerView:self.playerContainer];
    }
}

- (YDPlayerControlView *)playerControl {
    if (!_playerControl) {
        _playerControl = [YDPlayerControlView new];
    }
    return _playerControl;
}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark ---------------------------- tabview delegate ----------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.sectionArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section >= self.viewModel.sectionArray.count) {
        return 0;
    }
    JHStoneDetailTabelViewModel *typeModel = self.viewModel.sectionArray[section];
    
    switch (typeModel.detailSectionType) {
        case DetailSectionTypeTopInfo:
            return 1;
            break;
            
            case DetailSectionTypeOfferPrice:
            return self.viewModel.dataModel.offerRecordList.count;
            break;
            
            case DetailSectionTypeTotal:
            return 1;
            break;
            
            case DetailSectionTypeFamily:
            return 1;
            break;
            
            case DetailSectionTypeChange:
            return self.viewModel.dataModel.stoneChangeList.count;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    JHStoneDetailSectionHeader *header = [JHStoneDetailSectionHeader dequeueReusableHeaderFooterViewWithTableView:tableView];
    
    if (section < self.viewModel.sectionArray.count) {
        JHStoneDetailTabelViewModel *typeModel = self.viewModel.sectionArray[section];
        header.titleStr = typeModel.detailSectionTitle;
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    JHStoneDetailSectionFooterView *footer = [JHStoneDetailSectionFooterView dequeueReusableHeaderFooterViewWithTableView:tableView];
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JHStoneDetailTabelViewModel *typeModel = self.viewModel.sectionArray[indexPath.section];
    
    switch (typeModel.detailSectionType) {
            
        case DetailSectionTypeTopInfo:
        {
            JHStoneDetailTopInfoCell *cell = [JHStoneDetailTopInfoCell dequeueReusableCellWithTableView:tableView];
            CStoneDetailModel *model = self.viewModel.dataModel;
            [cell setAvatorUrl:model.saleCustomerImg name:model.saleCustomerName price:model.price number:model.goodsCode title:model.goodsDesc seekNumber:model.seekCount array:model.seekCustomerImgList resellFlag:self.type];
            return cell;
        }
            break;
            
        case DetailSectionTypeOfferPrice:
        {
            JHStoneDetailBidderCell *cell = [JHStoneDetailBidderCell dequeueReusableCellWithTableView:tableView];
            COfferRecordListData *model = self.viewModel.dataModel.offerRecordList[indexPath.row];
            cell.model = model;
            return cell;
        }
            break;
            
        case DetailSectionTypeTotal:
        {
            JHStoneDetailTotalCell *cell = [JHStoneDetailTotalCell dequeueReusableCellWithTableView:tableView];
            CStoneDetailModel *model = self.viewModel.dataModel;
            [cell setOriPrice:model.oriPrice expectPrice:model.expectPrice actualPrice:model.actualPrice sendCount:model.sendCount];
            return cell;
        }
            break;
            
        case DetailSectionTypeFamily:
        {
            JHStoneDetailFamilyCell *cell = [JHStoneDetailFamilyCell dequeueReusableCellWithTableView:tableView];
            @weakify(self);
            cell.enterFamilyTreeMethod = ^{
                @strongify(self);
                [self enterFamillyTree];
            };
            if (self.webViewHeight>0) {
                [cell.webView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(self.webViewHeight));
                }];
            }
            cell.webView.jh_webViewDidFinishBlock = ^(WKWebView * _Nonnull webView) {
                @strongify(self);
                [self loadDataWithWebView:webView];
            };
            
            return cell;
        }
        break;
            
        case DetailSectionTypeChange:
        {
            JHStoneDetailStoneChangeCell *cell = [JHStoneDetailStoneChangeCell dequeueReusableCellWithTableView:tableView];
            if (self.viewModel.dataModel.stoneChangeList.count) {
                CStoneChangeListData *model  = self.viewModel.dataModel.stoneChangeList[indexPath.row];
                model.isTop = (indexPath.row == 0);
                cell.model = model;
            }
            return cell;
        }
        break;
            
        default:
        {
            JHStoneDetailTopInfoCell *cell = [JHStoneDetailTopInfoCell dequeueReusableCellWithTableView:tableView];
            return cell;
        }
            break;
    }
}

-(void)loadDataWithWebView:(JHWebView *)webView{
    NSString *string = [self.viewModel.returnData mj_JSONString];

    [webView jh_nativeCallJSMethod:@"setFamilyTreeData" param:string];
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSInteger webHeight = [(NSString *)obj floatValue];
        if (self.webViewHeight != webHeight) {
            self.webViewHeight = webHeight;
            [self.tableView reloadData];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
 //第一部分：更改导航栏
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    self.jhNavView.hidden = (contentOffsetY < ScreenW - UI.statusAndNavBarHeight);
}

-(void)enterFamillyTree
{
    JHWebViewController *vc = [JHWebViewController new];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"familyHtml/passOnApp" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [vc.webView loadFileURL:url allowingReadAccessToURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"familyHtml" ofType:nil]]];
    @weakify(self);
    vc.webView.jh_webViewDidFinishBlock = ^(JHBaseWKWebView * _Nonnull webView) {
        @strongify(self);
        
        [webView jh_nativeCallJSMethod:@"setFamilyTreeData" param:[self.viewModel.returnData mj_JSONString]];
        
        
        NSString *injectionJSString = @"var script = document.createElement('meta');"
         "script.name = 'viewport';"
         "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=3.0, minimum-scale=1.0, user-scalable=yes\";"
         "document.getElementsByTagName('head')[0].appendChild(script);";
         [webView jh_nativeCallJSMethod:@"setFamilyTreeData" param:injectionJSString];

    };
}

@end

