//
//  JHGoodManagerListModel.h
//  TTjianbao
//
//  Created by user on 2021/8/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHGoodManagerNormalModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 请求体
@interface JHGoodManagerListRequestModel : NSObject
/// 商品类型 0 一口价 1 拍卖 2 全部
@property (nonatomic, assign) JHGoodManagerListRequestProductType    productType;
/// 商品状态   0上架   1下架   2违规禁售   3预告中  4已售出  5流拍  6交易取消
//@property (nonatomic, assign) JHGoodManagerListRequestProductStatus  productStatus;
@property (nonatomic,   copy) NSString  *__nullable productStatus;
/// 商品名称/分类名称
@property (nonatomic,   copy) NSString  *searchName;
/// 最低价
@property (nonatomic,   copy) NSString  *minPrice;
/// 最高价
@property (nonatomic,   copy) NSString  *maxPrice;
/// 发布开始时间
@property (nonatomic,   copy) NSString  *publishStartTime;
/// 发布结束时间
@property (nonatomic,   copy) NSString  *publishEndTime;
/// 分类一级id
@property (nonatomic,   copy) NSString  *firstCategoryId;
/// 分类二级id
@property (nonatomic,   copy) NSString  *secondCategoryId;
/// 分类三级id
@property (nonatomic,   copy) NSString  *thirdCategoryId;
/// 页码【必须】
@property (nonatomic, assign) NSInteger  pageNo;
/// 页数【必须】
@property (nonatomic, assign) NSInteger  pageSize;
/// \"s,m,b,o\" 分别对应返回small,medium,big,origin; \"s,m,b\" 分别对应返回small,medium,big; \"s,m\" 分别对应返回small,medium; \"s\" 对应返回small;【必须】
@property (nonatomic,   copy) NSString  *imageType;
@property (nonatomic,   copy) NSString  *__nullable lastId;
@end


@class JHGoodManagerListTabChooseModel;
@class JHGoodManagerListRecordModel;
@interface JHGoodManagerListAllDataModel : NSObject
@property (nonatomic, strong) NSArray <JHGoodManagerListTabChooseModel *> *statistics;
@property (nonatomic, strong) JHGoodManagerListRecordModel *record;
@end



@class JHGoodManagerListModel;
@interface JHGoodManagerListRecordModel : NSObject
@property (nonatomic, strong) NSArray <JHGoodManagerListModel *> *lists;
/// 最后一个id
@property (nonatomic,   copy) NSString  *lastId;
@end






/// 商品tab
@interface JHGoodManagerListTabChooseModel : NSObject
/// 商品状态   0上架   1下架   2违规禁售   3预告中  4已售出  5流拍  6交易取消
@property (nonatomic, assign) JHGoodManagerListRequestProductStatus productStatus;
/// 商品状态名称
@property (nonatomic,   copy) NSString  *name;
/// 数量
@property (nonatomic,   copy) NSString  *num;
/// 是否选中
@property (nonatomic, assign) BOOL  isSelected;

@end


/// 商品列表
@class JHGoodManagerListImageModel;
@interface JHGoodManagerListModel : NSObject
/// 商品id
@property (nonatomic,   copy) NSString *goodId;
/// 商品编码
@property (nonatomic,   copy) NSString *productSn;
/// 商品名称
@property (nonatomic,   copy) NSString *productName;
/// 商品类型 0一口价 1拍卖
@property (nonatomic, assign) JHGoodManagerListRequestProductType productType;
/// 商品主图
@property (nonatomic, strong) NSArray <JHGoodManagerListImageModel *> *mainImageUrls;
/// 库存
@property (nonatomic, assign) NSInteger sellStock;
/// 售价 单位为分
@property (nonatomic,   copy) NSString *price;
/// 售价 单位为元
@property (nonatomic,   copy) NSString *priceYuan;
/// 发布时间
@property (nonatomic,   copy) NSString *createTime;
/// 商品状态   0上架   1下架   2违规禁售   3预告中  4已售出  5流拍  6交易取消
@property (nonatomic, assign) JHGoodManagerListRequestProductStatus productStatus;
@property (nonatomic,   copy) NSString *productStatusStr;
/// 禁售原因
@property (nonatomic,   copy) NSString *forbidSellReason;
/// 拒绝原因
@property (nonatomic,   copy) NSString *refuseReason;
/// 孤品状态 0非孤品 1孤品
@property (nonatomic, assign) JHGoodManagerListGoodUniqueStatus uniqueStatus;
/// 审核状态 0系统审核中 1系统审核通过 2系统审核不通过
@property (nonatomic, assign) JHGoodManagerListAuditStatus auditStatus;
/// 拍卖流水号
@property (nonatomic,   copy) NSString *auctionSn;
/// 起拍价 单位为分
@property (nonatomic, assign) long startPrice;
/// 起拍价 单位为元
@property (nonatomic,   copy) NSString *startPriceYuan;

/// 加价幅度 单位为分
@property (nonatomic, assign) long bidIncrement;
/// 价加价幅度 单位为元
@property (nonatomic,   copy) NSString *bidIncrementYuan;
/// 保证金 单位为分
@property (nonatomic, assign) long earnestMoney;
/// 保证金 单位为元
@property (nonatomic,   copy) NSString *earnestMoneyYuan;


/// 拍卖剩余开始时间/拍卖结束剩余时间 毫秒值
@property (nonatomic, assign) long countdownTimeMillis;
/// 拍卖开始时间
@property (nonatomic,   copy) NSString *auctionStartTime;
/// 拍卖结束时间 毫秒值
@property (nonatomic, assign) long auctionEndTimeMillis;
/// 拍卖结束时间
@property (nonatomic,   copy) NSString *auctionEndTime;



/// 拍卖是否出价 0未出价 1已出价
@property (nonatomic, assign) NSInteger auctionPriceStatus;
/// 拍卖是否交保证金 0否 1是
@property (nonatomic, assign) NSInteger earnestMoneyStatus;
/// 编辑按钮是否显示 0否 1是
@property (nonatomic, assign) NSInteger updateFlag;
/// 下架按钮是否显示 0否 1是
@property (nonatomic, assign) NSInteger downProductFlag;
/// 查看竞价记录按钮是否显示 0否 1是
@property (nonatomic, assign) NSInteger viewAuctionRecordFlag;
/// 删除按钮是否显示 0否 1是
@property (nonatomic, assign) NSInteger deleteFlag;
/// 上架按钮是否显示 0否 1是
@property (nonatomic, assign) NSInteger upProductFlag;
@end




@interface JHGoodManagerListImageModel : NSObject
/// 原图
@property (nonatomic, copy) NSString *origin;
/// 缩略图
@property (nonatomic, copy) NSString *small;
/// 小图
@property (nonatomic, copy) NSString *medium;
/// 大图
@property (nonatomic, copy) NSString *big;
/// 宽
@property (nonatomic, copy) NSString *w;
/// 高
@property (nonatomic, copy) NSString *h;
@end



/// 上架
@interface JHGoodManagerListItemPutOnRequestModel : NSObject
/// 商品id【必须】
@property (nonatomic,   copy) NSString *productId;
/// 商品类型 0 一口价 1 拍卖
@property (nonatomic, assign) JHGoodManagerListRequestProductType productType;
/// 商品状态 0 立即上架(上架) 3 指定时间上架（预告中） ##拍卖商品不能为空",
@property (nonatomic, assign) NSInteger productStatus;
/// 起拍价    ##拍卖商品不能为空
@property (nonatomic,   copy) NSString *startPrice;
/// 加价幅度  ##拍卖商品不能为空
@property (nonatomic,   copy) NSString *bidIncrement;
/// 保证金    ##拍卖商品不能为空
@property (nonatomic,   copy) NSString *__nullable earnestMoney;
/// 拍卖开始时间
@property (nonatomic,   copy) NSString *auctionStartTime;
/// 拍卖持续时间
@property (nonatomic,   copy) NSString *auctionLastTime;
@end

NS_ASSUME_NONNULL_END
