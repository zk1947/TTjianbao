//
//  JHMarketFloatLowerLeftView.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHMarketFloatShowType) {
    JHMarketFloatShowTypeNormal         = 0, //都不显示
    JHMarketFloatShowTypeBackTop        = 1, //返回顶部
    JHMarketFloatShowTypeSallGoods      = 2, //卖宝贝

};

@interface JHMarketFloatLowerLeftView : UIView
///收藏点击回调
@property(nonatomic,   copy) JHFinishBlock collectGoodsBlock;
///到顶部点击回调
@property(nonatomic,   copy) JHFinishBlock backTopViewBlock;
///到顶部按钮
@property(nonatomic, strong) UIButton *topButton;
///是否存在tabBar
@property(nonatomic, assign) BOOL isHaveTabBar;
///加载数据
- (void)loadData;

- (instancetype)initWithShowType:(JHMarketFloatShowType)type;

@end

NS_ASSUME_NONNULL_END
