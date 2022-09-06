//
//  JHUserCenterResaleDataModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHUserCenterResaleDataModel.h"
#import "JHBuyerPriceListModel.h"
#import "JHUCOnSaleListModel.h"
#import "JHUCSoldListModel.h"
#import "NSString+Common.h"

@interface JHUserCenterResaleDataModel ()

@property (nonatomic, strong) NSMutableArray* dataArray;

@end

@implementation JHUserCenterResaleDataModel

- (void)requestByPage:(JHResaleSubPageType)type channelId:(NSString*)mChannelId pageIndex:(NSUInteger)index
{
    self.dataArray = nil;
    switch (type)
    {
        case JHResaleSubPageTypeBuyPrice:
        default:
            [self requestBuyPriceWithChannelId:mChannelId pageIndex:index];
            break;
            
        case JHResaleSubPageTypeOnSale:
            [self requestOnSaleWithPageIndex:index];
            break;
        case JHResaleSubPageTypeSold:
            [self requestSoldWithPageIndex:index];
            break;
    }
}

- (void)requestBuyPriceWithChannelId:(NSString*)cId pageIndex:(NSUInteger)index
{
    JHBuyerPriceListReqModel* model = [JHBuyerPriceListReqModel new];
    model.channelId = cId;
    model.pageIndex = index;
    JH_WEAK(self)
    [self request:model finish:^(id respData, NSString *errorMsg) {
        JH_STRONG(self)
        if(!errorMsg)
        {
            JHBuyerPriceListModel* model = [JHBuyerPriceListModel convertData:respData];
            if(![NSString isEmpty:model.totalNum])
            {
                self.total = model.totalNum;
                self.totalPrice = model.totalSalePrice;
                self.dataArray = [NSMutableArray arrayWithArray:model.stoneDetail];
            }
        }
        
        if([self.delegate respondsToSelector:@selector(responseData:error:)])
        {
            [self.delegate responseData:self.dataArray error:errorMsg];
        }
    }];
}

- (void)requestOnSaleWithPageIndex:(NSUInteger)index
{
    JHUCOnSaleListReqModel* model = [JHUCOnSaleListReqModel new];
    model.pageIndex = index;
    JH_WEAK(self)
    [self request:model finish:^(id respData, NSString *errorMsg) {
        JH_STRONG(self)
        if(!errorMsg)
        {
            JHUCOnSalePageModel* model = [JHUCOnSalePageModel convertData:respData];
            if(![NSString isEmpty:model.total])
            {
                self.total = model.total;
                self.totalPrice = model.totalPrice;
                self.dataArray = [NSMutableArray arrayWithArray:model.list];
            }
        }
        
        if([self.delegate respondsToSelector:@selector(responseData:error:)])
        {
            [self.delegate responseData:self.dataArray error:errorMsg];
        }
    }];
}

- (void)requestSoldWithPageIndex:(NSUInteger)index
{
    JHUCSoldListReqModel* model = [JHUCSoldListReqModel new];
    model.pageIndex = index;
    JH_WEAK(self)
    [self request:model finish:^(id respData, NSString *errorMsg) {
        JH_STRONG(self)
        if(!errorMsg)
        {
            JHUCSoldPageModel* model = [JHUCSoldPageModel convertData:respData];

            if(![NSString isEmpty:model.total])
            {
                self.total = model.total;
                self.totalPrice = model.totalPrice;
                self.dataArray = [NSMutableArray arrayWithArray:model.list];
            }
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
