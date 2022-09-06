//
//  JHNewStoreCollectAndTopView.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  收藏和返回顶部view

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreCollectAndTopView : UIView
@property(nonatomic, strong) JHActionBlock collectAndTopViewBlock;
@property(nonatomic, strong) UIButton *topButton;
@end

NS_ASSUME_NONNULL_END
