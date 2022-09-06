//
//  JHNewStoreSpecialShowUser.h
//  TTjianbao
//
//  Created by liuhai on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface JHNewStoreSpecialShowImage : NSObject
//用户图像
@property (nonatomic, copy) NSString *img;

@end

@interface JHNewStoreSpecialShowUser : NSObject
//浏览量
@property (nonatomic, assign) NSInteger num;
//浏览信息
@property (nonatomic, strong) NSMutableArray * showUserResponses;
@end

NS_ASSUME_NONNULL_END
