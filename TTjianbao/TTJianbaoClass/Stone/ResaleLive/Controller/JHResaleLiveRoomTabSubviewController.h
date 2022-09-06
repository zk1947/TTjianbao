//
//  JHResaleLiveRoomTabSubviewController.h
//  TTjianbao
//  Description:回血直播间tab子controller
//  Created by Jesse on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTableViewController.h"
#import "JHResaleLiveRoomTabDataModel.h"

#import "JHGrowingIO.h"

NS_ASSUME_NONNULL_BEGIN

@class JHGoodResaleListModel;
@protocol JHTableViewCellDelegate;

typedef NS_ENUM(NSUInteger, JHResaleTabStyle)
{
    JHResaleTabStyleDefault,    //隐藏,不显示
    JHResaleTabStyleHidden,// = JHResaleTabStyleDefault,
    JHResaleTabStyleLow,    //仅显示1行
    JHResaleTabStyleHigh    //全显示
};

@interface JHResaleLiveRoomTabSubviewController : JHTableViewController

@property (nonatomic, weak) id<JHTableViewCellDelegate> delegate;
@property (nonatomic, copy) JHActionBlock customAction;

- (instancetype)initWithPageType:(JHResaleLiveRoomTabType)type channelId:(NSString*)mChannelId;
//刷新页面
- (void)callbackRefreshData;
//刷新原石回血tab第一个cell
- (void)refreshStoneResaleWithHiddenRecord:(BOOL)isHidden;
//刷新to see cell
- (void)refreshStoneResaleCell:(NSIndexPath*)indexPath model:(JHGoodResaleListModel*)model;
@end

NS_ASSUME_NONNULL_END
