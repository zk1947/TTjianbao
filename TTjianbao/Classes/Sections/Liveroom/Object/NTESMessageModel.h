//
//  NTESMessageModel.h
//  TTjianbao
//
//  Created by chris on 16/3/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESLiveManager.h"

#define Chatroom_Message_Font     [UIFont fontWithName:@"PingFang-SC-Regular" size:13]
@interface JHMessageExtModel : NSObject

// 3.1.1新增 以后有时间把其他扩展字段都加到这里

//    "userTycoonLevel";//用户土豪等级
//    "userTycoonLevelIcon";//用户土豪等级图标
//    "userMsgColor";//用户聊天室发言颜色
@property (nonatomic, assign) NSInteger userTycoonLevel;
@property (nonatomic, copy) NSString *userTycoonLevelIcon;
@property (nonatomic, copy) NSString *userMsgColor;
@property (nonatomic, strong) UIImage *userTycoonLevelImage;

@end

@class M80AttributedLabel;

@interface NTESMessageModel : NSObject

@property (nonatomic,strong) NIMMessage *message;

@property (nonatomic,assign) CGFloat height;

@property (nonatomic,assign) CGFloat width;


@property (nonatomic,readonly) NSAttributedString *formatMessage;

@property (nonatomic,assign,readonly) NSRange nickRange;

@property (nonatomic,assign,readonly) NSRange textRange;

- (void)caculate:(CGFloat)width;

- (void)drawViewToLabel:(M80AttributedLabel *)label;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *customerId;

@property (nonatomic, assign) NSInteger bought;
@property (nonatomic, assign) NSInteger boughtOther; //在其他直播间付费

@property (nonatomic, assign) BOOL isAnchorRecv;

@property (nonatomic, assign) NSInteger gameGrade;

@property (nonatomic, assign) NSInteger isAppraise;

@property (nonatomic, assign) NSInteger type;//1是鉴定师 0不是

@property (nonatomic, assign) JHRoomRole roomRole;

@property (nonatomic, assign) BOOL isBeMuted;

@property (nonatomic, strong) UIImage *userLevelImage;

@property (nonatomic, strong) NSString *userLevelUrl;
@property (nonatomic, strong) NSString *userGameGradeUrl;
@property (nonatomic, strong) UIImage *userGameGradeImage;

//用户粉丝团级别
@property (assign,nonatomic)NSInteger userLevelType;
//用户粉丝团名字
@property (copy,nonatomic)NSString *userLevelName;
//用户粉丝牌地址
@property (copy,nonatomic)NSString *levelImg;
//用户粉丝牌image
@property (strong,nonatomic)UIImage *userLevelImg;

@property (nonatomic, assign) NSInteger userTitleLevel;

@property (nonatomic, strong) JHMessageExtModel *extModel;

@end
