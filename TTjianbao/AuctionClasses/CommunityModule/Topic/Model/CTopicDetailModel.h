//
//  CTopicDetailModel.h
//  TTjianbao
//
//  Created by wuyd on 2019/8/4.
//  Copyright © 2019 Netease. All rights reserved.
//  话题首页(详情) model
//

#import "YDBaseModel.h"
#import "JHDiscoverChannelCateModel.h"
@class CTopicInfo;
@class CTopicShareInfo;
@class CTopicSaleInfo;

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark - 话题模型 - CTopicDetailModel
@interface CTopicDetailModel : YDBaseModel

//自定义请求参数
@property (nonatomic, copy) NSString *item_id; //当前话题id
@property (nonatomic, copy) NSString *last_uniq_id; //最后一条文章的uniq_id（首次加载更多从2开始，刷新时从1开始）
@property (nonatomic, assign) NSInteger pageIndex; //选项卡参数，1-最新、2-热门

//服务器返回
///最新商品列表（对应服务端 content_list）
@property (nonatomic, strong) NSMutableArray<JHDiscoverChannelCateModel *> *contentList;
///热门商品列表（对应服务端 hot_content_list）
@property (nonatomic, strong) NSMutableArray<JHDiscoverChannelCateModel *> *hotContentList;

@property (nonatomic, strong) CTopicInfo *topicInfo; //话题信息 <topic>
@property (nonatomic, strong) CTopicSaleInfo *saleInfo; //特卖信息 <especially_buy_info>

- (NSString *)toRefreshParams;

- (void)configModel:(CTopicDetailModel *)model; //只有首次获取时调用
- (void)configRefreshModel:(CTopicDetailModel *)model; //刷新或加载更多时调用

@end


#pragma mark -
#pragma mark - 话题信息 - CTopicInfo
@interface CTopicInfo : NSObject
@property (nonatomic, copy) NSString *title; //标题
@property (nonatomic, copy) NSString *bg_image; //背景图片
@property (nonatomic, copy) NSString *introduce; //介绍
@property (nonatomic, copy) NSString *join; //参与人数
@property (nonatomic, copy) NSString *look; //浏览量
@property (nonatomic, assign) BOOL is_show_join; //是否显示立即参与按钮
@property (nonatomic, assign) CGFloat bg_wh_scale; //头图宽高比 w/h
@property (nonatomic, strong) CTopicShareInfo *shareInfo; //（对应服务端 share_info）
@end


#pragma mark -
#pragma mark - 话题分享信息 - CTopicShareInfo
@interface CTopicShareInfo : NSObject
@property (nonatomic, copy) NSString *title; //分享标题
@property (nonatomic, copy) NSString *desc; //描述
@property (nonatomic, copy) NSString *img; //图片
@property (nonatomic, copy) NSString *url; //分享连接
@end


#pragma mark -
#pragma mark - 特卖信息（对应服务端 especially_buy_info 字段）
@interface CTopicSaleInfo : NSObject
@property (nonatomic, copy) NSString *item_id; //特卖id，点击进入更多特卖列表用
@property (nonatomic, copy) NSString *server_time; //服务器当前时间
@property (nonatomic, copy) NSString *end_time; //特卖结束时间
@property (nonatomic, copy) NSString *price; //特卖价
@property (nonatomic, strong) NSMutableArray<JHDiscoverChannelCateModel *> *contentList;//特卖列表（对应content_list）
@end


NS_ASSUME_NONNULL_END
