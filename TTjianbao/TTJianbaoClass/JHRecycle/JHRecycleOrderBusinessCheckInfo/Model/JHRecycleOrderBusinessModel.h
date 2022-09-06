//
//  JHRecycleOrderBusinessModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class JHRecycleOrderBusinessImageInfo;
@interface JHRecycleOrderBusinessModel : NSObject
/// 备注
@property (nonatomic, copy) NSString *remark;
/// 图片
@property (nonatomic, strong) NSArray<JHRecycleOrderBusinessImageInfo *> *imageList;
/// 视频封面
@property (nonatomic, strong) JHRecycleOrderBusinessImageInfo *coverPicture;
/// 视频地址
@property (nonatomic, copy) NSString *videoUrl;

@end


@interface JHRecycleOrderBusinessImageInfo : NSObject

@property (nonatomic, copy) NSString *medium;
@property (nonatomic, copy) NSString *big;
@property (nonatomic, copy) NSString *origin;
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;
@end


NS_ASSUME_NONNULL_END
