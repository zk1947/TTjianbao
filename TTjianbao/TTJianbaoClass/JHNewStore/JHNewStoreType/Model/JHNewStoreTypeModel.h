//
//  JHNewStoreTypeModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface JHNewStoreTypeModel : NSObject

//主键
@property (nonatomic, assign) NSInteger ID;
//分类名称
@property (nonatomic, strong) NSString *cateName;
//分类图片
@property (nonatomic, strong) NSString *cateIcon;
//分类上级id
@property (nonatomic, assign) NSInteger pid;
//级别
@property (nonatomic, assign) NSInteger cateLevel;
//排序
@property (nonatomic, assign) NSInteger sort;
//所有子分类
@property (nonatomic, strong) NSArray<JHNewStoreTypeModel*> *children;

@end




NS_ASSUME_NONNULL_END
