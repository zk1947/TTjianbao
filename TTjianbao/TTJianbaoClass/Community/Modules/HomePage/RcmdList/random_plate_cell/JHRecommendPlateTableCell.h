//
//  JHRecommendPlateTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 社区推荐页 - 中间推荐版块部分

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHPlateListData;


static NSString *const kRecommendPlateTableIdentifer = @"JHRecommendPlateTableCellIdentifer";

@interface JHRecommendPlateTableCell : UITableViewCell

///需要展示的版块信息 每组数据最多有3条
@property (nonatomic, copy) NSArray <JHPlateListData *>*plateInfos;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
