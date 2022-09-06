//
//  YDMediaToolBar.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  工具条（视频、图片切换）
//

#import <UIKit/UIKit.h>

@class YDMediaToolBar;

NS_ASSUME_NONNULL_BEGIN

@protocol YDMediaToolBarDelegate <NSObject>
@optional
///点击按钮事件<0视频，1图片>
- (void)mediaToolBar:(YDMediaToolBar *)toolBar didSelectAtIndex:(NSInteger)index;
@end


@interface YDMediaToolBar : UIView

@property (nonatomic, weak) id<YDMediaToolBarDelegate > delegate;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

NS_ASSUME_NONNULL_END
