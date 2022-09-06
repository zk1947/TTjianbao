//
//  JHChatMediaManager.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHChatFileLocationHelper.h"
#import "AVAsset+NIMKit.h"
#import <Photos/Photos.h>

typedef void(^ImageHandler)(UIImage * _Nullable image, UIImage * _Nullable thumbImage );
typedef void(^VideoHandler)(NSString * _Nullable localUrl, UIImage * _Nullable thumbImage );
typedef void(^AssetHandler)(NSString * _Nullable localUrl, UIImage * _Nullable image, UIImage *_Nullable thumbImage );

NS_ASSUME_NONNULL_BEGIN


@interface JHChatMediaManager : NSObject

@property (nonatomic, assign) ImageHandler imageHandler;
@property (nonatomic, assign) VideoHandler videoHandler;
+ (void)convertAsset : (PHAsset *)asset handler : (AssetHandler)handler;
+ (void)convertImage : (UIImage *)image handler : (ImageHandler)handler;
+ (void)convertVideo : (NSURL *)url handler : (VideoHandler)handler;

@end

NS_ASSUME_NONNULL_END
