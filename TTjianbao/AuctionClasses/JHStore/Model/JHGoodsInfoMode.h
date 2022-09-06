//
//  JHGoodsInfoMode.h
//  TTjianbao
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHCoverImageMode;

static NSString *const storeShopPageTimerSourceId = @"storeShopPageTimerSourceId";



@interface JHGoodsInfoMode : NSObject

@property (nonatomic, copy) NSString *name;                     ///商品名称
@property (nonatomic, copy) NSString *desc;                     ///商品描述
@property (nonatomic, copy) NSString *tag_name;                 ///商品标签
@property (nonatomic, copy) NSString *attr;
@property (nonatomic, copy) NSString *orig_price;               ///原始价格
@property (nonatomic, copy) NSString *market_price;             ///现价
@property (nonatomic, copy) NSString *discount;                 ///折扣
@property (nonatomic, copy) NSString *goods_id;               ///商品ID
@property (nonatomic, copy) NSString *original_goods_id; //新接口商品id 仅用于统计 add 2020.06.05
@property (nonatomic, strong) NSNumber *status;               ///商品状态
@property (nonatomic, strong) NSNumber *seller_id;              ///卖家ID
@property (nonatomic, strong) NSNumber *sell_type;
@property (nonatomic, strong) NSNumber *sell_stat;              ///卖家状态
@property (nonatomic, strong) JHCoverImageMode *coverImage;     ///封面
@property (nonatomic, assign) long long offline_at;             ///结束时间
@property (nonatomic, assign) long long server_at;              ///服务器时间
@property (nonatomic, assign) long long countDownTime;          ///服务器时间
@property (nonatomic, copy) NSString *flash_sale_tag;           ///专题标签

@property (nonatomic, copy) NSString *pro_rate_tip;              ///已售进度描述
@property (nonatomic, assign) float sold_rate;          ///已售进度
///sk_status:[1马上抢,2 已结缘,3 提醒我，4 已设提醒, 5 已结束 ]
@property (nonatomic, assign) NSInteger sk_status;
@property (nonatomic, assign) NSInteger stock;///库存
@property (assign,nonatomic)BOOL  is_show_pro;///秒杀是否显示进度去

@property (nonatomic, assign) BOOL has_video; //是否有视频

//计算之后的JHDiscoverHomeFlowCollectionCell高度
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat picHeight;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat descHeight;
@property (nonatomic, assign) CGFloat priceHeight;


//倒计时相关 - 自定义倒计时的timer source id
@property (nonatomic,   copy) NSString *timerSourceIdentifier;
 

@end

@interface JHCoverImageMode : NSObject

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) CGFloat wh_scale;
@property (nonatomic, copy) NSString *video_url;
@property (nonatomic, copy) NSString *url;


@end

@interface JHHeaderInfo : NSObject

@property (nonatomic, strong) NSNumber *sc_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *bg_img;
@property (nonatomic, assign) long long count_down;
@property (nonatomic, assign) long long offline_at;
@property (nonatomic, assign) long long server_at;
@property (nonatomic, assign) long long next_offline_at;  ///下一次场次的结束时间
@property (nonatomic, assign) CGFloat pic_scale;
@property (nonatomic, copy) NSString *url;    ///分享橱窗用的url

@end



NS_ASSUME_NONNULL_END
