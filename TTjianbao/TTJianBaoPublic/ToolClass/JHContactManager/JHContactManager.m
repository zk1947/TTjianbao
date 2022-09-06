//
//  JHContactManager.m
//  TTjianbao
//
//  Created by YJ on 2021/1/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHContactManager.h"

static JHContactManager *manager = nil;

#define USER_DEFAULTS   [NSUserDefaults standardUserDefaults]
#define CONTACT_KEY     @"JH_CONTACT_KEY"
#define MAX_NUM         10

@implementation JHContactManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
    });

    return manager;
}

+ (void)storeModel:(JHContactUserInfoModel *)model
{
    NSMutableDictionary *mu_dic = [model mj_keyValues];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:mu_dic];
    NSArray *dicsArray = [NSArray new];
    
    NSArray *array = [NSArray new];
    array = [JHContactManager getModelsArray];
    NSMutableArray *mu_array = [NSMutableArray new];
    [mu_array addObjectsFromArray:array];
    
    if (mu_array.count > 0)
    {
        [mu_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
            JHContactUserInfoModel *infoModel = [JHContactUserInfoModel mj_objectWithKeyValues:obj];
            
//            if ([model.customerId intValue] == [infoModel.customerId intValue])
//            {
//                [mu_array removeObject:obj];
//            }
            
            if ([model.name isEqualToString:infoModel.name])
            {
                [mu_array removeObject:obj];
            }
            
            [mu_array insertObject:dic atIndex:0];
            
        }];

        if (mu_array.count > MAX_NUM)
        {
            dicsArray = [mu_array subarrayWithRange:NSMakeRange(0, MAX_NUM)];
        }
        else
        {
            dicsArray = mu_array;
        }
    }
    else
    {
        [mu_array addObject:dic];
        
        dicsArray = mu_array;
    }

    [JHContactManager saveModelsArray:dicsArray];
}

+ (void)saveModelsArray:(NSArray <NSDictionary *> *)array
{
    [USER_DEFAULTS setValue:array forKey:CONTACT_KEY];
    [USER_DEFAULTS synchronize];
}

+ (NSArray *)getModelsArray
{    
    NSArray *array = [NSArray new];
    array = [USER_DEFAULTS valueForKey:CONTACT_KEY];
    return array;
}

+ (void)clear
{
    NSArray *array = [NSArray new];
    [JHContactManager saveModelsArray:array];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [JHContactManager shareManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [JHContactManager shareManager];
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [JHContactManager shareManager];
}


@end
