//
//  JHRecycleDetailViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收详情-viewModel

#import <Foundation/Foundation.h>
#import "JHRecycleDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleDetailViewModel : NSObject

@property (nonatomic, strong) JHRecycleDetailModel *recycleDetailModel;

@property (nonatomic, strong) RACCommand *recycleDetailCommand;//详情列表请求

@property (nonatomic, strong) NSMutableArray *dataSourceArray;//内容数据

@property (nonatomic, strong) NSMutableArray *imageSourceArray;//图片数据

@property (nonatomic, strong) NSMutableArray *sectionHeaderArray;//分区标题

//****用户***
@property (nonatomic, strong) RACCommand *onOrOffShelfCommand;//商品上/下架
@property (nonatomic, strong) RACSubject *onOrOffShelfSubject;
@property (nonatomic, strong) RACCommand *deleteProductCommand;//删除商品
@property (nonatomic, strong) RACSubject *deleteProductSubject;

//****商户***
@property (nonatomic, strong) RACCommand *collectionProductCommand;//收藏请求
@property (nonatomic, strong) RACSubject *collectionSubject;
@property (nonatomic, strong) RACCommand *goBidCommand;//出价请求
@property (nonatomic, strong) RACSubject *goBidSubject;


@property (nonatomic, strong) RACSubject *errorRefreshSubject;

@end

NS_ASSUME_NONNULL_END
