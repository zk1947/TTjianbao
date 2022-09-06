//
//  JHSQUploadManager.h
//  TTjianbao
//
//  Created by wangjianios on 2020/6/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHSQUploadModel.h"

NS_ASSUME_NONNULL_BEGIN

@class JHPostData;

@interface JHSQUploadManager : NSObject

/// 动态发布数组
@property (nonatomic, strong) NSMutableArray *dataArray;
///上传的最后一篇帖子的数据信息标记
@property (nonatomic, strong) JHPostData *localPostInfo;
///帖子发布完成后的时间戳
@property (nonatomic, assign) NSTimeInterval publishTime;

@property (nonatomic, copy) dispatch_block_t changeBlock;

+ (instancetype)shareInstance;

+(void)addModel:(JHSQUploadModel *)model;

+(void)removeModel:(JHSQUploadModel *)model;

/// 更新数据
+(void)reload;

+ (void)updatePostInfoPublishedByNow:(dispatch_block_t)block;

///判断帖子是否是一分总内发出
+ (BOOL)isWithinOneSecond;
///是否在一分钟以内
@property (nonatomic, assign) BOOL isWithSecond;

@end

NS_ASSUME_NONNULL_END
