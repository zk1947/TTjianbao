//
//  JHFollowBubbleImage.h
//  TTjianbao
//
//  Created by jiangchao on 2020/8/31.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHFollowBubbleImage : UIView
-(void)addFollowBubbleByView:(UIView*)view;
@property (nonatomic, copy) JHFinishBlock block;
@end

NS_ASSUME_NONNULL_END
