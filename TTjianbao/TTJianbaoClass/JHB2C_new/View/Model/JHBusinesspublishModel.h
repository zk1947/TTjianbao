//
//  JHBusinesspublishModel.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHIssueGoodsEditModel.h"
#import "JHBusinessGoodsAttributeModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHB2CPublishGoodsType) {
    JHB2CPublishGoodsType_BuyNow = 0,///一口价
    JHB2CPublishGoodsType_Auction,///拍卖
    
};
@interface JHBusinesspublishImageModel : NSObject
@property(nonatomic, copy) NSString * type;
@property(nonatomic, copy) NSString * path;
@property(nonatomic, copy) NSString * width;
@property(nonatomic, copy) NSString * middleUrl;
@property(nonatomic, copy) NSString * url;
@property(nonatomic, copy) NSString * height;
@property(nonatomic, copy) NSString * detailVideoCoverUrl;
@end
@interface JHBusinesspublishModel : NSObject
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *productName;//商品名称【必须】",
@property (nonatomic, copy) NSString *productDesc;
@property (nonatomic, copy) NSString *firstCategoryId;
@property (nonatomic, copy) NSString *secondCategoryId;
@property (nonatomic, copy) NSString *thirdCategoryId;
@property (nonatomic, assign) NSInteger firstCategoryselect;
@property (nonatomic, assign) NSInteger secondCategoryselect;
@property (nonatomic, assign) NSInteger thirdCategoryselect;
@property (nonatomic, strong) NSMutableArray *attrs;

@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, strong) NSString *mainImageUrl;//主图地址 多个逗号分隔【必须】",
@property (nonatomic, strong) NSString *detailImageUrl;//详情介绍图片地址 多个逗号分隔【必须】

@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *procurePrice;

@property (nonatomic, assign) int stock;//库存【必须】",
@property (nonatomic, assign) int sellStock;//回显库存
@property (nonatomic, assign) int productStatus;//0-上架（立即上架） 1-下架（下架待售）  2违规禁售  3预告中(指定时间上架)  4已售出  5流拍  6交易取消 （3，5，6是拍卖商品特有的状态）【必须】",

@property (nonatomic, assign) int uniqueStatus; //孤品状态 0-非孤品 1-孤品【必须】",
@property (nonatomic, strong) NSString *startPrice;//起拍价",
@property (nonatomic, strong) NSString *bidIncrement;//加价幅度",
@property (nonatomic, strong) NSString *earnestMoney;//保证金",

@property (nonatomic, assign) int productType;//商品类型 0一口价  1拍卖"

@property (nonatomic, copy) NSString *auctionStartTime;//拍卖开始时间",
@property (nonatomic, copy) NSString *auctionEndTime;//拍卖结束时间",
@property (nonatomic, copy) NSString *auctionLastTime;//拍卖持续时间"

@property (nonatomic, strong)JHIssueGoodsEditImageItemModel *coverImage;//视频封面图
@property (nonatomic, strong)JHIssueGoodsEditImageItemModel *videoDetail;//视频详情
@property (nonatomic, strong) NSMutableArray *detailImages; //回显详情图
@property (nonatomic, strong) NSMutableArray *mainImages; //回显主图
@property (nonatomic, copy) NSString *firstCategoryName;
@property (nonatomic, copy) NSString *secondCategoryName;
@property (nonatomic, copy) NSString *thirdCategoryName;
@end

NS_ASSUME_NONNULL_END
