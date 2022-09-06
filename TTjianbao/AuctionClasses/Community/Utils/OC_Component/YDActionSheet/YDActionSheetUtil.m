//
//  YDActionSheetUtil.m
//  Cooking-Home
//
//  Created by Wuyd on 2019/6/30.
//  Copyright © 2019 Wuyd. All rights reserved.
//

#import "YDActionSheetUtil.h"
#import "YDActionSheetCell.h"
#import <YYKit/YYKit.h>
#import <YDCategoryKit/YDCategoryKit.h>
#import "TTjianbaoMarcoUI.h"

@implementation YDActionSheetUtil

/** 遮罩 */
+ (UIView *)yd_maskView {
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    maskView.backgroundColor = [UIColor colorWithHexStr:@"000000" alpha:0.5];
    maskView.alpha = 0;
    return maskView;
}

/** 容器 */
+ (UIView *)yd_containerWithFrame:(CGRect)frame {
    UIView *container = [[UIView alloc] initWithFrame:frame];
    container.backgroundColor = [UIColor clearColor];
    return container;
}

/** 头部标题 */
+ (UIView *)yd_headerWithFrame:(CGRect)frame title:(NSString *)title {
    UIView *header = [[UIView alloc] initWithFrame:frame];
    header.backgroundColor = [UIColor clearColor];
    UIVisualEffectView *blurView = [self yd_blurWithFrame:header.bounds style:UIBlurEffectStyleExtraLight];
    [header addSubview:blurView];
    
    UILabel *titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:14.0] textColor:kColor666];
    titleLabel.frame = CGRectMake(10, 0, CGRectGetWidth(frame)-20, CGRectGetHeight(frame));
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [header addSubview:titleLabel];
    
    return header;
}

/** 列表 */
+ (UITableView *)yd_tableWithFrame:(CGRect)frame {
    UITableView *table = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    table.backgroundColor = [UIColor clearColor];
    table.scrollEnabled = NO;
    table.rowHeight = YD_ASCellH;
    [table registerClass:[YDActionSheetCell class] forCellReuseIdentifier:kCellId_YDActionSheetCell];
    //适配iOS11
    table.estimatedRowHeight = 0.01;
    table.estimatedSectionHeaderHeight = 0.01;
    table.estimatedSectionFooterHeight = 0.01;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    return table;
}

/** Footer(分组间隔模糊效果) */
+ (UIView *)yd_footerWithFrame:(CGRect)frame {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurFooter = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurFooter.frame = frame;
    blurFooter.backgroundColor = [UIColor colorWithHexStr:@"707070" alpha:0.3];
    return blurFooter;
}

/** 模糊效果 */
+ (UIVisualEffectView *)yd_blurWithFrame:(CGRect)frame style:(UIBlurEffectStyle)style {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = frame;
    //blurView.alpha = 1.0f;
    return blurView;
}

@end
