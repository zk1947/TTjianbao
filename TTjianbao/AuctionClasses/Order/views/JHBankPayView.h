//
//  JHBankPayView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class BankPayDataMode;
@protocol JHBankPayViewDelegate <NSObject>

@optional
-(void)Complete:(NSString*)bankCode;
-(void)addPhoto;
@end

@interface JHBankPayView : BaseView
@property(weak,nonatomic)id<JHBankPayViewDelegate>delegate;
@property(strong,nonatomic) BankPayDataMode* bankPayMode;
@property(strong,nonatomic) UIImage * buttonImage;
@end

NS_ASSUME_NONNULL_END
