//
//  JHMyCenterMerchantView.h
//  TTjianbao
//
//  Created by apple on 2020/4/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 个人中心 - 商家专用 

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCenterMerchantView : UIView

///滑动的回调block
@property (nonatomic, copy) void(^scrollBlock)(CGFloat offSet);
@property (nonatomic, strong, readonly) UITableView *tableView;
-(void)reload;
- (void)updateOrderInfo:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
