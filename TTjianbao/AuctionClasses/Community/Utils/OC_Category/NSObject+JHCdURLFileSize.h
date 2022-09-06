//
//  NSObject+JHCdURLFileSize.h
//  TTjianbao
//
//  Created by lihui on 2020/7/31.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SizeBlock)(NSString *size);


@interface NSObject (JHCdURLFileSize)

/**
 通过连接获取文件大小

 @param URL 链接
 @param fileSize 文件大小
 */
+ (void)URLFileSizeWidthURL:(NSString *)URL
                   fileSize:(SizeBlock)fileSize;

@end

NS_ASSUME_NONNULL_END
