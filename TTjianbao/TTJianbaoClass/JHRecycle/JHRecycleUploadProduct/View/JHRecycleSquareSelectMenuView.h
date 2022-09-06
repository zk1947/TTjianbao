//
//  JHRecycleSquareSelectMenuView.h
//  TTjianbao
//
//  Created by hao on 2021/7/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleSquareSelectMenuView : UIView
@property (nonatomic, copy) void(^selectCompleteBlock)(NSInteger selectIndex, BOOL isDismiss);
@property (nonatomic, copy) NSArray *selectListDataArray;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
