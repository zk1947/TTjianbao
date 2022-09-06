//
//  JHPageControl.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHPageControl;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,JHPageControlAlignment){
    JHPageControlAlignmentMiddle = 0,
    JHPageControlAlignmentRight,
    JHPageControlAlignmentLeft
};

@protocol JHPageControlDelegate <NSObject>
@optional
- (void)jh_pageControl:(JHPageControl *)pageControl didSelectAtIndex:(NSInteger)index;
@end


@interface JHPageControl : UIControl

@property (nonatomic, weak) id<JHPageControlDelegate > delegate;

/** 控件位置，默认中间 */
@property (nonatomic, assign) JHPageControlAlignment pageControlAlignment;

/** 其他点w是h的倍数，默认1 */
@property (nonatomic, assign) NSInteger otherMultiple;
/** 当前点w是h的倍数，默认1 */
@property (nonatomic, assign) NSInteger currentMultiple;
/** 其他点颜色 */
@property (nonatomic, strong) UIColor *otherColor;
/** 当前点颜色 */
@property (nonatomic, strong) UIColor *currentColor;
/** 当前点背景图片 */
@property (nonatomic, strong) UIImage *currentPointImg;
/** 其他点背景图片 */
@property (nonatomic, strong) UIImage *otherPointImg;

/** 分页数量 */
@property (nonatomic, assign) NSInteger numberOfPages;
/** 当前点所在下标 */
@property (nonatomic, assign) NSInteger currentPage;
/** 点的大小 */
@property (nonatomic, assign) NSInteger pointSize;
/** 点的间距 */
@property (nonatomic, assign) NSInteger pointSpacing;

@end

NS_ASSUME_NONNULL_END
