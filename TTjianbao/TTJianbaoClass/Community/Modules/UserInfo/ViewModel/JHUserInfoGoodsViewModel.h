//
//  JHUserInfoGoodsViewModel.h
//  TTjianbao
//
//  Created by hao on 2021/6/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHUserInfoGoodsViewModel : NSObject
@property (nonatomic, strong) RACCommand *userInfoGoodsCommand;
@property (nonatomic, strong) NSMutableArray *goodsListDataArray;//商品数据

@property (nonatomic, strong) RACSubject *updateGoodsListSubject;
@property (nonatomic, strong) RACSubject *moreGoodsListSubject;
@property (nonatomic, strong) RACSubject *errorRefreshSubject;
@property (nonatomic, strong) RACSubject *noMoreDataSubject;
@end

NS_ASSUME_NONNULL_END
