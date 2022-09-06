//
//  JHGoodResaleListModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodResaleListModel.h"
#import "JHStoneResaleDetailSubModel.h"

@implementation JHGoodResaleOfferRecordModel

- (JHStoneResaleDetailSubModel*)convertDetailModel
{
    JHStoneResaleDetailSubModel* detail = [JHStoneResaleDetailSubModel new];
    detail.headImg = self.offerCustomerIcon;
    detail.name = self.offerCustomerName;
    detail.time = self.createTime;
    detail.price = self.offerPrice;
    detail.offerStatus = [self.offerState integerValue];
    
    return detail;
}

@end

@implementation JHGoodResaleListModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"offerRecordList" : [JHGoodResaleOfferRecordModel class]
    };
}

- (instancetype)initWithModel:(JHGoodResaleListModel*)model
{
    if(self = [super init])
    {
        self.goodsCode = model.goodsCode;
        self.goodsTitle  = model.goodsTitle; // (string, optional): 原石名称
        self.goodsUrl  = model.goodsUrl; //(string, optional): 图片
        self.orderCode  = model.orderCode; //(string, optional): 订单id
        self.saleCustomerId = model.saleCustomerId;// (integer, optional): 寄售人ID ,
        self.selfSeek  = model.selfSeek;// (boolean, optional): 表示是否是已求看 ,
        self.selfOffer = model.selfOffer; //(boolean, optional): 表示是否显示砍价按钮
        self.dealSequence  = model.dealSequence;// (integer, optional): 第几次交易 ,
        self.offerCount  = model.offerCount;// (integer, optional): 出价人数 ,
        self.seekCount  = model.seekCount;// (integer, optional): 求看人数 ,
        self.seekCustomerImgList  = model.seekCustomerImgList;// (Array[string], optional): 求看人图片列表 ,
        self.stoneRestoreId  = model.stoneRestoreId;// (integer, optional): 回血原石ID
        self.salePrice  = model.salePrice;
        self.offerRecordList = model.offerRecordList;
        self.buttonTxt  = model.buttonTxt;
        self.explainingFlag = model.explainingFlag;
    }
    return self;
}

@end

@implementation JHGoodResaleListReqModel

- (NSString *)uriPath
{
    return @"/anon/stone-restore/list-all";
}

@end

@implementation JHGoodSeeSaveModel

@end

@implementation JHGoodSeeSaveReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore-seek/save";
}

+ (void)requestWithStoneId:(NSString*)mId finish:(JHResponse)resp
{
    JHGoodSeeSaveReqModel* model = [JHGoodSeeSaveReqModel new];
    model.stoneRestoreId = mId;
    [JH_REQUEST asynPost:model success:^(id respData) {
        JHGoodSeeSaveModel* model = [JHGoodSeeSaveModel convertData:respData];
        resp(model, [JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        resp([JHRespModel nullMessage], errorMsg);
    }];
}

@end

@implementation JHGoodOrderSaveReqModel

- (NSString *)uriPath
{
    return @"/app/stone/order/save";
}

+ (void)requestWithStoneId:(NSString*)mId price:(NSString*)price finish:(JHResponse)resp
{
    JHGoodOrderSaveReqModel* model = [JHGoodOrderSaveReqModel new];
    model.stoneId = mId;
    model.orderPrice = price;
    [JH_REQUEST asynPost:model success:^(id respData) {
        
        JHGoodOrderSaveModel* model = [JHGoodOrderSaveModel convertData:respData];
        resp(model, [JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        resp([JHRespModel nullMessage], errorMsg);
    }];
}

@end

//目前data为空？？？？？
@implementation JHGoodOrderSaveModel
@end
