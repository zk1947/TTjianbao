//
//  JHNewStoreClassResultSortMenuView.h
//  TTjianbao
//
//  Created by hao on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  综合排序弹窗

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreClassResultSortMenuView : UIView
@property (nonatomic, copy) void(^selectCompleteBlock)(NSInteger selectIndex);
@property (nonatomic, copy) NSArray *sortDataArray;
@property (nonatomic, assign) BOOL isReset;
- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
