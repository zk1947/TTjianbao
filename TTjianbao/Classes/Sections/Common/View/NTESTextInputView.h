//
//  NTESTextInputView.h
//  TTjianbao
//
//  Created by chris on 16/3/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESGrowingTextView.h"

@protocol NTESTextInputViewDelegate <NSObject>

@optional

- (void)didSendText:(NSString *)text;

- (void)willChangeHeight:(CGFloat)height;

- (void)didChangeHeight:(CGFloat)height;

@end

#import "BaseView.h"

typedef NS_ENUM(NSInteger,NTESTextInputViewType){
    NTESTextInputViewTypeDefault,  //默认不带表情
    NTESTextInputViewTypeEmoji
};

@interface NTESTextInputView : BaseView

@property (nonatomic, strong) NTESGrowingTextView *textView;

@property (nonatomic, strong) NTESGrowingInternalTextView *textViewnew; //表情键盘使用

@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) BOOL  ignoreCheck; //是否忽略敏感词过滤；
@property (nonatomic, assign) NSInteger maxLength; //允许输入的最大长度，默认200

@property (nonatomic,weak) id<NTESTextInputViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withType:(NTESTextInputViewType)showType;
@end
