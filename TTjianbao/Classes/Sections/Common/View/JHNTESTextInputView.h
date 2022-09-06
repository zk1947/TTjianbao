//
//  JHNTESTextInputView.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "NTESTextInputView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNTESTextInputView : BaseView

@property (nonatomic, strong) NTESGrowingTextView *textView;
@property (nonatomic, assign) BOOL  ignoreCheck; //是否忽略敏感词过滤；
@property (nonatomic, assign) NSInteger maxLength; //允许输入的最大长度，默认200
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic,weak) id<NTESTextInputViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
