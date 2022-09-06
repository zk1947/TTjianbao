//
//  JHShopwindowRequest.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHShopwindowRequest.h"
#import "JHRequestManager.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation JHShopwindowRequest

/// 获取商品详情
+ (void)requestEditDetailWithId:(NSString *)Id successBlock:(void (^) (JHShopwindowGoodsListModel *data))successBlock
{
    JHShopwindowReqBaseModel *req =[JHShopwindowReqBaseModel creatModelWithId:Id requestType:JHShopwindowReqUrlTypeDetail];
    
    [JH_REQUEST asynPost:req success:^(id respData) {
        if(successBlock && respData)
        {
            successBlock([JHShopwindowGoodsListModel mj_objectWithKeyValues:respData]);
        }
    } failure:^(NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}

/// 获取商品数量
+ (void)requestshopwindowNumWithId:(NSString *)Id successBlock:(void (^) (NSString *text))successBlock
{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/opt/showGoods/normalUserNum") Parameters:@{@"channelLocalId" : Id} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if(successBlock)
        {
            successBlock(respondObject.data);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}

/// 下架
+ (void)requestDownLineWithId:(NSString *)Id successBlock:(dispatch_block_t)successBlock
{
    JHShopwindowReqBaseModel *req =[JHShopwindowReqBaseModel creatModelWithId:Id requestType:JHShopwindowReqUrlTypeDownLine];
    
    [JH_REQUEST asynPost:req success:^(id respData) {
        if(successBlock)
        {
            successBlock();
        }

        [SVProgressHUD showSuccessWithStatus:@"商品下架成功"];
    } failure:^(NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}

/// 下架列表删除
+ (void)requestDownLineDeleteWithId:(NSString *)Id successBlock:(dispatch_block_t)successBlock
{
    JHShopwindowReqBaseModel *req =[JHShopwindowReqBaseModel creatModelWithId:Id requestType:JHShopwindowReqUrlTypeDownListDelete];
    
    [JH_REQUEST asynPost:req success:^(id respData) {
        if(successBlock)
        {
            successBlock();
        }
    } failure:^(NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}

/// 上架
+ (void)requestUpLineWithId:(NSString *)Id successBlock:(dispatch_block_t)successBlock
{
    JHShopwindowReqBaseModel *req =[JHShopwindowReqBaseModel creatModelWithId:Id requestType:JHShopwindowReqUrlTypeUpLine];
    
    [JH_REQUEST asynPost:req success:^(id respData) {
        if(successBlock)
        {
            successBlock();
        }
        [SVProgressHUD showSuccessWithStatus:@"商品上架成功"];
    } failure:^(NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}

/// 上架的删除
+ (void)requestUpListDeleteWithId:(NSString *)Id successBlock:(dispatch_block_t)successBlock
{
    JHShopwindowReqBaseModel *req =[JHShopwindowReqBaseModel creatModelWithId:Id requestType:JHShopwindowReqUrlTypeUpListDelete];
    
    [JH_REQUEST asynPost:req success:^(id respData) {
        if(successBlock)
        {
            successBlock();
        }
    } failure:^(NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}

/// 橱窗列表
/// @param channelLocalId 直播间ID(买家必传，主播可以不穿)
/// @param type 0-买家端列表    1-主播端上架中列表    2-主播端下架中列表
/// @param successBlock 成功后的回调
+ (void)requestUpListDeleteWithChannelLocalId:(NSString *)channelLocalId type:(NSInteger)type successBlock:(void (^)(NSArray<JHShopwindowGoodsListModel *> * _Nonnull))successBlock
{
    NSString *url = @"";
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    switch (type) {
        
        case 0:
        {
            [param setValue:channelLocalId forKey:@"channelLocalId"];
            url = @"/app/opt/showGoods/normalUser";
        }
            break;
            
        case 1:
        {
            url = @"/app/showGoods/upListInfo";
        }
            break;
            
        case 2:
        {
            url = @"/app/showGoods/downListInfo";
        }
            break;
            
        default:
        {
            url = @"/app/opt/showGoods/normalUser";
        }
            break;
    }
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(url) Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        NSArray *array = @[];
        if(IS_ARRAY(respondObject.data))
        {
            array = [JHShopwindowGoodsListModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        }
        if(successBlock)
        {
            successBlock(array);
        }
    } failureBlock:^(RequestModel *respondObject) {
        
         if(successBlock)
         {
             successBlock(@[]);
         }
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}

/// 添加商品-add or edit
+ (void)requestAddGoods:(JHShopwindowGoodsListModel*)goodsModel successBlock:(dispatch_block_t)successBlock
{
    JHShopwindowAddGoodsReqModel *req = [JHShopwindowAddGoodsReqModel new];
    if(goodsModel.Id)
        req.requestType = JHShopwindowReqUrlTypeEditGoods;
    else
        req.requestType = JHShopwindowReqUrlTypeAddGoods;
    req.Id = goodsModel.Id;
    req.goodsCateId = goodsModel.goodsCateId;
    req.listImage = goodsModel.listImage;
    req.price = goodsModel.price;
    req.title = goodsModel.title;

    NSArray * newCateArr = [self getCateAll];
    [newCateArr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"id"] isEqualToString:goodsModel.goodsCateId]) {
            req.goodsNewCateId = obj[@"newGoodsCateId"];
        }
    }];
    
    [JH_REQUEST asynPost:req success:^(id respData) {
        if(successBlock)
        {
            successBlock();
        }
    } failure:^(NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}


+ (NSArray *)getCateAll {
    __block NSArray *dataArr = nil;
    if ([UserInfoRequestManager sharedInstance].feidanPickerDataArray) {
        dataArr = [UserInfoRequestManager sharedInstance].feidanPickerDataArray;
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in dataArr) {
            [array addObject:dic[@"name"]];
        }
        return dataArr;
    }
    
    dispatch_semaphore_t sig = dispatch_semaphore_create(0);
    [[UserInfoRequestManager sharedInstance] getNewFlyOrder_successBlock:^(RequestModel * _Nullable respondObject) {
        dataArr = respondObject.data;
       NSMutableArray *array = [NSMutableArray array];
       for (NSDictionary *dic in dataArr) {
           [array addObject:dic[@"name"]];
       }
        [UserInfoRequestManager sharedInstance].feidanPickerDataArray = respondObject.data;
    } failureBlock:^(RequestModel * _Nullable respondObject) {}];
    dispatch_semaphore_wait(sig, DISPATCH_TIME_FOREVER);
    return dataArr;
}


@end
