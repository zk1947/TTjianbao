//
//  JHStoreHomeCardModel.h
//  TTjianbao
//
//  Created by lihui on 2020/3/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class JHStoreHomeCardInfoModel;
@class JHStoreHomeShowcaseModel;
@class JHGoodsInfoMode;

@interface JHStoreHomeNewPeopleModel : NSObject
/// 要展示的图片
@property (nonatomic, copy) NSString *img;
/// 要跳转的URL
@property (nonatomic, copy) NSString *url;
@end

@interface JHStoreHomeCardModel : YDBaseModel
@property (nonatomic,   copy) NSString *card_type;  ///列表类型
@property (nonatomic,   copy) NSString *card_goto;  ///跳转位置
@property (nonatomic, strong) JHStoreHomeCardInfoModel *cardInfo;
@property (nonatomic, strong) JHStoreHomeNewPeopleModel *anewPeopleModel;
@end

@interface JHStoreHomeCardInfoModel : NSObject

@property (nonatomic, strong) NSMutableArray <JHStoreHomeShowcaseModel*>*showcaseList;  ///专题列表
@property (nonatomic, strong) NSMutableArray <JHGoodsInfoMode*>*goodsList;  ///商品列表
@property (nonatomic, strong) NSMutableArray <JHGoodsInfoMode*>*nextGoodsList;  ///下一场次商品列表

@end

///橱窗模型
@interface JHStoreHomeShowcaseModel : NSObject
@property (nonatomic, assign) NSInteger sc_id;              ///橱窗id (last_id)
@property (nonatomic,   copy) NSString *name;               ///标题
@property (nonatomic,   copy) NSString *desc;               ///描述
@property (nonatomic,   copy) NSString *bg_img;             ///不知道是干嘛的
@property (nonatomic,   copy) NSString *head_img;           ///封面图
@property (nonatomic, strong) NSNumber *server_at;          ///服务器当前时间戳
@property (nonatomic, strong) NSNumber *offline_at;         ///倒计时结束时间戳
@property (nonatomic, strong) NSNumber *next_offline_at;    ///下一次场次的结束时间
@property (nonatomic, strong) NSNumber *act_type;           ///活动类型：1新人专享，其他值-非新人专享
@property (nonatomic, strong) NSNumber *topic_type;         ///专题类型: 1:普通专题，2:活动专题，3:秒杀专题，4:种类导航专题',

///自定义字段
@property (nonatomic, assign) BOOL isEndCurrentSeckill;     ///是否结束当前场次秒杀
@property (nonatomic, assign) CGFloat imgHeight;              ///图片高度

//----以下是自定义属性
/*! 倒计时相关 - 倒计时的timer source id  */
@property (nonatomic,   copy) NSString *timerSourceIdentifier;

@end

NS_ASSUME_NONNULL_END
