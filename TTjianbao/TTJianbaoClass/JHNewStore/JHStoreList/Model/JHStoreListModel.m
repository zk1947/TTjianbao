//
//  JHStoreListModel.m
//  TTjianbao
//
//  Created by zk on 2021/10/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreListModel.h"

@implementation JHStoreListModel

//MJExtention
//+ (NSDictionary *)mj_objectClassInArray{
//    return @{
//        @"productList" : JHStoreItemModel.class
//    };
//}

+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"ID" :@"id"};
}

//YYModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"productList" : [JHStoreItemModel class],
    };
}

- (CGFloat)labW{
    CGSize size = [self.shopName boundingRectWithSize:CGSizeMake(1000, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:JHMediumFont(14)} context:nil].size;
    return size.width > 168 ? 168 : size.width+5;
}

@end

@implementation JHStoreItemModel

@end

@implementation JHStoreGoodsImgModel

@end

