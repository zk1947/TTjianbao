//
//  JHB2CRecommenViewModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/8/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCellBaseViewModel.h"
#import "JHNewStoreHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHB2CRecommenViewModel : JHStoreDetailCellBaseViewModel

@property(nonatomic, copy) NSString * productId;

@property (nonatomic, strong) NSArray<JHNewStoreHomeGoodsProductListModel *> *recommentArr;

@end

NS_ASSUME_NONNULL_END
