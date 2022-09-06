//
//  JHSQMessageShowView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/7/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSQMessageShowView : UIView

/// 消息类型: 0清空消息    1评论消息     2点赞消息
+ (void)showType:(NSInteger)type changeNum:(NSInteger)changeNum addToSuperView:(UIView *)view;

+ (CGSize)viewSize;

@end

NS_ASSUME_NONNULL_END
