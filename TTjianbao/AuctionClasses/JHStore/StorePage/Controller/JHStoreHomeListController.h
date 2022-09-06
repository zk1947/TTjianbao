//
//  JHStoreHomeListController.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/19.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  限时特卖商品列表
//

#import "YDBaseViewController.h"
#import "JXCategoryView.h"

typedef NS_ENUM(NSInteger, JHStoreHomeCellType) {
    JHStoreHomeCellTypeGuarantee = 0,       ///保障栏
    JHStoreHomeCellTypeActivity,            ///活动专题
    JHStoreHomeCellTypeSeckill,             ///秒杀专题
    JHStoreHomeCellTypeWindow,              ///普通专题
};

///建议是integer类型的比较好啦！
static NSString * _Nullable const JHWindowTypeActivity = @"act_mktplace";   ///活动专区
static NSString * _Nullable const JHWindowTypeNewUserOlder = @"newu_mktplace";   ///新人专区(原来的)
static NSString * _Nullable const JHWindowTypeNewUser = @"newu_mktplace_newStyle";   ///新人专区(原有的不要了，走新方式)
static NSString * _Nullable const JHWindowTypeSeckill = @"sk_mktplace";     ///秒杀专区
static NSString * _Nullable const JHWindowTypeCommon = @"agg_mktplace";     ///普通专区


NS_ASSUME_NONNULL_BEGIN

@interface JHStoreHomeListController : YDBaseViewController <JXCategoryListContentViewDelegate>

- (void)tableBarSelect:(NSInteger)currentIndex;

@property (nonatomic, assign) JHStoreHomeCellType cellType;
@end

NS_ASSUME_NONNULL_END
