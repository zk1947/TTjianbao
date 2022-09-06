//
//  LNLaunchVC.h
//  BabyTest
//
//  Created by Hello on 2019/5/10.
//  Copyright © 2019 LSJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHDiscoverChannelModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^LNSelectIntrestNextBlock) (NSMutableArray *dataArr);

@interface LNLaunchVC : UIViewController
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) BOOL hideBackBtn;
@property (nonatomic, copy) void(^didShowNewChannel)(void);
@property (nonatomic, copy) LNSelectIntrestNextBlock nextBlock;

///消失前block
@property (nonatomic, copy) dispatch_block_t completeBlock;

@end

NS_ASSUME_NONNULL_END
