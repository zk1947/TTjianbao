//
//  JHBuyAppraiseModel.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBuyAppraiseModel.h"
@implementation JHAppraiseUrlModel
- (void)setThumbsPictureUrl:(NSString *)thumbsPictureUrl{
    _thumbsPictureUrl = [thumbsPictureUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
- (void)setMediumPictureUrl:(NSString *)mediumPictureUrl{
    _mediumPictureUrl = [mediumPictureUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
- (void)setLargePictureUrl:(NSString *)largePictureUrl{
    _largePictureUrl = [largePictureUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
@end
@implementation JHAppraiseUrlArrayModel
- (void)setThumbsPictureUrls:(NSArray *)thumbsPictureUrls{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *string in thumbsPictureUrls) {
        NSString *urlString = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [array addObject:urlString];
    }
    _thumbsPictureUrls = array;
}
- (void)setMediumPictureUrls:(NSArray *)mediumPictureUrls{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *string in mediumPictureUrls) {
        NSString *urlString = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [array addObject:urlString];
    }
    _mediumPictureUrls = array;
}
- (void)setLargePictureUrls:(NSArray *)largePictureUrls{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *string in largePictureUrls) {
        NSString *urlString = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [array addObject:urlString];
    }
    _largePictureUrls = array;
}
@end
@implementation JHAppraiseTrueModel

@end
@implementation JHAppraiseFalseModel

@end
@implementation JHAppraiseInfoModel

@end
@implementation JHBuyAppraiseModel

@end
