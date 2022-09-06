//
//  JHShanGouTypeAlter.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/10/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, JHShanGouTypeAlter_Action) {
    JHShanGouTypeAlter_CreatProduct = 0,
    JHShanGouTypeAlter_SeeList,
};
@interface JHShanGouTypeAlter : UIView

/// 选择菜单类型回调
@property(nonatomic, copy) void(^seletedBlock)(JHShanGouTypeAlter_Action index, NSString* _Nullable  name, NSString* _Nullable  typeId) ;

@property (copy,nonatomic) NSArray <ShanGouInfo*> *flashCategories;

@end

NS_ASSUME_NONNULL_END
