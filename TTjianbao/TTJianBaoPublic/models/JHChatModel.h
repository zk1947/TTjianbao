//
//  JHChatModel.h
//  TTjianbao
//
//  Created by YJ on 2021/1/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHChatModel : NSObject

@property (copy, nonatomic) NSString   *content;
@property (copy, nonatomic) NSString   *create_time;
@property (copy, nonatomic) NSString   *image_medium;//中图
@property (copy, nonatomic) NSString   *image_thumb;//缩略图
@property (copy, nonatomic) NSString   *image_url;//原图
@property (copy, nonatomic) NSString   *type;//0：文本；1:图片
@property (strong, nonatomic) JHUserInfoModel *to_user_info;
@property (strong, nonatomic) JHUserInfoModel *from_user_info;

@end

NS_ASSUME_NONNULL_END
