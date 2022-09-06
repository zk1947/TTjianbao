//
//  JH99FreeModel.m
//  TTjianbao
//
//  Created by lihui on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JH99FreeModel.h"
#import "JHGoodsInfoMode.h"
#import "JHStoreHomeCardModel.h"

@implementation JH99FreeModel

- (instancetype)initWith99FreeInfo:(id)responseObj {
    self = [super init];
    if (self) {
        RequestModel *response = (RequestModel *)responseObj;
        NSDictionary *dict = [response.data firstObject];
        NSDictionary *cardInfo = dict[@"card_info"];
        
        ///商品信息
        self.goodsList = [NSMutableArray array];
        NSArray *goodsInfos = cardInfo[@"goods_list"];
        if (![goodsInfos isKindOfClass:[NSNull class]]) {
            if (goodsInfos && goodsInfos.count > 0) {
                for (NSDictionary *goodDic in cardInfo[@"goods_list"]) {
                    JHGoodsInfoMode *goods = [JHGoodsInfoMode mj_objectWithKeyValues:goodDic];
                    [self.goodsList addObject:goods];
                }
            }
        }
        
        NSDictionary *scInfo = [cardInfo[@"sc_infos"] firstObject];
        self.showcaseInfo = [JHStoreHomeShowcaseModel mj_objectWithKeyValues:scInfo];
        self.login_time = [cardInfo[@"login_time"] longLongValue];
        self.server_time = [cardInfo[@"server_time"] longLongValue];
        self.finish_time = [cardInfo[@"finish_time"] longLongValue];
        self.is_pop = [cardInfo[@"is_pop"] boolValue];
    }
    return self;
}

@end
