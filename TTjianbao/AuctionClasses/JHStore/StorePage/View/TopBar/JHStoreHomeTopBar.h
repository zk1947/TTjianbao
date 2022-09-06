//
//  JHStoreHomeTopBar.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/20.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  导航栏
//

#import <UIKit/UIKit.h>
#import "JHEasyPollSearchBar.h"

static const CGFloat StoreHomeTopBarHeight = 46;

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreHomeTopBar : UIView

+ (instancetype)topBarWithMsgClickBlock:(dispatch_block_t)msgClickBlock withSearchClickBlock:(dispatch_block_t)searchClickBlock;

- (void)refreshMsgCount:(NSString*)count; ///刷新消息数
//- (void)refreshTheme:(BOOL)isNew;
- (void)refreshTheme:(BOOL)isNew index:(NSInteger)index;
//- (void)changeTopBar:(BOOL)isChange;
//- (void)changeTopBar:(BOOL)isChange selectedIndex:(NSInteger)index;

@property (strong, nonatomic) UIImageView *backView;

@property (assign, nonatomic) NSInteger selectedIndex;

/** 搜索框 */
@property (nonatomic, strong) JHEasyPollSearchBar *searchBar;

- (void)addAnimationWithOffset:(CGFloat)scrollY;

@property (nonatomic, copy) dispatch_block_t searchClickBlock;
@property (nonatomic, copy) dispatch_block_t signBlock;
@property (nonatomic, copy) dispatch_block_t classBlock;

@property (nonatomic, copy) void(^searchScrollBlock)(NSInteger index, BOOL isLeft);

@property (nonatomic, assign) BOOL isSign;//是否已签到

@end

NS_ASSUME_NONNULL_END
