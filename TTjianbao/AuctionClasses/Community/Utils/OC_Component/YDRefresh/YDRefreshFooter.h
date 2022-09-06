//
//  YDRefreshFooter.h
//  Cooking-Home
//
//  Created by Wuyd on 2019/7/16.
//  Copyright © 2019 Wuyd. All rights reserved.
//

#import "MJRefreshAutoFooter.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDRefreshFooter : MJRefreshAutoFooter
@property (nonatomic, weak) UILabel *noMoreLabel;
@property (nonatomic, assign) BOOL showNoMoreString;

@end

NS_ASSUME_NONNULL_END
