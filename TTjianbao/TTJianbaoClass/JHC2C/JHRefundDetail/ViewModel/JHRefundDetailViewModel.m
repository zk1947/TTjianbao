//
//  JHRefundDetailViewModel.m
//  TTjianbao
//
//  Created by hao on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRefundDetailViewModel.h"
#import "JHRefundDetailBusiness.h"
#import "JHRefundDetailItemViewModel.h"

@interface JHRefundDetailViewModel ()
@end

@implementation JHRefundDetailViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    @weakify(self)
    [self.refundCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [self constructData:x];
        }else{
            [self.errorRefreshSubject sendNext:@YES];
        }
        
    }];
}
- (void)constructData:(id)data{
    RequestModel *model = (RequestModel *)data;
    self.refundDetailModel = [JHC2CRefundDetailModel mj_objectWithKeyValues:model.data];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.refundDetailModel.operationList.count; ++i) {
        
        JHRefundOperationListModel *listModel = self.refundDetailModel.operationList[i];
        JHRefundDetailItemViewModel *itemModel = [JHRefundDetailItemViewModel new];
        switch ([listModel.operationType intValue]) {
            case 1://买家申请退货退款
                itemModel.cellIdentifier = @"JHRefundBuyerApplyCell";
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
                break;
            case 2://卖家拒绝退货
                itemModel.cellIdentifier = @"JHRefundSellerRefuseCell";
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
                break;
            case 3://卖家同意退货申请
                itemModel.cellIdentifier = @"JHRefundSellerAgreesCell";
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
                break;
            case 4://卖家超时未处理，系统同意退货
            {
                if (listModel.sellerPhone.length > 0) {
                    itemModel.cellIdentifier = @"JHRefundSellerAgreesCell";
                }else{
                    itemModel.cellIdentifier = @"JHRefundSellerProcessingCell";
                }
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
            }
                break;
            case 5://平台介入，同意退货
            {
                if (listModel.sellerPhone.length > 0) {
                    itemModel.cellIdentifier = @"JHRefundSellerAgreesCell";
                }else{
                    itemModel.cellIdentifier = @"JHRefundSellerProcessingCell";
                }
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
            }
                break;
            case 6://买家已退货
                itemModel.cellIdentifier = @"JHRefundBuyerReturnedCell";
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
                break;
            case 7://卖家收货后同意退款
                itemModel.cellIdentifier = @"JHRefundSellerProcessingCell";
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
                break;
            case 8://卖家超时未处理，系统同意退款
                itemModel.cellIdentifier = @"JHRefundSellerProcessingCell";
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
                break;
            case 9://卖家收货后拒绝退款
                itemModel.cellIdentifier = @"JHRefundSellerRefuseCell";
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
                break;
            case 10://卖家取消交易
                itemModel.cellIdentifier = @"JHRefundBuyerApplyCell";
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
                break;
            case 11://买家申请退款
                itemModel.cellIdentifier = @"JHRefundBuyerApplyCell";
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
                break;
            case 12://卖家同意退款
                itemModel.cellIdentifier = @"JHRefundSellerProcessingCell";
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
                break;
            case 13://卖家超时未处理，系统自动退款
                itemModel.cellIdentifier = @"JHRefundSellerProcessingCell";
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
                break;
            case 14://卖家拒绝退款
                itemModel.cellIdentifier = @"JHRefundSellerRefuseCell";
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
                break;
            case 15://平台提醒
                itemModel.cellIdentifier = @"JHRefundRemindCell";
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
                break;
            case 16://平台介入 同意退款
                itemModel.cellIdentifier = @"JHRefundSellerProcessingCell";
                itemModel.dataModel = listModel;
                [tempArray addObject:@[itemModel]];
                break;
                
            default:
                break;
        }
        
    }
    self.dataSourceArray = tempArray;
}
- (RACCommand *)refundCommand{
    if (!_refundCommand) {
        _refundCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [JHRefundDetailBusiness requestRefundDetailWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
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
    return _refundCommand;
}

- (RACSubject *)errorRefreshSubject{
    if (!_errorRefreshSubject) {
        _errorRefreshSubject = [[RACSubject alloc] init];
    }
    return _errorRefreshSubject;
}


@end
