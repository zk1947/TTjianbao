//
//  JHRankingModel.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/15.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRankingModel : NSObject
@property (nonatomic, copy)NSString *anchorIcon;// (string, optional): 主播头像 ,
@property (nonatomic, copy)NSString *anchorName;// (string, optional): 主播昵称 ,
@property (nonatomic, copy)NSString *appraiseId;// (integer, optional): 鉴定记录Id ,
@property (nonatomic, copy)NSString *cateName;// (string, optional): 物品种类 ,
@property (nonatomic, assign)NSInteger price;// (number, optional): 鉴定金额 ,
@property (nonatomic, assign)NSInteger ranking;// (integer, optional): 排名 ,
@property (nonatomic, copy)NSString *videoCoverImg;// (string, optional): 视频封面
@property (nonatomic, copy)NSString *videoUrl;
@property (nonatomic, copy)NSString *priceStr;// (number, optional): 鉴定金额 ,
@property (nonatomic, copy)NSString *viewerIcon;
@property (nonatomic, copy)NSString *viewerName;
@property (nonatomic, copy)NSString *title;
@end

@interface JHRankingNewModel : NSObject


@property (nonatomic, copy)NSString *anchorName;//string, optional): 鉴定师昵称 ,
@property (nonatomic, copy)NSString *appraiseRecordId;//integer, optional): 鉴定记录ID ,
@property (nonatomic, copy)NSString *buyerImg;//string, optional): 买家头像 ,
@property (nonatomic, copy)NSString *buyerName;//string, optional): 买家昵称 ,
@property (nonatomic, copy)NSString *createDate;//string, optional): 生成鉴定报告时间 ,
@property (nonatomic, copy)NSString *goodsUrl;//string, optional): 订单商品图片 ,
@property (nonatomic, copy)NSString *Id;//integer, optional): 鉴定报告ID ,
@property (nonatomic, copy)NSString *originOrderPrice;//number, optional): 成交金额 ,
@property (nonatomic, copy)NSString *reportGoodsName;//string, optional): 鉴定物品名称 ,
@property (nonatomic, copy)NSArray *reportRecordScoreFieldList;//Array[ReportRecordScoreField], optional),
@property (nonatomic, assign)CGFloat scoreAverage;//number, optional): 综合平均分 ,
@property (nonatomic, assign)CGFloat scoreCost;//number, optional): 性价比分值 ,
@property (nonatomic, assign)CGFloat scoreCraft;//number, optional): 工艺分值 ,
@property (nonatomic, assign)CGFloat scoreHedging;//number, optional): 保值空间分值 ,
@property (nonatomic, assign)CGFloat scoreRare;//number, optional): 稀有度分值 ,
@property (nonatomic, copy)NSString *videoCoverImg;//string, optional): 视频封面 ,
@property (nonatomic, assign)NSInteger videoDuration;//integer, optional): 视频时长 ,
@property (nonatomic, copy)NSString *videoTitle;//string, optional): 视频标题
@property (nonatomic, copy)NSString *overshoot;//超越
@property (nonatomic, copy)NSString *videoUrl;
@property (nonatomic, copy)NSString *commentHelpful; //0：未评价 1：已评价-有帮助 2：已评价-无帮助
@property (nonatomic, assign)BOOL showComment; //是否显示评价详情：0-不显示、1-显示

@property (nonatomic, copy)NSString *channelRecordId;
@property (nonatomic, assign)BOOL isLaud;
@property (nonatomic, strong)NSString *lauds;

@property (nonatomic, strong)NSString *cateName;
@property (nonatomic, strong)NSString *updateDate;
@property (nonatomic, strong)NSString *appraiseDate;
@property (strong,nonatomic)NSString *originRecordId;

@end


@interface JHRankingDataModel : NSObject
@property (nonatomic, copy)NSString *rankingTitle;
@property (nonatomic, copy)NSArray *reportRankingList;
@end


NS_ASSUME_NONNULL_END
