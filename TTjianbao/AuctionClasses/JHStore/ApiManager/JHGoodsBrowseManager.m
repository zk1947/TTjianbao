//
//  JHGoodsBrowseManager.m
//  TTjianbao
//
//  Created by lihui on 2020/2/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGoodsBrowseManager.h"
#import "JHBuryPointOperator.h"
#import <NSString+YYAdd.h>
#import "NSTimer+Help.h"

@implementation JHStasticsModel

@end

@interface JHGoodsBrowseManager ()
///1. 已经进入屏幕的商品数据
@property (nonatomic, strong) NSMutableArray <JHStasticsModel *>*originArray;
///2. 等待上报的商品数据
@property (nonatomic, strong) NSMutableArray <JHStasticsModel *>*waitUploadArray;
///3. 忽略不上报的数据
@property (nonatomic, strong) NSMutableArray <JHStasticsModel *>*ignoreArray;
///标记定时器是否被关闭
@property (nonatomic, assign) BOOL isInvalidate;
///定时器
@property (nonatomic, strong) NSTimer *timer;

///是否正在上报数据
@property (nonatomic, assign) BOOL isUploading;


@end


@implementation JHGoodsBrowseManager

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _originArray = [NSMutableArray array];
        _waitUploadArray = [NSMutableArray array];
        _ignoreArray = [NSMutableArray array];
        _isTiming = NO;
        _isUploading = NO;
        
        ///添加定时器
        @weakify(self);
        _timer = [NSTimer jh_scheduledTimerWithTimeInterval:10 repeats:YES block:^{
            @strongify(self);
            [self uploadDataPer10Seconds];
        }];
    }
    return self;
}

- (void)addGoodsItem:(NSString *)goodsId {
    if (!self.isTiming) {
        ///开启定时器
        [self startTimer];
    }
    
    ///添加时判断 1列表和3列表中没有该数据时 加入  存在则不进行任何操作
    for (JHStasticsModel *model in self.ignoreArray) {
        if ([model.itemId isEqualToString:goodsId]) {
            return;
        }
    }
    for (JHStasticsModel *model in self.originArray) {
        if ([model.itemId isEqualToString:goodsId]) {
            return;
        }
    }
    
    for (JHStasticsModel *model in self.waitUploadArray) {
        if ([model.itemId isEqualToString:goodsId]) {
            return;
        }
    }

    JHStasticsModel *model = [JHStasticsModel new];
    model.itemId = goodsId;
    model.startTime = [[NSDate date] timeIntervalSince1970]*1000;
    [self.originArray addObject:model];
}

- (void)removeGoodsItem:(NSString *)goodsId {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (JHStasticsModel *model in self.originArray) {
        if (![model.itemId isEqualToString:goodsId]) {
            //找到相应的item,加入waitUploadArr,canUploadArr,并且从originArr移除
            if ([self shouldUploadItem:model]) {
                [self.waitUploadArray addObject:model];
                [self.ignoreArray addObject:model];
                [tempArray addObject:model];
            }
        }
    }
    
    ///筛选完成之后 将加入到2 3的数据从1移除
    [self.originArray removeObjectsInArray:tempArray];
    
    
    ///超过10条主动上报
    [self uploadDataWhenMorethan10];
}

#pragma mark - 每满10条发一次
- (void)uploadDataWhenMorethan10 {
    if (_isUploading) {  ///如果正在上传数据 不执行操作
        return;
    }
    ///如果不满10条 不做处理
    if (self.waitUploadArray.count < 10) {
        return;
    }
    
    _isUploading = YES;
    ///整理出itemId
    NSMutableArray *tempArray = [NSMutableArray array];
    for (JHStasticsModel *model in self.waitUploadArray) {
        [tempArray addObject:model.itemId];
    }

    [self.ignoreArray enumerateObjectsUsingBlock:^(JHStasticsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![tempArray containsObject:obj.itemId]) {
            [self.ignoreArray addObject:self.waitUploadArray[idx]];
        }
    }];
    
    ///上传满足条件的数据
    [self uploadRecords];
}

#pragma mark - 每间隔10秒发一次
- (void)uploadDataPer10Seconds {
    if (_isUploading) {  ///如果正在上传数据 不执行操作
        return;
    }
    ///正在上报数据
    _isUploading = YES;
    ///执行上报数据操作
    NSMutableArray *filtrateArray = [NSMutableArray array];
    //检查以添加的集合中是否有符合条件的记录
    NSMutableArray *tempArray = [NSMutableArray array];
    for (JHStasticsModel *model in self.originArray) {
        if ([self shouldUploadItem:model]) {
            [tempArray addObject:model.itemId];
        }
    }
    for (JHStasticsModel *model in self.waitUploadArray) {
        if (![tempArray containsObject:model.itemId]) {
            [filtrateArray addObject:model];
        }
    }
    
    if (filtrateArray.count == 0) {
        _isUploading = NO;
        return;
    }
    
    [self.waitUploadArray addObjectsFromArray:filtrateArray];
    [self.ignoreArray addObjectsFromArray:filtrateArray];
    
    if (self.waitUploadArray.count > 0) {
        //2上传符合的记录
        [self uploadRecords];
        ///从进入屏幕数组中移除已经满足条件的数据
        [self.originArray removeObjectsInArray:filtrateArray.copy];
    }
}

///上报浏览商品
- (void)uploadRecords {
     if (self.waitUploadArray.count == 0) {
        return;
    }
    NSLog(@"浏览商品信息埋点上报::::: %ld",self.waitUploadArray.count);

    ///上报数据前 关闭定时器
    [self stopTimer];

    JHBuryPointStoreGoodsListBrowseModel *pointModel = [[JHBuryPointStoreGoodsListBrowseModel alloc] init];
    pointModel.entry_type = self.entryType;
    pointModel.entry_id = @"0";

    NSMutableArray *tempArray = [NSMutableArray array];
    [self.waitUploadArray enumerateObjectsUsingBlock:^(JHStasticsModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArray addObject:obj.itemId];
    }];
    NSString *itemIdString = [tempArray componentsJoinedByString:@","];
    pointModel.item_ids = itemIdString;
    
    
    NSLog(@"上报itemIdString:%@", itemIdString);
    
    if ([itemIdString isNotBlank]) {
        [[JHBuryPointOperator shareInstance] browseStoreGoodsList:pointModel];
    }
    
    _isUploading = NO;
    
    ///上报完成后清空数据
    [self.waitUploadArray removeAllObjects];
    
    ///上报完成后需要重启定时器
    if (self.originArray.count == 0) {
        return;
    }
    ///开启定时器
    [self stopTimer];
}

///开启定时器
- (void)startTimer {
    if (!self.timer) return;
    [self.timer setFireDate:[NSDate distantPast]];
    self.isTiming = YES;
}

///暂停定时器
- (void)stopTimer {
    if (!self.timer) return;
    [self.timer setFireDate:[NSDate distantFuture]];
    self.isTiming = NO;
}

///永久关闭定时器
- (void)invalidateTimer {
    if (!self.timer) return;
    self.isTiming = NO;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)uploadRecordBeforeRefresh {
    ///刷新前需要查看1 2中是否有满足条件的数据
    [self uploadDataPer10Seconds];
}

- (void)uploadRecoredBeforeClose {
    [self invalidateTimer];
    [self uploadDataPer10Seconds];
}

- (BOOL)shouldUploadItem:(JHStasticsModel *)itemModel {
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970]*1000;
    return endTime - itemModel.startTime >= 1000 ? YES : NO;
}

- (void)setEntryType:(NSString *)entryType {
    _entryType = entryType;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end

