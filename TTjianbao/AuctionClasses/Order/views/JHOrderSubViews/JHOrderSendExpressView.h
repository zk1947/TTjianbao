//
//  JHOrderSendExpressView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderSendExpressView : JHOrderSubBaseView

@property(nonatomic,strong) UILabel *expressCompany;
@property(nonatomic,strong) UITextField *textField;
@property(nonatomic,strong) UILabel *name;
@property(nonatomic,strong) UILabel *phoneNum;
@property(nonatomic,strong) UILabel *address;
@property(strong,nonatomic)JHActionBlock chooseExpressHandle;
@property(strong,nonatomic)JHActionBlock buttonHandle;
@property(nonatomic,strong) NSString *titleString;
@property(nonatomic,assign) BOOL isStoneResellSend;
@end

NS_ASSUME_NONNULL_END
