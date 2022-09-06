//
//  JHPersistData.h
//  TTjianbao
//  Description:持久化存储,序列化小数据
//  Created by jesee on 27/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHPersistData : NSObject

//持久化数据到savePath下
+ (void)savePersistData:(id)data savePath:(NSString*)savePath;

//从savePath下获取持久化数据
+ (id)persistDataByPath:(NSString*)savePath;

//删除savePath下的持久化数据
+ (void)deletePersistDataPath:(NSString*)savePath;
@end

