//
//  CStoreHomeListModel.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  首页列表数据 - 标签栏以上的列表数据
//

#import "YDBaseModel.h"
#import "JHDiscoverChannelCateModel.h"
#import "BannerMode.h"

@class CStoreHomeListData; //首页列表数据 - 标签栏以上的列表数据
@class CStoreHomeGoodsData; //商品数据
@class CStoreHomeSellerData; //商城店铺列表数据
@class CStoreHomeGoodsCoverImageInfo; //封面图信息

NS_ASSUME_NONNULL_BEGIN

static NSString *const storeHomeListTimerSourceId = @"storeHomeListTimerSource";
static NSString *const storeHomeRcmdListTimerSourceId = @"storeHomeRcmdListTimerSource";


#pragma mark -
#pragma mark - CStoreHomeListModel

@interface CStoreHomeListModel : YDBaseModel

@property (nonatomic, strong) NSMutableArray<CStoreHomeListData *> *list;

- (NSString *)toUrl;
- (void)configModel:(CStoreHomeListModel *)model;

@end


#pragma mark -
#pragma mark - CStoreHomeListData 首页列表数据 - 标签栏以上的列表数据

@interface CStoreHomeListData : NSObject
@property (nonatomic, assign) NSInteger sc_id; ///橱窗id (last_id)
@property (nonatomic, assign) NSInteger layout; ///布局 [1 今日推荐样式，2 专题样式，3特卖商城店铺]
@property (nonatomic,   copy) NSString *name; ///标题
@property (nonatomic,   copy) NSString *desc; ///描述
@property (nonatomic,   copy) NSString *head_img; ///今日推荐样式背景大图、专题样式的封面图
@property (nonatomic, strong) NSNumber *server_at; ///服务器当前时间戳
@property (nonatomic, strong) NSNumber *offline_at; ///倒计时结束时间戳
@property (nonatomic, strong) NSNumber *next_offline_at;  ///下一次场次的结束时间
@property (nonatomic, strong) NSMutableArray<CStoreHomeGoodsData *> *goodsList; ///商品列表 (layout=1时有goodsList) <goods_list>
@property (nonatomic, strong) NSMutableArray<CStoreHomeSellerData *> *sellerList; ///商家店铺列表 (layout=3时) <rec_seller>
//----以下是自定义属性
/*! 倒计时相关 - 倒计时的timer source id  */
@property (nonatomic,   copy) NSString *timerSourceIdentifier;

@end

#pragma mark - CStoreHomeGoodsData 商品数据
@interface CStoreHomeGoodsData : NSObject
@property (nonatomic, assign) NSInteger status; //商品状态
@property (nonatomic,   copy) NSString *goods_id; //商品id
@property (nonatomic,   copy) NSString *original_goods_id; //新接口商品id 仅用于统计 add 2020.06.05
@property (nonatomic,   copy) NSString *name; //商品名称
@property (nonatomic,   copy) NSString *desc; //商品描述
@property (nonatomic,   copy) NSString *tag_name; //商品标签
@property (nonatomic,   copy) NSString *orig_price; //原始价格
@property (nonatomic,   copy) NSString *market_price; //当前市场价
@property (nonatomic,   copy) NSString *discount; //打几折
@property (nonatomic, assign) NSInteger sell_type; //商品类型 0非特卖(普通商品)，1限时特卖
@property (nonatomic, strong) NSNumber *seller_id; //商家id
@property (nonatomic, strong) NSNumber *sell_stat; //售卖状态 [1下单购买 , 2 咨询购买]
@property (nonatomic,   copy) NSString *flash_sale_tag; //限时购标签
@property (nonatomic,   copy) NSString *store_name; //店铺名称
@property (nonatomic, strong) NSNumber *server_at; //服务器当前时间戳
@property (nonatomic, strong) NSNumber *offline_at; //倒计时结束时间戳
@property (nonatomic, assign) NSInteger item_type; //item_type确定的对象类型（item_type=6 && layout=4表示广告）
@property (nonatomic, assign) NSInteger layout; //layout是布局（比如广告可以有文本和文本加配图）
@property (nonatomic, assign) BOOL has_video; //是否有视频
@property (nonatomic, strong) TargetModel *target; //广告
@property (nonatomic, strong) CStoreHomeGoodsCoverImageInfo *coverImgInfo; //封面图信息（对应服务端接口返回参数：cover_img）
@property (nonatomic,   copy) NSString *timerSourceIdentifier; //倒计时相关 - 自定义倒计时的timer source id
///自定义属性：图片高度
@property (nonatomic, assign) CGFloat imgHeight;
@end

#pragma mark - CStoreHomeSellerData 商家店铺列表数据
@interface CStoreHomeSellerData : NSObject
@property (nonatomic, assign) NSInteger seller_id; //商家id
@property (nonatomic,   copy) NSString *name; //商家店铺名
@property (nonatomic,   copy) NSString *head_img; //头像
@property (nonatomic,   copy) NSString *bg_img; //？？？没用到
@property (nonatomic,   copy) NSString *desc; //商家描述信息（多少人已关注 用此字段显示）
@property (nonatomic,   copy) NSString *onsale_desc; //商品详情中 售卖了多少件
@property (nonatomic,   copy) NSString *publish_num; //商品在售数
@property (nonatomic,   copy) NSString *like_num; //点赞数
@property (nonatomic,   copy) NSString *fans_num; //粉丝数
@property (nonatomic, assign) NSInteger fans_num_int; //粉丝数
@property (nonatomic, assign) NSInteger follow_status; //关注状态 1关注 0未关注
@end

#pragma mark - CStoreHomeGoodsCoverImageInfo 封面图信息
@interface CStoreHomeGoodsCoverImageInfo : NSObject
@property (nonatomic, assign) CGFloat width; ///图片宽度
@property (nonatomic, assign) CGFloat height; ///图片高度
@property (nonatomic,   copy) NSString *imgUrl; ///图片或视频  封面图地址（对应服务端接口返回参数：url）
@property (nonatomic,   copy) NSString *video_url; ///视频资源地址
@property (nonatomic, assign) NSInteger type; ///封面类型，1图片 2视频
@end


NS_ASSUME_NONNULL_END
