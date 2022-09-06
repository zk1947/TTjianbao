//
//  JHRecycleDetailModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleDetailModel.h"

@implementation JHRecycleDetailImageUrlModel

@end

@implementation JHRecycleDetailProductDetailUrlsModel

@end

@implementation JHRecycleDetailProductImgUrlsModel

@end



@implementation JHRecycleDetailModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"productDetailUrls" : [JHRecycleDetailProductDetailUrlsModel class],
        @"productImgUrls" : [JHRecycleDetailProductImgUrlsModel class]
    };
}
@end
