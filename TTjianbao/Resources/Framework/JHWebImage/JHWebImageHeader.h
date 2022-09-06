//
//  JHWebImageHeader.h
//  TTjianbao
//  Description:SDWebImage对应的头文件
//  Created by Jesse on 2020/11/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#ifndef JHWebImageHeader_h
#define JHWebImageHeader_h

#import <SDWebImage/SDWebImageDefine.h>

typedef void(^JHWebImageCallbackBlock)(void);
typedef void(^JHWebImageCompletionBlock)(UIImage* _Nullable image, NSError * _Nullable error);
typedef void(^JHWebImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, NSURL* _Nullable  targetURL);

#endif /* JHWebImageHeader_h */
