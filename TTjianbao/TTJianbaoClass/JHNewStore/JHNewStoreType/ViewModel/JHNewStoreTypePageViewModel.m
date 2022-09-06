//
//  JHNewStoreTypePageViewModel.m
//  TTjianbao
//
//  Created by zk on 2021/10/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreTypePageViewModel.h"

@implementation JHNewStoreTypePageViewModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"leftCategoryList" : JHNewStoreTypeModel.class,
        @"rightCategoryList" : JHNewStoreTypeRightSectionModel.class,
    };
}

//YYModel
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{
//        @"leftCategoryList" : [JHNewStoreTypeModel class],
//    };
//}

@end

@implementation JHNewStoreTypeRightSectionModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"operationList" : JHNewStoreTypeRightScrollModel.class,
        @"liveList" : JHNewStoreTypeRightLiveModel.class,
        @"secondCateList" : JHNewStoreTypeModel.class
    };
}

- (CGFloat)sectionHeight{
    CGFloat h = 50;
    if (self.operationList.count > 0) {
        h += 90;
    }
    if (self.liveList.count > 0) {
        h += [self liveHeight];
    }
    return h;
}

- (CGFloat)liveHeight{
    CGFloat height = 160;
    if (self.liveList.count > 0) {
        for (int i = 0; i < self.liveList.count; i++) {
            if (i < 3) {
                if ([self itemNameMoreRow:[self.liveList[i] anchorName]]) {
                    height = 170;
                    break;
                }
            }
        }
    }
    return height;
}
- (BOOL)itemNameMoreRow:(NSString *)liveName{
    CGSize size = [self calculationTextWidthWithWidth:80.f string:liveName font:JHFont(13)];
    if (size.height > 20.f) {
        return YES;
    }
    return NO;
}

- (CGSize)calculationTextWidthWithWidth:(CGFloat)width string:(NSString *)string font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return size;
}

@end

@implementation JHNewStoreTypeRightScrollModel

@end

@implementation JHNewStoreTypeRightScrollTargetModel

@end

@implementation JHNewStoreTypeRightLiveModel

@end


