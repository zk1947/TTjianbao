//
//  JHC2CSearchResultViewModel.h
//  TTjianbao
//
//  Created by hao on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHC2CGoodsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CSearchResultViewModel : NSObject
@property (nonatomic, strong) RACCommand *searchResultCommand;
@property (nonatomic, strong) NSMutableArray *searchListDataArray;//商品数据
@property (nonatomic, strong) NSMutableArray *operatingDataArray;//运营位
@property (nonatomic, strong) JHC2CGoodsListModel *goodsModel;


@property (nonatomic, strong) RACSubject *updateGoodsListSubject;
@property (nonatomic, strong) RACSubject *moreGoodsListSubject;
@property (nonatomic, strong) RACSubject *errorRefreshSubject;
@property (nonatomic, strong) RACSubject *noMoreDataSubject;
@end

NS_ASSUME_NONNULL_END
