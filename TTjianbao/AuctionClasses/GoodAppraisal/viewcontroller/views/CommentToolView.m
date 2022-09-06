//
//  CommentToolView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "CommentToolView.h"
#import "CommHelp.h"
#import "UIView+Toast.h"

@interface CommentToolView ()<UITextFieldDelegate>

@property(strong,nonatomic)  UIButton *commentBtn;

@property (nonatomic,   copy) NSString *commentStr;
@property (nonatomic, strong) NSArray *placeHolderArray;

@end

@implementation CommentToolView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.placeHolderArray = @[@"说点什么吧，怪无聊的",
                                  @"有爱评论，幸福你我他",
                                  @"写个评论吧，万一火了呢",
                                  @"想说就说，有啥不敢的",
                                  @"这个宝贝也太棒了，你觉得呢？",
                                  @"这里是评论区哦~",
                                  @"你敢评论么",
                                  @"你喜欢这个宝贝吗？说一下"];

        self.top=0;
        self.backgroundColor=[UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f] CGColor];
        [self setupSubviews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)setupSubviews {
    UIView *commentBackView = [[UIView alloc] init];
    commentBackView.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    commentBackView.layer.cornerRadius = 17.5;
    [self addSubview:commentBackView];
    
    //logo
    UIImageView *Logo = [[UIImageView alloc]init];
    Logo.image = [UIImage imageNamed:@"comment_logo"];
    Logo.contentMode = UIViewContentModeScaleAspectFit;
    [commentBackView addSubview:Logo];
    
    [commentBackView addSubview:self.commentTextField];
    
    [self addSubview:self.commentBtn];
    
    [commentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-100);
    }];
    
    [Logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(commentBackView);
        make.left.equalTo(commentBackView).offset(10);
    }];
    
    [_commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(commentBackView);
        make.left.equalTo(Logo.mas_right).offset(5);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(commentBackView);
        make.right.equalTo(self).offset(-15);
        make.width.equalTo(@62);
        make.height.equalTo(@31);
    }];
    
    RAC(self, commentBtn.enabled) =
    [RACSignal combineLatest:@[RACObserve(self, commentStr),
                               /*RACObserve(self, commentTextField.text)*/]
                      reduce:^id (NSString *str/*, NSString *fieldStr*/) {
        
        BOOL enabled = str.length > 0;
        /*
        if (![fieldStr isNotBlank]) {
            enabled = NO;
        }
         */
        return @(enabled);
    }];
}

- (UITextField*)commentTextField {
    if (!_commentTextField) {
        _commentTextField = [[UITextField alloc] init];
        _commentTextField.backgroundColor = [UIColor clearColor];
        _commentTextField.delegate = self;
        _commentTextField.font = [UIFont systemFontOfSize:16];
        _commentTextField.textColor = [UIColor blackColor];
        _commentTextField.returnKeyType = UIReturnKeySend;
        _commentTextField.textAlignment = UIControlContentHorizontalAlignmentCenter;
        
        NSUInteger r = arc4random_uniform((uint32_t)self.placeHolderArray.count);
        _commentTextField.placeholder = self.placeHolderArray[r];
        
        //为了kvo
        [_commentTextField addTarget:self
                              action:@selector(textValueChanged:)
                    forControlEvents:UIControlEventEditingChanged];
        
//        [_commentTextField addTarget:self
//                              action:@selector(editDidBegin:)
//                    forControlEvents:UIControlEventEditingDidBegin];
//
//        [_commentTextField addTarget:self
//                              action:@selector(editDidEnd:)
//                    forControlEvents:UIControlEventEditingDidEnd];
    }
    return _commentTextField;
}

- (UIButton*)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithTitle:@"发送" titleColor:kColor333];
        _commentBtn.clipsToBounds = YES;
        _commentBtn.layer.cornerRadius = 15.5;
        _commentBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
        [_commentBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        [_commentBtn setTitleColor:kColor999 forState:UIControlStateDisabled];
        [_commentBtn setBackgroundImage:[UIImage imageWithColor:kColorMain] forState:UIControlStateNormal];
        [_commentBtn setBackgroundImage:[UIImage imageWithColor:kColorMain] forState:UIControlStateHighlighted];
        [_commentBtn setBackgroundImage:[UIImage imageWithColor:kColorEEE] forState:UIControlStateDisabled];
        [_commentBtn addTarget:self action:@selector(Comment) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (void)becomeFirstRes {
    [self.commentTextField becomeFirstResponder];
}

- (void)Comment {
    if ([self.commentTextField.text length] <= 0) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"请输入评论内容" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (self.delegate) {
        [self.delegate OnClickComment:self.commentTextField.text];
        
        //为了kvo
        self.commentStr = @"";
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self autoMovekeyBoard:keyboardRect.size.height];
    
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self autoMovekeyBoard:0];
}

- (void)autoMovekeyBoard:(float)h {
    
    CGRect rect = self.frame;
    if (h > 0){
        rect.origin.y = ScreenH - self.top - rect.size.height - h;
    } else {
        rect.origin.y = ScreenH - self.top - 50;
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.commentTextField.text length] > 0) {
        if (self.delegate) {
            [self.delegate OnClickComment:self.commentTextField.text];

            //为了kvo
            self.commentStr = @"";
        }
    } else {
        [[UIApplication sharedApplication].keyWindow makeToast:@"请输入评论内容"
                                                      duration:1.0
                                                      position:CSToastPositionCenter];
    }
    
    return YES;
}

#pragma mark -
#pragma mark - UITextField Events
- (void)textValueChanged:(id)sender {
    self.commentStr = self.commentTextField.text;
}
- (void)editDidBegin:(id)sender {
    self.commentStr = self.commentTextField.text;
}

- (void)editDidEnd:(id)sender {
    self.commentStr = self.commentTextField.text;
}

@end
