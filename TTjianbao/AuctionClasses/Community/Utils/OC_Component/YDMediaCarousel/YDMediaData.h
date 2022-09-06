//
//  YDMediaData.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  媒体数据
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDMediaData : NSObject

/** 是否是视频 */
@property (nonatomic, assign) BOOL isVideo;
/** 视频地址 */
@property (nonatomic, copy) NSString *videoUrl;
/** 图片地址 */
@property (nonatomic, copy) NSString *imageUrl;

@end

NS_ASSUME_NONNULL_END
