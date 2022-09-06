//
//  JHCustomerSectionHeader.h
//  TTjianbao
//
//  Created by lihui on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomerSectionHeader : UIView

///section的标题
@property (nonatomic,   copy) NSString *sectionTitle;

@property (nonatomic, copy) void(^actionBlock)(NSInteger section);
//- (void)setTitle:(NSString *)title showEdit:(BOOL)showEdit;

///初始化方法
- (instancetype)initWithFrame:(CGRect)frame isShowEdit:(BOOL)isShow section:(NSInteger)section;
- (void)reloadApplayStatus:(NSString *)str;
- (void)hiddenRecycleCagetory:(BOOL)isHidden;
@end

NS_ASSUME_NONNULL_END
