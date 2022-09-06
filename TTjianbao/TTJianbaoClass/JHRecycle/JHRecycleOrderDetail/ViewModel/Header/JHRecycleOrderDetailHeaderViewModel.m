//
//  JHRecycleOrderDetailHeaderViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailHeaderViewModel.h"
#import "JHRecycleOrderNodeLineItemViewModel.h"
#import "JHRecycleOrderNodeItemViewModel.h"
@interface JHRecycleOrderDetailHeaderViewModel()

@property (nonatomic, strong) NSDictionary *nodeDict;

@end

@implementation JHRecycleOrderDetailHeaderViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions
- (void)setupDataWithNodeInfo : (JHRecycleOrderNodeInfo *)model {
    [self.nodeViewModel.itemList removeAllObjects];
    int i = 1;

    for (NSString *title in model.recycleNodes) {
        JHRecycleOrderNodeItemViewModel *itemViewModel = [[JHRecycleOrderNodeItemViewModel alloc] init];
        itemViewModel.numText = [NSString stringWithFormat:@"%d", i];
        itemViewModel.detailText = title;
        if (i <= model.selectedNode) {
            itemViewModel.isHighlight = true;
        }else {
            itemViewModel.isHighlight = false;
        }
        [self.nodeViewModel.itemList appendObject:itemViewModel];
        
        if (i != 0 && i < model.recycleNodes.count) {
            int index = i - 1;
            JHRecycleOrderNodeLineItemViewModel *lineViewModel = [[JHRecycleOrderNodeLineItemViewModel alloc] init];
            NSString *detail = model.recycleNodesStr[index];
            
            if (detail != nil) {
                lineViewModel.detailText = detail;
            }
            
            if (index < model.selectedNode - 1) {
                lineViewModel.isHighlight = true;
            }else {
                lineViewModel.isHighlight = false;
            }
            [self.nodeViewModel.itemList appendObject:lineViewModel];
        }
        
        i += 1;
    }

    [self.nodeViewModel.refreshView sendNext:nil];
}
#pragma mark - Private Functions
- (void)setupData {
    
}
#pragma mark - Action functions
#pragma mark - Lazy
- (JHRecycleOrderNodeViewModel *)nodeViewModel {
    if (!_nodeViewModel) {
        _nodeViewModel = [[JHRecycleOrderNodeViewModel alloc] init];
    }
    return _nodeViewModel;
}

- (NSDictionary *)nodeDict {
    if (!_nodeDict) {
        _nodeDict = @{
            @"1" : @"提交订单",
            @"2" : @"取消订单",
            @"3" : @"预约取件",
            @"4" : @"确认交易",
            @"5" : @"结算打款",
            @"6" : @"订单关闭",
        };
    }
    return _nodeDict;
}
@end
