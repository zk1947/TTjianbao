//
//  JHContactManager.h
//  TTjianbao
//
//  Created by YJ on 2021/1/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHContactUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHContactManager : NSObject

+ (instancetype)shareManager;

+ (void)storeModel:(JHContactUserInfoModel *)model;

+ (NSArray *)getModelsArray;

+ (void)clear;

@end

NS_ASSUME_NONNULL_END
