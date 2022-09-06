//
//  JHPersistData.m
//  TTjianbao
//
//  Created by jesee on 27/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPersistData.h"

#define kPersistPrePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"%@"]

@implementation JHPersistData

+ (NSString*)dataPath:(NSString*)suffixPath
{
    NSString* path = [NSString stringWithFormat:kPersistPrePath, suffixPath];
    return path;
}

//持久化数据到savePath下
+ (void)savePersistData:(id)data savePath:(NSString*)savePath
{
    if(data && savePath)
    {
        [NSKeyedArchiver archiveRootObject:data toFile:[self dataPath:savePath]];
    }
    else
    {
        NSLog(@"data or savePath is nil !!");
    }
}
//从savePath下获取持久化数据
+ (id)persistDataByPath:(NSString*)savePath
{
    if(savePath)
    {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:[self dataPath:savePath]];
    }
    else
    {
        NSLog(@"savePath is nil !!");
        return nil;
    }
}

//删除savePath下的持久化数据
+ (void)deletePersistDataPath:(NSString*)savePath
{
    if(savePath)
    {
        id data = nil;
        [NSKeyedArchiver archiveRootObject:data toFile:[self dataPath:savePath]];
    }
    else
    {
        NSLog(@"delete savePath is nil !!");
    }
}

@end
