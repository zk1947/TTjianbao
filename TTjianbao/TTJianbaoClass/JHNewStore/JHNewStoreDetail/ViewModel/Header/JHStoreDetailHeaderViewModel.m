//
//  JHStoreDetailHeaderViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailHeaderViewModel.h"
#import "JHStoreDetailCycleViewModel.h"

@interface JHStoreDetailHeaderViewModel()

@end
@implementation JHStoreDetailHeaderViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init {
    self = [super init];
    if (self) {
        self.height = ScreenW;
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Private Functions
- (void)setupDataWithVideoUrl : (NSString *)url
                    imageList : (NSArray<NSString *>*)list
                   mediumUrls : (NSArray<NSString *>*)mediumlist {
    [self.sycleViewModel.itemList removeAllObjects];
    
    if (url != nil && url.length > 0) {
        JHStoreDetailCycleItemViewModel *model = [[JHStoreDetailCycleItemViewModel alloc]initWithType:Video url:url];
        [self.sycleViewModel.itemList appendObject:model];
    }
    
    if (list == nil) { return; }
    
    for (NSString *url in list) {
        JHStoreDetailCycleItemViewModel *model = [[JHStoreDetailCycleItemViewModel alloc]initWithType:Image url:url];
        [self.sycleViewModel.itemList appendObject:model];
    }
    
    self.sycleViewModel.thumbsUrls = list;
    self.sycleViewModel.mediumUrls = mediumlist.count == list.count ? mediumlist : list;
    self.sycleViewModel.largeUrls = mediumlist.count == list.count ? mediumlist : list;
    
    [self.sycleViewModel.refreshView sendNext:nil];
}
#pragma mark - Action functions
#pragma mark - Lazy
- (JHStoreDetailCycleViewModel *)sycleViewModel {
    if (!_sycleViewModel) {
        _sycleViewModel = [[JHStoreDetailCycleViewModel alloc]init];
    }
    return _sycleViewModel;
}
@end
