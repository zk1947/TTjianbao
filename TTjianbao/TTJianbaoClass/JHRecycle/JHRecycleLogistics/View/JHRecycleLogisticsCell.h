//
//  JHRecycleLogisticsCell.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHRecycleLogisticsListModel;
@interface JHRecycleLogisticsCell : UITableViewCell
@property (nonatomic, strong) JHRecycleLogisticsListModel *model;
/** 最新一条*/
/** 分割线*/
@property (nonatomic, strong) UIView *lineTopView;
@property (nonatomic, strong) UIView *lineBottomView;
/** 节点图*/
@property (nonatomic, strong) UIImageView *tagImageView;
/** 时间*/
@property (nonatomic, strong) UILabel *timeLabel;
/** 描述*/
@property (nonatomic, strong) UILabel *desLabel;

@end

NS_ASSUME_NONNULL_END
