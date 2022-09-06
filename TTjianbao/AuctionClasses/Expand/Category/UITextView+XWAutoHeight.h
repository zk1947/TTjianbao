//
//  UITextView+XWAutoHeight.h
//  XWTextViewAutoHeight
//
//  简书主页:https://www.jianshu.com/u/aab8d2e03384
//  Created by bill on 2018/12/5.
//  Copyright © 2018 bill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef UITEXTVIEW_XWAUTOHEIGHT
#define UITEXTVIEW_XWAUTOHEIGHT

typedef void(^XWChangeHeightBlock)(CGFloat height);

#endif

@interface UITextView (XWAutoHeight)

/**
 开启自动改变高度
 
 @param minHeight 最小高度，传0为文字的最小高度
 @param maxHeight 最大高度，传0为不限制高度
 @param changeHeightBlock textview高度改变的回调
 */
- (void)autoChangeWithMinHeight:(CGFloat)minHeight maxHeight:(CGFloat)maxHeight changeBlock:(XWChangeHeightBlock)changeHeightBlock;

@end

NS_ASSUME_NONNULL_END
