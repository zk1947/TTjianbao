//
//  JHRecycleDetailViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleDetailViewModel.h"
#import "JHRecycleDetailBusiness.h"
#import "JHRecycleDetailItemViewModel.h"

@interface JHRecycleDetailViewModel ()
@end

@implementation JHRecycleDetailViewModel
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    @weakify(self)
    //回收详情
    [self.recycleDetailCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [self constructData:x];
        }else{
            [self.errorRefreshSubject sendNext:@YES];
        }
        
    }];
    
    
    //****用户****
    //上/下架
    [self.onOrOffShelfCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [self.onOrOffShelfSubject sendNext:@YES];
        }
    }];
    //删除商品
    [self.deleteProductCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [self.deleteProductSubject sendNext:@YES];
        }
    }];
    
    
    //****商户****
    //收藏
    [self.collectionProductCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [self.collectionSubject sendNext:@YES];
        }
    }];
    //出价
    [self.goBidCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [self.goBidSubject sendNext:@YES];
        }
    }];
}
- (void)constructData:(id)data{

    RequestModel *model = (RequestModel *)data;
    self.recycleDetailModel = [JHRecycleDetailModel mj_objectWithKeyValues:model.data];
    

    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];

    //分类
    [self.sectionHeaderArray addObject:@""];
    JHRecycleDetailItemViewModel *typeViewModel = [[JHRecycleDetailItemViewModel alloc] init];
    typeViewModel.cellIdentifier = @"JHRecycleTypeInfoTableViewCell";
    typeViewModel.dataModel = self.recycleDetailModel;
    [tempArray addObject:@[typeViewModel]];
    //宝贝说明
    if (self.recycleDetailModel.productDesc.length > 0) {
        [self.sectionHeaderArray addObject:@"宝贝说明"];
        JHRecycleDetailItemViewModel *desViewModel = [[JHRecycleDetailItemViewModel alloc] init];
        desViewModel.cellIdentifier = @"JHRecycleDesInfoTableViewCell";
        desViewModel.dataModel = self.recycleDetailModel;
        [tempArray addObject:@[desViewModel]];
    }
    //宝贝信息
    if (self.recycleDetailModel.productDetailUrls.count > 0 || self.recycleDetailModel.productImgUrls.count > 0) {
        [self.sectionHeaderArray addObject:@"宝贝信息"];
    }
    
    NSMutableArray *imgAndVideoArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *imgArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.recycleDetailModel.productDetailUrls.count; ++i) {
        if ([self.recycleDetailModel.productDetailUrls[i] detailType] == 1) {//视频
            JHRecycleDetailItemViewModel *videoViewModel = [[JHRecycleDetailItemViewModel alloc] init];
            videoViewModel.cellIdentifier = @"JHRecycleVideoInfoTableViewCell";
            videoViewModel.dataModel = self.recycleDetailModel.productDetailUrls[i];
            videoViewModel.cellHeight = (kScreenWidth-24)*9/16;
            [imgAndVideoArray addObject:videoViewModel];
    
        }else{//图片
            JHRecycleDetailImageUrlModel *imgURLModel = [self.recycleDetailModel.productDetailUrls[i] detailImageUrl];
            
            JHRecycleDetailItemViewModel *imgViewModel = [[JHRecycleDetailItemViewModel alloc] init];
            imgViewModel.cellIdentifier = @"JHRecycleImageInfoTableViewCell";
            imgViewModel.dataModel = imgURLModel;
            imgViewModel.cellHeight = kScreenWidth*([imgURLModel.h doubleValue])/([imgURLModel.w doubleValue]);//310.5
            [imgAndVideoArray addObject:imgViewModel];
            [imgArray addObject:imgURLModel.origin];
        }

    }
    for (int i = 0; i < self.recycleDetailModel.productImgUrls.count; ++i) {
        JHRecycleDetailImageUrlModel *imgURLModel = [self.recycleDetailModel.productImgUrls[i] productImage];
        JHRecycleDetailItemViewModel *imgViewModel = [[JHRecycleDetailItemViewModel alloc] init];
        imgViewModel.cellIdentifier = @"JHRecycleImageInfoTableViewCell";
        imgViewModel.dataModel = imgURLModel;
        imgViewModel.cellHeight = kScreenWidth*([imgURLModel.h doubleValue])/([imgURLModel.w doubleValue]);
        [imgAndVideoArray addObject:imgViewModel];
        [imgArray addObject:imgURLModel.origin];
    }
    [tempArray addObject:imgAndVideoArray];
    self.dataSourceArray = tempArray;
    self.imageSourceArray = imgArray;

}


- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)imageSourceArray{
    if (!_imageSourceArray) {
        _imageSourceArray = [NSMutableArray array];
    }
    return _imageSourceArray;
}

- (NSMutableArray *)sectionHeaderArray{
    if (!_sectionHeaderArray) {
        _sectionHeaderArray = [NSMutableArray array];
    }
    return _sectionHeaderArray;
}

- (RACCommand *)recycleDetailCommand{
    if (!_recycleDetailCommand) {
        _recycleDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [SVProgressHUD show];
                [JHRecycleDetailBusiness requestRecycleDetailWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    [SVProgressHUD dismiss];
                    if (!error ) {
                        [subscriber sendNext:respondObject];
                    }else{
                        [subscriber sendNext:nil];
                        JHTOAST(error.localizedDescription);
                    }
                    [subscriber sendCompleted];

                }];
                
                return nil;
            }];
        }];
    }
    return _recycleDetailCommand;
}

///商品上/下架
- (RACCommand *)onOrOffShelfCommand{
    if (!_onOrOffShelfCommand) {
        _onOrOffShelfCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [JHRecycleDetailBusiness requestRecycleDetailOnOrOffShelfWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error ) {
                        [subscriber sendNext:respondObject];
                    }else{
                        [subscriber sendNext:nil];
                    }
                    [subscriber sendCompleted];

                }];
                
                return nil;
            }];
        }];
    }
    return _onOrOffShelfCommand;
}
///删除商品
- (RACCommand *)deleteProductCommand{
    if (!_deleteProductCommand) {
        _deleteProductCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [JHRecycleDetailBusiness requestRecycleDetailDeleteProductWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error ) {
                        [subscriber sendNext:respondObject];
                    }else{
                        [subscriber sendNext:nil];
                    }
                    [subscriber sendCompleted];

                }];
                
                return nil;
            }];
        }];
    }
    return _deleteProductCommand;
}



///收藏/取消收藏
- (RACCommand *)collectionProductCommand{
    if (!_collectionProductCommand) {
        _collectionProductCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
                if ([input[@"collectionStatus"] integerValue] == 1) {//收藏
                    requestDic[@"productId"] = input[@"productId"];
                }else{//取消收藏
                    requestDic[@"productIds"] = input[@"productIds"];//列表
                }
                
                [JHRecycleDetailBusiness requestRecycleDetailCollectionProductWithParams:requestDic collectionStatus:[input[@"collectionStatus"] integerValue] Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error ) {
                        [subscriber sendNext:respondObject];
                    }else{
                        [subscriber sendNext:nil];
                    }
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _collectionProductCommand;
}
///出价
- (RACCommand *)goBidCommand{
    if (!_goBidCommand) {
        _goBidCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

                [JHRecycleDetailBusiness requestRecycleDetailGoBidWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error ) {
                        [subscriber sendNext:respondObject];
                    }else{
                        [subscriber sendNext:nil];
                        JHTOAST(error.localizedDescription);
                    }
                    [subscriber sendCompleted];

                }];
                
                return nil;
            }];
        }];
    }
    return _goBidCommand;
}


- (RACSubject *)onOrOffShelfSubject{
    if (!_onOrOffShelfSubject) {
        _onOrOffShelfSubject = [[RACSubject alloc] init];
    }
    return _onOrOffShelfSubject;
}
- (RACSubject *)deleteProductSubject{
    if (!_deleteProductSubject) {
        _deleteProductSubject = [[RACSubject alloc] init];
    }
    return _deleteProductSubject;
}
- (RACSubject *)collectionSubject{
    if (!_collectionSubject) {
        _collectionSubject = [[RACSubject alloc] init];
    }
    return _collectionSubject;
}
- (RACSubject *)goBidSubject{
    if (!_goBidSubject) {
        _goBidSubject = [[RACSubject alloc] init];
    }
    return _goBidSubject;
}

- (RACSubject *)errorRefreshSubject{
    if (!_errorRefreshSubject) {
        _errorRefreshSubject = [[RACSubject alloc] init];
    }
    return _errorRefreshSubject;
}

@end
