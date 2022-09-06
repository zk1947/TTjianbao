//
//  JHCommentHelper.h
//  TTjianbao
//
//  Created by lihui on 2020/11/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kCommentPicCorner  8.f
#define COMMENT_PIC_W      (98.f)
#define PIC_W_MIN          (300.f)

@interface JHCommentHelper : NSObject

///根据图片尺寸返回需要显示的文字
+ (NSString *)picImageTagName:(CGSize)size imageUrl:(NSString *)url;

///下载图片
+ (void)dowloadImageSource:(NSString *)imageUrl completationBLock:(void(^)(UIImage *imageSource))block;

@end

NS_ASSUME_NONNULL_END
