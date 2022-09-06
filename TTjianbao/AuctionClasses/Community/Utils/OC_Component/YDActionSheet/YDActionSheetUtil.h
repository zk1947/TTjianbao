//
//  YDActionSheetUtil.h
//  Cooking-Home
//
//  Created by Wuyd on 2019/6/30.
//  Copyright © 2019 Wuyd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YD_ASHeaderH    (70.f)
#define YD_ASFooterH    (6.f)
#define YD_ASCellH      (50.f)
#define YD_KeyWindow    [UIApplication sharedApplication].keyWindow

NS_ASSUME_NONNULL_BEGIN

@interface YDActionSheetUtil : NSObject

/** 遮罩 */
+ (UIView *)yd_maskView;

/** 容器 */
+ (UIView *)yd_containerWithFrame:(CGRect)frame;

/** 头部标题 */
+ (UIView *)yd_headerWithFrame:(CGRect)frame title:(NSString *)title;

/** 列表 */
+ (UITableView *)yd_tableWithFrame:(CGRect)frame;

/** Footer(分组间隔模糊效果) */
+ (UIView *)yd_footerWithFrame:(CGRect)frame;

/** 模糊效果 */
+ (UIVisualEffectView *)yd_blurWithFrame:(CGRect)frame style:(UIBlurEffectStyle)style;

@end

NS_ASSUME_NONNULL_END
