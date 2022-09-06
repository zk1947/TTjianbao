//
//  JHRecommendAppraiserListItem.h
//  TTjianbao
//
//  Created by mac on 2019/8/1.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecommendAppraiserListItem : JHResponseModel
//"appraiseTime": "string",
//"appraiserTag": "string",
//"grade": 0,
//"id": 0,
//"img": "string",
//"name": "string",
//"online": 0,
//"state": 0

@property(nonatomic, copy)NSString *appraiseTime;
@property(nonatomic, copy)NSString *appraiserTag;
@property(nonatomic, copy)NSString *appraiserId;
@property(nonatomic, copy)NSString *channelId;
@property(nonatomic, copy)NSString *img;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *Id;
@property(nonatomic, assign)NSInteger waitNumber;
@property(nonatomic, assign)NSInteger state; // 直播中
@property(nonatomic, copy)NSString *grade;
@property(nonatomic, copy)NSString *tag;
@property(nonatomic, assign)NSInteger follow;
@property(nonatomic, copy)NSString *appraiserCustomerId;
@property(nonatomic, assign)BOOL isFollow;
@property(nonatomic, assign)NSInteger watchTotal;
@property(nonatomic, copy) NSString *customerId;
@property(nonatomic, copy) NSString *smallCoverImg;
@property(nonatomic, assign) BOOL canAppraise; //可以 申请鉴定

@end


@interface JHRecommendAppraiserListModel : NSObject
//"appraiseTime": "string",
//"appraiserTag": "string",
//"grade": 0,
//"id": 0,
//"img": "string",
//"name": "string",
//"online": 0,
//"state": 0

@property(nonatomic, copy)NSString *tag;
@property(nonatomic, strong)NSArray<JHRecommendAppraiserListItem *> *recommendAppraiserInfoVoList;
@property(nonatomic, assign)NSInteger hasOnline;

@end

@interface AppraiserPlan : NSObject
//"appraiseTime": "string",
//"appraiserId": 0,
//"follow": 0,
//"grade": 0,
//"img": "string",
//"name": "string",
//"tag": "string"

@property(nonatomic, copy)NSString *appraiseTime;
@property(nonatomic, copy)NSString *appraiserId;
@property(nonatomic, copy)NSString *customerId;
@property(nonatomic, copy)NSString *img;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *tag;
@property(nonatomic, assign)NSInteger follow;
@property(nonatomic, assign)NSInteger grade;

@end


NS_ASSUME_NONNULL_END
