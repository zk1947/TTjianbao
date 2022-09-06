//
//  AppraisalVideoRecordMode.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/16.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppraisalVideoRecordMode : NSObject
@property (strong,nonatomic)NSString* duration;
@property (strong,nonatomic)NSString* anchorIcon;
@property (strong,nonatomic)NSString* anchorId;
@property (strong,nonatomic)NSString * anchorName;
@property (strong,nonatomic)NSString* anchorTitle;
@property (strong,nonatomic)NSString * appraiseId;
@property (strong,nonatomic)NSString* assessmentReport;
@property (strong,nonatomic)NSString* coverImg;
@property (assign,nonatomic)NSInteger isGenuine;  //0假  1真  2未知
@property (strong,nonatomic)NSString * price;
@property (strong,nonatomic)NSString* recordId;
@property (strong,nonatomic)NSString* videoUrl;
@property (strong,nonatomic)NSString* watchTotal;
@property (strong,nonatomic)NSArray* tags;
@property (strong,nonatomic)NSString * priceStr;
@property (strong,nonatomic)NSString * title;
@property (strong,nonatomic)NSString * goodsHolder;
@property (assign,nonatomic)BOOL isLaud;//是否点赞
@property (strong,nonatomic)NSString * lauds;//点赞数
@property (strong,nonatomic)NSString * laudsStr;

@property (assign,nonatomic)NSInteger appraiseResult;


//主播主页鉴定历史
@property (strong,nonatomic)NSString * videoTitle;
@property (strong,nonatomic)NSString * recordTime;

@property (strong,nonatomic)NSString * viewedTimes;
@property (strong,nonatomic)NSString * viewedTimesStr;

@end


