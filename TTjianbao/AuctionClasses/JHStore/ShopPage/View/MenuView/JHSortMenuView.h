//
//  JHSortMenuView.h
//  TTjianbao
//
//  Created by apple on 2019/12/17.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 sort [1 最新时间，2 价格从低到高，3 价格从高到低]
 */
typedef NS_ENUM(NSInteger, JHMenuSortType) {
    JHMenuSortTypeRecommend     = 0,     ///默认排序
    JHMenuSortTypeTime          = 1,     ///时间排序
    JHMenuSortTypeIncrease      = 2,     ///升序
    JHMenuSortTypeDecrease      = 3,     ///降序
};

NS_ASSUME_NONNULL_BEGIN

@protocol JHSortMenuViewDelegate <NSObject>

- (void)menuViewDidSelect:(JHMenuSortType)sortType;

@end

@interface JHSortMenuView : UIView

@property (nonatomic, weak) id<JHSortMenuViewDelegate> delegate;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) JHMenuSortType sortType;

- (instancetype)initWithFrame:(CGRect)frame menuArray:(NSArray *)menuArray;

@end

@interface JHMenuMode : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isShowImg;   ///是否显示图标

@end

NS_ASSUME_NONNULL_END
