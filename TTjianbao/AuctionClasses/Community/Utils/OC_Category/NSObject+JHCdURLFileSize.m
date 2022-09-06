//
//  NSObject+JHCdURLFileSize.m
//  TTjianbao
//
//  Created by lihui on 2020/7/31.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "NSObject+JHCdURLFileSize.h"

@implementation NSObject (JHCdURLFileSize)

+ (void)URLFileSizeWidthURL:(NSString *)URL fileSize:(SizeBlock)fileSize{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL parameters:@{} headers:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *dic = [(NSHTTPURLResponse *)task.response allHeaderFields];
        CGFloat length = [[dic objectForKey:@"Content-Length"] floatValue];// Content-Length单位是byte，除以1024后是KB
        NSString *size;
        if (length >= 1048576) {//1048576bt = 1M  小于1m的显示KB 大于1m显示M
            size = [NSString stringWithFormat:@"%.2fM",length/1024/1024];
        }else{
            size = [NSString stringWithFormat:@"%.1fKB",length/1024];
        }
        if (fileSize) {
            fileSize(size);
        }
    }];
}

@end
