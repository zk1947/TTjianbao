//
//  JHUserInfoEvaluateController.h
//  TTjianbao
//
//  Created by hao on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
// 用户中心-评价

#import <UIKit/UIKit.h>
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUserInfoEvaluateController : JHBaseViewController <JXPagerViewListViewDelegate>
@property (nonatomic, copy) NSString *userId;

@end

NS_ASSUME_NONNULL_END
