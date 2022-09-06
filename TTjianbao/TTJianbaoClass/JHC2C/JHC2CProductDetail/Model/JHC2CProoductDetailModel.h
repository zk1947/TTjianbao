//
//  JHC2CProoductDetailModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CProoductDetailProductExt : NSObject

/// C2C一口价商品入手价
@property(nonatomic, copy) NSString * originPrice;

/// 审核状态 0系统审核中  1系统审核通过  2系统审核不通过
@property(nonatomic, copy) NSString * auditStatus;

/// 拒绝（审核不通过）原因
@property(nonatomic, copy) NSString * refuseReason;

@property(nonatomic, copy) NSString * provinceCode;

@property(nonatomic, copy) NSString * provinceName;

@property(nonatomic, copy) NSString * cityCode;

@property(nonatomic, copy) NSString * cityName;

@property(nonatomic, copy) NSString * areaCode;

@property(nonatomic, copy) NSString * areaName;

/// 浏览次数
@property(nonatomic, copy) NSString * viewCount;

/// 想要人数
@property(nonatomic, copy) NSString * wantCount;

@end

@interface JHC2CProoductDetailAuctionFlow : NSObject
/// 起拍价（单位分）
@property(nonatomic, copy) NSString * startPrice;

/// 加价幅度（单位分）
@property(nonatomic, copy) NSString * bidIncrement;

/// 保证金（单位分）
@property(nonatomic, copy) NSString * earnestMoney;

/// 拍卖开始时间
@property(nonatomic, copy) NSString * auctionStartTime;

@property(nonatomic, copy) NSString * auctionEndTime;

/// 拍卖流水号
@property(nonatomic, copy) NSString * auctionSn;

/// 拍卖状态（0 待拍 1竞拍中 2 已结束）
@property(nonatomic, copy) NSString * auctionStatus;

/// 最高价
@property(nonatomic, copy) NSString * maxBuyerPrice;


/// 1:下架      以下状态都表示为上架 因为是基于上架状态使用的      10:待拍 11:已预约拍卖      20:开拍该用户无动作 21：领先 22：出局      30:表示拍卖结束 无出价 31:拍卖结束有中拍 32:中拍待支付 33 中拍支付中 （根据这两个值区分提单页面还是支付页面）35:支付完成",
@property(nonatomic) NSInteger  productDetailStatus;


@end

@interface JHC2CProoductDetailImageModel : NSObject

@property(nonatomic, copy) NSString * width;
@property(nonatomic, copy) NSString * height;
@property(nonatomic, copy) NSString * url;
@property(nonatomic, copy) NSString * middleUrl;
@property(nonatomic, copy) NSString * detailVideoCoverUrl;



/// 是否是视频   NO 是图片 ，YES 视频
@property(nonatomic) BOOL type;

@end


///声音信息类
@interface JHC2CVoiceContentVOS : NSObject
/// 声音时长
@property(nonatomic, copy) NSString * audioDuration;
/// 声音rul
@property(nonatomic, copy) NSString * voiceContentUrl;

@end


///鉴定结果类
@interface JHC2CAppraisalResult : NSObject

/// 鉴定完成时间
@property(nonatomic, copy) NSString * appraisalCompletedTime;

/// 鉴定师id
@property(nonatomic, copy) NSString * appraisalPersonId;

/// 鉴定师昵称
@property(nonatomic, copy) NSString * appraisalPersonName;

/// 鉴定师头像
@property(nonatomic, copy) NSString * appraisalPersonImg;

/// 鉴定结果 真 仿品 存疑 现代工艺品
@property(nonatomic, copy) NSString * appraisalResult;

/// 鉴定结果类型 0 真 1 仿品 2 存疑 3 现代工艺品
@property(nonatomic, copy) NSString * appraisalResultType;

/// 鉴定描述
@property(nonatomic, copy) NSString * remark;

/// 鉴定语音  audioDuration  voiceContentUrl
@property(nonatomic, strong) NSArray<JHC2CVoiceContentVOS*> * voiceContentVOS;

@end




@interface JHC2CCurrentCustomerAuction : NSObject

@property(nonatomic, copy) NSString * isAgent;
@property(nonatomic, copy) NSString * expectedPrice;
//拍卖状态（0无状态 1 失效 2出局 3领先 4中拍 ）
@property(nonatomic, copy) NSString * auctionStatus;
//@property(nonatomic, copy) NSString * middleUrl;

@end


@interface JHC2CProoductDetailModel : NSObject

/// 商品id
@property(nonatomic, copy) NSString * productId;

/// 商品名称
@property(nonatomic, copy) NSString * productName;

/// 商品描述
@property(nonatomic, copy) NSString * productDesc;

/// 视频地址
@property(nonatomic, copy) NSString * videoUrl;

/// 孤品状态 0-非孤品 1-孤品
@property(nonatomic, copy) NSString * uniqueStatus;

/// 后台一级分类id
@property(nonatomic, copy) NSString * firstCategoryId;

/// 后台二级分类id
@property(nonatomic, copy) NSString * secondCategoryId;

/// 后台三级分类id
@property(nonatomic, copy) NSString * thirdCategoryId;

/// 0-上架 1-下架 2违规禁售  3预告中  4已售出  5流拍  6交易取消
@property(nonatomic, copy) NSString * productStatus;

/// 店铺id
@property(nonatomic, copy) NSString * shopId;

/// 售价 单位为分
@property(nonatomic, copy) NSString * price;
/// C2C一口价商品入手价
@property(nonatomic, copy) NSString * originPrice;
/// 可售库存
@property(nonatomic, copy) NSString * sellStock;

/// 商品类型 0一口价  1拍卖
@property(nonatomic, copy) NSString * productType;

/// 是否需要运费 0否  1是
@property(nonatomic, copy) NSString * needFreight;

/// 运费（单位分)
@property(nonatomic, copy) NSString * freight;

/// 商品sn
@property(nonatomic, copy) NSString * productSn;

/// 是否关注
@property(nonatomic, assign) BOOL followStatus;

/// 鉴定数据
@property(nonatomic, strong) JHC2CAppraisalResult * appraisalResult;

/// 封面地址
@property(nonatomic, strong) JHC2CProoductDetailImageModel * coverImage;

/// 主图地址
@property(nonatomic, strong)  NSArray <JHC2CProoductDetailImageModel*> * mainImages;

/// 详情介绍图片地址
@property(nonatomic, strong)  NSArray <JHC2CProoductDetailImageModel*> * detailImages;


/// 详情介绍图片地址
@property(nonatomic, strong)  NSArray <JHC2CProoductDetailImageModel*> * allImages;



/// 商品属性
@property(nonatomic, strong)  NSArray * productAttrList;

/// 商品扩展信息
@property(nonatomic, strong)  JHC2CProoductDetailProductExt * productExt;

/// 拍卖商品信息
@property(nonatomic, strong)  JHC2CProoductDetailAuctionFlow * auctionFlow;


/// 分享信息 title img url desc
@property(nonatomic, strong)  NSDictionary * shareInfo;


/// 用户信息 isFaceAuth id img  name
@property(nonatomic, strong)  NSDictionary * seller;


/// 当前用户拍卖信息  isAgent    expectedPrice   auctionStatus
@property(nonatomic, strong)  JHC2CCurrentCustomerAuction * currentCustomerAuction;


/// 商品是否支持鉴定
@property(nonatomic) BOOL supportAuth;

@end

NS_ASSUME_NONNULL_END
