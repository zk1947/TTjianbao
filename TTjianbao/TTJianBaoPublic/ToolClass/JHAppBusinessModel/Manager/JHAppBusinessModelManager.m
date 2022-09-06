//
//  JHAppImageManager.m
//  TTjianbao
//
//  Created by miao on 2021/7/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAppBusinessModelManager.h"
#import "JHBusinessModelTitleConfig.h"

@implementation JHAppBusinessModelManager

+ (void)getImage:(NSString *)imageName
          bModel:(JHBusinessModel)bModel
           block:(void(^)(UIImage * _Nullable image))block {
    UIImage *image = nil;
    if (isEmpty(imageName)) {
        block(image);
        return;
    }
    NSString *suffix = @"_straightHair";
    NSString *straightHairName = [NSString stringWithFormat:@"%@%@",imageName,suffix];
    imageName = bModel == JHBusinessModel_SH ? straightHairName : imageName;
    image = [UIImage imageNamed:imageName];
    block(image);

}

+ (void)getTitle:(NSString *)titleKey
          bModel:(JHBusinessModel)bModel
           block:(void(^)(NSString * _Nullable title))block {
    NSString *titleStr = nil;
    if (isEmpty(titleKey)) {
        block(titleStr);
        return;
    }
    NSDictionary *configDict = [JHBusinessModelTitleConfig businessModelTitleConfig];
    NSDictionary *tempDict = [configDict objectForKey:titleKey];
    NSString *specificKey = bModel == JHBusinessModel_SH ? JHStraightHairConfigKey : JHDeliveryConfigKey;
    titleStr = [tempDict objectForKey:specificKey];
    block(titleStr);
}

+ (nullable NSString *)getTitle:(NSString *)titleKey
                         bModel:(JHBusinessModel)bModel {
    NSString *titleStr = nil;
    if (isEmpty(titleKey)) {
        return titleStr;
    }
    NSDictionary *configDict = [JHBusinessModelTitleConfig businessModelTitleConfig];
    NSDictionary *tempDict = [configDict objectForKey:titleKey];
    NSString *specificKey = bModel == JHBusinessModel_SH ? JHStraightHairConfigKey : JHDeliveryConfigKey;
    titleStr = [tempDict objectForKey:specificKey];
    return titleStr;
}

@end
