//
//  JHStoreHomeCardModel.m
//  TTjianbao
//
//  Created by lihui on 2020/3/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeCardModel.h"
#import "JHGoodsInfoMode.h"
#import "UIImage+JHImageSize.h"
#import "UIImageView+JHWebImage.h"

@implementation JHStoreHomeNewPeopleModel
@end


@implementation JHStoreHomeCardModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"cardInfo" : @"card_info",
    };
}


@end

@implementation JHStoreHomeCardInfoModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"showcaseList" : @"sc_infos",
             @"goodsList" : @"goods_list",
             @"nextGoodsList":@"next_goods_list",
    };
}

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"showcaseList" : [JHStoreHomeShowcaseModel class],
             @"goodsList" : [JHGoodsInfoMode class],
             @"nextGoodsList":[JHGoodsInfoMode class],
    };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _showcaseList = [NSMutableArray array];
        _goodsList = [NSMutableArray array];
        _nextGoodsList = [NSMutableArray array];
    }
    return self;
}

@end

@implementation JHStoreHomeShowcaseModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _isEndCurrentSeckill = NO;
    }
    return self;
}

- (void)setBg_img:(NSString *)bg_img {
    _bg_img = [bg_img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    ///计算图片高度
//    CGSize imgSize = [UIImage getImageSizeWithURL:_bg_img];
//    _imgHeight = (ScreenW-20)*imgSize.height/imgSize.width+10;
}

- (void)setHead_img:(NSString *)head_img {
    //url中文转码
    _head_img = [head_img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
