//
//  OrderAppraiseModel.h
//  TTjianbao
//
//  Created by yaoyao on 2019/2/13.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderAppraiseModel : NSObject
@property (nonatomic, copy)NSString *coverImg;// (string, optional),
@property (nonatomic, assign)NSInteger duration;// (integer, optional),
@property (nonatomic, assign)NSInteger fileSize;// (integer, optional),
@property (nonatomic, copy)NSString *videoId;// (string, optional),
@property (nonatomic, copy)NSString *videoUrl;// (string, optional)
@property (nonatomic, copy)NSString *appraiseStatus;
@property (nonatomic, copy)NSString *orderCode;
@end

NS_ASSUME_NONNULL_END
