///
///   JHGoodManagerFilterModel.h
///   TTjianbao
///
///   Created by user on 2021/8/18.
///   Copyright © 2021 YiJian Tech. All rights reserved.
///

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodManagerFilterModel : NSObject
/// 主键
@property (nonatomic,   copy) NSString *cateId;
/// 分类名称
@property (nonatomic,   copy) NSString *cateName;
/// 父节点id
@property (nonatomic,   copy) NSString *pid;
/// 级别
@property (nonatomic,   copy) NSString *cateLevel;
/// 排序
@property (nonatomic, assign) NSInteger sort;
/// 老的分类id
@property (nonatomic,   copy) NSString *oldCateId;
/// 分类图片
@property (nonatomic,   copy) NSString *cateIcon;
/// 是否直发 0否1是
@property (nonatomic, assign) NSInteger directDelivery;
/// 创建时间
@property (nonatomic,   copy) NSString *createTime;
/// 更新时间
@property (nonatomic,   copy) NSString *updateTime;
/// 所有子分类
@property (nonatomic, strong) NSArray<JHGoodManagerFilterModel *> *children;
@end

NS_ASSUME_NONNULL_END
