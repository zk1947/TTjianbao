//
//  JHStoneBaseView.h
//  TTjianbao
//  Description:
//  Created by mac on 2019/11/23.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHUIFactory.h"
#import "JHMainLiveSmartModel.h"
#import "JHStoneMessageModel.h"
//弹窗里的请求接口类型
typedef NS_ENUM (NSInteger, RequestType) {
    RequestTypeResale,//主播寄售
    RequestTypeConfirmResale,//用户弹窗确认寄售
    RequestTypeCancelResale,//用户弹窗取消寄售
    RequestTypeAgreePrice,//卖家用户同意出价
    RequestTypeRejectPrice,//卖家用户拒绝出价
    RequestTypeRePutPrice,//买家被拒绝后重新出价
    RequestTypeCancelPrice,//取消出价
    RequestTypeWillPrice,//待支付出价
    RequestTypeProtocol,//查看协议
    RequestTypeConfirmBreakPaper,//确认拆单
    
    RequestTypeSendBack,//主播点寄回
    RequestTypeProcess,//主播发加工单
    RequestTypeBreakPaper,//主播点拆单
    RequestTypePrintGoodCode,//打印商品码
    RequestTypePutShelf,//主播上架
    RequestTypeEdit,//主播编辑-->>卖家修改价格
    RequestTypeExplain,//主播讲解中
    RequestTypeNotificationUser, //通知宝友
    RequestTypeOnePrice, //一口价
    RequestTypeoOfferPrice, //出价
    RequestTypeSeeSee, //求看
    RequestTypeCellCancelResale, //取消寄售
    RequestTypeEnterLive,//进入直播间
    
    RequestTypeStoneResell,//个人转售button
};

typedef void (^RequestActionBlock)(id _Nullable model, RequestType type);

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneBaseView : BaseView
@property(nonatomic, copy) NSString *channelCategory;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) id model;
@property (nonatomic, copy) RequestActionBlock actionBlock;

- (void)makeUI;
- (void)showAlert;
- (void)showAlertWithView:(UIView *)view;
- (void)hiddenAlert;
//一个确定按钮
- (void)style1;
//两个按钮
- (void)style2;

- (void)okAction;

- (void)cancelAction;
@end

NS_ASSUME_NONNULL_END
