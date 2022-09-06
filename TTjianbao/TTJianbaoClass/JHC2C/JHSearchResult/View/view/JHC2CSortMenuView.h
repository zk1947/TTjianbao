//
//  JHC2CSortMenuView.h
//  TTjianbao
//
//  Created by hao on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  排序

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, JHC2CSortMenuType) {
    JHC2CSortMenuTypeRecommend     = 0,     ///综合排序
    JHC2CSortMenuTypeIncrease      = 1,     ///升序
    JHC2CSortMenuTypeDecrease      = 2,     ///降序
    JHC2CSortMenuTypeNewPush       = 3,     ///最新上架
};

@protocol JHC2CSortMenuViewDelegate <NSObject>
- (void)menuViewDidSelect:(JHC2CSortMenuType)sortType;

@end

@interface JHC2CSortMenuView : UIView
@property (nonatomic, weak) id<JHC2CSortMenuViewDelegate> delegate;
@property (nonatomic, assign) JHC2CSortMenuType sortType;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) BOOL isPriceFirst;//yes-第一个是价格
- (instancetype)initWithFrame:(CGRect)frame menuArray:(NSArray *)menuArray titleFont:(CGFloat )titleFont;
@end


@interface JHC2CSortMenuMode : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isShowImg;   ///是否显示图标

@end

NS_ASSUME_NONNULL_END
