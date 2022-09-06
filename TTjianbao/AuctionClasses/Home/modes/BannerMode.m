//
//  BannerMode.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/14.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "BannerMode.h"

@implementation BannerMode

@end

@implementation TargetModel

- (NSString *)recordComponentName {
    NSString *name = self.vc ?: self.componentName;
    if ([self.componentName isEqualToString:@"JHWebViewController"] || [self.vc isEqualToString:@"JHWebViewController"]) {
        name = self.params[@"urlString"];
    }
    return name;
}
@end

@implementation BannerCustomerModel

- (void)setImage:(NSString *)image {
    //url中文转码
    _image = [image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
