//
//  JHRecycleHomeViewModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeViewModel.h"
#import "JHRecycleHomeBusiness.h"
#import "JHRecycleItemViewModel.h"
#import "JHRecycleHomeModel.h"
#import "JHRecycleHomeHotGoodsCell.h"
@interface JHRecycleHomeViewModel ()
@property (nonatomic, strong) JHRecycleHomeModel *recycleHomeModel;

@end

@implementation JHRecycleHomeViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    @weakify(self)
    [self.recycleHomeCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [self constructData:x];
            [self.recycleHomeCompleteSubject sendNext:@YES];

        }else{
            [self.errorRefreshSubject sendNext:@YES];
        }
        
    }];
    
    [self.recycleProblemCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        if (x) {
            [self constructProblemData:x];
        }
    }];
    
    
//[[RACSignal combineLatest:@[self.recycleHomeCommand.executionSignals.switchToLatest ,self.recycleProblemCommand.executionSignals.switchToLatest]]subscribeNext:^(id x){
//
//
//
//
//    }];
}
- (void)constructData:(id)data{
    RequestModel *model = (RequestModel *)data;
    self.recycleHomeModel = [JHRecycleHomeModel mj_objectWithKeyValues:model.data];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 8; ++i) {
        
        if (i == 0){//回收直播
            JHRecycleItemViewModel *viewModel = [[JHRecycleItemViewModel alloc] init];
            viewModel.cellIdentifier = @"JHRecycleHomeLiveCell";
            viewModel.cellHeight = 280;
            viewModel.dataModel = self.recycleHomeModel.recycleLiveList;
            if (self.recycleHomeModel.recycleLiveList.count > 1) {
                [tempArray addObject:@[viewModel]];
            }
            
        }
        if (i == 1) {//用户保障
            JHRecycleItemViewModel *viewModel = [[JHRecycleItemViewModel alloc] init];
            viewModel.cellIdentifier = @"JHRecycleHomeUserProtectionCell";
            viewModel.cellHeight = (ScreenW-24)*54/351.+10;// 375/36
            [tempArray addObject:@[viewModel]];
            
        }
        
        if (i == 2){//关键节点引导
            JHRecycleItemViewModel *viewModel = [[JHRecycleItemViewModel alloc] init];
            viewModel.cellIdentifier = @"JHRecycleNodeGuideCell";
            viewModel.dataModel = self.recycleHomeModel.orderInfoList;
            
            if (self.recycleHomeModel.orderInfoList.count > 0) {
//                if (self.recycleHomeModel.orderInfoList.count == 1) {
//                    viewModel.cellHeight = 70;//如果返回只有一条数据，高度应减去10
//                }else{
//                    viewModel.cellHeight = 80;
//                }
                 viewModel.cellHeight = 90;
                
                [tempArray addObject:@[viewModel]];
            }
        }
        
        if (i == 3) {//图文回收模块
            JHRecycleItemViewModel *viewModel = [[JHRecycleItemViewModel alloc] init];
            viewModel.cellIdentifier = @"JHRecycleHomeKeyTypeCell";
            viewModel.cellHeight = 150;
            viewModel.dataModel = self.recycleHomeModel.recycleCategoryList;
            if (self.recycleHomeModel.recycleCategoryList.count > 0) {
                [tempArray addObject:@[viewModel]];
            }
            
        }
        
        if (i == 4){//大家都在卖模块
            JHRecycleItemViewModel *viewModel = [[JHRecycleItemViewModel alloc] init];
            viewModel.cellIdentifier = @"JHRecycleHomeHotGoodsCell";
            NSInteger cellCount ;
        if (self.recycleHomeModel.productAggVOList.count%3>0) {
            cellCount = self.recycleHomeModel.productAggVOList.count/3+1;
        }
        else{
            cellCount = self.recycleHomeModel.productAggVOList.count/3;
            
            }
            viewModel.cellHeight = cellCount * HotGoodsCellHeight+60;
            
            //查看更多高度
        if(self.recycleHomeModel.productAggVOList.count>=GoodLimitCount) {
            viewModel.cellHeight = viewModel.cellHeight+46;
            }
            viewModel.dataModel = self.recycleHomeModel;
            if (self.recycleHomeModel.productAggVOList.count > 0) {
                [tempArray addObject:@[viewModel]];
            }
        }
        
        
        if (i == 5){
            JHRecycleItemViewModel *viewModel = [[JHRecycleItemViewModel alloc] init];
            viewModel.cellIdentifier = @"JHRecycleHomeBannerCell";
            viewModel.cellHeight = (kScreenWidth-24)*80/351;//351/80
            viewModel.dataModel = self.recycleHomeModel.operatingPositionThree;
            if (self.recycleHomeModel.operatingPositionThree > 0) {
                [tempArray addObject:@[viewModel]];
            }
            
        }
        
        
        
        if (i == 6){
            JHRecycleItemViewModel *viewModel = [[JHRecycleItemViewModel alloc] init];
            viewModel.cellIdentifier = @"JHRecycleHomeGuideEntranceCell";
            viewModel.cellHeight = (kScreenWidth-24)*69/351;
            viewModel.dataModel = self.recycleHomeModel.operatingPositionThree;
            [tempArray addObject:@[viewModel]];
        }
//        if (i == 7){//常见问题
//            JHRecycleItemViewModel *viewModel = [[JHRecycleItemViewModel alloc] init];
//            viewModel.cellIdentifier = @"JHRecycleHomeProblemCell";
//           // viewModel.cellHeight = 260;
//            viewModel.cellHeight = 35*self.recycleHomeModel.recycleHelpArticleList.count+85;
//            viewModel.dataModel = self.recycleHomeModel.recycleHelpArticleList;
//            if (self.recycleHomeModel.recycleHelpArticleList.count > 0) {
//                [tempArray addObject:@[viewModel]];
//            }
//        }
    }
    self.dataSourceArray = tempArray;
}

- (void)constructProblemData:(id)data{
    
  RequestModel *model = (RequestModel *)data;
  NSArray *arr = [JHHomeRecycleHelpArticleListModel mj_objectArrayWithKeyValuesArray :model.data[@"rows"]];
    NSMutableArray *tempArray = [self.dataSourceArray mutableCopy];
    NSMutableArray *dataList = [NSMutableArray array];
    
    for (int i=0; i<tempArray.count; i++) {
        JHRecycleItemViewModel *viewModel = tempArray[i][0];
        if ([viewModel.cellIdentifier isEqualToString:@"JHRecycleHomeProblemCell"]) {
            [dataList addObjectsFromArray:viewModel.dataModel[@"rows"]];
            [tempArray removeObjectAtIndex:i];
            break;
        }
    }
    
    [dataList addObjectsFromArray:arr];
    JHRecycleItemViewModel *viewModel = [[JHRecycleItemViewModel alloc] init];
    viewModel.cellIdentifier = @"JHRecycleHomeProblemCell";
    viewModel.cellHeight = 35*dataList.count+85;
    if ([model.data[@"isHasMore"] isEqual:@"1"]) {
       // viewModel.cellHeight = viewModel.cellHeight+40;
    }
    viewModel.dataModel = @{@"rows":dataList,@"isHasMore":model.data[@"isHasMore"]};
   // viewModel.dataModel = dataList;
    
    if (dataList.count > 0) {
        [tempArray addObject:@[viewModel]];
    }
    
    self.dataSourceArray = tempArray;
}
- (RACCommand *)recycleHomeCommand{
    if (!_recycleHomeCommand) {
        _recycleHomeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [JHRecycleHomeBusiness requestRecycleHomeWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error) {
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
    return _recycleHomeCommand;
}
- (RACCommand *)recycleProblemCommand{
    if (!_recycleProblemCommand) {
        _recycleProblemCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [JHRecycleHomeBusiness requestRecycleHomeProblemParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error) {
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
    return _recycleProblemCommand;
}

- (RACSubject *)errorRefreshSubject{
    if (!_errorRefreshSubject) {
        _errorRefreshSubject = [[RACSubject alloc] init];
    }
    return _errorRefreshSubject;
}
- (RACSubject *)recycleHomeCompleteSubject{
    if (!_recycleHomeCompleteSubject) {
        _recycleHomeCompleteSubject = [[RACSubject alloc] init];
    }
    return _recycleHomeCompleteSubject;
}


@end
