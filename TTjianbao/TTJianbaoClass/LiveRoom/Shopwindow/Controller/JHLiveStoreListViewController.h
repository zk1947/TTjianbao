//
//  JHLiveStoreListViewController.h
//  TTjianbao
//
//  Created by YJ on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,JHLiveStoreListShowType){
    JHLiveStoreListShowTypeWithNormal,            //用户列表
    JHLiveStoreListShowTypeWithSaler_Header,      //带headerView
    JHLiveStoreListShowTypeWithSaler,             //不带带headerView
};
@interface JHLiveStoreListViewController : JHTableViewController

@property (nonatomic, copy) dispatch_block_t removeBlock;

@property (nonatomic, copy) void (^hiddenBlock) (BOOL hidden);

- (instancetype)initWithType:(JHLiveStoreListShowType)type channel:(ChannelMode * __nullable)channel;
@end

NS_ASSUME_NONNULL_END
