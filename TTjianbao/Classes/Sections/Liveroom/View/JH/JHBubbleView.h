//
//  JHBubbleView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/5/7.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, JHBubbleViewType){
    JHBubbleViewTypeShare,
    JHBubbleViewTypeLight,
    JHBubbleViewTypeFreeGift,
    JHBubbleViewTypeComment,
    JHBubbleViewTypeFollow,
    JHBubbleViewTypeWaitMic,
    JHBubbleViewTypeVoteAndGuess
};

typedef NS_ENUM(NSInteger, JHBubbleViewArrowDirection){
    JHBubbleViewArrowDirectionenTopCenter,
    JHBubbleViewArrowDirectionenBottomCenter,
    JHBubbleViewArrowDirectionenBottomRight,
     JHBubbleViewArrowDirectionenTopRight,
};
@interface JHBubbleView : BaseView
-(void)setTitle:(NSString*)title andArrowDirection:(JHBubbleViewArrowDirection)direction;
- (void)setTitle:(NSString*)title andArrowDirection:(JHBubbleViewArrowDirection)direction click:(JHActionBlock)action;
@property(assign,nonatomic) BOOL showCancleBtn;
@property(assign,nonatomic) BOOL bubbleUserInteractionEnabled;
@end

NS_ASSUME_NONNULL_END
