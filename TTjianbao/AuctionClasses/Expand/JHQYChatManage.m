//
//  JHQYChatManage.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/22.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHQYChatManage.h"
#import <IQKeyboardManager.h>
#import "UIImageView+JHWebImage.h"
#import "NSString+LNExtension.h"
#import "JHOrderConfirmViewController.h"

#import "OrderMode.h"
#import "JHOrderConfirmViewController.h"
#import "JHOrderDetailViewController.h"
#import "JHMsgCenterModel.h"
#import "JHAppraiseVideoViewController.h"
#import "BaseNavViewController.h"
#import "TTjianbaoBussiness.h"
#import "CGoodsDetailModel.h"
#import "QYPOPSDK.h"
#import "JHGoodsDetailViewController.h"
#import "NSString+Common.h"
#import "JHGrowingIO.h"
#import "JHSQManager.h"
#import "JHQiYuVIPCustomerServiceManager.h"
#import "JHCustomizeOrderDetailController.h"
#define JHPlateChatSeverTitle @"平台客服"
#define JHCounselorChatSeverTitle @"珠宝顾问"
#define JHOfficialShopId @"bjydkjyxgs"
#define JHOfficialPreSaleGroupId 397596878 //售前
#define JHOfficialPostSaleGroupId 264188385 //售后

@implementation JHQYStaffInfo

@end


@interface JHQYChatManage ()<QYConversationManagerDelegate, PanPushToNextViewControllerDelegate>
@property (nonatomic, strong) QYSessionViewController *sessionViewController;
//@property (nonatomic, strong) UINavigationController *nav;
//商品详情页进入时临时保存的商品信息
//@property (nonatomic, strong) CommunityArticalModel *info;
@property(nonatomic, strong) OrderMode* orderMode;
@property (nonatomic, strong) CGoodsInfo *goodsInfo;
@property (nonatomic, assign) BOOL isSpecialSale; //是否是特卖商品客服服务
@property (nonatomic, copy) NSString *defaultText; //默认发送的文本消息
@property (nonatomic, assign) BOOL isSaleBack; //是退货申请成功的自动调起商家客服
@property (nonatomic, strong) UILabel *titleLabel;//破title 总不显示
@property (nonatomic, strong) UIButton *contactCustomerBtn; //联系平台
@property (nonatomic, assign) BOOL iqKeyboardEnable;  //IQKeyboardManager Enabled 状态

@property (nonatomic, strong) NSMutableArray *orderArray;
@end

@implementation JHQYChatManage

static JHQYChatManage *instance = nil;

+ (JHQYChatManage *)shareInstance{
    static dispatch_once_t once_Token;
    dispatch_once(&once_Token, ^{
        instance = [[JHQYChatManage alloc] init];
        [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[QYSessionViewController class]];
        //        [[IQKeyboardManager sharedManager] disableDistanceHandlingInViewControllerClass:[QYSessionViewController class]];
    });
    if (instance) {
        instance.iqKeyboardEnable = [[IQKeyboardManager sharedManager] isEnabled];
        [[IQKeyboardManager sharedManager] setEnable:NO];
    }
    return instance;
}

- (void)configQYSDKSuccessBlock:(QYCompletionWithResultBlock)block {
    [[QYSDK sharedSDK].conversationManager setDelegate:self];
    
    QYUserInfo *userInfo = [[QYUserInfo alloc] init];
    userInfo.userId = [UserInfoRequestManager sharedInstance].user.customerId;
    NSDictionary *dic = @{
        @"key":@"real_name",
        @"value":[UserInfoRequestManager sharedInstance].user.name?:@"宝友",
        @"custom_id": userInfo.userId ? : @""
    };
    
    NSDictionary *dic1 = @{
        @"key":@"custom_id",
        @"label": @"用户ID",
        @"value":userInfo.userId ? : @"",
    };
    userInfo.data = [@[dic, dic1] mj_JSONString];
    [[QYSDK sharedSDK] setUserInfo:userInfo authTokenVerificationResultBlock:block];
    
    //action事件回调
    [[QYSDK sharedSDK] customActionConfig].actionBlock = ^(QYAction *action) {
        if (action.type == QYActionTypeRequestStaffAfter) {
            action.requestStaffAfterBlock = ^(NSDictionary *info, NSError *error) {
                if (!error) {
                    if (self.defaultText) {
                        [self.sessionViewController sendText:self.defaultText];
                    }
                }
                
            };
        }
    };
    
    //链接点击事件回调
    JH_WEAK(self)
    [[QYSDK sharedSDK] customActionConfig].linkClickBlock = ^(NSString *linkAddress) {
        JH_STRONG(self)
        NSLog(@"linkAddress = %@", linkAddress);
        
        if ([linkAddress hasPrefix:@"http://"] || [linkAddress hasPrefix:@"https://"]) {
            
            if ([linkAddress hasPrefix:@"http://www.tianmouwangluo.com/event/toArticle?"]) {
                //社区商品详情链
                NSDictionary *dic = [self getUrlParameterWithUrl:[NSURL URLWithString:linkAddress]];
                if (dic != nil) {
                    [self didClickCommunityLink:dic];
                }
                
            } else if ([linkAddress hasPrefix:@"http://www.tianmouwangluo.com/event/toSaleCommodity"]) {
                //特卖商品详情链接
                NSDictionary *dic = [self getUrlParameterWithUrl:[NSURL URLWithString:linkAddress]];
                if (dic != nil) {
                    [self didClickStoreLink:dic];
                }
                
            } else {
                //订单链接
                NSString *jsonStr = nil;
                jsonStr = [linkAddress hasPrefix:@"http://"] ? [linkAddress substringFromIndex:7] : [linkAddress substringFromIndex:8];
                NSDictionary *dic = [jsonStr dictionaryWithJsonString:jsonStr];
                if (dic != nil && [dic objectForKey:@"ttjb_order_id"]) { //http://{"ttjb_order_id":"568"}
                    //json解析成功
                    NSString *orderId = dic[@"ttjb_order_id"];
                    [self requestInfo:orderId];
                }
                
                if ([linkAddress containsString:@"orderId"]) { //http://{"ttjb_order_id":"568"}
                    //json解析成功
                    NSString *url = H5_BASE_STRING(@"/jianhuo/serviceOrder.html?");
                    url = [url stringByAppendingFormat:@"orderId="];
                    NSString *orderId = [linkAddress stringByReplacingOccurrencesOfString:url withString:@""];
                    [self requestInfo:orderId];
                }
            }
        }
    };
}

//点击社区可售贴链接
- (void)didClickCommunityLink:(NSDictionary *)dic {
//    if ([NSString empty:[dic objectForKey:@"item_id"]]) {
//        return;
//    }
//    //点击的商品的链接和上一个页面一样，就返回
//    if ([[dic objectForKey:@"item_id"] isEqualToString:self.info.item_id]) {
//        [self onBack:nil];
//    } else {
//
//        //跳转到图文或者视频详情
//        NSNumber *layout = [dic objectForKey:@"layout"];
//
//        if ([layout integerValue] == JHSQLayoutTypeAppraisalVideo) {//鉴定剪辑视频
//            NSString *url = [NSString stringWithFormat:@"content/detailBridge/%@/%@",dic[@"item_type"],dic[@"item_id"]];
//            [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
//                JHAppraiseVideoViewController *vc = [[JHAppraiseVideoViewController alloc] init];
//                vc.cateId = [NSString stringWithFormat:@"%@", respondObject.data[@"item_type"]];
//                vc.appraiseId = respondObject.data[@"item_id"];
//                vc.from = JHLiveFromChat;
//
//                [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
//            } failureBlock:^(RequestModel *respondObject) { }];
//
//        } else {
//            BOOL value = NO;
//            if(dic[@"is_rich_text"])
//            {
//                value = [dic[@"is_rich_text"] boolValue];
//            }
//            JHPostItemType itemType = [dic[@"item_type"] integerValue];
//            [JHSQManager enterPostDetailWebWithItemType:itemType itemId:dic[@"item_id"] isComment:NO pageFrom:JHFromChatPage isRichText:value];
//        }
//    }
}

//点击特卖商品链接
- (void)didClickStoreLink:(NSDictionary *)dic {
    NSLog(@"dic:======== %@", dic);
    if ([NSString empty:dic[@"item_id"]]) {
        return;
    }
    //点击的商品id和上一个页面一样，就直接返回
    if ([dic[@"item_id"] isEqualToString:self.goodsInfo.goods_id]) {
        [self onBack:nil];

    } else {
        //跳转到特卖商品详情页
        JHGoodsDetailViewController *vc = [JHGoodsDetailViewController new];
        vc.goods_id = dic[@"item_id"];
        vc.entry_type = JHFromChatPage; ///客服页面
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }
}
///联系官方客服
- (void)showNoGroupChatWithViewcontroller:(UIViewController *)vc
{
//    self.info = nil;
    
    [self configQYSDKSuccessBlock:nil];
    
    [self makeSessionViewController:JHPlateChatSeverTitle withShopId:nil];
    
    //非社区客服组id
    NSString *vipGroupId = [JHQiYuVIPCustomerServiceManager shared].groupId;
    if (vipGroupId && ![vipGroupId isEqualToString:@""]) {
        _sessionViewController.groupId = [vipGroupId intValue];
        _sessionViewController.vipLevel = [JHQiYuVIPCustomerServiceManager shared].vipLevel;
    } else {
//        _sessionViewController.groupId = JHOfficialPostSaleGroupId;
    }
    
    if(!vc)
    {
        vc = [JHRouterManager jh_getViewController];
    }
    [vc.navigationController pushViewController:_sessionViewController animated:YES];
    
    PanNavigationController *nav = (PanNavigationController *)vc.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        [nav setNextViewControllerDelegate:self];
        [nav setShouldReceiveTouchViewController:_sessionViewController];
    }
}
///联系官方客服
- (void)showChatWithViewcontroller:(UIViewController *)vc
{
//    self.info = nil;
    
    [self configQYSDKSuccessBlock:nil];
    
    [self makeSessionViewController:JHPlateChatSeverTitle withShopId:nil];
    
    //非社区客服组id
    NSString *vipGroupId = [JHQiYuVIPCustomerServiceManager shared].groupId;
    if (vipGroupId && ![vipGroupId isEqualToString:@""]) {
        _sessionViewController.groupId = [vipGroupId intValue];
        _sessionViewController.vipLevel = [JHQiYuVIPCustomerServiceManager shared].vipLevel;
    } else {
        _sessionViewController.groupId = JHOfficialPostSaleGroupId;
    }
    
    if(!vc)
    {
        vc = [JHRouterManager jh_getViewController];
    }
    [vc.navigationController pushViewController:_sessionViewController animated:YES];
    
    PanNavigationController *nav = (PanNavigationController *)vc.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        [nav setNextViewControllerDelegate:self];
        [nav setShouldReceiveTouchViewController:_sessionViewController];
    }
}

//add by wuyd 2019.08.29
- (void)showPlatformChatWithViewcontroller:(UIViewController *)vc {
//    self.info = nil;
    
    [self configQYSDKSuccessBlock:nil];
    
    [self makeSessionViewController:JHPlateChatSeverTitle withShopId:nil];
    
    //访客分流展示模式 add by wuyd on 2019.09.03
    [[QYSDK sharedSDK] customUIConfig].bypassDisplayMode = QYBypassDisplayModeNone;
    //取消自动键盘
    [[QYSDK sharedSDK] customUIConfig].autoShowKeyboard = NO;
    
    //非社区客服组id
    //sessionViewController.groupId = JHOfficialPostSaleGroupId;
    
    [vc.navigationController pushViewController:_sessionViewController animated:YES];
    
    PanNavigationController *nav = (PanNavigationController *)vc.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        [nav setNextViewControllerDelegate:self];
    }
}

/*****发现模块start*******/
//展示购买聊天客服页面
- (void)showPurchaseChatWithViewcontroller:(UIViewController *)vc withQYCommodityInfo:(CommunityArticalModel *__nullable)info {
//    self.info = info;
//
//    [self configQYSDKSuccessBlock:nil];
//
//    [self makeSessionViewController:JHCounselorChatSeverTitle withShopId:nil];
//
//    _sessionViewController.view.backgroundColor = [UIColor whiteColor];
//
//    //社区客服组id
//    NSString *vipGroupId = [JHQiYuVIPCustomerServiceManager shared].groupId;
//    if (vipGroupId && ![vipGroupId isEqualToString:@""]) {
//        _sessionViewController.groupId = [vipGroupId intValue];
//        _sessionViewController.vipLevel = [JHQiYuVIPCustomerServiceManager shared].vipLevel;
//    } else {
//        _sessionViewController.groupId = JHOfficialPreSaleGroupId;
//    }
//
//    //设置顶部商品卡片
//    if (info) {
//        [_sessionViewController registerTopHoverView:[self customTopHoverView] height:(126-41) marginInsets:UIEdgeInsetsZero];
//        [self showTopCommunityGoodsInfo];
//    }
//
//    [vc.navigationController pushViewController:_sessionViewController animated:YES];
//
//    PanNavigationController *nav = (PanNavigationController *)vc.navigationController;
//    if ([nav isKindOfClass:[PanNavigationController class]]) {
//        [nav setNextViewControllerDelegate:self];
//    }
}

///客服 - 商品详情客服
- (void)showStoreChatWithViewController:(UIViewController *)vc goodsInfo:(CGoodsInfo *__nullable)goodsInfo {
    self.goodsInfo = goodsInfo;
    _isSpecialSale = YES;
    //获取客服信息yy
    [self requestStaffInfoWithOrderModel:nil vc:vc anchorId:@(goodsInfo.seller_id).stringValue defaultText:nil type:JHChatSaleTypeFront];
    return;
    
    [self configQYSDKSuccessBlock:nil];
    
    [self makeSessionViewController:@"珠宝顾问" withShopId:nil];
    
    //社区客服组id
    NSString *vipGroupId = [JHQiYuVIPCustomerServiceManager shared].groupId;
    if (vipGroupId && ![vipGroupId isEqualToString:@""]) {
        _sessionViewController.groupId = [vipGroupId intValue];
        _sessionViewController.vipLevel = [JHQiYuVIPCustomerServiceManager shared].vipLevel;
    } else {
        _sessionViewController.groupId = JHOfficialPreSaleGroupId;
    }
    
    //设置顶部商品卡片
    if (goodsInfo) {
        [_sessionViewController registerTopHoverView:[self customTopHoverView] height:(126-41) marginInsets:UIEdgeInsetsZero];
        [self showTopStoreGoodsInfo];
    }
    
    [vc.navigationController pushViewController:_sessionViewController animated:YES];
    
    PanNavigationController *nav = (PanNavigationController *)vc.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        [nav setNextViewControllerDelegate:self];
    }
}

- (NSDictionary *)getUrlParameterWithUrl:(NSURL *)url {
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    return parm;
}

//订单详情页
-(void)requestInfo:(NSString *)orderId {
    [SVProgressHUD show];
    NSString *type = @"0";
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/detail?orderId=%@&userType=%@"), orderId, type];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSLog(@"respondObject = %@", respondObject);
        self.orderMode = [OrderMode mj_objectWithKeyValues: respondObject.data];
        
    if (self.orderMode.orderCategoryType == JHOrderCategoryPersonalCustomizeOrder){
        
        JHCustomizeOrderDetailController * detail=[[JHCustomizeOrderDetailController alloc]init];
        detail.orderId = orderId;
        detail.isSeller = NO;
        [_sessionViewController.navigationController pushViewController:detail animated:YES];
        [self.sessionViewController destroyTopHoverViewWithAnmation:YES duration:0.1];
    }
        
    else{
        if ([self.orderMode.orderStatus isEqualToString:@"waitack"]) {
            JHOrderConfirmViewController * order=[[JHOrderConfirmViewController alloc]init];
            order.orderId = orderId;
            order.fromString = JHConfirmFromKF;
            [_sessionViewController.navigationController pushViewController:order animated:YES];
            [self.sessionViewController destroyTopHoverViewWithAnmation:YES duration:0.1];
        }
        else{
            JHOrderDetailViewController * detail=[[JHOrderDetailViewController alloc]init];
            detail.orderId = orderId;
            detail.isSeller = NO;
            [_sessionViewController.navigationController pushViewController:detail animated:YES];
            [self.sessionViewController destroyTopHoverViewWithAnmation:YES duration:0.1];
        }
    }
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [UITipView showTipStr:respondObject.message];
        //        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
}

//顶部商品卡片信息
- (UIView *)customTopHoverView {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0,0,ScreenW, 126);
    view.layer.backgroundColor = RGB(255, 255, 255).CGColor;
    view.layer.shadowColor = RGBA(0, 0, 0, 0.07).CGColor;
    view.layer.shadowOffset = CGSizeMake(0,2);
    view.layer.shadowOpacity = 1;

    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBack:)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:ges];

    UIImageView *imgV = [UIImageView new];
    imgV.layer.cornerRadius = 4.0f;
    imgV.layer.masksToBounds = YES;
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.clipsToBounds = YES;

//    NSString *imgUrl = _isSpecialSale ? self.goodsInfo.coverImgInfo.url : self.info.preview_image;
//    NSString *titleStr = _isSpecialSale ? [NSString stringWithFormat:@"特卖商品：%@", self.goodsInfo.name] : self.info.buy_title;
    
    NSString *imgUrl = self.goodsInfo.coverImgInfo.url;
    NSString *titleStr = [NSString stringWithFormat:@"特卖商品：%@", self.goodsInfo.name];

    [imgV jh_setImageWithUrl:imgUrl];
    [view addSubview:imgV];

    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(10);
        make.height.width.equalTo(@64);
    }];

    UILabel *titleLab = [UILabel new];
    titleLab.text = titleStr;
    titleLab.textColor = RGB(51, 51, 51);
    titleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    titleLab.numberOfLines = 2;
    [view addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgV.mas_right).offset(12);
        make.top.equalTo(imgV.mas_top);
        make.right.offset(-13);
    }];

//    NSString *price = _isSpecialSale ? self.goodsInfo.market_price : self.info.price;
//    NSString *provider = _isSpecialSale ? self.goodsInfo.provider : self.info.provider;
    NSString *price = self.goodsInfo.market_price;
    NSString *provider = self.goodsInfo.provider;

    if (![NSString empty:price]) {
        NSString *priceStr = [NSString stringWithFormat:@"市场价：%@", price];
        UILabel *priceLab = [UILabel new];
        NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [priceString setAttributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 12],NSForegroundColorAttributeName: RGB(153, 153, 153)} range:NSMakeRange(0, 4)];
        [priceString setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"DINAlternate-Bold" size: 15],NSForegroundColorAttributeName: RGB(255, 66, 0)} range:NSMakeRange(4, priceString.length - 4)];
        priceLab.attributedText = priceString;
        [view addSubview:priceLab];

        [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgV.mas_right).offset(12);
            make.bottom.equalTo(imgV.mas_bottom).offset(-4);
            make.right.offset(-13);
        }];

    } else {
        if (![NSString empty:provider]) {
            UILabel *providerLab = [UILabel new];
            providerLab.textColor = HEXCOLOR(0x666666);
            providerLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
            [view addSubview:providerLab];
            providerLab.text = provider;
            [providerLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imgV.mas_right).offset(12);
                make.bottom.equalTo(imgV.mas_bottom).offset(-4);
                make.right.offset(-13);
            }];
        }
    }
    
    return view;
}

//发送商品信息到聊天页面 <社区可售贴>
- (void)showTopCommunityGoodsInfo {
//    QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
//    commodityInfo.title = [NSString stringWithFormat:@"%@", self.info.buy_title];
//    commodityInfo.desc = [NSString stringWithFormat:@"id: %@", self.info.item_id];
//    commodityInfo.pictureUrlString = self.info.preview_image;
//    commodityInfo.note = self.info.provider;
//    commodityInfo.show = YES;
//    commodityInfo.urlString = [NSString stringWithFormat:@"http://www.tianmouwangluo.com/event/toArticle?layout=%ld&item_type=%ld&item_id=%@",
//                               (long)self.info.layout, (long)self.info.item_type, self.info.item_id];
//    [self.sessionViewController sendCommodityInfo:commodityInfo];
}

//发送商品信息到聊天页面 <特卖商品>
- (void)showTopStoreGoodsInfo {
    NSLog(@"showTopStoreGoodsInfo --- ");
    QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
    commodityInfo.title = [NSString stringWithFormat:@"特卖商品：%@", [self.goodsInfo.name isNotBlank]?self.goodsInfo.name:@""];
    commodityInfo.desc = [NSString stringWithFormat:@"商品ID: %@", [self.goodsInfo.goods_id isNotBlank]?self.goodsInfo.goods_id:@""];
    commodityInfo.pictureUrlString = self.goodsInfo.coverImgInfo.url;
    commodityInfo.note = self.goodsInfo.market_price;
    commodityInfo.show = YES;
    commodityInfo.urlString = [NSString stringWithFormat:@"http://www.tianmouwangluo.com/event/toSaleCommodity?layout=%ld&item_type=%ld&item_id=%@",
                               (long)self.goodsInfo.sell_type, (long)self.goodsInfo.sell_type, self.goodsInfo.goods_id];
    [self.sessionViewController sendCommodityInfo:commodityInfo];
}

- (void)cleanData {
    _sessionViewController = nil;
//    _info = nil;
    _orderMode = nil;
    _goodsInfo = nil;
    _isSpecialSale = NO;
    _defaultText = nil;
    _isSaleBack = NO;
    [_contactCustomerBtn removeFromSuperview];
    _contactCustomerBtn = nil;
    [_titleLabel removeFromSuperview];
    _titleLabel = nil;
}

/*****发现模块end*******/
- (void)onBack:(id)sender {
    [[IQKeyboardManager sharedManager] setEnable:self.iqKeyboardEnable];
    NSLog(@"onBack1111 nav = %@，_sessionViewController = %@", _sessionViewController.navigationController, _sessionViewController);
    //    [_sessionViewController.navigationController popViewControllerAnimated:YES];
    [[JHRootController currentViewController].navigationController popViewControllerAnimated:YES];
    NSLog(@"onBack2222 nav = %@，_sessionViewController = %@", _sessionViewController.navigationController, _sessionViewController);
    _sessionViewController = nil;
    
    [self cleanData];
}

- (void)onContactCustomer
{

#ifdef xxx
    [self prepareSessionViewController];
#else

    //back from
    [[JHRootController currentViewController].navigationController popViewControllerAnimated:NO];
    [self cleanData];
    //go to
    [self prepareSessionViewController];

    
    NSString *vipGroupId = [JHQiYuVIPCustomerServiceManager shared].groupId;
    if (vipGroupId && ![vipGroupId isEqualToString:@""]) {
        _sessionViewController.groupId = [vipGroupId intValue];
        _sessionViewController.vipLevel = [JHQiYuVIPCustomerServiceManager shared].vipLevel;
    } else {
        self.sessionViewController.groupId = JHOfficialPostSaleGroupId; //售后
    }

    [[JHRootController currentViewController].navigationController pushViewController:self.sessionViewController animated:NO];
       
    PanNavigationController *nav = (PanNavigationController *)[JHRootController currentViewController].navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
       [nav setNextViewControllerDelegate:self];
    }
#endif
    
    [JHGrowingIO trackPublicEventId:JHTrackMsgCenterContactCustomerClick];
}

- (JHQYStaffInfo*)prepareSessionViewController
{
    JHQYStaffInfo *staff = [JHQYStaffInfo new];
    staff.shopId = JHOfficialShopId;
    staff.title = JHPlateChatSeverTitle;
    [self cleanData];
    [self configQYSDKSuccessBlock:nil];
    
    [self makeSessionViewController:staff.title withShopId:staff.shopId];
    self.sessionViewController.navigationItem.title = staff.title;
    self.sessionViewController.shopId = staff.shopId;
    self.titleLabel.text = self.sessionViewController.sessionTitle;
    self.defaultText = staff.text;
    return staff;
}

+ (void)setUpQY {
#if DEBUG
    [[QYSDK sharedSDK] registerAppId:QYAppKey appName:@"天天鉴宝_dev"];
#else
    [[QYSDK sharedSDK] registerAppId:QYAppKey appName:@"天天鉴宝"];
#endif
}

+ (void)logout {
    [[QYSDK sharedSDK] logout:^(BOOL success) {
        
    }];
}

+ (NSInteger)unreadMessage {
    return  [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
}

+ (JHMsgCenterModel *)getChatModel:(JHMsgCenterModel *)model {
    NSArray<QYSessionInfo *> *array = [[[QYSDK sharedSDK] conversationManager] getSessionList];
    if (array.count) {
        QYSessionInfo *info = array.firstObject;
        model.body = info.lastMessageText;
        model.total = info.unreadCount;
        
        model.updateDate = [CommHelp stringWithTimeInterval:@(info.lastMessageTimeStamp*1000).stringValue formatter:@"yyyy-MM-dd HH:mm"];
    }
    
    [JHQYChatManage getChatSessionList];
    return model;
}


- (void)onUnreadCountChanged:(NSInteger)count {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameChatUnreadCountChanged object:@(count)];
}

- (void)onReceiveMessage:(QYMessageInfo *)message {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameChatReceivedMessage object:message];
    
}

- (void)popFinish {
    NSLog(@"popFinish");
    [self cleanData];
//    _sessionViewController = nil;
}

- (void)requestStaffInfoWithOrderModel:(OrderMode *)model vc:(UIViewController *)vc anchorId:(NSString *)customerId defaultText:(NSString *)text type:(JHChatSaleType)type {
    [SVProgressHUD show];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"customerId"] = customerId;
    dic[@"type"] = @(type);

    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/waiter/getCustomerWaiterInfo") Parameters:dic successBlock:^(RequestModel * _Nullable respondObject) {

        [SVProgressHUD dismiss];
        JHQYStaffInfo *info = [JHQYStaffInfo mj_objectWithKeyValues:respondObject.data];
        info.text = text;
        if (info.groupId>0 || info.staffId>0 || (![NSString isEmpty:info.shopId])) {
            
        } else {
            if (self.isSaleBack) {
                //如果是退货退款 而且没有配置客服信息 则不调起客服
                return;
            }
            info.title = JHPlateChatSeverTitle;
        }
        [self presentChatVc:vc orderModel:model staffinfo:info hiddenVC:NO];

    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        JHQYStaffInfo *info = [[JHQYStaffInfo alloc] init];
        info.title = JHPlateChatSeverTitle;
        info.text = text;
        [self presentChatVc:vc orderModel:model staffinfo:info hiddenVC:NO];
    }];
}

- (void)showShopChatWithViewcontroller:(UIViewController *)vc anchorId: (NSString *)anchorId {
    [self requestStaffInfoWithOrderModel:nil vc:vc anchorId:anchorId defaultText:nil type:JHChatSaleTypeFront];
}

- (void)showShopChatWithViewcontroller:(UIViewController *)vc orderModel:(OrderMode *)model {
    [self requestStaffInfoWithOrderModel:model vc:vc anchorId:model.sellerCustomerId defaultText:nil type:model?JHChatSaleTypeAfter:JHChatSaleTypeFront];
}

- (void)showShopChatWithViewcontroller:(UIViewController *)vc staffInfo:(JHQYStaffInfo *)info orderModel:(OrderMode *)model {
    [self presentChatVc:vc orderModel:model staffinfo:info hiddenVC:NO];
}

- (void)showShopChatWithViewcontroller:(UIViewController *)vc anchorId:(NSString *)anchorId defaultText:(NSString *)text {
    self.isSaleBack = YES;
    [self requestStaffInfoWithOrderModel:nil vc:vc anchorId:anchorId defaultText:text type:JHChatSaleTypeAfter];

}

- (void)presentChatVc:(UIViewController *)vc orderModel:(OrderMode *)model staffinfo:(JHQYStaffInfo *)staff hiddenVC:(BOOL)hidden{
    
    _sessionViewController = nil;
    [self configQYSDKSuccessBlock:nil];
    
    if ([NSString isEmpty:staff.shopId]) {
        staff.title = JHPlateChatSeverTitle;
        if (self.isSpecialSale) {
            staff.title = JHCounselorChatSeverTitle;
        }
    }
    [self makeSessionViewController:staff.title withShopId:staff.shopId];

    _sessionViewController.navigationItem.title = staff.title;
    
    //子商户客服 3.1.4版本添加
    if (![NSString isEmpty:staff.shopId]) {
       _sessionViewController.shopId = staff.shopId;
    }
    
    if (!isEmpty(staff.shopId)) {
        if (staff.groupId > 0) {
            _sessionViewController.groupId = staff.groupId;
        }
        if (staff.staffId > 0) {
            _sessionViewController.staffId = staff.staffId;
        }
    } else {
        NSString *vipGroupId = [JHQiYuVIPCustomerServiceManager shared].groupId;
        if (vipGroupId && ![vipGroupId isEqualToString:@""]) {
            _sessionViewController.groupId = [vipGroupId intValue];
            _sessionViewController.vipLevel = [JHQiYuVIPCustomerServiceManager shared].vipLevel;
        } else {
            if (staff.groupId > 0) {
                _sessionViewController.groupId = staff.groupId;
            }
        }
        
        NSString *staffId = [JHQiYuVIPCustomerServiceManager shared].staffId;
        if (![NSString isEmpty:staffId]) {
            _sessionViewController.staffId = [staffId intValue];
            _sessionViewController.vipLevel = [JHQiYuVIPCustomerServiceManager shared].vipLevel;
        } else {
            if (staff.staffId > 0) {
                _sessionViewController.staffId = staff.staffId;
            }
        }
    }
    
//    sessionViewController.shopId = @"sj0020";
    self.defaultText = staff.text;

    //设置顶部商品卡片
    if (model) {
        
        [_sessionViewController registerTopHoverView:[UIView new] height:0 marginInsets:UIEdgeInsetsZero];
        
        QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
        commodityInfo.title = model.goodsTitle;
        commodityInfo.desc = [@"订单编号：" stringByAppendingString:OBJ_TO_STRING(model.orderCode)];
        commodityInfo.pictureUrlString = model.goodsUrl;
        commodityInfo.note = [@"价格：" stringByAppendingString:OBJ_TO_STRING(model.originOrderPrice)];
        commodityInfo.show = YES;
        NSString *url = H5_BASE_STRING(@"/jianhuo/serviceOrder.html?");
        url = [url stringByAppendingFormat:@"orderId=%@",model.orderId];
        commodityInfo.urlString = url;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_sessionViewController sendCommodityInfo:commodityInfo];
        });
    }
    
    if (_goodsInfo) {
        [_sessionViewController registerTopHoverView:[self customTopHoverView] height:(126-41) marginInsets:UIEdgeInsetsZero];
        [self showTopStoreGoodsInfo];
    }
    if (hidden) {
        _sessionViewController.view.hidden = YES;
        [vc.view addSubview:_sessionViewController.view];
        [_sessionViewController.view endEditing:YES];
    }else{
        [vc.navigationController pushViewController:_sessionViewController animated:YES];
    }

    PanNavigationController *nav = (PanNavigationController *)vc.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        [nav setNextViewControllerDelegate:self];
    }
}

- (UIButton *)contactCustomerBtn
{
    if(!_contactCustomerBtn)
    {
        _contactCustomerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contactCustomerBtn addTarget:self action:@selector(onContactCustomer) forControlEvents:UIControlEventTouchUpInside];
        [_contactCustomerBtn setImage:JHImageNamed(@"img_msg_contacter") forState:UIControlStateNormal];
        _contactCustomerBtn.backgroundColor = [UIColor clearColor];
    }
    return _contactCustomerBtn;
}
- (NSMutableArray *)orderArray{
    if (!_orderArray) {
        _orderArray = [NSMutableArray arrayWithCapacity:2];
    }
    return _orderArray;
}
- (void)makeSessionViewController:(NSString*)title withShopId:(NSString*)shopId
{
    QYSource *source = [[QYSource alloc] init];
    source.title = title;
    source.urlString = @"";
    
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = title;
    sessionViewController.source = source;
    if (![NSString isEmpty:shopId])
    {
        sessionViewController.shopId = shopId;
    }
    //返回按钮
    UIImage *image = [kNavBackBlackImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    sessionViewController.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    
    //联系平台按钮:属于平台客服情况(有漏洞):1,官方id 2,官方id为空,暂时去掉title这个条件(平台客服和珠宝顾问)
    if(!([shopId isEqualToString:JHOfficialShopId] || [NSString isEmpty:shopId]))
    {
        [sessionViewController.view addSubview:self.contactCustomerBtn];
        [sessionViewController.view bringSubviewToFront:_contactCustomerBtn];
        [self.contactCustomerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(44, 43));
            make.bottom.mas_equalTo(sessionViewController.view).offset(0 - 137*ScreenH/812.0);
            make.right.mas_equalTo(sessionViewController.view).offset(0 - 8);
        }];
    }
    
    self.sessionViewController = sessionViewController;
}

- (void)setSessionViewController:(QYSessionViewController *)sessionViewController {
    _sessionViewController = sessionViewController;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!_titleLabel) {
            UILabel *title = [UILabel new];
            title.text = sessionViewController.sessionTitle;
            title.textColor = HEXCOLOR(0x333333);
            title.font = [UIFont fontWithName:kFontMedium size:18];
            title.textAlignment = NSTextAlignmentCenter;
            [sessionViewController.navigationController.navigationBar addSubview:title];
            title.frame = CGRectMake(100, 0, ScreenW-200, 44);
            _titleLabel = title;
        }
        _titleLabel.text = sessionViewController.sessionTitle;
        sessionViewController.navigationItem.title = @"";
        
    });
}

+ (void)checkChatTypeWithCustomerId:(NSString *)customerId saleType:(JHChatSaleType)type completeResult:(void(^)(BOOL isShop, JHQYStaffInfo *model))chatTypeResult {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([NSString isEmpty:customerId]) {
        chatTypeResult(NO, nil);
        return;
    }
    dic[@"customerId"] = customerId;
    dic[@"type"] = @(type);
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/waiter/getCustomerWaiterInfo") Parameters:dic successBlock:^(RequestModel * _Nullable respondObject) {
        JHQYStaffInfo *info = [JHQYStaffInfo mj_objectWithKeyValues:respondObject.data];
        BOOL isShop = NO;
        if (![NSString isEmpty:info.shopId]) {
            isShop = YES;
        }
        chatTypeResult(isShop, info);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        chatTypeResult(NO, nil);
        
    }];
    
}

- (void)showShopChatWithViewcontroller:(UIViewController *)vc shopId:(NSString *)shopId title:(nonnull NSString *)title {
    JHQYStaffInfo *staffInfo = [JHQYStaffInfo new];
    staffInfo.shopId = shopId;
    staffInfo.title = title;
    [self presentChatVc:vc orderModel:nil staffinfo:staffInfo hiddenVC:NO];
}

- (void)sendTextWithViewcontroller:(UIViewController *)vc ToShop:(NSString *)shopId title:(NSString *)title andOrderId:(NSString *)orderId isPayFinish:(BOOL)isPay{
    
    if (orderId.length>0) {
        if ([self.orderArray containsObject:orderId]) {
            return;
        }
        [self.orderArray addObject:orderId];
    }
    

    NSString *sendText = [NSString stringWithFormat:@"您好，我购买了宝贝【%@】，请及时发货。",title];
    if (!isPay) {
        sendText = [NSString stringWithFormat:@"您好，已收到飞单，我购买宝贝【%@】后，请及时发货。",title];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"customerId"] = shopId;  
    dic[@"type"] = @(JHChatSaleTypeAfter);

    JH_WEAK(self);
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/waiter/getCustomerWaiterInfo") Parameters:dic successBlock:^(RequestModel * _Nullable respondObject) {
        JH_STRONG(self);
        [SVProgressHUD dismiss];
        JHQYStaffInfo *info = [JHQYStaffInfo mj_objectWithKeyValues:respondObject.data];
 
        NSLog(@"-----------=====-%@",info.shopId);
        
        if (![NSString isEmpty:info.shopId]) {
//            [self presentChatVc:vc orderModel:nil staffinfo:info hiddenVC:YES];
            _sessionViewController = nil;
            [self configQYSDKSuccessBlock:nil];
            QYSource *source = [[QYSource alloc] init];
            source.title = info.title;
            source.urlString = @"";
            
            QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
            sessionViewController.sessionTitle = info.title;
            sessionViewController.source = source;
            if (![NSString isEmpty:info.shopId])
            {
                sessionViewController.shopId = info.shopId;
            }
            _sessionViewController = sessionViewController;
            _sessionViewController.view.hidden = YES;
            [vc.view addSubview:_sessionViewController.view];
            [_sessionViewController.view endEditing:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"-----------=====----%@",self.sessionViewController);
                [self.sessionViewController sendText:sendText];
            });
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
    
}


+ (NSMutableArray<JHMsgCenterModel *> *)getChatSessionList {
    NSArray<QYSessionInfo *> *array = [[[QYSDK sharedSDK] conversationManager] getSessionList];

    NSMutableArray *msgArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(QYSessionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JHMsgCenterModel *model = [JHMsgCenterModel new];
        model.type = kMsgSublistTypeKefu;
        model.body = obj.lastMessageText;
        model.total = obj.unreadCount;
        model.updateDate = [CommHelp timeChange:@(obj.lastMessageTimeStamp*1000).stringValue];
        model.title = obj.sessionName;
        model.icon = obj.avatarImageUrlString;
        model.shopId = obj.shopId;
        [msgArray addObject:model];

    }];
    
    return msgArray;
}

+ (void)deleteSessionWithShopId:(NSString *)shopId {
    [[[QYSDK sharedSDK] conversationManager] deleteRecentSessionByShopId:shopId deleteMessages:NO];
}


@end
