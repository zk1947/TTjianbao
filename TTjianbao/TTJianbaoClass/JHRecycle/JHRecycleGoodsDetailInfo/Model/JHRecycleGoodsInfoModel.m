//
//  JHRecycleGoodsInfoModel.m
//  TTjianbao
//
//  Created by user on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleGoodsInfoModel.h"

@implementation JHRecycleDetailInfoImageUrlModel
- (CGFloat)aNewHeight {
    CGFloat width  = [self.w floatValue];
    CGFloat height = [self.h floatValue];
    if (width <= 0 || height <= 0) {
        return 0.f;
    }
    if (width == height) {
        return [self imageNeedWidth];
    }
    CGFloat whRatio = (width / height);
    whRatio = [[NSString stringWithFormat:@"%.2f", whRatio] floatValue];
    if (whRatio >= 1) {
        return [self imageNeedWidth];
    } else if (whRatio < 0.75) {
        return [self imageNeedWidth]*4/3;
    } else {
        return [self imageNeedWidth]/whRatio;
    }
}

- (CGFloat)imageNeedWidth {
    return ScreenW;
}
@end


@implementation JHRecycleDetailInfoProductImgUrlsModel

@end

@implementation JHRecycleDetailInfoProductDetailUrlsModel

@end


@implementation JHRecycleGoodsInfoModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"productImgUrls" : [JHRecycleDetailInfoProductImgUrlsModel class],
        @"productDetailUrls" : [JHRecycleDetailInfoProductDetailUrlsModel class]
    };
}

- (NSArray<NSString *> *)productDetailMedium {
    return [self.productDetailUrls jh_map:^id _Nonnull(JHRecycleDetailInfoProductDetailUrlsModel * _Nonnull obj, NSUInteger idx) {
        return obj.detailImageUrl.medium;
    }];
}

- (NSArray<NSString *> *)productDetailOrigin {
    return [self.productDetailUrls jh_map:^id _Nonnull(JHRecycleDetailInfoProductDetailUrlsModel * _Nonnull obj, NSUInteger idx) {
        return obj.detailImageUrl.origin;
    }];
}

@end
