//
//  JHResaleSubViewController.h
//  TTjianbao
//  Description:根据类型区分页面
//  Created by Jesse on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTableViewController.h"
#import "JHUserCenterResaleDataModel.h"

@protocol JHTableViewCellDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface JHResaleSubViewController : JHTableViewController

@property (nonatomic, weak) id<JHTableViewCellDelegate> delegate;

- (instancetype)initWithPageType:(JHResaleSubPageType)type channelId:(NSString*)mChannelId;
//返回刷新数据
- (void)callbackRefreshData;

@end

NS_ASSUME_NONNULL_END
