//
//  JHQuickCommentBar.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  动态贴cell：说点啥，点击进行评论的静态输入框
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHQuickCommentBar : UIView

@property (nonatomic, copy) dispatch_block_t didClickBlock;

+ (CGFloat)viewHeight;

- (void)updateAvatarIcon;

@end

NS_ASSUME_NONNULL_END
