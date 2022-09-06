//
//  JHMarketPublishModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface JHMarketPublishCoverModel : NSObject
/** 中图*/
@property(nonatomic, copy) NSString *middleUrl;
/** 大图*/
@property(nonatomic, copy) NSString *url;
@end

@interface JHMarketProductExtModel : NSObject
/** 浏览人数*/
@property(nonatomic, copy) NSString *viewCount;
/** 想要人数*/
@property(nonatomic, copy) NSString *wantCount;
@end

@interface JHMarketPublishAuctionModel : NSObject
/** 拍卖状态*/
@property(nonatomic, assign) NSInteger auctionStatus;
@end

@interface JHMarketPublishModel : NSObject
/** 商品id*/
@property(nonatomic, copy) NSString *productId;
/** 商品名称*/
@property(nonatomic, copy) NSString *productName;
/** 商品描述*/
@property(nonatomic, copy) NSString *productDesc;
/** 商品编号*/
@property(nonatomic, copy) NSString *productSn;
/** coverImage*/
@property(nonatomic, strong) JHMarketPublishCoverModel *coverImage;
/** 商品状态 0-上架 1-下架 2违规禁售 3预告中 4已售出 5流拍 6交易取消 （3，5，6是拍卖商品特有的状态）*/
@property(nonatomic, assign) NSInteger productStatus;
/** 售价 单位*/
@property(nonatomic, copy) NSString *price;
/** 可售库存*/
@property(nonatomic, copy) NSString *sellStock;
/** 鉴定报告结果类型 0 真 1 仿品 2 存疑 3 现代工艺品 4 鉴定中 5 未鉴定（没有人买鉴定服务） 6 未鉴定（买家买了鉴定服务）*/
@property(nonatomic, assign) NSInteger authResult;
/** 商品类型 0一口价 1拍卖*/
@property(nonatomic, assign) NSInteger productType;
/** 拍卖开始时间*/
@property(nonatomic, copy) NSString *auctionStartTime;
/** 拍卖结束时间*/
@property(nonatomic, copy) NSString *auctionEndTime;
/** 起拍价*/
@property(nonatomic, copy) NSString *startPrice;
/** 加价幅度*/
@property(nonatomic, copy) NSString *bidIncrement;
/** 保证金*/
@property(nonatomic, copy) NSString *earnestMoney;
/** 当前价*/
@property(nonatomic, copy) NSString *currentPrice;
/** 已出价次数*/
@property(nonatomic, copy) NSString *num;
/** 查看鉴定报告是否显示（0否1是）*/
@property (nonatomic, assign) BOOL viewReportFlag;
/** 按钮是否可编辑（0否1是）*/
@property (nonatomic, assign) BOOL updateFlag;
/** 上架商品按钮是否显示（0否1是）*/
@property (nonatomic, assign) BOOL upProductFlag;
/** 下架商品按钮是否显示（0否1是）*/
@property (nonatomic, assign) BOOL downProductFlag;
/** 调价按钮是否显示（0否1是）*/
@property (nonatomic, assign) BOOL modifyPriceFlag;
/** 去鉴定按钮是否显示（0否1是）*/
@property (nonatomic, assign) BOOL goAppraisalFlag;
/** 删除按钮是否显示（0否1是）*/
@property (nonatomic, assign) BOOL deleteFlag;
/** productExt*/
@property (nonatomic, strong) JHMarketProductExtModel *productExt;
/** auctionFlow*/
@property (nonatomic, strong) JHMarketPublishAuctionModel *auctionFlow;
/** 距离拍卖开始时间差*/
@property (nonatomic, assign) NSInteger auctionStartRemainTime;
/** 距离拍卖结束时间差*/
@property (nonatomic, assign) NSInteger auctionRemainTime;
/** 距离拍卖开始时间戳*/
@property (nonatomic, copy) NSString *auctionStartTimeMillis;
/** 距离拍卖结束时间戳*/
@property (nonatomic, copy) NSString *auctionEndTimeMillis;
/** 倒计时时间*/
@property (nonatomic, assign) NSInteger timeDuring;
/// 违规描述
@property (nonatomic, copy) NSString *forbidSellReason;
@end

NS_ASSUME_NONNULL_END
