//
//  JHFansUpgradeGuideView.h
//  TTjianbao
//
//  Created by liuhai on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHFansEquityLVModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHFansUpgradeGuideView : UIView
+ (instancetype)signAppealpopWindow;
- (void)show;
- (void)resetViewData:(JHFansEquityLVModel *)model;
@end

NS_ASSUME_NONNULL_END
