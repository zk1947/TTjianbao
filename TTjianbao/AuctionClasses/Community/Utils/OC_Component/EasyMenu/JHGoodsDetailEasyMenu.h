//
//  JHGoodsDetailEasyMenu.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  悬浮标签栏
//

#import <UIKit/UIKit.h>

#define kEasyMenuH  [JHGoodsDetailEasyMenu menuHeight]

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodsDetailEasyMenu : UIView

@property (nonatomic, copy) void(^pageSelectBlock)(NSInteger curPage);

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, assign) NSInteger currentPage;

+ (CGFloat)menuHeight;

@end

NS_ASSUME_NONNULL_END
