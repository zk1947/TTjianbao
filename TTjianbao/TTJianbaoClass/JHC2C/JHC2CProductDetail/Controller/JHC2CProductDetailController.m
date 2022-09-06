//
//  JHC2CProductDetailController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
#import "JHC2CAllScreenPlayController.h"
#import "JHMarketFloatLowerLeftView.h"
#import "JHC2CProductDetailBottomFunctionView.h"
#import "JHC2CProductDetailController.h"
#import "JHC2CProductDetailChatListController.h"
#import "JHC2CProductDetailNavView.h"
#import "JHC2CProductDetailHeader.h"
#import "JHC2CProductDetailTextCell.h"
#import "JHC2CProductDetailImageCell.h"
#import "JHC2CProductDetailBottomInfoCell.h"
#import "JHC2CProductDetailJianDingCell.h"
#import "JHC2CProductDetailDaiJianDingCell.h"
#import "JHC2CProductDetailChatHeader.h"
#import "JHC2CProductDetailChatFooter.h"
#import "JHC2CProductDetailChatCell.h"
#import "JHC2CProductDetailYiKouJiaInfoCell.h"
#import "JHC2CProductDetailPaiMaiInfoCell.h"
#import "JHC2CProductDetailPaiMaiListController.h"
#import "JHC2CUploadProductController.h"
#import "JHC2CProductDetailBusiness.h"
#import "JHBaseOperationAction.h"
#import "JHSQCollectViewController.h"
#import "JHSessionViewController.h"
#import "JHIMEntranceManager.h"
#import "JHTextInPutView.h"

#import "UIScrollView+JHEmpty.h"
#import "JHDynamicViewController.h"
#import "JHUserInfoViewController.h"
#import "JHNewShopDetailViewController.h"
#import "JHPlateDetailController.h"
#import "JHWebViewController.h"
#import "JHCommitViewController.h"
#import "JHSettingAutoPlayController.h"
#import "JHPostMainCommentHeader.h"
#import "JHPostCommentFooterView.h"
#import "JHTopicTallyView.h"
#import "JHWebImage.h"
#import "JHPostDetailPicInfoTableCell.h"
#import "JHPostDetailTextLinkCell.h"
#import "JHPostDetailUpdateTimeTableCell.h"
#import "JHPostDetailCommentHeader.h"
#import "JHBaseOperationView.h"
#import "JHBaseOperationModel.h"

#import "JHSQManager.h"
#import "JHSQApiManager.h"
#import "JHUserInfoApiManager.h"
#import "JHPostDetailModel.h"

#import "UIImageView+ZFCache.h"
#import "JHPostDetailEventManager.h"
#import "UIImageView+JHWebImage.h"
#import "CommAlertView.h"
#import "JHDetailSvgaLoadingView.h"
#import "JHPostUserInfoView.h"
#import "JHLivePlayer.h"

#import "JHEasyInputTextView.h"
#import "JHAttributeStringTool.h"

#import "JHTrackingPostDetailModel.h"
#import "JHPlayerViewController.h"
#import "JHNormalControlView.h"
#import "JHPlayerVerticalBigView.h"
#import "JHVideoPlayCompleteView.h"
#import "JHCommentTypeHeader.h"
#import "UIView+CornerRadius.h"
#import "JHAppraisePayView.h"

#import "JHC2CSetPriceAlertView.h"
#import "JHMyCompeteViewController.h"
#import "JHC2CProductRecommentView.h"
#import "JHMarketOrderConfirmViewController.h"
#import "JHMarketOrderViewModel.h"
#import "JHC2CPaySureMoneyView.h"
#import "JHAppraisePayView.h"
#import "JHOrderPayViewController.h"
#import "JHMarketOrderViewModel.h"
#import "JHC2CProductInnerChatMainCell.h"
#import "JHC2CProduuctDetailPaiMaiJianDingCell.h"
#import "JHC2CProductDetailJianDingStatuView.h"
#import "JHAuctionOrderDetailViewController.h"
#import "JHAuthorize.h"
#import "JHC2CProductInnerChatSubCell.h"
#import "JHC2CRulerAlertView.h"
#import "JHMarketHomeBusiness.h"

@interface JHC2CProductDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic) JHC2CProductDetailVCType type;

@property(nonatomic, strong) UIView * topJianDingImageViewBackView;
@property(nonatomic, strong) JHC2CProductDetailJianDingStatuView * topJianDingImageView;

@property(nonatomic, strong) JHC2CProductDetailBottomFunctionView * bottomView;

@property(nonatomic, strong) JHC2CProductRecommentView * tableFooter;

@property(nonatomic, strong) UITableView * tableView;

@property(nonatomic, strong) JHC2CProductDetailNavView *navView;

@property(nonatomic, strong) JHC2CProoductDetailModel * dataModel;

@property(nonatomic, strong) JHC2CAuctionRefershModel * auModel;



@property(nonatomic, assign) NSInteger  test;

///评论的数组
@property (nonatomic, strong) NSArray <JHCommentModel *>*commentArray;

@property (nonatomic, strong) JHPostDetailModel *postDetaiInfo;

@property(nonatomic) BOOL  hasPayBaoZhengPrice;

@property(nonatomic) BOOL  needJingPaiList;

///选中的当前评论的信息
@property (nonatomic, strong) JHCommentModel *currentMainComment;
@property (nonatomic, strong) JHCommentModel *currentComment;

/** 浮层 */
@property (nonatomic, strong) JHMarketFloatLowerLeftView *floatView;


//播放器
@property (nonatomic, strong) JHPlayerViewController *playerController;
@property (nonatomic, strong) JHNormalControlView *normalPlayerControlView;
@property (nonatomic, strong) JHC2CProductDetailImageCell *currentCell;/** 当前播放视频的cell*/

@property(nonatomic) NSInteger allChatCount;
@end

@implementation JHC2CProductDetailController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //收藏等数据刷新
//    [self.view addSubview:self.floatView];
    [self.floatView loadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupRigtFloatView];
    [self.view addSubview:self.floatView];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadData) name:@"JHC2CProductDetailControllerNeedReloadLoad" object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(refreshAllInfo) name:@"JHC2CProductDetailControllerNeedRefreshData" object:nil];
    [self requestSeeAPI];
    [JHC2CProductDetailBusiness requestC2CProductDetailProductID:self.productId completion:^(NSError * _Nullable error, JHC2CProoductDetailModel * _Nullable model) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"获取商品信息失败"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            self.dataModel = model;
            self.type = model.productType.integerValue;
            
            [self setItems];
            [self layoutItems];
            [self refrshStatus];
            [self refrehChatData];
            [self addStatistic];
            NSString* name = @"集市拍卖商品详情页";
            if (self.type == JHC2CProductDetailVCType_YiKouJia) {
                name = self.dataModel.appraisalResult == nil ? @"集市一口价商品未鉴定详情页" : @"集市一口价商品已鉴定详情页";
            }
            self.tableFooter.staticTypeName = name;
            
            //右下角浮窗按钮
            [self.view bringSubviewToFront:self.floatView];
        }
    }];
    
   
    
}

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}


- (void)reloadData{
    [self.tableView reloadData];
}

- (void)refrshStatus{
    if (self.type == JHC2CProductDetailVCType_YiKouJia) {
        if ([self.dataModel.productStatus isEqualToString:@"0"]) {
            [self.bottomView refershStatusWithType:JHC2CProductDetailBottomFunctionView_Type_YiKouJia];
        }else if ([self.dataModel.productStatus isEqualToString:@"4"]) {
            [self.bottomView refershStatusWithType:JHC2CProductDetailBottomFunctionView_Type_YiShouChu];
        }else {
            [self.bottomView refershStatusWithType:JHC2CProductDetailBottomFunctionView_Type_XiaJia];
        }
        [self setSepNav];
    }else{
        [self refershPaiMaiStatus];
    }
    //刷新浮层
    [self refreshJianDingView];
}

- (void)refreshJianDingView{
    JHC2CProductDetailJianDingType type  = JHC2CProductDetailJianDingType_NotJianDing;
    if (self.dataModel.appraisalResult) {
        NSInteger idex = self.dataModel.appraisalResult.appraisalResultType.integerValue;
//        鉴定结果类型 0 真 1 仿品 2 存疑 3 现代工艺品
        switch (idex) {
                //0 真
            case 0:
            {
                type  = JHC2CProductDetailJianDingType_Real;
            }
                break;
            case 1:
            {
                type  = JHC2CProductDetailJianDingType_Jia;
            }
                break;
                
            case 2:
            {
                type  = JHC2CProductDetailJianDingType_CunYi;
            }
                break;
            case 3:
            {
                type  = JHC2CProductDetailJianDingType_GongYiPin;
            }
                break;
            default:
                break;
        }
    }
    [self.topJianDingImageView refreshStatusType:type];

}


- (void)refrehChatData{
    [JHC2CProductDetailBusiness requestC2CChatCount:self.dataModel.productSn completion:^(NSError * _Nullable error, NSInteger count) {
        self.allChatCount = count;
        [self.tableView reloadData];
    }];
    [self loadCommentData:^(NSArray<JHCommentModel *> *commentList) {
        self.commentArray = commentList;
        [self.tableView reloadData];
    }];
}

-(void)refreshAllInfo{
    [SVProgressHUD show];
    [JHC2CProductDetailBusiness requestC2CProductDetailProductID:self.productId completion:^(NSError * _Nullable error, JHC2CProoductDetailModel * _Nullable model) {
        [SVProgressHUD dismiss];
        if (!error) {
            self.dataModel = model;
            self.needJingPaiList = YES;
            [self.tableView reloadData];
        }
    }];
    [self refershPaiMaiStatus];

}

- (void)refershPaiMaiStatus{
    if(self.type != JHC2CProductDetailVCType_PaiMai){return;}
    //        拍卖状态（0无状态 1 失效 2出局 3领先 4中拍）
    [JHC2CProductDetailBusiness requestC2CProductDetailPaiMai:self.dataModel.auctionFlow.auctionSn completion:^(NSError * _Nullable error, JHC2CAuctionRefershModel * _Nullable auModel) {
        if (!error) {
            self.auModel = auModel;
            
            [self setSepNav];
            
            JHC2CProductDetailBottomFunctionView_Type type = JHC2CProductDetailBottomFunctionView_Type_XiaJia;
            
            NSInteger productStatus = auModel.productDetailStatus;
            //预告状态未提醒
            if (productStatus  == 10){
                type = JHC2CProductDetailBottomFunctionView_Type_XiaJia;
            }else if(productStatus  == 11){
                type = JHC2CProductDetailBottomFunctionView_Type_XiaJia;
                //出价状态
            }else if(productStatus ==  20 ||
                     productStatus ==  22){
                type = JHC2CProductDetailBottomFunctionView_Type_PaiMaiZhong;
                //出价领先
            }else if(productStatus ==  21){
                type = JHC2CProductDetailBottomFunctionView_Type_LingXian;
            //流拍
            }else if(productStatus ==  30){
                type = JHC2CProductDetailBottomFunctionView_Type_Finish;
            //售出
            }else if(productStatus ==  31 ||
                     productStatus ==  33 ||
                     productStatus ==  35){
                type = JHC2CProductDetailBottomFunctionView_Type_YiShouChu;
            }else if(productStatus ==  32){
                type = JHC2CProductDetailBottomFunctionView_Type_ZhongPai;
            }

            
            [self.bottomView refershStatusWithType:type];
            
            
//            if ([auModel.productStatus isEqualToString:@"5"] || [auModel.productStatus isEqualToString:@"6"]) {
//                [self.bottomView refershStatusWithType:JHC2CProductDetailBottomFunctionView_Type_XiaJia];
//            }
//            // 商品已下架，优先考虑是否中标。- 中标 去支付
//            else if ([auModel.productStatus isEqualToString:@"1"] || [auModel.productStatus isEqualToString:@"4"]) {
//                if ([auModel.auctionStatus isEqualToString:@"4"] && auModel.orderStatus < 4) {
//                    [self.bottomView refershStatusWithType:JHC2CProductDetailBottomFunctionView_Type_ZhongPai];
//                }else {
//                    [self.bottomView refershStatusWithType:JHC2CProductDetailBottomFunctionView_Type_XiaJia];
//                }
//            }
//            else if ([auModel.flowStatus isEqualToString:@"0"]) {
//                [self.bottomView refershStatusWithType:JHC2CProductDetailBottomFunctionView_Type_XiaJia];
//
//            //竞拍中
//            }else if ([auModel.flowStatus isEqualToString:@"1"]) {
//                //当前用户拍卖状态（0无状态 1 失效 2出局 3领先 4中拍）
//                if ([auModel.auctionStatus isEqualToString:@"3"]) {
//                    [self.bottomView refershStatusWithType:JHC2CProductDetailBottomFunctionView_Type_LingXian];
//                }else if ([auModel.auctionStatus isEqualToString:@"4"]) {
//                    [self.bottomView refershStatusWithType:JHC2CProductDetailBottomFunctionView_Type_ZhongPai];
//                }else {
//                    [self.bottomView refershStatusWithType:JHC2CProductDetailBottomFunctionView_Type_PaiMaiZhong];
//                }
//            //已结束
//            }else if ([auModel.flowStatus isEqualToString:@"2"]) {
//                //当前用户拍卖状态（0无状态 1 失效 2出局 3领先 4中拍）
//                 if ([auModel.auctionStatus isEqualToString:@"4"]) {
//                    [self.bottomView refershStatusWithType:JHC2CProductDetailBottomFunctionView_Type_ZhongPai];
//                 }else{
//                     [self.bottomView refershStatusWithType:JHC2CProductDetailBottomFunctionView_Type_Finish];
//                 }
//            }
            [self.tableView reloadData];
        }
    }];

}




///全部评论接口
- (void)loadCommentData:(void(^)(NSArray <JHCommentModel *>*))block {
    [self.view beginLoading];
    ///展开父级评论
    //获取最后一条主评论的评论id
    NSString *lastId = @"0";
    
    NSString *fillterIds =  @"0";
        
    [JHSQApiManager getAllCommentList:self.dataModel.productSn itemType:100 page:1 lastId:lastId filterIds:fillterIds completation:^(RequestModel *respObj, BOOL hasError) {
        [self.view endLoading];
        NSMutableArray *commentList = [NSMutableArray array];
        if (!hasError) {
            NSMutableArray <JHCommentModel *>*arr = [JHCommentModel mj_objectArrayWithKeyValuesArray:respObj.data[@"list"]];
            [commentList addObjectsFromArray:arr];
        }
        else {
            [UITipView showTipStr:respObj.message ?: @"加载失败"];
        }
        if (block) {
            block(commentList);
        }
    }];
    
}

#pragma mark -- <Actions>

/// 分享朋友圈
/// @param sender
- (void)shareQuanActionWithSender:(UIButton*)sender{
    NSDictionary * infoDic = self.dataModel.shareInfo;
    JHShareInfo* info = [JHShareInfo new];
    info.title = infoDic[@"title"];
    info.desc = infoDic[@"desc"];
    info.img = infoDic[@"img"];
    info.shareType = ShareObjectTypeStoreGoodsDetail;
    info.pageFrom = JHPageFromTypeUnKnown;
    info.url = infoDic[@"url"];
    [JHBaseOperationAction toShare:JHOperationTypeWechatTimeLine operationShareInfo:info object_flag:@{}];//TODO:Umeng share

}

/// 分享wexin
/// @param sender
- (void)shareWeChatActionWithSender:(UIButton*)sender{
    NSDictionary * infoDic = self.dataModel.shareInfo;
    JHShareInfo* info = [JHShareInfo new];
    info.title = infoDic[@"title"];
    info.desc = infoDic[@"desc"];
    info.img = infoDic[@"img"];
    info.shareType = ShareObjectTypeStoreGoodsDetail;
    info.pageFrom = JHPageFromTypeUnKnown;
    info.url = infoDic[@"url"];
    [JHBaseOperationAction toShare:JHOperationTypeWechatSession operationShareInfo:info object_flag:@{}];//TODO:Umeng share
}


///一键鉴定,先下单,后跳转到支付页面
- (void)appriseButtonlick{
    //调取下单接口
    [JHRootController checkLoginWithTarget:self complete:^(BOOL result) {
        if (result) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"productId"] = self.productId;
            [SVProgressHUD show];
            [JHMarketOrderViewModel appriaseProductAuth:params Completion:^(NSError * _Nullable error, JHMarketProductAuthModel * _Nullable model) {
                [SVProgressHUD dismiss];
                if(error){
                    JHTOAST(error.localizedDescription);
                }else if ([model.orderStatus isEqualToString:@"waitack"] || [model.orderStatus isEqualToString:@"waitpay"]) {
                    //下面是支付页面
                    JHAppraisePayView * payView = [[JHAppraisePayView alloc]init];
                    payView.orderId = model.orderId;
                    payView.from = @"ProductDetail";
                    
                    [JHKeyWindow addSubview:payView];
                    [payView showAlert];
                }else{
                    JHTOAST(@"鉴定报告即将出炉，请耐心等待");
                }
            }];
        }
    }];
}


/// 底部收藏
/// @param sender
- (void)bottomSaveBtnActionWithSender:(UIButton*)sender{
    
    //埋点
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* name = @"集市拍卖商品详情页";
    if (self.type == JHC2CProductDetailVCType_YiKouJia) {
        name = self.dataModel.appraisalResult == nil ? @"集市一口价商品未鉴定详情页" : @"集市一口价商品已鉴定详情页";
    }
    parDic[@"page_position"] = name;
    parDic[@"is_favorite"] = !sender.isSelected ? @YES : @NO;
    parDic[@"favorite_Type"] = @"商品";
    parDic[@"commodity_id"] = self.productId;
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickFavorite" params:parDic type:JHStatisticsTypeSensors];

    [JHRootController checkLoginWithTarget:self complete:^(BOOL result) {
        if (result) {
            [self collectProductWithSender:sender];
        }
    }];
}
- (void)collectProductWithSender:(UIButton*)sender{
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"productId"] = self.productId;
    par[@"productType"] = self.dataModel.productType;
    par[@"sellerType"] = @"1";
    if (!sender.isSelected) {
        [JHC2CProductDetailBusiness requestC2CProductDetailCollectProduct:par completion:^(NSError * _Nullable error) {
            if (!error) {
                [sender setSelected:YES];
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                [self.floatView loadData];
                
                [JHAuthorize clickTriggerPushAuthorizetion:JHAuthorizeClickTypeGoodsCollection];
            }else{
                [SVProgressHUD showErrorWithStatus:@"收藏失败"];
            }
        }];
    }else{
        [JHC2CProductDetailBusiness requestC2CProductDetailCancleCollectProduct:par completion:^(NSError * _Nullable error) {
            if (!error) {
                [sender setSelected:NO];
                [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
                [self.floatView loadData];
            }else{
                [SVProgressHUD showErrorWithStatus:@"操作失败"];
            }
        }];
    }
}



/// 聊一聊
/// @param sender
- (void)chatBtnActionWithSender:(UIButton*)sender{
    
    //埋点
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* name = @"集市拍卖商品详情页";
    if (self.type == JHC2CProductDetailVCType_YiKouJia) {
        name = self.dataModel.appraisalResult == nil ? @"集市一口价商品未鉴定详情页" : @"集市一口价商品已鉴定详情页";
    }
    parDic[@"page_position"] = name;
    parDic[@"operation_type"] = @"im";
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickCustomer" params:parDic type:JHStatisticsTypeSensors];

    NSString *userID = UserInfoRequestManager.sharedInstance.user.customerId;
    NSNumber *sellerID = self.dataModel.seller[@"id"];
    if ([sellerID.stringValue isEqualToString:userID]) {
        [SVProgressHUD showInfoWithStatus:@"不能和自己聊天"];
        return;
    }
    [JHRootController checkLoginWithTarget:self complete:^(BOOL result) {
        if (result) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
            dic[@"productId"] = self.productId;
            dic[@"type"] = @"2";
            [JHC2CProductDetailBusiness requestC2CProductSeeOrWant:dic completion:^(NSError * _Nullable error) {
            }];
            
            JHChatGoodsInfoModel *model = [JHChatGoodsInfoModel new];
            model.productId = self.productId;
            model.title = self.dataModel.productDesc;
            model.iconUrl = self.dataModel.mainImages.firstObject.url;
            model.price = self.dataModel.price;
            [JHIMEntranceManager pushSessionWithUserId:sellerID.stringValue
                                           sourceType : JHIMSourceTypeC2CGoodsDetail
                                             goodsInfo:model];
        }
    }];
    
}


- (BOOL)cheackAlert{
    BOOL hasShow = [NSUserDefaults.standardUserDefaults boolForKey:@"JHC2C_notice_Detail_HasShow"];
    if (!hasShow) {
        [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"JHC2C_notice_Detail_HasShow"];
        [NSUserDefaults.standardUserDefaults synchronize];
        JHC2CRulerAlertView *alert = [JHC2CRulerAlertView new];
        alert.forDetailVC = YES;
        [self.view addSubview:alert];
    }
    return hasShow;
}


/// 底部MainBtn
/// @param sender
- (void)bottomMainBtnActionWithSender:(UIButton*)sender{
    if (![self cheackAlert]) {return;}
    //埋点"属性值：集市一口价商品已鉴定详情页、集市一口价商品未鉴定详情页、集市拍卖商品详情页
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* name = @"集市拍卖商品详情页";
    if (self.type == JHC2CProductDetailVCType_YiKouJia) {
        name = self.dataModel.appraisalResult == nil ? @"集市一口价商品未鉴定详情页" : @"集市一口价商品已鉴定详情页";
    }
    parDic[@"page_position"] = name;
    parDic[@"commodity_id"] = self.productId;
    [JHAllStatistics jh_allStatisticsWithEventId:@"buyButtonClick" params:parDic type:JHStatisticsTypeSensors];
    @weakify(self);
    [JHRootController checkLoginWithTarget:self complete:^(BOOL result) {
        @strongify(self);
        if (result) {
            //判断用户是否被处罚或IM拉黑
            [self cheakUserIsLimit:3 completion:^(BOOL isLimit) {
                if (isLimit) return;
                [self bugAction];
            }];
        }
    }];
}

/// leftBtn
/// @param sender
- (void)bottomLeftBtnActionWithSender:(UIButton*)sender{
    if (![self cheackAlert]) {return;}
    //拉黑后禁止代理出价
    [self cheakUserIsLimit:3 completion:^(BOOL isLimit) {
        if (isLimit) return;
        
        [self checkAndDoActionWith:YES];
        //埋点
        NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
        parDic[@"page_position"] = @"集市拍卖商品详情页";
        parDic[@"commodity_id"] = self.productId;
        [JHAllStatistics jh_allStatisticsWithEventId:@"agentBidOfferButtonClick" params:parDic type:JHStatisticsTypeSensors];
    }];
}


/// bottomRightBtn
/// @param sender
- (void)bottomRightBtnActionWithSender:(UIButton*)sender{
    if (![self cheackAlert]) {return;}
    //拉黑后禁止出价
    [self cheakUserIsLimit:3 completion:^(BOOL isLimit) {
        if (isLimit) return;
        
        if (self.bottomView.type == JHC2CProductDetailBottomFunctionView_Type_LingXian) {return;}
        [self checkAndDoActionWith:NO];
        
    }];
}

- (void)checkAndDoActionWith:(BOOL)isAgentBtn{
    [JHRootController checkLoginWithTarget:self complete:^(BOOL result) {
        if (result) {
            NSString *userID = UserInfoRequestManager.sharedInstance.user.customerId;
            NSNumber *sellerID = self.dataModel.seller[@"id"];
            if ([userID isEqualToString:sellerID.stringValue]) {
                NSString *tostStr = isAgentBtn ? @"用户不能对自己的宝贝设置代理":@"用户不能对自己的宝贝进行出价";
                [SVProgressHUD showInfoWithStatus:tostStr];
            }else{
                [self checkBaoZhangJinWith:isAgentBtn];
            }
        }
    }];

}





- (void)checkBaoZhangJinWith:(BOOL)isAgent{
    if ([self.dataModel.auctionFlow.earnestMoney isEqualToString:@"0"]) {
        JHC2CSetPriceAlertView *alertView = [JHC2CSetPriceAlertView new];
        alertView.isAgent = isAgent ? 1 : 0;
        alertView.productID = self.productId;
        JHC2CSetPriceAlertViewType type = JHC2CSetPriceAlertView_First;
        if (isAgent) {
            if (self.auModel.isAgent) {
                type = JHC2CSetPriceAlertView_SetDelegate;
            }
        }else{
            type = JHC2CSetPriceAlertView_ChuJia;
        }
        [alertView refresWithType:type];
        alertView.model = self.dataModel;
        alertView.auModel = self.auModel;
        [self.view addSubview:alertView];
    }else{
        [SVProgressHUD show];
        NSMutableDictionary* par = [NSMutableDictionary dictionary];
        par[@"auctionSn"] = self.dataModel.auctionFlow.auctionSn;
        par[@"orderType"] = @"11";
        par[@"orderCategory"] = @"marketDepositOrder";
        par[@"earnestMoney"] = self.dataModel.auctionFlow.earnestMoney;
        par[@"productId"] = self.productId;
        par[@"source"] = @"保证金";
        [JHC2CProductDetailBusiness requestC2CPaySureMoney:par completion:^(NSError * _Nullable error, JHC2CSureMoneyModel * model) {
            [SVProgressHUD dismiss];
            if ([model.orderStatus isEqualToString:@"waitpay"]) {
                JHC2CPaySureMoneyView *alertView = [JHC2CPaySureMoneyView new];
                alertView.productID = self.productId;
                alertView.model = self.dataModel;
                @weakify(self);
                [alertView setPayBlock:^ {
                    @strongify(self);
                    [self showPayViewOrderID:model.orderId];
                }];
                [self.view addSubview:alertView];
            }else if([model.orderStatus isEqualToString:@"waitack"]){
                [SVProgressHUD showInfoWithStatus:@"订单确认中"];
            }else if([model.orderStatus isEqualToString:@"buyerreceived"]){
                JHC2CSetPriceAlertView *alertView = [JHC2CSetPriceAlertView new];
                alertView.isAgent = isAgent ? 1 : 0;
                alertView.productID = self.productId;
                JHC2CSetPriceAlertViewType type = JHC2CSetPriceAlertView_First;
                if (isAgent) {
                    if (self.auModel.isAgent) {
                        type = JHC2CSetPriceAlertView_SetDelegate;
                    }
                }else{
                    type = JHC2CSetPriceAlertView_ChuJia;
                }
                [alertView refresWithType:type];
                alertView.model = self.dataModel;
                alertView.auModel = self.auModel;
                [self.view addSubview:alertView];
    //            refunding
            }else{
                [SVProgressHUD showErrorWithStatus:@"获取信息失败"];
            }
        }];
    }
}

///支付保证金
- (void)showPayViewOrderID:(NSString*)orderID{
    JHOrderPayViewController * order = [[JHOrderPayViewController alloc]init];
    order.orderCategory = @"marketAuctionOrder";
    order.goodsId = self.productId;
    order.orderId = orderID;
    order.isAuction = YES;
    [self.navigationController pushViewController:order animated:YES];

}


- (void)payBaoZhengJin{
    JHMarketOrderConfirmViewController *vc = [[JHMarketOrderConfirmViewController alloc] init];
    vc.activeConfirmOrder = YES;
    vc.goodsId = self.productId;
    vc.orderCategory = @"marketDepositOrder";
    vc.orderType  = JHOrderTypeMarketsell;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)bugAction{
    NSString *userID = UserInfoRequestManager.sharedInstance.user.customerId;
    NSNumber *sellerID = self.dataModel.seller[@"id"];
    if ([userID isEqualToString:sellerID.stringValue]) {
        [SVProgressHUD showInfoWithStatus:@"用户不能对自己的宝贝进行购买"];
        return;
    }
    if (self.type == JHC2CProductDetailVCType_YiKouJia) {
        JHMarketOrderConfirmViewController *vc = [[JHMarketOrderConfirmViewController alloc] init];
        vc.activeConfirmOrder = YES;
        vc.goodsId = self.productId;
        vc.orderCategory = @"marketFixedOrder";
        vc.orderType  = JHOrderTypeMarketsell;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self getOrderDetail];
//        JHMarketOrderConfirmViewController *vc = [[JHMarketOrderConfirmViewController alloc] init];
//        vc.activeConfirmOrder = YES;
//        vc.goodsId = self.productID;
//        vc.orderCategory = @"marketAuctionOrder";
//        vc.orderId = self.auModel.orderId;
//        vc.orderType  = JHOrderTypeMarketsell;
//        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -- 获取订单详情
- (void)getOrderDetail {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.auModel.orderId;
    [JHMarketOrderViewModel orderDetail:params isBuyer:true Completion:^(NSError * _Nullable error, JHMarketOrderModel * _Nullable orderModel) {
        
        [SVProgressHUD dismiss];
        if (!error) {
            if (orderModel.orderStatus.integerValue == 1) {
                [self pushOrderConfirm];
            }else if (orderModel.orderStatus.integerValue == 2){
                [self pushOrderPay];
            }
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}
- (void)pushOrderConfirm {
//    JHMarketOrderConfirmViewController * order=[[JHMarketOrderConfirmViewController alloc]init];
//    order.orderCategory = @"marketAuctionOrder";
//    order.orderId= self.auModel.orderId;
//
//    [self.navigationController pushViewController:order animated:YES];
    
    JHAuctionOrderDetailViewController * order=[[JHAuctionOrderDetailViewController alloc]init];
    order.orderId= self.auModel.orderId;
    order.orderCategory = @"marketAuctionOrder";
    [self.navigationController pushViewController:order animated:YES];
}
- (void)pushOrderPay {
    //下面是支付页面
    JHOrderPayViewController *order =[[JHOrderPayViewController alloc]init];
    order.orderId=self.auModel.orderId;
    order.goodsId = self.productId;
    order.isMarket = YES;
    [self.navigationController pushViewController:order animated:YES];
}
/// 举报页面
- (void)showJuBao{
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.titleString = @"举报";
    NSString *url = H5_BASE_HTTP_STRING(@"/jianhuo/app/cTwoc/report.html?");
    url = [url stringByAppendingFormat:@"productId=%@",
           self.productId];
    webVC.urlString = url;
    [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];

}


- (void)showChatListVC{
    JHC2CProductDetailChatListController *vc = [JHC2CProductDetailChatListController new];
    vc.productSn = self.dataModel.productSn;
    NSNumber *sellerID = self.dataModel.seller[@"id"];
    vc.sellerID = sellerID;
    @weakify(self);
    [vc setCloseNeedRefresh:^(BOOL refresh) {
        @strongify(self);
        [self refrehChatData];
    }];
    [vc setChatCountChange:^(NSInteger count) {
        @strongify(self);
        self.allChatCount = count;
    }];
    [self.navigationController presentViewController:vc animated:NO completion:nil];
}

- (void)showJingPaiListController{
    JHC2CProductDetailPaiMaiListController *vc = [JHC2CProductDetailPaiMaiListController new];
    vc.ansID = self.dataModel.auctionFlow.auctionSn;
    [self.navigationController presentViewController:vc animated:NO completion:nil];
}

- (void)requestSeeAPI{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"productId"] = self.productId;
    dic[@"type"] = @"1";
    [JHC2CProductDetailBusiness requestC2CProductSeeOrWant:dic completion:^(NSError * _Nullable error) {
    }];

}

#pragma mark - 评论输入框相关
- (void)loginAndPublish{
    JHTextInPutView *easyView = [[JHTextInPutView alloc] initInputTextViewWithFontSize:[UIFont fontWithName:kFontNormal size:13.f] limitNum:10000 inputBackgroundColor:kColorF5F6FA maxNumbersOfLine:3 currentViewController:NSStringFromClass([JHRootController.currentViewController class])];
    easyView.showLimitNum = YES;
    [JHKeyWindow addSubview:easyView];
    [easyView show];
    @weakify(easyView);
    [easyView toPublish:^(NSDictionary * _Nonnull inputInfos) {
        @strongify(easyView);
        [easyView endEditing:YES];
        [self toPublishPostComment:inputInfos];
    }];
}

- (void)publishChat:(int)index{
    @weakify(self);
    [JHRootController checkLoginWithTarget:self complete:^(BOOL result) {
        @strongify(self);
        if (result) {
            //判断用户是否被平台处罚或im拉黑
            [self cheakUserIsLimit:4 completion:^(BOOL isLimit) {
                @strongify(self);
                if (isLimit) return;
                if (index == 0) {
                    [self loginAndPublish];
                }else{
                    [self inputComment:NO];
                }
            }];
        }
    }];
}


///评论帖子
- (void)toPublishPostComment:(NSDictionary *)inputInfos {
    if (!inputInfos) {
        [UITipView showTipStr:@"请输入评论内容"];
        return;
    }
    @weakify(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:inputInfos];
    NSNumber *sellerID = self.dataModel.seller[@"id"];
    params[@"item_user_id"] = sellerID;
    
    [JHSQApiManager submitCommentWithCommentInfos:params itemId:self.dataModel.productSn itemType:100 completeBlock:^(RequestModel *respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            [UITipView showTipStr:@"评论成功"];
            JHCommentModel *model = [JHCommentModel mj_objectWithKeyValues:respObj.data];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.commentArray];
            [arr insertObject:model atIndex:0];
            self.commentArray = arr.copy;
            self.allChatCount += 1;
            [self.tableView reloadData];
        }else {
            [UITipView showTipStr:[respObj.message isNotBlank] ? respObj.message : @"评论失败"];
        }
    }];
}
///回复主评论或者子评论
- (void)toPublishReplyComment:(NSDictionary *)commentInfos {
//    self.hasChenge = YES;
    if (!commentInfos) {
        [UITipView showTipStr:@"请输入评论内容"];
        return;
    }
    //需要判断是@的还是主动发送的
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"item_user_id"] = self.dataModel.seller[@"id"];;
    params[@"item_id"] = self.dataModel.productSn;
    params[@"item_type"] = @100;
    [params addEntriesFromDictionary:commentInfos];
    if (self.currentComment.parent_id > 0) { ///子评论
        [params setValue:@(self.currentComment.parent_id) forKey:@"comment_id"];
        [params setValue:[NSNumber numberWithString:self.currentComment.publisher.user_id] forKey:@"at_user_id"];
        [params setValue:self.currentComment.publisher.user_name forKey:@"at_user_name"];
    }else {///主评论
        [params setValue:[NSNumber numberWithString:self.currentComment.comment_id] forKey:@"comment_id"];
    }
    [JHSQApiManager submitCommentReplay:params completeBlock:^(RequestModel *respObj, BOOL hasError) {
        if (!hasError) {
            //无论回复的是主评论还是子评论，都插在当前组的第一条
            JHCommentModel *model = [JHCommentModel mj_objectWithKeyValues:respObj.data];
            if (model) {
                NSMutableArray *arr = [NSMutableArray arrayWithArray:self.currentMainComment.reply_list];
                [arr insertObject:model atIndex:0];
                self.currentMainComment.reply_list = arr.copy;
                [self.tableView reloadData];
                self.allChatCount += 1;
                [self.tableView reloadData];
            }
        }
    }];
}
#pragma mark - 点赞
- (void)likeActionWithContentView:(id)contentView itemType:(NSInteger)itemType itemId:(NSString *)itemId likeNum:(NSInteger)likeNum isLike:(BOOL)isLike {
    if (IS_LOGIN) {
        @weakify(self);
        if (isLike) {
            ///当前状态是已赞状态 需要取消点赞
            [JHUserInfoApiManager sendCommentUnLikeRequest:itemType itemId:itemId likeNum:likeNum block:^(RequestModel *respObj, BOOL hasError) {
                @strongify(self);
                if (!hasError) {
                    [UITipView showTipStr:@"取消点赞成功"];
                    [self __updateContentViewData:contentView isLike:!isLike];
                }
            }];
        }else {
            [JHUserInfoApiManager sendCommentLikeRequest:itemType itemId:itemId likeNum:likeNum block:^(RequestModel *respObj, BOOL hasError) {
                @strongify(self);
                if (!hasError) {
                    [UITipView showTipStr:@"点赞成功"];
                    [self __updateContentViewData:contentView isLike:!isLike];
                }
            }];
        }
    }
}

- (void)__updateContentViewData:(id)contentView isLike:(BOOL)isLike {
    if (contentView) {
        self.currentComment.like_num += isLike ? 1 : (-1);
        self.currentComment.is_like = @(isLike).integerValue;
        if ([contentView isMemberOfClass:[JHC2CProductInnerChatMainCell class]]) {
            JHC2CProductInnerChatMainCell *header = (JHC2CProductInnerChatMainCell *)contentView;
            [header updateLikeButtonStatus:self.currentComment];
        }
    }
}

#pragma mark -- <UITableViewDelegate and UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [self tableView:tableView getInfoCellWithIndexPath:indexPath];
    }else{
        cell = [self tableView:tableView getChatCellWithIndexPath:indexPath];
    }
    return cell ? cell : [UITableViewCell new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1){
        @weakify(self);
        JHC2CProductDetailChatHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JHC2CProductDetailChatHeader"];
        [view setTapViewAction:^{
            @strongify(self);
            [self publishChat:0];
        }];
        view.titlleLbl.text = [NSString stringWithFormat:@"全部留言 %ld",self.allChatCount];
        return view;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (self.commentArray.count > 3) {
        NSInteger chatCount = MIN(self.commentArray.count, 3);
        if (section == chatCount) {
            @weakify(self);
            JHC2CProductDetailChatFooter *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JHC2CProductDetailChatFooter"];
            [view setTapViewAction:^{
                @strongify(self);
                [self showChatListVC];
            }];
            return view;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 1) {
//        [self showChatListVC];
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSInteger count = 6;
        if (!self.dataModel.supportAuth) {
            count = 4;
        }
        return count;
    }else{
//        NSInteger chatCount = MIN(self.commentArray.count, 3);
//        return chatCount;
        if (self.commentArray.count == 0) {
            return 0;
        }
        JHCommentModel *model = self.commentArray[section-1];
        return model.reply_list.count + 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger chatCount = MIN(self.commentArray.count, 3);
    if (self.commentArray.count == 0) {
        return 2;
    }
    return chatCount+1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 107;

    }else{
        return 0.1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.commentArray.count > 3) {
        NSInteger chatCount = MIN(self.commentArray.count, 3);
        if (section == chatCount) {
            return 42;
        }else{
            return 0.01;
        }
    }else{
        return 0.01;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.tableView]) {
        //返回顶部按钮
        self.floatView.topButton.hidden = self.tableView.contentOffset.y < kScreenHeight;
        
        //如果未鉴定增加悬浮逻辑
        if(self.dataModel.supportAuth){
            BOOL needShow = self.tableView.contentOffset.y > 78.f;
            NSArray *arr = [self.tableView visibleCells];
            NSArray<NSIndexPath*> *indexPathArr = [self.tableView indexPathsForVisibleRows];
            CGFloat footerViewY = self.tableView.tableFooterView.frame.origin.y;
            BOOL footerViewShow = self.tableView.contentOffset.y + ScreenHeight > footerViewY ;
            __block BOOL reachBottom = NO;
            __block BOOL hasShowJianDing = NO;
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[JHC2CProductDetailDaiJianDingCell class]]) {
                    hasShowJianDing = YES;
                }
            }];
            [indexPathArr enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.section > 0) {
                    reachBottom = YES;
                }
            }];
            if (self.tableView.contentOffset.y < 100) {
                self.topJianDingImageViewBackView.alpha = !hasShowJianDing && needShow ? 1 : 0;
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    self.topJianDingImageViewBackView.alpha = !hasShowJianDing && needShow && !reachBottom && !footerViewShow ? 1 : 0;
                }];
            }
        }
    }
    
    //底部推荐
    [self.tableFooter refrshWithMainScroolViewScrool:self.tableView];
}

#pragma mark -- <private menth>


- (UITableViewCell *)tableView:(UITableView*)tableView getInfoCellWithIndexPath:(NSIndexPath*)indexPath{
    BOOL supportAuth = self.dataModel.supportAuth;
    NSInteger row = indexPath.row;
    if (!supportAuth) {
        row += 1;
    }
    switch (row) {
            
        case 0:
        {
            
            JHC2CProduuctDetailPaiMaiJianDingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHC2CProduuctDetailPaiMaiJianDingCell" forIndexPath:indexPath];
            cell.model = self.dataModel;
            @weakify(self);
            [cell setGoJianDingBlock:^{
                @strongify(self);
                [self appriseButtonlick];
            }];
            return cell;
        }
            break;
            
        case 1:
        {
            if (self.type == JHC2CProductDetailVCType_YiKouJia) {
                JHC2CProductDetailYiKouJiaInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHC2CProductDetailYiKouJiaInfoCell" forIndexPath:indexPath];
                cell.model = self.dataModel;
                return cell;
            }else{
                JHC2CProductDetailPaiMaiInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHC2CProductDetailPaiMaiInfoCell" forIndexPath:indexPath];
                cell.model = self.dataModel;
                cell.auModel = self.auModel;
                if (self.needJingPaiList) {
                    self.needJingPaiList = NO;
                    [cell refreshPaiMai];
                }
                @weakify(self);
                [cell setTapSeletedJingPai:^{
                    @strongify(self);
                    [self showJingPaiListController];
                }];
                [cell setTapRefreshBlock:^{
                    @strongify(self);
                    [self refreshAllInfo];
                }];
                if (self.test == 1) {
                    [cell refreshStatus:JHC2CJingPaiStatus_Type_WeiChuJia];
                }
                return cell;
            }
                break;

            }
            
        case 2:
        {
            JHC2CProductDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHC2CProductDetailTextCell" forIndexPath:indexPath];
            cell.model = self.dataModel;
            return cell;
        }
            break;
        case 3:
        {
            JHC2CProductDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHC2CProductDetailImageCell" forIndexPath:indexPath];
            cell.model = self.dataModel;
            @weakify(self);
            [cell setPlayVideo:^(JHC2CProductDetailImageCell * _Nonnull cell) {
                @strongify(self);
                self.currentCell = cell;
                [self addPlayerToCell];
            }];
            [cell setPlayVideoOut:^(JHC2CProductDetailImageCell * _Nonnull cell) {
                @strongify(self);
                self.currentCell = cell;
                [self showPlayer];
            }];

            return  cell;
        }
            break;
        case 4:
        {
            JHC2CProductDetailBottomInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHC2CProductDetailBottomInfoCell" forIndexPath:indexPath];
            cell.model = self.dataModel;
            @weakify(self);
            [cell setTapJuBao:^{
                @strongify(self);
                [self showJuBao];
            }];
            return  cell;
        }
            break;
        case 5:
        {
            //鉴定信息
            if (self.dataModel.appraisalResult) {
                JHC2CProductDetailJianDingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHC2CProductDetailJianDingCell" forIndexPath:indexPath];
                cell.model = self.dataModel;
                cell.productID = self.dataModel.productSn;
                return  cell;
            }else{
                JHC2CProductDetailDaiJianDingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHC2CProductDetailDaiJianDingCell" forIndexPath:indexPath];
                [cell.jianDingBtn addTarget:self action:@selector(appriseButtonlick) forControlEvents:UIControlEventTouchUpInside];
                return  cell;
            }
        }
            break;
            
        default:
            break;
    }
    return  [UITableViewCell new];
}

- (UITableViewCell *)tableView:(UITableView*)tableView getChatCellWithIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row == 0) {
        JHCommentModel *model = self.commentArray[indexPath.section-1];
        JHC2CProductInnerChatMainCell *header = [tableView dequeueReusableCellWithIdentifier:@"JHC2CProductInnerChatMainCell"];
        
        header.postAuthorId = model.publisher.user_id;
        header.indexPath = indexPath;
        model.isDetailView = YES;
        header.mainComment = model;
        @weakify(self);
        header.actionBlock = ^(NSIndexPath * _Nonnull selectIndexPath, JHC2CProductInnerChatMainCell * _Nonnull header, JHPostDetailActionType actionType) {
            @strongify(self);
            [self handleCommentActionEvent:actionType selecIndexPath:selectIndexPath contentView:header];
        };
        return header;
    }
    
    ///回复列表
    JHC2CProductInnerChatSubCell *cell = [tableView dequeueReusableCellWithIdentifier:kJHC2CProductInnerChatSubCell];
    JHCommentModel *model = self.commentArray[indexPath.section-1];
    cell.postAuthorId = model.publisher.user_id;
    cell.indexPath = indexPath;
    JHCommentModel *subModel = model.reply_list[indexPath.row-1];
    model.isDetailView = YES;
    cell.commentModel = subModel;
    @weakify(self);
    cell.actionBlock = ^(NSIndexPath * _Nonnull selectIndexPath, JHC2CProductInnerChatSubCell * _Nonnull cell, JHPostDetailActionType actionType) {
        @strongify(self);
        [self handleCommentActionEvent:actionType selecIndexPath:selectIndexPath contentView:cell];
    };
    return cell;
}

#pragma mark -- <社区cell事件>
///处理评论列表的各种点击事件
- (void)handleCommentActionEvent:(JHPostDetailActionType)type selecIndexPath:(NSIndexPath *)indexPath contentView:(id)contentView {
    JHCommentModel *commentInfo = self.commentArray[indexPath.section-1];
    BOOL isMain = [contentView isMemberOfClass:[JHC2CProductInnerChatMainCell class]];
    self.currentMainComment = commentInfo;
    self.currentComment = isMain ? self.currentMainComment : commentInfo.reply_list[indexPath.row-1];
    switch (type) {
        case JHPostDetailActionTypeLike: /// 点赞
        {
            NSInteger itemType = (self.currentComment.parent_id > 0) ? 4 : 3;
            [self likeActionWithContentView:contentView itemType:itemType itemId:self.currentComment.comment_id likeNum:self.currentComment.like_num isLike:self.currentComment.is_like];
        }
            break;
        case JHPostDetailActionTypeSingleTap: /// 单击
        {
//            self.commentMethod = @"文章详情页评论";
            [self publishChat:1];
        }
            break;
        case JHPostDetailActionTypeLongPress: /// 长按
        {
            NSLog(@"长按了子评论 弹出弹窗呢要");
        }
            break;
        case JHPostDetailActionTypeEnterPersonPage: ///进入个人主页
        {
//            NSLog(@"长按了子评论 弹出弹窗呢要");
//            [self enterPersonalPage:self.currentComment.publisher.user_id publisher:self.currentComment.publisher roomId:self.currentComment.publisher.room_id];
        }
            break;

        default:
            break;
    }
}

- (void)inputComment:(BOOL)isMainComment {
    JHTextInPutView *easyView = [[JHTextInPutView alloc] initInputTextViewWithFontSize:[UIFont fontWithName:kFontNormal size:13.f] limitNum:10000 inputBackgroundColor:kColorF5F6FA maxNumbersOfLine:3 currentViewController:NSStringFromClass([JHRootController.currentViewController class])];
    easyView.showLimitNum = YES;
    [JHKeyWindow addSubview:easyView];
    [easyView show];
    @weakify(easyView);
    [easyView toPublish:^(NSDictionary * _Nonnull inputInfos) {
        @strongify(easyView);
        [easyView endEditing:YES];
        if (isMainComment) {
            [self toPublishPostComment:inputInfos];
        }else {
            [self toPublishReplyComment:inputInfos];
        }
    }];
}

- (void)tableView:(UITableView*)tableView registerCellWithClassString:(NSString*)name{
    [tableView registerClass:NSClassFromString(name) forCellReuseIdentifier:name];
}
- (void)tableView:(UITableView*)tableView registerHeaderAndFooterWithClassString:(NSString*)name{
    [tableView registerClass:NSClassFromString(name) forHeaderFooterViewReuseIdentifier:name];
}

- (void)showToastMsg{
    [self.view makeToast:@"您已经被该卖家限制留言，看看其他宝品吧～" duration:1.0 position:CSToastPositionCenter];
}



- (void)setSepNav{
    [self.navView removeFromSuperview];
    JHC2CProductDetailNavView *navView = [JHC2CProductDetailNavView new];
    navView.dataModel = self.dataModel;
    navView.auModel = self.auModel;
    navView.productID = self.productId;
    [navView.quanBtn addTarget:self action:@selector(shareQuanActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
    [navView.wechatBtn addTarget:self action:@selector(shareWeChatActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
    [self.jhNavView addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(@0);
        make.left.equalTo(self.jhLeftButton.mas_right).offset(-20);
    }];
    self.navView = navView;
}
- (void)setItems{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    if(self.dataModel.supportAuth){
        [self.view addSubview:self.topJianDingImageViewBackView];
    }

}
- (void)layoutItems{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top);
        make.left.right.equalTo(@0);
        make.top.equalTo(self.jhNavView.mas_bottom);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(UI.bottomSafeAreaHeight + 58);
        make.bottom.left.right.equalTo(@0);
    }];
    if(self.dataModel.supportAuth){
        [self.topJianDingImageViewBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(self.jhNavView.mas_bottom);
        }];
    }

}


#pragma mark -- <Set and get>
- (JHC2CProductDetailHeader*)getHeader{
    JHC2CProductDetailHeader *header = [JHC2CProductDetailHeader new];
    header.model = self.dataModel;
    return header;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        view.delegate = self;
        view.dataSource = self;
        view.tableHeaderView = [self getHeader];
        view.showsVerticalScrollIndicator = NO;
        view.bounces = NO;
        JHC2CProductRecommentView *footView = [JHC2CProductRecommentView new];
        footView.locationProductID = self.productId;
        footView.mainTableView = view;
        footView.productType = self.type == JHC2CProductDetailVCType_YiKouJia ? @"0" : @"1";
        self.tableFooter = footView;
        view.tableFooterView = footView;
        view.backgroundColor = HEXCOLOR(0xF5F5F5);
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.estimatedRowHeight = 100;
        view.estimatedSectionHeaderHeight = 0;
        view.estimatedSectionFooterHeight = 0;
        [self tableView:view registerCellWithClassString:@"JHC2CProductDetailYiKouJiaInfoCell"];
        [self tableView:view registerCellWithClassString:@"JHC2CProduuctDetailPaiMaiJianDingCell"];
        [self tableView:view registerCellWithClassString:@"JHC2CProductDetailPaiMaiInfoCell"];
        [self tableView:view registerCellWithClassString:@"JHC2CProductDetailTextCell"];
        [self tableView:view registerCellWithClassString:@"JHC2CProductDetailImageCell"];
        [self tableView:view registerCellWithClassString:@"JHC2CProductDetailBottomInfoCell"];
        [self tableView:view registerCellWithClassString:@"JHC2CProductDetailJianDingCell"];
        [self tableView:view registerCellWithClassString:@"JHC2CProductDetailDaiJianDingCell"];
        [self tableView:view registerCellWithClassString:@"JHC2CProductInnerChatMainCell"];
        [self tableView:view registerHeaderAndFooterWithClassString:@"JHC2CProductDetailChatHeader"];
        [self tableView:view registerHeaderAndFooterWithClassString:@"JHC2CProductDetailChatFooter"];
        [view registerClass:[JHC2CProductInnerChatSubCell class] forCellReuseIdentifier:kJHC2CProductInnerChatSubCell];
        _tableView = view;
    }
    return _tableView;
}

- (JHC2CProductDetailBottomFunctionView *)bottomView{
    if (!_bottomView) {
        JHC2CProductDetailBottomFunctionView *view = [JHC2CProductDetailBottomFunctionView new];
        view.hasCollecte = self.dataModel.followStatus;
        [view.smallLeftBtn addTarget:self action:@selector(bottomLeftBtnActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        [view.smallRightBtn addTarget:self action:@selector(bottomRightBtnActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        [view.largeMainBtn addTarget:self action:@selector(bottomMainBtnActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        [view.saveBtn addTarget:self action:@selector(bottomSaveBtnActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        [view.chatBtn addTarget:self action:@selector(chatBtnActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _bottomView = view;
    }
    return _bottomView;
}
- (UIView *)topJianDingImageViewBackView{
    if (!_topJianDingImageViewBackView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        [view addSubview:self.topJianDingImageView];
        view.alpha = 0;
        [self.topJianDingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(@0);
            make.top.equalTo(@0).offset(12);
            make.bottom.equalTo(@0).offset(-5);
        }];
        _topJianDingImageViewBackView = view;
    }
    return _topJianDingImageViewBackView;
}
- (JHC2CProductDetailJianDingStatuView *)topJianDingImageView{
    if (!_topJianDingImageView) {
        JHC2CProductDetailJianDingStatuView *view = [JHC2CProductDetailJianDingStatuView new];
//        view.hidden = YES;
        @weakify(self);
        [view setGoJianDingBlock:^{
            @strongify(self);
            [self appriseButtonlick];
        }];
        _topJianDingImageView = view;
    }
    return _topJianDingImageView;
}


- (NSArray<JHCommentModel *> *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSArray array];
    }
    return _commentArray;
}


#pragma mark - 播放器相关
- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
        _playerController.muted = YES;
        _playerController.view.frame = CGRectMake(0, 0, ScreenW - 24, ScreenW - 24);
    }
    return _playerController;
}
- (JHNormalControlView *)normalPlayerControlView {
    if (_normalPlayerControlView == nil) {
        _normalPlayerControlView = [[JHNormalControlView alloc] initWithFrame:self.playerController.view.bounds];
        _normalPlayerControlView.playImage = JHImageNamed(@"recycle_video_icon");
    }
    return _normalPlayerControlView;
}

- (void)addPlayerToCell {
    [self.currentCell.videoView addSubview: self.playerController.view];
    [self.playerController setSubviewsFrame];
    [self.playerController setControlView:self.normalPlayerControlView];
    self.playerController.urlString = self.currentCell.videoUrl;
}

- (void)showPlayer{
    [self.playerController pause];
    JHC2CAllScreenPlayController *vc = [[JHC2CAllScreenPlayController alloc] init];
    vc.videoUrl = self.currentCell.videoUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self endScrollToPlayVideo];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self endScrollToPlayVideo];
}
// 触发自动播放事件
- (void)endScrollToPlayVideo {
    NSArray *visiableCells = [self.tableView visibleCells];
    if (![visiableCells containsObject:self.currentCell]) {
        if (self.playerController.isPLaying) {
            [self.playerController pause];
        }
    }
    //没有满足条件的 释放视频
}


- (void)addStatistic{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *name = @"集市拍卖商品详情页";
    if (self.type == JHC2CProductDetailVCType_YiKouJia) {
        BOOL isAppraisal = self.dataModel.appraisalResult != nil;
        name = isAppraisal ? @"集市一口价商品已鉴定详情页" : @"集市一口价商品未鉴定详情页";
        if (isAppraisal) {
            parDic[@"appraisal_result"] = NONNULL_STR(self.dataModel.appraisalResult.appraisalResult);
        }
    }
    parDic[@"page_name"] = name;
    parDic[@"commodity_id"] = self.productId;
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:parDic type:JHStatisticsTypeSensors];
}


#pragma mark -- <浮层收藏以及拍卖>
- (JHMarketFloatLowerLeftView *)floatView{
    if (!_floatView) {
        _floatView = [[JHMarketFloatLowerLeftView alloc] initWithShowType:JHMarketFloatShowTypeBackTop];
        _floatView.isHaveTabBar = NO;
        @weakify(self)
        //返回顶部
        _floatView.backTopViewBlock = ^{
            @strongify(self)
            [self.tableView scrollToTop];
            [self.tableFooter scrTop];

        };
    }
    return _floatView;
}

///判断用户是否被平台处罚或IM拉黑
- (void)cheakUserIsLimit:(int)limitType completion:(void(^)(BOOL isLimit))completion{
    @weakify(self);
    NSInteger sellId = [self.dataModel.seller[@"id"] integerValue];
    [JHMarketHomeBusiness cheakUserIsLimit:limitType sellerId:sellId completion:^(NSString * _Nullable reason, int level) {
        @strongify(self);
        BOOL isLimit;
        if (reason.length>0) {
            if (level == 1) {
//                NSMutableAttributedString *attStr = [self matchString:reason];
//                CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andMutableDesc:attStr cancleBtnTitle:@"确定"];
                CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:reason cancleBtnTitle:@"确定"];
                [alert show];
            }else{
                [self.view makeToast:reason duration:1.0 position:CSToastPositionCenter];
            }
            isLimit = YES;
        }else{
            isLimit = NO;
        }
        if (completion) {
            completion(isLimit);
        }
    }];
}

- (NSMutableAttributedString *)matchString:(NSString *)string{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
    //提取[]中字符串正则表达式
    NSString *regexStr = @"(?<=\\[)[^\\]]+";
    //提取正则
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *object in matches) {
        NSRange attRange = NSMakeRange(object.range.location-1, object.range.length+2);
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:HEXCOLOR(0xFE4200)
                             range:attRange];
        }
    return attributeStr;
}

@end

