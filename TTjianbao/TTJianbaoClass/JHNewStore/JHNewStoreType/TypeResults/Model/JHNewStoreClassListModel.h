//
//  JHNewStoreClassListModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHNewStoreHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreClassListModel : NSObject
///商品列表
@property (nonatomic, copy) NSArray<JHNewStoreHomeGoodsProductListModel *> *productList;
///分类列表
@property (nonatomic, copy) NSArray *cateIds;


@end

NS_ASSUME_NONNULL_END
