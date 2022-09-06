//
//  JHSQUploadManager.m
//  TTjianbao
//
//  Created by wangjianios on 2020/6/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQUploadManager.h"
#import "JHSQApiManager.h"
#import "JHSQModel.h"

@implementation JHSQUploadManager

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    static JHSQUploadManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [JHSQUploadManager new];
    });
    return instance;
}

-(NSMutableArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

///发布模型
+(void)addModel:(JHSQUploadModel *)model
{
    model.status = JHSQUploadStatusUploading;
    [[JHSQUploadManager shareInstance].dataArray addObject:model];
    
    JHPostData *data = [JHSQUploadManager resolveLocalPostInfo:model];
    [JHSQUploadManager shareInstance].localPostInfo = data;
    
    [self reload];
    [model start];
}

///保存草稿箱
+ (JHPostData *)resolveLocalPostInfo:(JHSQUploadModel *)model {
    ///将刚发布的帖子记录下来 用于推荐 热帖 版块 版块列表 话题列表的数据展示
    JHPostData *data = [[JHPostData alloc] init];
    data.item_type = JHPostItemTypeLocalPost;
    data.localPost = model;
    return data;
}

///删除模型
+(void)removeModel:(JHSQUploadModel *)model
{
    [[JHSQUploadManager shareInstance].dataArray removeObject:model];
    [self reload];
}

///更新
+(void)reload
{
    if([JHSQUploadManager shareInstance].changeBlock)
    {
        [JHSQUploadManager shareInstance].changeBlock();
    }
}

+ (void)updatePostInfoPublishedByNow:(dispatch_block_t)block {
    [JHSQApiManager getPostDetailInfoPublishByNow:^(JHPostData *data, BOOL hasError) {
        if (!hasError) {
            [JHSQUploadManager shareInstance].localPostInfo = data;
        }
        if (block) {
            block();
        }
    }];
}

+ (BOOL)isWithinOneSecond {
    BOOL isNeed = NO;
    NSTimeInterval currentTime = [[CommHelp getCurrentTimeString] longLongValue];
    NSTimeInterval publishTime = [JHSQUploadManager shareInstance].publishTime;
    NSTimeInterval interval = (currentTime - publishTime);
    if (interval/1000 <= 60) {
        ///一分钟以内
        isNeed = YES;
    }
    
    [JHSQUploadManager shareInstance].isWithSecond = isNeed;
    
    return isNeed;
}

@end
