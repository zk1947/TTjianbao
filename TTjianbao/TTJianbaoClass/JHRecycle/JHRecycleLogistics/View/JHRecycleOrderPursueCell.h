//
//  JHRecycleOrderPursueCell.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHRecycleOrderPursueModel;
@interface JHRecycleOrderPursueCell : UITableViewCell
@property (nonatomic, strong) JHRecycleOrderPursueModel *model;
/** 最新一条*/
/** 分割线*/
@property (nonatomic, strong) UIView *lineTopView;
@property (nonatomic, strong) UIView *lineBottomView;
/** 节点图*/
@property (nonatomic, strong) UIImageView *tagImageView;
/** 状态*/
@property (nonatomic, strong) UILabel *statusLabel;
/** 描述*/
@property (nonatomic, strong) UILabel *desLabel;
/** 时间*/
@property (nonatomic, strong) UILabel *timeLabel;
@end

NS_ASSUME_NONNULL_END
