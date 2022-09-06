//
//  JHRecycleOrderBusinessViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessViewModel.h"

@interface JHRecycleOrderBusinessViewModel()
@property (nonatomic, strong) JHRecycleOrderBusinessModel *model;
@end
@implementation JHRecycleOrderBusinessViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - 网络请求
- (void)getBusinessInfo {
    if (self.orderId == nil) {
        [self.endRefreshing sendNext:nil];
        return;
    }
    @weakify(self)
    [JHRecycleOrderBusinessCheck getBusinessInfoWithOrderId:self.orderId successBlock:^(JHRecycleOrderBusinessModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        self.model = respondObject;
        [self setupData];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        self.toastMsg = respondObject.message;
    }];
//    [self setupData1];
//    [self setupData];
//    [self.endRefreshing sendNext:nil];
}
#pragma mark - Private Functions
- (void)setupData1 {
    self.model = [[JHRecycleOrderBusinessModel alloc] init];
    self.model.remark = @"这是验货说明信息，这是验货说明信息，这是验货说明信息，这是验货说明信息，这是验货说明";
    
    self.model.videoUrl = @"http://www.w3school.com.cn/example/html5/mov_bbb.mp4";
    
    JHRecycleOrderBusinessImageInfo *imageInfo = [[JHRecycleOrderBusinessImageInfo alloc]init];
    imageInfo.medium = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201303%2F18%2F233119quyrec7to3ws3rco.jpg&refer=http%3A%2F%2Fattach.bbs.miui.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1619088792&t=d662d70e0165c03464fe0fada0f959c9";
    imageInfo.big = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201303%2F18%2F233119quyrec7to3ws3rco.jpg&refer=http%3A%2F%2Fattach.bbs.miui.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1619088792&t=d662d70e0165c03464fe0fada0f959c9";
    imageInfo.origin = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201303%2F18%2F233119quyrec7to3ws3rco.jpg&refer=http%3A%2F%2Fattach.bbs.miui.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1619088792&t=d662d70e0165c03464fe0fada0f959c9";
    
    imageInfo.w = 1920;
    imageInfo.h = 1200;
    self.model.coverPicture = imageInfo;
    
    self.model.imageList = @[
        imageInfo,
        imageInfo,
        imageInfo,
    ];
    
}
- (void)setupData {
    [self.sectionViewModel.cellViewModelList removeAllObjects];
    
    [self setupDesViewModelWithSection:self.sectionViewModel];
    [self setupVideoViewModelWithSection:self.sectionViewModel];
    [self setupImageViewModelWithSection:self.sectionViewModel];
    
    [self.refreshTableView sendNext:nil];
}

- (void)setupDesViewModelWithSection : (JHRecycleOrderBusinessSectionViewModel *)section {
    if (self.model.remark == nil) return;
    JHRecycleOrderBusinessDesViewModel *viewModel = [[JHRecycleOrderBusinessDesViewModel alloc] init];
    viewModel.desText = self.model.remark;
    [section.cellViewModelList appendObject:viewModel];
    
}
- (void)setupVideoViewModelWithSection : (JHRecycleOrderBusinessSectionViewModel *)section {
    if (self.model.videoUrl == nil) return;
    JHRecycleOrderBusinessVideoViewModel *viewModel = [[JHRecycleOrderBusinessVideoViewModel alloc] init];
    [viewModel setupDataWithImageUrl: self.model.coverPicture.medium
                            videoUrl: self.model.videoUrl
                               scale: 9.f / 16.f];
    
    [section.cellViewModelList appendObject:viewModel];
}
- (void)setupImageViewModelWithSection : (JHRecycleOrderBusinessSectionViewModel *)section {
    if (self.model.imageList == nil) return ;
    NSInteger index = 0;
    for (JHRecycleOrderBusinessImageInfo *info in self.model.imageList) {
        JHRecycleOrderBusinessImageViewModel *viewModel = [[JHRecycleOrderBusinessImageViewModel alloc] init];
        viewModel.index = index;
        CGFloat scale = info.h / info.w;
        
        [viewModel setupDataWithImageUrl: info.medium
                                   scale: scale];
        [section.cellViewModelList appendObject:viewModel];
        [self.mediumList appendObject:info.medium];
        [self.bigList appendObject:info.big];
        [self.originList appendObject:info.origin];
        index += 1;
    }
}
#pragma mark - Action functions
#pragma mark - Lazy

- (JHRecycleOrderBusinessSectionViewModel *)sectionViewModel {
    if (!_sectionViewModel) {
        _sectionViewModel = [[JHRecycleOrderBusinessSectionViewModel alloc] init];
    }
    return _sectionViewModel;
}

- (RACSubject *)endRefreshing {
    if (!_endRefreshing) {
        _endRefreshing = [RACSubject subject];
    }
    return _endRefreshing;
}
- (RACSubject *)refreshTableView {
    if (!_refreshTableView) {
        _refreshTableView = [RACSubject subject];
    }
    return _refreshTableView;
}

- (NSMutableArray *)mediumList {
    if (!_mediumList) {
        _mediumList = [[NSMutableArray alloc] init];
    }
    return _mediumList;
}
- (NSMutableArray *)bigList {
    if (!_bigList) {
        _bigList = [[NSMutableArray alloc] init];
    }
    return _bigList;
}
- (NSMutableArray *)originList {
    if (!_originList) {
        _originList = [[NSMutableArray alloc] init];
    }
    return _originList;
}
@end
