//
//  JHSearchAssociateView.h
//  TTjianbao
//
//  Created by liuhai on 2021/10/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchAssociateModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHSearchAssociateView : UIView
@property (nonatomic, weak) UIViewController *supVC;

@property (nonatomic, copy) void(^pushToResultVC)(NSString *keyword);// 普通全部结果

- (void)showAssociateViewWithKeyword:(NSString *)keyword currentPageIndex:(NSInteger)currentIndex;
@end

NS_ASSUME_NONNULL_END
