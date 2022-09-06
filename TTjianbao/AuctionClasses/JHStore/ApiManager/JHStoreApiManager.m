//
//  JHStoreApiManager.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoreApiManager.h"
#import "TTjianbaoHeader.h"
#import "JHHotWordModel.h"
#import "JHStoreNewRedpacketModel.h"

@implementation JHStoreApiManager

//调试方法
/*
+ (void)loadLocalGoodsListWithModel:(CStoreHomeListModel *)model block:(HTTPCompleteBlock)block {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StoreList" ofType:@"json"]];
    NSError *error = nil;
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if ( !error ) {
        id data = dataDic[@"data"];
        if (data) {
            NSArray *dataList = [NSArray modelArrayWithClass:[CStoreHomeListData class] json:data];
            
            model.isLoading = NO;
            [self __handleDataList:dataList model:model block:block];
        }
    }
}
*/

///以前的方法 国哥的！！！！
//+ (void)getHomeDataList:(CStoreHomeListModel *)model block:(HTTPCompleteBlock)block {
//    NSLog(@"获取商城首页列表数据");
//    if (model.isLoading) {return;}
//    model.isLoading = YES;
//    model.isFirstReq = NO;
//
//    //[self loadLocalGoodsListWithModel:model block:block]; //测试数据
//    //return;
//    @weakify(self);
//    [HttpRequestTool getWithURL:[model toUrl] Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
//        model.isLoading = NO;
//        NSArray *dataList = [NSArray modelArrayWithClass:[CStoreHomeListData class] json:respondObject.data];
//        @strongify(self);
//        if (dataList.count > 0) {
//            [self __handleDataList:dataList model:model block:block];
//        } else {
//            block(nil, NO);
//        }
//
//    } failureBlock:^(RequestModel * _Nullable respondObject) {
//        model.isLoading = NO;
//        block(nil, YES);
//        [UITipView showTipStr:respondObject.message];
//    }];
//}
//
//+ (void)__handleDataList:(NSArray *)dataList model:(CStoreHomeListModel *)model block:(HTTPCompleteBlock)block {
//
//    NSMutableArray *storeArray = [NSMutableArray new];
//
//    //倒计时相关 - 过滤掉无效数据，（layout：1橱窗<今日推荐样式>, 2<专题>样式, 3<特卖商城店铺数据>）
//    [dataList enumerateObjectsUsingBlock:^(CStoreHomeListData * _Nonnull listData, NSUInteger idx, BOOL * _Nonnull stop)
//    {
//        if (listData.layout == 1)
//        {
//            //****今日推荐样式（横向collectionView滚动）
//            //倒计时标识符：每个橱窗和橱窗中的数据采用同样的标识符，采用橱窗id（sc_id）对同样类型的橱窗做区分
//            listData.timerSourceIdentifier = [NSString stringWithFormat:@"%@_%ld_%ld",
//                                              storeHomeRcmdListTimerSourceId,
//                                              (long)model.page,
//                                              (long)listData.sc_id];
//
//            NSMutableArray *goodsArr = [NSMutableArray new];
//            [listData.goodsList enumerateObjectsUsingBlock:^(CStoreHomeGoodsData * _Nonnull goodsData, NSUInteger idx, BOOL * _Nonnull stop)
//            {
//                NSInteger second = goodsData.offline_at.integerValue - goodsData.server_at.integerValue;
//                if ( second > 0 && (goodsData.server_at.integerValue > 0) )
//                {
//                    //倒计时标识符：每个橱窗和橱窗中的数据采用同样的标识符
//                    goodsData.timerSourceIdentifier = [NSString stringWithFormat:@"%@_%ld_%ld",
//                                                       storeHomeRcmdListTimerSourceId,
//                                                       (long)model.page,
//                                                       (long)listData.sc_id];
//                    [goodsArr addObject:goodsData];
//                }
//            }];
//
//            if (goodsArr.count > 0) {
//                listData.goodsList = goodsArr.mutableCopy;
//                [storeArray addObject:listData];
//            }
//        }
//        else if (listData.layout == 2)
//        {
//            //****专题列表样式，不对倒计时进行校验，只验证服务器时间是否有效
//            //NSInteger second = data.offline_at.integerValue - data.server_at.integerValue;
//            if ( /* second > 0 && */ (listData.server_at.integerValue > 0) )
//            {
//                //每个专题采用独立的倒计时标识符，
//                listData.timerSourceIdentifier = [NSString stringWithFormat:@"%@_%ld_%ld", storeHomeListTimerSourceId, (long)model.page, (long)listData.sc_id];
//                [storeArray addObject:listData];
//            }
//        } else {
//            //其他类型不用倒计时
//            [storeArray addObject:listData];
//        }
//    }];
//
//    if (storeArray.count > 0) {
//        CStoreHomeListModel *aModel = [[CStoreHomeListModel alloc] init];
//        aModel.list = storeArray.mutableCopy;
//        block(aModel, NO);
//    } else {
//        block(nil, NO);
//    }
//}

+ (void)getHomeDataListWithCompleteblock:(HTTPCompleteBlock)block {
    NSLog(@"获取商城首页列表数据");
    [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/v2/shop/homepage") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        block(respondObject, NO);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

///商城首页-分类导航标签
+ (void)getChannelList:(CStoreChannelModel *)model block:(HTTPCompleteBlock)block {
    NSLog(@"商城首页-分类导航标签");
    if (model.isLoading) {return;}
    model.isLoading = YES;
    
    [HttpRequestTool getWithURL:[model toUrl] Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        NSArray *dataList = [NSArray modelArrayWithClass:[CStoreChannelData class] json:respondObject.data];
        if (!dataList) {
            dataList = [NSArray new];
        }
        CStoreChannelModel *aModel = [[CStoreChannelModel alloc] init];
        aModel.list = dataList.mutableCopy;
        block(aModel, NO);
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        block(nil, YES);
        //[UITipView showTipStr:respondObject.message];
    }];
}

///商城首页-获取某个分类标签下的商品列表
+ (void)getGoodsListForChannel:(CStoreChannelGoodsListModel *)model channelId:(NSInteger)channelId cateType:(NSInteger)cateType block:(HTTPCompleteBlock)block {
    NSLog(@"商城首页-获取某个分类标签下的商品列表");
    model.isLoading = YES;
    model.isFirstReq = NO;
    
    NSString *url = [model toUrlWithChannelId:channelId cateType:cateType];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        NSArray *dataList = [NSArray modelArrayWithClass:[CStoreHomeGoodsData class] json:respondObject.data];
        if (dataList.count > 0) {
            CStoreChannelGoodsListModel *aModel = [[CStoreChannelGoodsListModel alloc] init];
            aModel.list = dataList.mutableCopy;
            block(aModel, NO);
        } else {
            block(nil, NO);
        }
        model.page += 1;        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        block(nil, YES);
        //[UITipView showTipStr:respondObject.message];
    }];
}


+ (void)getGoodsDetailWithGoodsId:(NSString *)goodsId pageFrom:(NSString *)pageFrom block:(HTTPCompleteBlock)block {
    NSLog(@"获取商品详情");
    //GET：http://39.97.164.118:8080/v1/shop/goods_info?goods_id=1
    
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v2/shop/goods_info?goods_id=%@&from=%@"), goodsId, pageFrom];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        
        CGoodsDetailModel *model = [CGoodsDetailModel modelWithJSON:respondObject.data];
        block(model, NO);
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

+ (void)getOrderIdWithGoodsId:(NSString *)goodsId block:(HTTPCompleteBlock)block {
    NSString *urlStr = COMMUNITY_FILE_BASE_STRING(@"/v1/shop/order");
    NSDictionary *params = @{@"goods_id" : goodsId};
    [HttpRequestTool postWithURL:urlStr Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        block(respondObject, NO);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

///我的收藏列表 商品----新的
+ (void)getNewMyCollectionListBlock:(succeedBlock)block {
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/followList") Parameters:nil
    requestSerializerType:RequestSerializerTypeHttp
    successBlock:^(RequestModel * _Nullable respondObject) {
        
        block(respondObject);
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        block(respondObject);
        [UITipView showTipStr:respondObject.message];
    }];
}
///我的收藏列表
+ (void)getMyCollectionList:(CStoreCollectionModel *)model block:(HTTPCompleteBlock)block {
    NSLog(@"获取我的收藏");
    if (model.isLoading) {return;}
    model.isLoading = YES;
    model.isFirstReq = NO;
    
    [HttpRequestTool getWithURL:[model toUrl] Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        NSArray *dataList = [NSArray modelArrayWithClass:[CStoreCollectionData class] json:respondObject.data];
        if (!dataList) {
            dataList = [NSArray new];
        }
        CStoreCollectionModel *aModel = [[CStoreCollectionModel alloc] init];
        aModel.list = dataList.mutableCopy;
        block(aModel, NO);
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

///收藏商品
+ (void)collectionWithGoodsId:(NSString *)goodsId block:(HTTPCompleteBlock)block {
    NSString *urlStr = COMMUNITY_FILE_BASE_STRING(@"/v1/shop/collection");
    NSDictionary *params = @{@"goods_id" : goodsId};
    [HttpRequestTool postWithURL:urlStr Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        block(respondObject, NO);
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

///取消收藏商品
+ (void)cancelCollectionWithGoodsId:(NSString *)goodsId block:(HTTPCompleteBlock)block {
    NSString *urlStr = COMMUNITY_FILE_BASE_STRING(@"/v1/shop/cancel_collection");
    NSDictionary *params = @{@"goods_id" : goodsId};
    [HttpRequestTool postWithURL:urlStr Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        block(respondObject, NO);
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

///商城热搜关键词
+ (void)getHotKeywords:(HTTPCompleteBlock)completeBlock {
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/shop/hot_words");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        NSArray * hotHeys = [JHHotWordModel mj_objectArrayWithKeyValuesArray:respondObject.data].copy;
        completeBlock(hotHeys, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        NSLog(@"请求失败");
        completeBlock(nil, YES);
        //[UITipView showTipStr:respondObject.message];
    }];
}

+ (void)getSearchResult:(CStoreCollectionModel *)model Keyword:(NSString *)keyword searchKey:(NSString *)searchKey sortType:(NSInteger)sortType  block:(HTTPCompleteBlock)block {
    if (model.isLoading) {return;}
    model.isLoading = YES;
    model.isFirstReq = NO;
    NSString * url = [model toSearchUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:keyword forKey:@"q"];
    NSString *searchWord = ![searchKey isEmpty] ? searchKey : @"";
    [params setValue:searchWord forKey:@"q_key"];
    [params setValue:@(model.page) forKey:@"page"];
    [params setValue:@(sortType) forKey:@"sort"];
    
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        model.isLoading = NO;
        NSArray *dataList = [NSArray modelArrayWithClass:[CStoreCollectionData class] json:respondObject.data];
        if (!dataList) {
            dataList = [NSArray new];
        }
        CStoreCollectionModel *aModel = [[CStoreCollectionModel alloc] init];
        aModel.list = dataList.mutableCopy;
        block(aModel, NO);
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

+ (void)getSeckillCateList:(JHApiRequestHandler)completion{
    
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/shop/seckill_info");
    [HttpRequestTool getWithURL:url Parameters:nil  successBlock:^(RequestModel * _Nullable respondObject) {
        
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
           
       } failureBlock:^(RequestModel * _Nullable respondObject) {
           NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                code:respondObject.code
                                            userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
           if (completion) {
               completion(respondObject,error);
           }
       }];
}
+ (void)getSeckillList:(JHSecKillReqMode*)reqMode completion:(JHApiRequestHandler)completion{
    
  NSString *url=[NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v1/shop/seckill_list?ses_id=%@&page=%ld"),reqMode.sec_id,reqMode.page];
    [HttpRequestTool getWithURL:url Parameters:nil  successBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
    
}
+ (void)goodRemind:(NSString*)ses_id GoodId:(NSString*)goods_id completion:(JHApiRequestHandler)completion{
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/v1/shop/seckill_remind") Parameters:@{@"ses_id":ses_id,@"goods_id":goods_id} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
    
}
+ (void)goodCancelRemind:(NSString*)ses_id GoodId:(NSString*)goods_id completion:(JHApiRequestHandler)completion{
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/v1/shop/seckill_cancel_remind") Parameters:@{@"ses_id":ses_id,@"goods_id":goods_id} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
}

+ (void)getRecommendListWithParams:(NSDictionary *)params block:(HTTPCompleteBlock)block {
    ///1订单列表 2订单详情 3个人中心 4商品详情
    
    
    [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/v1/shop/product_recommend") Parameters:params successBlock:^(RequestModel *respondObject) {

        if (block) {
            block(respondObject, NO);
        }

    } failureBlock:^(RequestModel *respondObject) {
        NSLog(@"请求失败");
        if (block) {
            block(respondObject, YES);
        }
    }];
}

+ (void)getCommentListWithSellerId:(NSInteger)sellerId completeBlock:(HTTPCompleteBlock)completeBlock {
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/orderComment/list?sellerCustomerId=%ld"), (long)sellerId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        if (completeBlock) {
            completeBlock(respondObject, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (completeBlock) {
            completeBlock(respondObject, YES);
        }
    }];
}


+ (void)getShowcaseWithId:(NSInteger)showcaseId pageNumber:(NSInteger)pageNumber latId:(NSInteger)lastId completeBlock:(HTTPCompleteBlock)completeBlock {
    
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v1/shop/showcase?sc_id=%ld&last_id=%ld&page=%ld"), (long)showcaseId, (long)lastId, (long)pageNumber];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        if (completeBlock) {
            completeBlock(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSLog(@"请求失败");
        if (completeBlock) {
            completeBlock(respondObject, NO);
        }
    }];
}

#pragma mark - 3.1.7专题(橱窗)页改版
///获取专题信息
+ (void)getWindowInfo:(JHShopWindowModel *)model block:(HTTPCompleteBlock)block {
    NSLog(@"获取专题信息");
    if (model.isLoading) {return;}
    model.isLoading = YES;
    model.isFirstReq = NO;
    
    [HttpRequestTool getWithURL:[model toUrl] Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        //NSArray *dataList = [NSArray modelArrayWithClass:[CStoreHomeListData class] json:respondObject.data];
        JHShopWindowModel *aModel = [JHShopWindowModel modelWithJSON:respondObject.data];
        block(aModel, NO);

    } failureBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

///获取专题页导航标签下的商品列表
+ (void)getWindowList:(JHShopWindowListModel *)model block:(HTTPCompleteBlock)block {
    NSLog(@"获取专题信息");
    if (model.isLoading) {return;}
    model.isLoading = YES;
    model.isFirstReq = NO;
    
    [HttpRequestTool getWithURL:[model toUrl] Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        //NSArray *dataList = [NSArray modelArrayWithClass:[JHGoodsInfoMode class] json:respondObject.data];
        JHShopWindowListModel *aModel = [JHShopWindowListModel modelWithJSON:respondObject.data];
//        if (!dataList) {
//            dataList = [NSArray new];
//        }
//        JHShopWindowListModel *aModel = [[JHShopWindowListModel alloc] init];
//        aModel.goodsList = dataList.mutableCopy;
        block(aModel, NO);

    } failureBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}
+(void)getNewUserRedpacketWithCompleteBlock:(HTTPCompleteBlock)block
{
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/redPacket/newUserRedPacketImg/v2") Parameters:nil successBlock:^(RequestModel *respondObject) {
        if (block) {
            if (respondObject && respondObject.data) {
                JHStoreNewRedpacketModel *model = [JHStoreNewRedpacketModel modelWithJSON:respondObject.data];
                block(model, NO);

            }
        }

    } failureBlock:^(RequestModel *respondObject) {
        NSLog(@"请求失败");
        [UITipView showTipStr:respondObject.message];
        if (block) {
            block(respondObject, YES);
        }
    }];
}

@end
