//
//  JHRecycleTemplateImageModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleTemplateImageModel.h"

@implementation JHRecycleTemplateImageModel

- (void)getOriginalImageHandle : (ImageHandle) handle {
    if (self.asset == nil) return ;
    
    [PHImageManager.defaultManager requestImageForAsset:self.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result == nil) return;
        handle(result);
    }];
}
@end
