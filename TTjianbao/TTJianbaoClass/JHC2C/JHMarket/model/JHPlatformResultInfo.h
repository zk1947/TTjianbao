//
//  JHPlatformResultInfo.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/6/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class JHPlatformResultImageInfo;

@interface JHPlatformResultInfo : NSObject
@property (nonatomic, assign) NSInteger arbResult;
@property (nonatomic, copy) NSString *arbResultDesc;
@property (nonatomic, copy) NSArray<JHPlatformResultImageInfo *> *arbCertificate;

@end

@interface JHPlatformResultImageInfo : NSObject
@property (nonatomic, copy) NSString *small;
@property (nonatomic, copy) NSString *medium;
@property (nonatomic, copy) NSString *big;
@property (nonatomic, copy) NSString *origin;
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;
@end
NS_ASSUME_NONNULL_END
