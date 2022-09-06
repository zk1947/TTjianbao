//
//  JHOrderConfirmCoponView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/1/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
#import "JHSwitch.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderConfirmCoponView : JHOrderSubBaseView
@property(nonatomic,strong)    UIView *mallCoponView;
@property(nonatomic,strong)    UIView *platformCoponView;
@property(nonatomic,strong)    UIView *discountCoponView;

@property (strong, nonatomic)  UILabel *mallDesc;
@property (strong, nonatomic)  UILabel *platformDesc;
@property (strong, nonatomic)  UILabel *discountdDesc;

@property(strong,nonatomic)JHOrderDetailMode * orderConfirmMode;
@property(strong,nonatomic)JHActionBlock mallCoponHandle;
@property(strong,nonatomic)JHActionBlock coponHandle;
@property(strong,nonatomic)JHActionBlock discountCoponHandle;
-(void)initSubViews;
-(void)hiddenCoponView;
@end

NS_ASSUME_NONNULL_END
