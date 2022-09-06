//
//  JHAudienceCommentMode.h
//  TTjianbao
//
//  Created by jiangchao on 2019/5/15.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHAudienceCommentMode : NSObject

@property (nonatomic, strong) NSString * serviceReply;
@property (nonatomic, strong) NSArray * orderServiceComments;
@property (nonatomic, strong) NSString * sellerCustomerId;
@property (nonatomic, strong) NSString * commentContent;
@property (nonatomic, strong) NSString * customerId;
@property (nonatomic, assign) BOOL haveReport;
@property (nonatomic, assign) BOOL isLaud;

//是否是优质评价
@property (nonatomic, assign) BOOL good;
@property (nonatomic, assign) BOOL isReply; //主播是否回复过
@property (nonatomic, assign) NSInteger pass;

@property (nonatomic, strong) NSString * laudTimes;
@property (nonatomic, strong) NSString * laudTimesStr;
@property (nonatomic, strong) NSString * customerImg;
@property (nonatomic, strong) NSString * customerName;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * Id;
@property (nonatomic, strong) NSString * orderImg;
@property (nonatomic, strong) NSString * orderId;
@property (nonatomic, strong) NSString * orderCode;


@property (nonatomic, strong) NSArray * commentImgsList;
@property (nonatomic, strong) NSArray * commentTagsList;

@property (nonatomic, assign) NSInteger pass1;
@property (nonatomic, assign) NSInteger pass2;
@property (nonatomic, assign) NSInteger pass3;

//cell高度
@property (nonatomic, assign) CGFloat height;


/// 店铺回复
@property (nonatomic, strong) NSString * shopReply;

@end

@interface CommentTagMode : NSObject
@property (nonatomic, strong) NSString * Id;
@property (nonatomic, strong) NSString * tagName;
@property (nonatomic, strong) NSString * countStr;
@property (nonatomic, strong) NSString * tagCode;
@end


@interface CommentReplyMode : NSObject
//0  客服回复  1 是主播回复
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString * comment;
@property (nonatomic, strong) NSString * title;
@end



