//
//  JHNewShopSortMenuView.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  筛选排序View

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JHNewShopSortType) {
    JHMenuSortTypeRecommend     = 0,     ///综合排序
    JHMenuSortTypeIncrease      = 1,     ///升序
    JHMenuSortTypeDecrease      = 2,     ///降序
};

NS_ASSUME_NONNULL_BEGIN

@protocol JHNewShopSortMenuViewDelegate <NSObject>

- (void)menuViewDidSelect:(JHNewShopSortType)sortType;

@end

@interface JHNewShopSortMenuView : UIView
@property (nonatomic, weak) id<JHNewShopSortMenuViewDelegate> delegate;
@property (nonatomic, assign) JHNewShopSortType sortType;
@property (nonatomic, assign) NSInteger selectIndex;
- (instancetype)initWithFrame:(CGRect)frame menuArray:(NSArray *)menuArray titleFont:(CGFloat )titleFont;
@end


@interface JHNewShopMenuMode : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isShowImg;   ///是否显示图标

@end
NS_ASSUME_NONNULL_END
