//
//  JHBrowserModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBrowserModel : NSObject
/// 缩略图
@property (nonatomic, copy) NSString *thumbImageUrl;
/// 原图
@property (nonatomic, copy) NSString *imageUrl;
/// 原图
@property (nonatomic, strong) UIImage *image;
/// 视频播放地址
@property (nonatomic, copy) NSString *mediaUrl;
@end

NS_ASSUME_NONNULL_END
