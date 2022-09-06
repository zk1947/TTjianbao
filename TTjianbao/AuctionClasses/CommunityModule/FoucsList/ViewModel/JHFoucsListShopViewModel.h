//
//  JHFoucsListShopViewModel.h
//  TTjianbao
//
//  Created by apple on 2020/2/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewModel.h"
#import "JHSellerInfo.h"
#import "JHFoucsUserAndShopNumModel.h"
#import "JHFoucsShopModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JHFoucsListShopViewModel : JHBaseViewModel

@property (nonatomic, assign) NSInteger userId;

///关注店铺/取消关注店铺 当前model
+ (void)foucsShopWithModel:(JHFoucsShopInfo *)model
             completeBlock:(dispatch_block_t)completeBlock;

/// 改变关注model
+(void)changeFocusStatuModel:(JHFoucsShopInfo *)model;

///关注店铺/用户 数量
+ (void)foucsShopAndUserWithUserId:(NSInteger)userId ompleteBlock:(void(^)(JHFoucsUserAndShopNumModel *model))completeBlock;
@end

NS_ASSUME_NONNULL_END
