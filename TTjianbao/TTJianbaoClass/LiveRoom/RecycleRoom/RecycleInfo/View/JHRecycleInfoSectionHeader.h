//
//  JHRecycleInfoSectionHeader.h
//  TTjianbao
//
//  Created by user on 2021/4/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleInfoSectionHeader : UIView
///section的标题
@property (nonatomic,   copy) NSString *sectionTitle;
@property (nonatomic, copy) void(^actionBlock)(NSInteger section);
///初始化方法
- (instancetype)initWithFrame:(CGRect)frame isShowEdit:(BOOL)isShow section:(NSInteger)section;
- (void)setSectionTitle:(NSString *)sectionTitle image:(NSString *)image;
- (void)hiddenRecycleCagetory:(BOOL)isHidden;
@end

NS_ASSUME_NONNULL_END
