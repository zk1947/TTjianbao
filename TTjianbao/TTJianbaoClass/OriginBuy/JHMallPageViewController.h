//
//  JHMallPageViewController.h
//  TTjianbao
//
//  Created by lihui on 2020/7/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///源头直购首页 -- 标签页

#import "JHBaseViewController.h"
#import "JXCategoryView.h"
#import "JHMallBaseViewController.h"
#import "JXPageListView.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHMallPageSection) {
    ///保障栏
    JHMallPageSectionGraduatee = 0,
    ///隐藏金刚位
    JHMallPageSectionHideOperate = 1,
    ///金刚位：分类入口
    JHMallPageSectionCategory = 2,
    ///运营位
    JHMallPageSectionOperate = 3,
    
    ///新人礼包
    JHMallPageSectionNewUserPacket = 4,
    
    ///底部列表
    JHMallPageSectionChannel = 5,
    
    
};

@interface JHMallPageViewController : JHMallBaseViewController <JXCategoryListContentViewDelegate>

@property (nonatomic, strong) JXPageListView *pageListView;

- (void)tableBarSelect:(NSInteger)currentIndex;

- (void)setPushLastSelectIndex:(NSInteger)index;

- (void)addScrollAnimation:(CGFloat)scrollY;

@property (nonatomic, strong) UIViewController *vc;

@end

NS_ASSUME_NONNULL_END
