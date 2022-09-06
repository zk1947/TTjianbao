//
//  JHCommentHelper.m
//  TTjianbao
//
//  Created by lihui on 2020/11/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCommentHelper.h"
#import "UIImage+GIF.h"
#import "TTjianbao.h"
#import "SDWebImageDownloader.h"
#import "JHWebImage.h"

@implementation JHCommentHelper

///根据图片的尺寸大小返回显示的文字
+ (NSString *)picImageTagName:(CGSize)size imageUrl:(NSString *)url  {
    if (size.width/2 >= PIC_W_MIN && size.height/2 >= 5*PIC_W_MIN) {
        return @"长图";
    }
    if ([url containsString:@".gif"]) {
        return @"GIF";
    }
    return nil;
}

+ (void)dowloadImageSource:(NSString *)imageUrl completationBLock:(void(^)(UIImage *imageSource))block {
    SDWebImageDownloaderOptions options = 0;
    // 方法一 SDWebImageDownloader下载
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:[NSURL URLWithString:imageUrl]
                             options:options
                            progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        UIImage *img = [UIImage sd_imageWithGIFData:data];
        if (block) {
            block(img);
        }
    }];
}


@end
