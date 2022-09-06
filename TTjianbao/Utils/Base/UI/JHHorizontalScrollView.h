//
//  JHHorizontalScrollView.h
//  TTjianbao
//  Description:根据需要定制横向滚动view
//  Created by Jesse on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHorizontalScrollViewButtonTag 900
#define kHorizontalScrollViewButtonMargin 5
#define kHorizontalScrollViewButtonWidth 75

@protocol JHHorizontalScrollViewDelegate <NSObject>

- (void)pressScrollViewButton:(UIButton*_Nullable)button;

@end

NS_ASSUME_NONNULL_BEGIN

@interface JHHorizontalScrollView : UIScrollView

@property (nonatomic, weak) id <JHHorizontalScrollViewDelegate> hDelegate;

- (instancetype)initWithDelegate:(id)delegate;
- (void)updateSubviews:(NSArray*)imageArr;

@end

NS_ASSUME_NONNULL_END
