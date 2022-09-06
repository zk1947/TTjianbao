//
//  JHInputTextView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/7/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHInputTextView : UIView

///输入框内容
@property (nonatomic, strong) NSString *text;

///输入框提示
@property (nonatomic, strong) NSString *placeholder;

///最大字数
@property (nonatomic, assign) NSInteger maxWordsNumber;

/// 最大高度
@property (nonatomic, assign) NSInteger maxHeight;

/// 黑色蒙层
@property (nonatomic, assign) BOOL showBlackLayer;

/// 发送
@property (nonatomic, copy) void (^inputTextViewBlock)(NSString *text);

- (void)starInput;

@end

NS_ASSUME_NONNULL_END
