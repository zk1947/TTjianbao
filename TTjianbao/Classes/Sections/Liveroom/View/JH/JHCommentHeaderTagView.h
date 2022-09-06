//
//  JHAudienceCommentHeaderTagView.h
//  TTjianbao
//
//  Created by jiang on 2019/6/25.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCommentHeaderTagView : BaseView
@property (nonatomic, copy) void (^finish)(CGFloat height);
@property (nonatomic, copy) JHActionBlock clickTagFinish;

//显示tag
- (void)showTagArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
