//
//  JHMainLiveRoomTabDataModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMainLiveRoomTabDataModel.h"
#import "JHLastSaleGoodsReqModel.h"
#import "JHUCOnSaleListModel.h"
#import "JHOffSaleGoodsModel.h"
#import "JHLastSaleGoodsModel.h"
#import "JHBackUpLoadManage.h"

@interface JHMainLiveRoomTabDataModel ()
{
    JHLastSaleGoodsReqModel* reqModel;
    JHGoodsReqModel* goodsReqModel;
}

@property (nonatomic, strong) NSMutableArray* dataArray;

@end
@implementation JHMainLiveRoomTabDataModel

- (void)requestByPage:(JHMainLiveRoomTabType)type channelId:(NSString*)mChannelId pageIndex:(NSUInteger)index keyword:(NSString*)keyword
{
    if(type == JHMainLiveRoomTabTypeOffSale)
    {
        goodsReqModel = [[JHGoodsReqModel alloc] init];
        [goodsReqModel setRequestPath:@"/app/stone-restore/list-channel-unshelve"];
        goodsReqModel.channelId = mChannelId;
        goodsReqModel.pageIndex = index;
        goodsReqModel.keyword = keyword;
        JH_WEAK(self)
        [JH_REQUEST asynPost:goodsReqModel success:^(id respData) {
            JH_STRONG(self)
            NSArray* arr = [JHOffSaleGoodsModel convertData:respData];
            
            if(index > 0)
                [self.dataArray addObjectsFromArray:arr];
            else
                self.dataArray = [NSMutableArray arrayWithArray:arr];
            
            if([self.delegate respondsToSelector:@selector(responsePage:error:)])
            {
                [self.delegate responsePage:type error:[JHRespModel nullMessage]];
            }
            
        } failure:^(NSString *errorMsg) {
            JH_STRONG(self)
            if([self.delegate respondsToSelector:@selector(responsePage:error:)])
            {
                [self.delegate responsePage:type error:errorMsg];
            }
        }];
    }
    else if(type == JHMainLiveRoomTabTypeLastSale || type == JHMainLiveRoomTabTypeWillSale || type == JHMainLiveRoomTabTypeWillSaleFromUserCenter)
    {
        reqModel = [[JHLastSaleGoodsReqModel alloc] init];
        reqModel.keyword = keyword;
        if(type == JHMainLiveRoomTabTypeWillSale)
            reqModel.reqType = JHLastSaleGoodsReqTypeWillSale;
        else if(type == JHMainLiveRoomTabTypeWillSaleFromUserCenter)
        {
            reqModel.reqType = JHLastSaleGoodsReqTypeWillSaleFromUserCenter;
            reqModel.keyword = @"";
        }
        reqModel.channelId = mChannelId;
        
        reqModel.pageIndex = index;
        JH_WEAK(self)
        [JH_REQUEST asynPost:reqModel success:^(id respData) {
            JH_STRONG(self)
    
            NSArray* arr = [JHLastSaleGoodsModel convertData:respData];
            if(index > 0)
                [self.dataArray addObjectsFromArray:arr];
            else
                self.dataArray = [NSMutableArray arrayWithArray:arr];
            
            //本地查询上架状态,补充到数据数组
            [self queryWillSaleOnshelfState:type stoneId:nil];
            if([self.delegate respondsToSelector:@selector(responsePage:error:)])
            {
                [self.delegate responsePage:type error:[JHRespModel nullMessage]];
            }
        } failure:^(NSString *errorMsg) {
            JH_STRONG(self)
            
            if([self.delegate respondsToSelector:@selector(responsePage:error:)])
            {
                [self.delegate responsePage:type error:errorMsg];
            }
        }];
    }
    else
    {
        //type = JHMainLiveRoomTabTypeResaleStoneTab
        NSString* url = @"/app/stone-restore/list-channel-sale"; //直播间寄售原石
        if(type == JHMainLiveRoomTabTypeResaleStone)
        {
            url = @"/app/stone-restore/list-anchor-sale"; //个人中心寄售原石「channelId = 0」
            mChannelId = @"0";
        }
        else if(type == JHMainLiveRoomTabTypeToSee)
            url = @"/app/stone-restore-seek/page";
        
        goodsReqModel = [[JHGoodsReqModel alloc] init];
        [goodsReqModel setRequestPath:url];
        goodsReqModel.channelId = mChannelId;
        goodsReqModel.pageIndex = index;
        goodsReqModel.keyword = keyword;
        JH_WEAK(self);
        [JH_REQUEST asynPost:goodsReqModel success:^(id respData) {
            JH_STRONG(self)
            //不用JHToSeeGoodsModel,使用JHUCOnSaleListModel大结构
            NSArray* arr = [JHUCOnSaleListModel convertData:respData];
            if(index > 0)
                [self.dataArray addObjectsFromArray:arr];
            else
                self.dataArray = [NSMutableArray arrayWithArray:arr];
             if([self.delegate respondsToSelector:@selector(responsePage:error:)])
             {
                 [self.delegate responsePage:type error:[JHRespModel nullMessage]];
             }
             
         } failure:^(NSString *errorMsg) {
             JH_STRONG(self)
             if([self.delegate respondsToSelector:@selector(responsePage:error:)])
             {
                 [self.delegate responsePage:type error:errorMsg];
             }
         }];
    }
}

- (void)queryWillSaleOnshelfState:(JHMainLiveRoomTabType)type stoneId:(NSString*)stoneId
{
    if(type == JHMainLiveRoomTabTypeWillSale || type == JHMainLiveRoomTabTypeWillSaleFromUserCenter)
    {
        NSMutableArray* queryArray = [NSMutableArray arrayWithArray:self.dataArray];
        for (JHLastSaleGoodsModel* model in queryArray)
        {
            model.shelfState = [[JHBackUpLoadManage shareInstance] checkShowStatusStoneId:model.stoneRestoreId];
            if(model.shelfState == JHShelvShowStatusSuccess)
            {
                //remove the data
                [self.dataArray removeObject:model];
            }
            //如果stoneId有值,查询到就ok,无需遍历全部
            if(stoneId && [stoneId isEqualToString:model.stoneRestoreId])
                break;
        }
    }
}

@end
