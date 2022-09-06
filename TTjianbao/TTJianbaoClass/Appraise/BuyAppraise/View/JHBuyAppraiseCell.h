//
//  JHBuyAppraiseCell.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

@class JHBuyAppraiseModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHBuyAppraiseCell : UITableViewCell

@property (nonatomic, strong) JHBuyAppraiseModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
/** 视频视图*/
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, copy) void(^enterDetailBlock)(NSInteger selectIndex);

+ (NSString *)updateTimeForRow:(NSString *)createTimeString;

@end

NS_ASSUME_NONNULL_END
