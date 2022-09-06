//
//  JHSectionModel.h
//  TTjianbao
//
//  Created by lihui on 2020/4/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHMySectionType) {
    
    ///个人信息
    JHMySectionTypeHeader = 0,
    
    ///店铺入口
    JHMySectionTypeShop,
    
    ///订单
    JHMySectionTypeOrder,
    
    ///轮播图
    JHMySectionTypeCycle,
    
    ///原始回血
    JHMySectionTypeResale,
    
    ///钱包
    JHMySectionTypeWallet,
    
    ///工具
    JHMySectionTypeTools,
    
    ///为您推荐
    JHMySectionTypeRecommend,
    
    ///定制服务
    JHMySectionTypeCustomize,
    
    ///创作中心
    JHMySectionTypeCommunity,
};

typedef NS_ENUM(NSInteger, JHMyCenterRedPointType) {
    ///无
    JHMyCenterRedPointNOne = 0,
    /// 待付款
    JHMyCenterRedPointWillPay,      
    /// 待鉴定
    JHMyCenterRedPointWillAppriase,
    
    /// 待收货
    JHMyCenterRedPointWillReceive,
    
    /// 待评价
    JHMyCenterRedPointWillComment,
    
    /// 有人出价
    JHMyCenterRedPointOtherBid,
    
    /// 我的出价
    JHMyCenterRedPointMyBid,
    /// 个人转售
    JHMyCenterRedPointPersonalTransSale,
    /// 退款售后（买家端）
    JHMyCenterRedPointAfterSale,
    
    //定制服务
    /// 全部订单
    JHMyCenterCustomRedPointAll,
    /// 代付款
    JHMyCenterCustomRedPointWaitPay,
    /// 进行中
    JHMyCenterCustomRedPointInProcess,
    /// 待收货
    JHMyCenterCustomRedPointWaitReceive,
    /// 已完成
    JHMyCenterCustomRedPointFinish,
    
    JHMyCenterMerchantRecycleMySoldCount,
    JHMyCenterMerchantRecycleMyPublishCount,

};




@interface JHMySectionModel : NSObject

@property (nonatomic, copy) NSString *title;                ///标题
@property (nonatomic, assign) JHMySectionType sectionType;  ///section类型
@property (nonatomic, assign) NSInteger columnCount;        ///列数
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;

@end


@interface JHMyCellModel : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *iconTitle;  ///如果不是图片的时候显示文字
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *countString;
@property (nonatomic, assign) BOOL isShowPoint;
@property (nonatomic, assign) BOOL isShowRightLine;
@property (nonatomic, copy) NSString *vcName;
@property (nonatomic, copy) NSDictionary *params;
@property (nonatomic, assign) BOOL isUpdateIconSize; //图标的大小是否需要改变
@property (nonatomic, assign) BOOL isShowRedDot; //是否显示角标
@property (nonatomic, assign) JHMyCenterRedPointType redMessageType;

@property (nonatomic, copy) NSString *growingClickString; //点击事件埋点

@end



NS_ASSUME_NONNULL_END
