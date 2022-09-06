//
//  JHBubbleWindow.h
//  TTjianbao
//  Description:Bubble外点击可以消失
//  Created by Jesse on 2019/12/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBubbleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBubbleWindow : UIButton

@property (nonatomic, strong) JHBubbleView* bubbleView;

- (void)setText:(NSString*)text click:(JHActionBlock)action;

@end

NS_ASSUME_NONNULL_END
