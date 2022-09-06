//
//  JHBusinessFansAlertView.h
//  TTjianbao
//
//  Created by user on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessFansAlertView : UIView
- (instancetype)initWithTitle:(NSString *)title  andDesc:(NSString *)desc  cancleBtnTitle:(NSString *)cancleTitle  sureBtnTitle:(NSString *)completeTitle;
@property(strong,nonatomic)UIImageView *titleImage;
@property(strong,nonatomic)JHFinishBlock cancleHandle;
@property(strong,nonatomic)JHFinishBlock handle;
- (instancetype)initWithTitle:(NSString *)title  andDesc:(NSString *)desc  cancleBtnTitle:(NSString *)cancleTitle;
-(void)addCloseBtn;
-(void)addBackGroundTap;
-(void)setDescTextAlignment:(NSTextAlignment)align;
@end

NS_ASSUME_NONNULL_END
