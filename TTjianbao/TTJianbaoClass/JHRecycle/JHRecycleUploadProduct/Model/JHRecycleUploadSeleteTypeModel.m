//
//  JHRecycleUploadSeleteTypeModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleUploadSeleteTypeModel.h"

@implementation JHRecycleUploadImageInfoModel

- (NSString *)big{
    NSString *url = _big.stringByRemovingPercentEncoding;
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return url;
}
- (NSString *)medium{
    NSString *url = _medium.stringByRemovingPercentEncoding;
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return url;
}
- (NSString *)origin{
    NSString *url = _origin.stringByRemovingPercentEncoding;
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return url;
}
- (NSString *)small{
    NSString *url = _small.stringByRemovingPercentEncoding;
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return url;
}

@end

@implementation JHRecycleUploadSeleteTypeBannerModel

@end

@implementation JHRecycleUploadSeleteTypeListModel

@end

@implementation JHRecycleUploadSeleteTypeModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"bannerImgUrls" : JHRecycleUploadSeleteTypeBannerModel.class,
             @"categoryVOs" : JHRecycleUploadSeleteTypeListModel.class,};
}

@end
