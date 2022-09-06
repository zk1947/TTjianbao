//
//  JHCustomizeHomPickupSendExpressView.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/1/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeHomPickupSendExpressView : JHOrderSubBaseView

@property(nonatomic, strong) UILabel *expressCompany;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UILabel *name;
@property(nonatomic, strong) UILabel *phoneNum;
@property(nonatomic, strong) UILabel *address;
@property(nonatomic, strong) JHActionBlock chooseExpressHandle;
@property(nonatomic, strong) JHActionBlock buttonHandle;
@property(nonatomic, strong) JHActionBlock textFieldString;
@property(nonatomic, strong) NSString *titleString;
@property(nonatomic, assign) BOOL isStoneResellSend;
@end

NS_ASSUME_NONNULL_END
