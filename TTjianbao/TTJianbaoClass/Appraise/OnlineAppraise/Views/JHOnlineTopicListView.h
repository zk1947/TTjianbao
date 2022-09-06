//
//  JHOnlineTopicListView.h
//  TTjianbao
//
//  Created by lihui on 2020/12/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 在线鉴定首页 - 中间显示话题列表的cell部分

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHOnlineTopicIconType) {
    ///显示图片
    JHOnlineTopicIconTypeImg,
    ///显示文字
    JHOnlineTopicIconTypeText,
};

@interface JHOnlineTopicListView : UIView
- (void)setIcon:(NSString *)icon name:(NSString *)name iconType:(JHOnlineTopicIconType)iconType;
- (void)topicCellClick:(dispatch_block_t)block;
@end

NS_ASSUME_NONNULL_END
