//
//  JHRushPurChaseModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/9/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHStoreDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRushPurChaseSeckillProductInfoModel : NSObject
//商品id
@property (nonatomic) NSInteger productId;
//商品主图
@property (nonatomic, strong) ProductImageInfo* mainImageUrl;
//商品名称
@property (nonatomic, strong) NSString*  productName;
//商品原价
@property (nonatomic, strong) NSString*  productOriginalPrice;
//商品秒杀价
@property (nonatomic, strong) NSString*  productSeckillPrice;
//营销标签
@property (nonatomic, strong) NSArray<NSString*> * productTagList;
//秒杀进度
@property (nonatomic) NSInteger seckillProgress;
//按钮类型 0-马上抢 1-已抢光 2-开售提醒 3-已设置提醒   
@property (nonatomic) NSInteger btnType;


@property (nonatomic, strong) NSString*  saveMoney;

@property (nonatomic) NSInteger sellStock;

@end


@interface JHRushPurChaseSeckillTimeModel : NSObject
//秒杀场次id
@property (nonatomic) NSInteger seckillNumId;
//秒杀场次时间描述
@property (nonatomic, strong) NSString* timeDesc;
//秒杀场次状态描述
@property (nonatomic, strong) NSString* statusDesc;
//是否是当天的专场 true 是  false 否
@property (nonatomic) BOOL thatDay;

//秒杀场次状态 1 抢购中 0 未开始",
@property (nonatomic) NSInteger seckillNumStatus;

@end


@interface JHRushPurChasePageResultModel : NSObject

//页码
@property (nonatomic) NSInteger pageNo;
//每页数量
@property (nonatomic) NSInteger pageSize;
//分页总页数
@property (nonatomic) NSInteger pages;
//是否有下一页
@property (nonatomic) BOOL hasMore;
//排序 默认0-综合排序， 其余根据业务增加类型
@property (nonatomic) NSInteger sort;
//服务端去重生，成当前页最后一条记录的信息
@property (nonatomic, strong) NSString* cursor;
//list数据
@property (nonatomic, strong) NSArray<JHRushPurChaseSeckillProductInfoModel*> *  resultList;
//总条数
@property (nonatomic) NSInteger total;

@end

@interface JHRushPurChaseModel : NSObject

//背景图
@property (nonatomic, strong) ProductImageInfo* bgImage;
//秒杀时间段
@property (nonatomic, strong) NSArray<JHRushPurChaseSeckillTimeModel*> * seckillTimeList;
//秒杀倒计时描述
@property (nonatomic, strong) NSString* seckillCountdownDesc;
//秒杀倒计时
@property (nonatomic) NSInteger seckillCountdown;
//专场id
@property (nonatomic) NSInteger showId;
//秒杀分页商品数据
@property (nonatomic, strong) JHRushPurChasePageResultModel* productPageResult;

//秒杀倒计时描述
@property (nonatomic, strong) NSString* shareMainTitle;
//秒杀倒计时描述
@property (nonatomic, strong) NSString* shareSubtitle;
//秒杀倒计时描述
@property (nonatomic, strong) NSString* shareUrl;

@end

NS_ASSUME_NONNULL_END

