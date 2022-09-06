//
//  JHAppImageManager.h
//  TTjianbao
//
//  Created by miao on 2021/7/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JHBusinessModel) {
    JHBusinessModel_De = 0,   // 过仓商品
    JHBusinessModel_SH = 1, // 直发商品
};

NS_ASSUME_NONNULL_BEGIN

@interface JHAppBusinessModelManager : NSObject


/// 获得不同商品模式的图片
/// @param imageName 图片名
/// @param state 商品模式
/// @param block 图片
+ (void)getImage:(NSString *)imageName
          bModel:(JHBusinessModel)bModel
           block:(void(^)(UIImage * _Nullable image))block;


/// 获得不同商品的描述
/// @param titleKey titleKey
/// @param bModel 商品描述
/// @param block 描述
+ (void)getTitle:(NSString *)titleKey
          bModel:(JHBusinessModel)bModel
           block:(void(^)(NSString * _Nullable title))block;


///无回调的获得不同商品的描述
/// @param titleKey titleKey
/// @param bModel 商品描述
+ (nullable NSString *)getTitle:(NSString *)titleKey
                         bModel:(JHBusinessModel)bModel;

@end

NS_ASSUME_NONNULL_END
