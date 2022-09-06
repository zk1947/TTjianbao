//
//  JHChatKeyBoardView.h
//  TTjianbao
//
//  Created by YJ on 2021/1/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickPhotoBlock)(BOOL isYes);
typedef void(^ClickSendBlock)(NSString *text);

@class JHChatKeyBoardView;

@protocol JHChatKeyBoardViewDelegate <NSObject>

//- (void)chatKeyBoardiewWithoriginY:(CGFloat)originY resetFrame:(BOOL)isYes;
- (void)chatKeyBoardiewWithoriginY:(CGFloat)originY keyBoardHeight:(CGFloat)height resetFrame:(BOOL)isYes;

@end

@interface JHChatKeyBoardView : UIView

@property (copy, nonatomic) ClickPhotoBlock block;
@property (copy, nonatomic) ClickSendBlock  sendBlock;
@property (weak, nonatomic) id<JHChatKeyBoardViewDelegate>delegate;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
