//
//  JHNewSearchResultsModel.h
//  TTjianbao
//
//  Created by hao on 2021/8/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHNewStoreHomeModel.h"
#import "JHLiveRoomMode.h"

NS_ASSUME_NONNULL_BEGIN
@interface JHNewSearchResultPositionTargetModel : NSObject
@property (nonatomic,   copy)NSString *componentName;
@property (nonatomic,   copy)NSString *vc;//专题专区点击返回
@property (nonatomic, strong)NSMutableDictionary *params;
@end

@interface JHNewSearchResultOperationListModel : NSObject
///运营位栏位id
@property (nonatomic,   copy) NSString *detailsId;
///图片素材地址
@property (nonatomic,   copy) NSString *imageUrl;
///落地页类型名称
@property (nonatomic,   copy) NSString *targetName;
///落地页目标
@property (nonatomic,   copy) NSString *landingTarget;
///落地页关联参数
@property (nonatomic,   copy) NSString *landingId;
///落地页解析
@property (nonatomic, strong) JHNewSearchResultPositionTargetModel *target;
@end


@interface JHNewSearchResultsModel : NSObject
///搜索是否有数据： 0：否 1：是
@property (nonatomic,   copy) NSString *isMallProduct;
//服务端去重生，成当前页最后一条记录的信息
@property (nonatomic, strong) NSString* cursor;
///商品列表
@property (nonatomic,   copy) NSArray<JHNewStoreHomeGoodsProductListModel *> *productList;
///直播间列表
@property (nonatomic,   copy) NSArray<JHLiveRoomMode *> *liveList;
///运营位列表
@property (nonatomic,   copy) NSArray<JHNewSearchResultOperationListModel *> *operationPositionList;
@end

NS_ASSUME_NONNULL_END
