//
//  CStoreCollectionModel.m
//  TTjianbao
//
//  Created by wuyd on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "CStoreCollectionModel.h"

@implementation CStoreCollectionModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"data"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [CStoreCollectionData class]};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _list = [NSMutableArray new];
    }
    return self;
}

- (NSString *)toUrl {
    self.page = self.willLoadMore ? self.page+1 : 1;
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v1/shop/collection_list?page=%ld"), (long)self.page];
    return url;
}

///商城热搜结果落地页
- (NSString *)toSearchUrl {
    self.page = self.willLoadMore ? self.page+1 : 1;
    return COMMUNITY_FILE_BASE_STRING(@"/v1/shop/search");
}

- (void)configModel:(CStoreCollectionModel *)model {
    if (!model) return;
    //if (model.list.count <= 0) return;
    
    //设置图片布局
    CGFloat imgWidth = (kScreenWidth-25)/2;
    [model.list enumerateObjectsUsingBlock:^(CStoreCollectionData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.coverImgInfo.width <= 0 || obj.coverImgInfo.height <= 0) {
            obj.imgHeight = imgWidth;
        } else {
            CGFloat whRatio = (obj.coverImgInfo.width / obj.coverImgInfo.height);
            whRatio = [[NSString stringWithFormat:@"%.2f", whRatio] floatValue];
            if (whRatio >= 1) {
                obj.imgHeight = imgWidth;
            } else if (whRatio < 0.75) {
                obj.imgHeight = imgWidth*4/3;
            } else {
                obj.imgHeight = imgWidth/whRatio;
            }
        }
    }];
    
    if (self.willLoadMore) {
        [_list addObjectsFromArray:model.list];
    } else {
        _list = [NSMutableArray arrayWithArray:model.list];
    }
    
    self.canLoadMore = model.list.count > 0;
}

@end


@implementation CStoreCollectionData

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"coverImgInfo" : @"cover_img"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"coverImgInfo" : [CStoreCollectionCoverImageInfo class]
    };
}

@end


@implementation CStoreCollectionCoverImageInfo

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"imgUrl" : @"url"};
}

- (void)setImgUrl:(NSString *)imgUrl {
    //url中文转码
    _imgUrl = [imgUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
