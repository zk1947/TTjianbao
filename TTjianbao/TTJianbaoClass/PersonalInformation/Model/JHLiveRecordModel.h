//
//  JHLiveRecordModel.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/17.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHLiveRecordModel : NSObject

//"anchorIcon": "string",
//"anchorName": "string",
//"anchorTitle": "string",
//"appraiseId": 0,
//"coverImg": "string",
//"evaluateId": 0,
//"isGenuine": 0,
//"price": 0,
//"recordId": 0,
//"recordTime": "2019-01-17T06:30:58.163Z",
//"reportId": 0,
//"videoUrl": "string"

@property (nonatomic, copy) NSString *recordTime;
@property (nonatomic, assign) NSInteger appraiseSecond;
//主播获取
@property (nonatomic, copy) NSString *viewerIcon;
@property (nonatomic, copy) NSString *viewerName;
//观众获取
@property (nonatomic, copy) NSString *anchorName;
@property (nonatomic, copy) NSString *anchorIcon;
@property (nonatomic, copy) NSString *anchorId;
@property (nonatomic, copy) NSString *anchorTitle;

@property (nonatomic, copy) NSString *coverImg;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *reportId;
@property (nonatomic, assign) NSInteger isGenuine; //0假  1真 2未知
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, copy) NSString *evaluateId;
@property (nonatomic, copy) NSString *appraiseId;
@property (nonatomic, copy) NSString *priceStr;
@property (nonatomic, copy) NSString *goodsHolder;
@property (nonatomic, copy) NSString *videoTitle;
///372新增  是否推荐
@property (nonatomic, assign) BOOL isRecommend;
///备注内容
@property (nonatomic, copy) NSString *remark;

@end

@class JHRecordFilterMenuModel;
@interface JHRecordFilterModel : NSObject
///列表标题
@property (nonatomic, copy) NSString *title;
///列表数据
@property (nonatomic, copy) NSArray <JHRecordFilterMenuModel *>*list;
@end

@interface JHRecordFilterMenuModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *keyword;
@end

NS_ASSUME_NONNULL_END
