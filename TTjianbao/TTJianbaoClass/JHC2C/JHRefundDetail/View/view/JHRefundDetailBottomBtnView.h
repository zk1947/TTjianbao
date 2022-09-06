//
//  JHRefundDetailBottomBtnView.h
//  TTjianbao
//
//  Created by hao on 2021/5/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHC2CRefundDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

///按钮显示
typedef enum : NSUInteger {
    RefundDetailBottomBtnTagDelete = 100,           //删除
    RefundDetailBottomBtnTagApplyIntervention,      //仲裁申请介入
    RefundDetailBottomBtnTagInterventionResult,     //查看介入结果
    RefundDetailBottomBtnTagModifyApply,            //修改申请
    RefundDetailBottomBtnTagRevokApply,             //撤销申请
    RefundDetailBottomBtnTagReturn,                 //去退货
    RefundDetailBottomBtnTagAddOrderNum,            //填写物流单号
    RefundDetailBottomBtnTagRemindSeller,           //提醒卖家收货
    
    RefundDetailBottomBtnTagAgreeRefund,            //同意退款
    RefundDetailBottomBtnTagRefuseRefund,           //拒绝退款
    RefundDetailBottomBtnTagShippedRefuseRefund,    //已发货拒绝退款
    RefundDetailBottomBtnTagAgreeReturn,            //同意退货
    RefundDetailBottomBtnTagRefuseReturn,           //拒绝退货
    RefundDetailBottomBtnTagRemindBuyer,            //提醒买家发货
    RefundDetailBottomBtnTagReceiveAgreeRefund,     //收到货同意退款
    
} RefundDetailBottomBtnTag;

@interface JHRefundDetailBottomBtnView : UIView

/** 点击事件的回调*/
@property (nonatomic, copy) void(^clickActionBlock)(RefundDetailBottomBtnTag btnTag);

@property (nonatomic, strong) JHRefundButtonShowModel *refundButtonShowModel;

@end

NS_ASSUME_NONNULL_END
