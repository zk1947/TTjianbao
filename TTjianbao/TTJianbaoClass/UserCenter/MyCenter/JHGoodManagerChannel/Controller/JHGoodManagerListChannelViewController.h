//
//  JHGoodManagerListChannelViewController.h
//  TTjianbao
//
//  Created by user on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const FILTER_NAVIGATION_CONTROLLER_CLASS;

typedef void (^SideSlipFilterCommitBlock)(NSArray *dataList);
typedef void (^SideSlipFilterResetBlock)(NSArray *dataList);

@interface JHGoodManagerListChannelViewController : UIViewController
@property (nonatomic, assign) CGFloat  animationDuration;
@property (nonatomic, assign) CGFloat  sideSlipLeading;
@property (nonatomic,   copy) NSArray *dataList;
- (instancetype)initWithSponsor:(UIViewController *)sponsor
                     resetBlock:(SideSlipFilterResetBlock)resetBlock
                    commitBlock:(SideSlipFilterCommitBlock)commitBlock;
- (void)show;
- (void)dismiss;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
