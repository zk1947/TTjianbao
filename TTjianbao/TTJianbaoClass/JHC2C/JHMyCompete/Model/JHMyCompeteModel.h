//
//  JHMyCompeteModel.h
//  TTjianbao
//
//  Created by miao on 2021/6/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHMyCompeteImageInfoModel;
@class JHMyCompeteWantToModel;

typedef NS_ENUM(NSInteger, JHC2CMyCompeteAuctionStatus){
    JHC2CMyCompeteAuctionStatus_Stateless = 0,///无状态
    JHC2CMyCompeteAuctionStatus_Failure,///失效
    JHC2CMyCompeteAuctionStatus_Out,///出局
    JHC2CMyCompeteAuctionStatus_Leading,///领先
    JHC2CMyCompeteAuctionStatus_InThePat,///中拍
    JHC2CMyCompeteAuctionStatus_HasEnded,///已结束
    JHC2CMyCompeteAuctionStatus_XiaJia,///下架
} ;

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCompeteModel : NSObject

///  商品id
@property (nonatomic, assign) long productId;
///  单刷参数
@property (nonatomic, copy) NSString *auctionSn;
/// 视频地址
@property (nonatomic, copy) NSString *videoUrl;
/// 拍卖中标签
@property (nonatomic, copy) NSString *auction;
/// 商品名称
@property (nonatomic, copy) NSString *productDesc;
/// 处理后的商品名称
@property (nonatomic, copy) NSMutableAttributedString *attriProductDesc;
@property (nonatomic, copy) NSString *payExpireTime;
/// 商品标签列表
@property (nonatomic, strong) NSArray<NSString *> *labels;

@property (nonatomic, strong) NSArray<NSString *> *productTagList;

/// 是否需要运费 0否  1是
@property(nonatomic, assign) NSInteger needFreight;
/// 是否即将截止拍卖 1 即将截拍
@property(nonatomic, assign) NSInteger auctionEndStatus;

/// 商品售卖状态 0无状态 1 失效 2出局 3领先 4中拍 5:已结束 6:已下架
@property (nonatomic, assign) NSInteger auctionStatus;
///  枚举类型商品售卖状态
@property (nonatomic, assign) JHC2CMyCompeteAuctionStatus auctionStatusType;
///商品售卖状态View是否隐藏
@property (nonatomic, assign) BOOL auctionStatusViewHidden;
///商品售卖状态 文字颜色
@property (nonatomic, copy) NSAttributedString *auctionStatusText;

///商品售卖状态 背景色
@property (nonatomic, copy) UIColor *auctionStatusBackgroundColor;

/// 瀑布流图片
@property (nonatomic, strong) JHMyCompeteImageInfoModel *coverImage;
/// 商品售价
@property (nonatomic, copy) NSString *price;
/// 出价次数
@property (nonatomic, assign) NSInteger priceNumber;
/// 展示出价多少次
@property (nonatomic, copy) NSString *showPriceNumber;
/// 立即付款是否显示
@property (nonatomic, assign) BOOL immediatePaymentHidden;

/// 底部想要
@property (nonatomic, strong) JHMyCompeteWantToModel *wantToModel;
/// 用户头像
@property (nonatomic, copy) NSString *userImg;
/// 用户昵称
@property (nonatomic, copy) NSString *userName;
/// 想要人数
@property (nonatomic, assign) NSInteger wantCount;

/// 距拍卖结束时间
@property (nonatomic, copy) NSString *auctionDeadline;
/// 距订单支付结束时间
@property (nonatomic, copy) NSString *orderDeadline;

///  鉴定结果类型 0 真 1 仿品 2 存疑 3 现代工艺品 999:异常
@property (nonatomic, assign) NSInteger appraisalResult;
/// 鉴定结果的图片
@property (nonatomic, copy) NSString *appraisalPictureName;
/// 拍卖状态（0 待拍 1竞拍中 2 已结束）
@property (nonatomic, assign) NSInteger productAuctionStatus;
/// cell的高度
@property (nonatomic, assign) CGFloat itemHeight;
/// 商品描述的高度
@property (nonatomic, assign) CGFloat descHeight;

///价格处是否一行显示
@property (nonatomic, assign) BOOL isOnelineOfMoney;
/// 订单状态  1 待确认 2 待付款 3 支付中 4 待发货 5 已预约 6 待收货 7 已完成 8 退货退款中 9 已退款 10 已关闭 11 待鉴定 12 已鉴定
@property (nonatomic, assign) NSUInteger orderStatus;
///订单ID
@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, assign) NSUInteger sellerType;

@end


@interface JHMyCompeteImageInfoModel  : NSObject
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic,   copy) NSString *url;
@property (nonatomic, assign) CGFloat   aNewHeight;
@end

@interface JHMyCompeteWantToModel : NSObject
/// 用户头像
@property (nonatomic, copy) NSString *userImg;
/// 用户昵称
@property (nonatomic, copy) NSString *userName;
/// 想要人数
@property (nonatomic, copy) NSString *wantCountStr;

///用户信息处是否一行显示
@property (nonatomic, assign) BOOL isOnelineOfUserInfo;

@end

NS_ASSUME_NONNULL_END
