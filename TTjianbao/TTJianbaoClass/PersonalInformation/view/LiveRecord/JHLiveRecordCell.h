//
//  JHLiveRecordCell.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/17.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHLiveRecordCell : UITableViewCell
@property (nonatomic, strong) JHLiveRecordModel *model;
@property (nonatomic, assign) NSInteger roleType;

@property (nonatomic, copy) void (^remarkBlock)(JHLiveRecordModel *model);


@end

NS_ASSUME_NONNULL_END
