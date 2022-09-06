//
//  JHResaleLiveRoomTabDataModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHResaleLiveRoomTabDataModel.h"
#import "JHGoodResaleListModel.h"
#import "JHMyResaleListModel.h"
#import "JHBuyerPriceListModel.h"
#import "JHMyPriceListModel.h"
#import "SVProgressHUD.h"

@interface JHResaleLiveRoomTabDataModel ()

@property (nonatomic, strong) NSMutableArray* dataArray;

@end

@implementation JHResaleLiveRoomTabDataModel

- (void)requestByPage:(JHResaleLiveRoomTabType)type channelId:(NSString*)mChannelId pageIndex:(NSUInteger)index
{
    switch (type)
    {
        case JHResaleLiveRoomTabTypeStoneResale:
        default:
            [self requestStoneResaleWithChannelId:mChannelId pageIndex:index];
            break;
            
        case JHResaleLiveRoomTabTypeOnSale:
            [self requestOnSaleWithPageIndex:index];
            break;
        case JHResaleLiveRoomTabTypeBuyPrice:
            [self requestBuyPriceWithChannelId:mChannelId pageIndex:index];
            break;
        case JHResaleLiveRoomTabTypeMyPrice:
            [self requestMyPriceWithChannelId:mChannelId pageIndex:index];
            break;
    }
}

//JHResaleLiveRoomTabTypeStoneResale
- (void)requestStoneResaleWithChannelId:(NSString*)mChannelId pageIndex:(NSUInteger)index
{
    JHGoodResaleListReqModel* model = [JHGoodResaleListReqModel new];
    model.channelId = mChannelId;
    model.pageIndex = index;
    JH_WEAK(self)
    [self request:model finish:^(id respData, NSString *errorMsg) {
        JH_STRONG(self)
        if(!errorMsg)
        {
            self.dataArray = [JHGoodResaleListModel convertData:respData];
        }
        
        if([self.delegate respondsToSelector:@selector(responseData:error:)])
        {
            [self.delegate responseData:self.dataArray error:errorMsg];
        }
        else
        {
            [SVProgressHUD dismiss];
        }
    }];
}

//JHResaleLiveRoomTabTypeOnSale
- (void)requestOnSaleWithPageIndex:(NSUInteger)index
{
    JHMyResaleListReqModel* model = [JHMyResaleListReqModel new];
    model.pageIndex = index;
    JH_WEAK(self)
    [self request:model finish:^(id respData, NSString *errorMsg) {
        JH_STRONG(self)
        if(!errorMsg)
        {
            self.dataArray = [JHMyResaleListModel convertData:respData];
        }
        
        if([self.delegate respondsToSelector:@selector(responseData:error:)])
        {
            [self.delegate responseData:self.dataArray error:errorMsg];
        }
    }];
}

//JHResaleLiveRoomTabTypeBuyPrice
- (void)requestBuyPriceWithChannelId:(NSString*)mChannelId pageIndex:(NSUInteger)index
{
    JHBuyerPriceListReqModel* model = [JHBuyerPriceListReqModel new];
    model.channelId = mChannelId;
    model.pageIndex = index;
    JH_WEAK(self)
    [self request:model finish:^(id respData, NSString *errorMsg) {
        JH_STRONG(self)
        if(!errorMsg)
        {
            JHBuyerPriceListModel* model = [JHBuyerPriceListModel convertData:respData];
            self.dataArray = [NSMutableArray arrayWithArray:model.stoneDetail];
        }
        
        if([self.delegate respondsToSelector:@selector(responseData:error:)])
        {
            [self.delegate responseData:self.dataArray error:errorMsg];
        }
    }];
}

//JHResaleLiveRoomTabTypeMyPrice
- (void)requestMyPriceWithChannelId:(NSString*)mChannelId pageIndex:(NSUInteger)index
{
    JHMyPriceListReqModel* model = [JHMyPriceListReqModel new];
    model.channelId = mChannelId;
    model.pageIndex = index;
    JH_WEAK(self)
    [self request:model finish:^(id respData, NSString *errorMsg) {
        JH_STRONG(self)
        if(!errorMsg)
        {
            self.dataArray = [JHMyPriceListModel convertData:respData];
        }
        
        if([self.delegate respondsToSelector:@selector(responseData:error:)])
        {
            [self.delegate responseData:self.dataArray error:errorMsg];
        }
    }];
}

- (void)request:(JHReqModel*)model finish:(JHResponse)resp
{
    [JH_REQUEST asynPost:model success:^(id respData) {
        
        resp(respData, [JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        resp([JHRespModel nullMessage], errorMsg);
    }];
}

@end
