//
//  JHAnchorInfoModel.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/14.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHAnchorInfoModel : NSObject

@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *appraiserDesc;
@property (nonatomic, copy) NSString *appraiserImg;
@property (nonatomic, copy) NSString *appraiserName;
@property (nonatomic, assign) NSInteger appraiseCount;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, assign) NSInteger isFollow;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *appraiserIntroduction;
@property (nonatomic, copy) NSArray *certifications;
@property (nonatomic, copy) NSArray *certificationFiles;
@property (nonatomic, copy) NSString *roomId;
/** 擅长鉴定*/
@property (nonatomic, copy) NSString *goodAt;

@end

@interface JHAnchorHomeModel : NSObject
/** 关注数量  店铺+用户数*/
@property (nonatomic, copy) NSString *follow_num;
/** 获赞数量  用户数*/
@property (nonatomic, copy) NSString *follow_user_num;
/** 获赞数量*/
@property (nonatomic, copy) NSString *like_num;
/** 粉丝数量*/
@property (nonatomic, copy) NSString *fans_num;
/** 鉴定师详情模型*/
@property (nonatomic, strong) JHAnchorInfoModel *appraise;
/** 是否关注*/
@property (nonatomic, assign) NSInteger is_follow;
@end


