//
//  JHIdentificationDetailsModel.m
//  TTjianbao
//
//  Created by miao on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIdentificationDetailsModel.h"
#import "NSString+UISize.h"

@implementation JHIdentificationDetailsModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"images" : [JHIdentDetailImageOrVideoModel class],
        @"videos" : [JHIdentDetailImageOrVideoModel class],
    };
}

-(void)setProductDesc:(NSString *)productDesc {
    _productDesc = productDesc;
    CGFloat descHight = [_productDesc getStringHeight:JHFont(16) width:kScreenWidth-24 size:0];
    _introduceHeight = isEmpty(_productDesc) ? 72 : descHight + 88;
}
- (NSString *)showAppraisalFeeYuan {
    return [NSString stringWithFormat:@"¥%@",self.appraisalFeeYuan];;
}

- (NSString *)showCategoryName{
    NSString *categoryName = [NSString stringWithFormat:@"%@-%@",self.categoryFirstName,self.categorySecondName];
    return categoryName;
}

- (NSArray<JHIdentDetailImageOrVideoModel *> *)imagesAndVideosAll {
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:1];
    if (self.images.count > 0) {
        [list addObjectsFromArray:self.images];
    }
    if (self.videos.count > 0) {
        [list addObjectsFromArray:self.videos];
    }
    return list.copy;
}

@end

@implementation JHIdentDetailImageOrVideoModel

- (BOOL)isVideo {
    return isEmpty(self.url) ? NO : YES;
}

- (NSString *)showImageUrl {
    return self.isVideo ? self.converUrl : self.medium;
}

- (CGFloat)aNewHeight {
    if (self.isVideo) {
        return (kScreenWidth-24)*9/16;
    }
    CGFloat width = [self.w floatValue];
    CGFloat height = [self.h floatValue];
    if (width <= 0 || height <= 0) {
        return 0.f;
    }
    if (width == height) {
        return [self iamgeNeedWidth];
    }
    CGFloat whRatio = (width / height);
    whRatio = [[NSString stringWithFormat:@"%.2f", whRatio] floatValue];
    if (whRatio >= 1) {
        return [self iamgeNeedWidth];
    }
    return [self iamgeNeedWidth]/whRatio;
    
}

- (CGFloat)iamgeNeedWidth {
    return ScreenW - 24;
}

@end
