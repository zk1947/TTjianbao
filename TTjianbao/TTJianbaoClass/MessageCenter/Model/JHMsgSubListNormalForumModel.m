//
//  JHMsgSubListNormalForumModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/3/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMsgSubListNormalForumModel.h"

@implementation JHMsgSubListNormalForumModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"ext" : [JHMsgSubListNormalForumExtModel class]};
}
@end

@implementation JHMsgSubListNormalForumExtModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    //coverImg; //鉴定回复扩展 > 视频封面图片
    return @{@"image" : @"coverImg"};
}
@end
