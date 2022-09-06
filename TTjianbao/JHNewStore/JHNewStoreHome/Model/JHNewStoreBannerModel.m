//
//  JHNewStoreBannerModel.m
//  TTjianbao
//
//  Created by user on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreBannerModel.h"

//@implementation BannerMode
//
//@end

@implementation JHNewStoreBannerTargetModel
@end

@implementation JHNewStoreBannerModel
- (void)setImage:(NSString *)image {
    /// url中文转码
    _image = [image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
@end
