//
//  JHStoneDetailViewModel.m
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//
#import "JHStoneDetailViewModel.h"
#import "TTjianbaoUtil.h"

@interface JHStoneDetailViewModel ()

@end

@implementation JHStoneDetailViewModel

#pragma mark ---------------------------- network ----------------------------
-(void)requestCommonDataWithSubscriber:(id<RACSubscriber>)subscriber
{
    NSString *urlStr = FILE_BASE_STRING(@"/app/opt/stone-restore/find-details");
    NSDictionary *param = @{@"stoneId" : self.stoneId};
    
    if(self.type == 1){
        urlStr = FILE_BASE_STRING(@"/app/opt/stone/resale/find-detail");
        param = @{@"stoneResaleId" : self.stoneId};
    }
    
    [HttpRequestTool postWithURL:urlStr Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        self.returnData = respondObject.data;
        self.dataModel = [CStoneDetailModel modelWithJSON:respondObject.data];
        [self loadSectionMethod];
        
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
    }];
}

-(void)explainAction:(void(^)(void))block
{
    if(_isExplained)
    {
        if (block) {
            block();
        }
        return;
    }
    [JHGoodSeeSaveReqModel requestWithStoneId:self.stoneId finish:^(id respData, NSString *errorMsg) {
        if(errorMsg)
            [SVProgressHUD showErrorWithStatus:errorMsg];
        else
        {
            User *user = [UserInfoRequestManager sharedInstance].user;
            [self.dataModel.seekCustomerImgList insertObject:user.icon atIndex:0];
            _isExplained = YES;
            if (block) {
                block();
            }
        }
    }];
}

-(void)buyMethod:(void (^)(id _Nonnull))block
{
    JHGoodOrderSaveReqModel *reqm = [JHGoodOrderSaveReqModel new];
    reqm.channelCategory = JHRoomTypeNameRestoreStone;
    reqm.stoneId = self.stoneId;
    reqm.orderCategory = @"restoreOrder";
    reqm.orderPrice = self.dataModel.price.stringValue;
    [JHMainLiveSmartModel request:reqm response:^(id respData, NSString *errorMsg) {

        if(errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        else
        {
            if (block) {
                block(respData);
            }
        }
    }];
}

-(void)loadSectionMethod
{
    [self.sectionArray removeAllObjects];
    {
        JHStoneDetailTabelViewModel *model = [JHStoneDetailTabelViewModel new];
        model.detailSectionType = DetailSectionTypeTopInfo;
        model.detailSectionTitle = @"";
        [self.sectionArray addObject:model];
    }
    
//    if(self.dataModel.offerRecordList.count > 0)
    {
        JHStoneDetailTabelViewModel *model = [JHStoneDetailTabelViewModel new];
        model.detailSectionType = DetailSectionTypeOfferPrice;
        model.detailSectionTitle = [NSString stringWithFormat:@"出价记录（%lu人次）",self.dataModel ? self.dataModel.offerRecordList.count : 0];
        [self.sectionArray addObject:model];
    }
    
    {
        JHStoneDetailTabelViewModel *model = [JHStoneDetailTabelViewModel new];
        model.detailSectionType = DetailSectionTypeTotal;
        model.detailSectionTitle = @"原石数据统计";
        [self.sectionArray addObject:model];
    }
    
    {
        JHStoneDetailTabelViewModel *model = [JHStoneDetailTabelViewModel new];
        model.detailSectionType = DetailSectionTypeFamily;
        model.detailSectionTitle = @"原石家谱";
        [self.sectionArray addObject:model];
    }
    
    {
        JHStoneDetailTabelViewModel *model = [JHStoneDetailTabelViewModel new];
        model.detailSectionType = DetailSectionTypeChange;
        model.detailSectionTitle = @"原石溯源";
        [self.sectionArray addObject:model];
    }
    
}

-(NSMutableArray<JHStoneDetailTabelViewModel *> *)sectionArray
{
    if(!_sectionArray){
        _sectionArray = [NSMutableArray new];
    }
    return _sectionArray;
}

@end
