//
//  JHQiYuVIPCustomerServiceManager.h
//  TTjianbao
//
//  Created by user on 2020/11/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHQiYuVIPCustomerServiceManager : NSObject
@property (nonatomic,   copy) NSString *groupId;
@property (nonatomic,   copy) NSString *staffId;
@property (nonatomic, assign) NSInteger vipLevel;

+ (JHQiYuVIPCustomerServiceManager *)shared;
- (void)loadQiYuInfo:(BOOL)isNewLogin;
@end

NS_ASSUME_NONNULL_END
