//
//  ApprailsalCommentMode.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ApprailsalCommentMode : NSObject
@property (strong,nonatomic)NSString * createDate;
@property (strong,nonatomic)NSString* ID;
@property (strong,nonatomic)NSString * img;
@property (strong,nonatomic)NSString* name;
@property (strong,nonatomic)NSString* remarks;
@property (strong,nonatomic)NSString* userId;
@property (strong,nonatomic)NSString* laudTimes;
@property (strong,nonatomic)NSString* laudTimesStr;
@property (strong,nonatomic) NSString *userTycoonLevelIcon; //称号等级
@property (strong,nonatomic)NSString* title_level_icon;
@property (strong,nonatomic)NSString* game_level_icon;
@property (strong,nonatomic)NSString* role_icon;

@property (assign,nonatomic)BOOL isLaud;
@end


