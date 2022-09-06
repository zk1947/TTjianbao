//
//  JHCustomServiceNewHeaderView.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomServiceNewHeaderView : UIView
/** 动态刷新高度*/
@property (nonatomic, copy) void(^changeHeightBlock)(CGFloat viewHeight);

/** 刷新数据完成*/
@property (nonatomic, strong) void (^completeBlock)(void);
/** 刷新数据*/
- (void)reloadData;
/** 刷新数据*/
- (void)reloadLastOrderData;
/** 展示*/
- (void)viewAppear;
/** 消失*/
- (void)viewDismiss;
@end

NS_ASSUME_NONNULL_END
