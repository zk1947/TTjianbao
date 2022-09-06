//
//  JHOrderListZhiFaHeaderView.h
//  TTjianbao
//
//  Created by user on 2021/6/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderListZhiFaHeaderView : UIView
@property(nonatomic,   copy) void(^didSelectedCallback)(NSInteger index, NSString * content);
/// 移除
- (void)removeListView;
/// 收起
- (void)putAwayListView;
@end

NS_ASSUME_NONNULL_END
