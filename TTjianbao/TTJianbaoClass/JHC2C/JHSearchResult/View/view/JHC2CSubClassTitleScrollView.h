//
//  JHC2CSubClassTitleScrollView.h
//  TTjianbao
//
//  Created by hao on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  三级分类

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol JHC2CSubClassTitleScrollViewDelegate <NSObject>
- (void)subClassTitleDidSelect:(NSInteger )selectItem;

@end

@interface JHC2CSubClassTitleScrollView : UIScrollView
@property (nonatomic, weak) id<JHC2CSubClassTitleScrollViewDelegate> classDelegate;
@property (nonatomic, copy) NSArray *subClassArray;
@end

NS_ASSUME_NONNULL_END
