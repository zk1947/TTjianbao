//
//  JHSellerInfo.m
//  TTjianbao
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSellerInfo.h"
#import "JHGoodsInfoMode.h"

@interface JHSellerInfo ()

@property (nonatomic, assign) CGFloat maxHeight;

@end


@implementation JHSellerInfo


- (instancetype)init {
    self = [super init];
    if (self) {
        _maxHeight = 0;
    }
    return self;
}

- (void)setGoodsArray:(NSArray<JHGoodsInfoMode *> *)goodsArray {
    _goodsArray = goodsArray;
    for (JHGoodsInfoMode *model in _goodsArray) {
        if (model.titleHeight > _maxHeight) {
            _maxHeight = model.titleHeight;
        }
    }
    CGFloat itemWidth = (ScreenW - 40) / 3;
    _cellheight = _maxHeight + itemWidth + 55 + 25;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"goodsArray" : @"goods_list"
    };
}

/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"goodsArray" : [JHGoodsInfoMode class]
    };
}


- (void)setHead_img:(NSString *)head_img {
    _head_img = [head_img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setBg_img:(NSString *)bg_img {
    _bg_img = [bg_img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}


@end

