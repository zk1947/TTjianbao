//
//  JHMarketRefundInfoView.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketRefundInfoView : BaseView
/** 退款类型 1 仅退款 2 退款退货 */
@property (nonatomic, assign) NSInteger refundType;
/** 退款金额*/
@property (nonatomic, copy) NSString *refundMoney;
/** 退款原因*/
@property (nonatomic, copy) NSString *reasonString;
@property (nonatomic, copy) NSString *reasonCode;
/** 退款原因数据组*/
@property (nonatomic, strong) NSArray *reasonsArray;
/** 退款类型按钮*/
@property (nonatomic, strong) UIButton *typeButton;
/** 箭头*/
@property (nonatomic, strong) UIImageView *arrowImageView1;
/** 退款原因按钮*/
@property (nonatomic, strong) UIButton *reasonButton;
/** 退款金额描述*/
@property (nonatomic, strong) UILabel *moneyDesLabel;
@end

NS_ASSUME_NONNULL_END
