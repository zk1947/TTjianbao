//
//  JHPostDetailEventManager.h
//  TTjianbao
//
//  Created by lihui on 2020/9/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHPostDetailEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class JHCommentModel;

UIKIT_EXTERN NSString *const kUpdateCommentInfoNotification;

@interface JHPostDetailEventManager : NSObject

/// 查看大图
/// @param sourceViews 展示图片的view数组
/// @param index 当前选中的下标
+ (void)browseBigImage:(NSArray <UIImageView *>*)sourceViews
           thumbImages:(NSArray <NSString *>*)thumbImages
          mediumImages:(NSArray <NSString *>*)mediumImages
          originImages:(NSArray <NSString *>*)originImages
           selectIndex:(NSInteger)index;


/// 处理帖子详情中的点击事件
/// @param type 事件类型
/// @param commentInfo 评论数据信息
/// @param contentView 点击的控件
+ (void)handleActionEvent:(JHPostDetailActionType)type
              commentInfo:(JHCommentModel *)commentInfo
              contentView:(id)contentView;


- (void)handleFullScreenControlAction:(JHFullScreenControlActionType)actionType ;

///分享
- (void)toShare;

@end

NS_ASSUME_NONNULL_END
