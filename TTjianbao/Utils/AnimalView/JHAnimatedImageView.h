//
//  JHAnimatedImageView.h
//  TTjianbao
//
//  Created by wangjianios on 2021/1/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "YYAnimatedImageView.h"

NS_ASSUME_NONNULL_BEGIN

/// 支持gif webp svga
@interface JHAnimatedImageView : YYAnimatedImageView

- (void)jh_setImageWithUrl:(NSString *)imageUrl placeholder:(NSString * __nullable)placeholder;

- (void)jh_setImageWithUrl:(NSString *)imageUrl;

@end

NS_ASSUME_NONNULL_END
