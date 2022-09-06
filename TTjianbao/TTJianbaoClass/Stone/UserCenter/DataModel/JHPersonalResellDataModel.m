//
//  JHPersonalResellDataModel.m
//  TTjianbao
//
//  Created by jesee on 20/5/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPersonalResellDataModel.h"

@interface JHPersonalResellDataModel ()

@property (nonatomic, strong) JHPersonalResellModel* resellModel;
@end

@implementation JHPersonalResellDataModel

- (void)asynReqPersonalResellListPageType:(JHPersonalResellSubPageType)pageType lastStoneId:(NSString*)lastStoneId response:(JHResponse)resp
{
    JHPersonalResellReqModel* model = nil;
    switch (pageType)
    {
        case JHPersonalResellSubPageTypeShelve:
        default:
        {///原石转售-个人中心-在售（已上架）列表
            model = [JHPersonalResellShelveListReqModel new];
        }
            break;
        
        case JHPersonalResellSubPageTypeSold:
        {///原石转售-个人中心-已售列表
            model = [JHPersonalResellSoldReqModel new];
        }
            break;
            
        case JHPersonalResellSubPageTypeWaitShelve:
        {///原石转售-个人中心-待上架列表
            model = [JHPersonalResellWaitshelveReqModel new];
        }
            break;
    }
    model.lastId = lastStoneId;
    [self reqPersonalResellListWithModel:model response:resp];
}

- (void)reqPersonalResellListWithModel:(JHGoodsReqModel*)model response:(JHResponse)resp
{
    JH_WEAK(self)
    [JH_REQUEST asynPost:model success:^(id respData) {
        JH_STRONG(self)
        if(respData)
        {
            self.resellModel = [JHPersonalResellModel convertData:respData];
        }
        resp(self.resellModel, [JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        resp([JHRespModel nullMessage], errorMsg);
    }];
}

///原石转售-个人中心-list item
- (void)asynReqPersonalResellListItem:(NSString*)stoneId response:(JHResponse)resp
{
    JHPersonalResellListItemReqModel* model = [JHPersonalResellListItemReqModel new];
    model.stoneResaleId = stoneId;

    [JH_REQUEST asynPost:model success:^(id respData) {
        JHPersonalResellListModel* resellModel = nil;
        if(respData)
        {
            resellModel = [JHPersonalResellListModel convertData:respData];
        }
        resp(resellModel, [JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        resp([JHRespModel nullMessage], errorMsg);
    }];
}

///原石转售-上架-操作
- (void)asynReqPersonalResellShelve:(NSString*)stoneId response:(JHResponse)resp
{
    JHPersonalResellShelveReqModel* model = [JHPersonalResellShelveReqModel new];
    model.stoneResaleId = stoneId;
    [JH_REQUEST asynPost:model success:^(id respData) {
    
        resp(respData, [JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        resp([JHRespModel nullMessage], errorMsg);
    }];
}

///原石转售-下架-操作
- (void)asynReqPersonalResellUnshelve:(NSString*)stoneId response:(JHResponse)resp
{
    JHPersonalResellUnshelveReqModel* model = [JHPersonalResellUnshelveReqModel new];
    model.stoneResaleId = stoneId;
    [JH_REQUEST asynPost:model success:^(id respData) {
    
        resp(respData, [JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        resp([JHRespModel nullMessage], errorMsg);
    }];
}

///原石转售-个人中心-删除
- (void)asynReqPersonalResellDelete:(NSString*)stoneId response:(JHResponse)resp
{
    JHPersonalResellDeleteReqModel* model = [JHPersonalResellDeleteReqModel new];
    model.stoneResaleId = stoneId;
    [JH_REQUEST asynPost:model success:^(id respData) {
    
        resp(respData, [JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        resp([JHRespModel nullMessage], errorMsg);
    }];
}

@end
