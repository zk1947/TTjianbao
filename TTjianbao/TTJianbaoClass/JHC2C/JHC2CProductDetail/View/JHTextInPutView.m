//
//  JHTextInPutView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHTextInPutView.h"
#import "TTJianbao.h"
#import "JHUploadManager.h"
#import "YYKit.h"
#import "TZImagePickerController.h"
#import "JHPhotoBrowserManager.h"
#import "JHPreviewImageView.h"
#import "JHCommentHelper.h"
#import "JHAttributeStringTool.h"

@interface JHTextInPutView () <UITextViewDelegate, UINavigationControllerDelegate> {
    void(^_publishBlock)(NSDictionary *inputInfos);
}

@property (nonatomic, strong) UIView      *backgroundView;
@property (nonatomic, strong) UITextView  *inputTextView;
@property (nonatomic, strong) UILabel     *wordNumberLabel;
@property (nonatomic, strong) YYAnimatedImageView *selectImageView;
@property (nonatomic, strong) UIImage *selectImage;

@property (nonatomic, strong) UIView      *inputBgView;
@property (nonatomic, strong) UIView      *lineView;
@property (nonatomic, strong) UIButton    *deletePicButton;
@property (nonatomic, strong) UIButton    *sendButton;

///gif二进制数据
@property (nonatomic, strong) NSData *gifImageData;
/// biaoji
@property (nonatomic, copy) NSString *callTagString;


@property (nonatomic, assign) CGFloat inputMaxHeight;


@end

#define inputBgViewWidth      (self.bounds.size.width - 64.f)
#define inputBgViewHeight     (34.f)
#define inputTextViewHeight     (self.inputBgView.bounds.size.height-6.f)
#define singleLineTextHeight    18.f
#define wordsWidth              (50.f)


@implementation JHTextInPutView

static JHTextInPutView *_easyTextView = nil;

+ (void)showInputTextViewWithFontSize:(UIFont *)font limitNum:(NSInteger)limitNum inputBackgroundColor:(UIColor *)inputBackgroundColor maxNumbersOfLine:(NSInteger)maxNumbersOfLine currentViewController:(NSString *)currentViewController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JHTextInPutView *easyView = [[self alloc] initInputTextViewWithFontSize:font limitNum:limitNum inputBackgroundColor:(UIColor *)inputBackgroundColor maxNumbersOfLine:maxNumbersOfLine currentViewController:currentViewController];
        _easyTextView = easyView;
        [JHRootController.currentViewController.view addSubview:_easyTextView];
    });
}

- (JHTextInPutView *)initInputTextViewWithFontSize:(UIFont *)font limitNum:(NSInteger)limitNum inputBackgroundColor:(UIColor *)inputBackgroundColor maxNumbersOfLine:(NSInteger)maxNumbersOfLine currentViewController:(NSString *)currentViewController {
    JHTextInPutView *easyView = [[JHTextInPutView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    easyView.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:.5f];
    [easyView setupPropertys];
    easyView.font = font;
    easyView.limitNum = limitNum;
    easyView.bgColor = inputBackgroundColor;
    easyView.maxNumbersOfLine = maxNumbersOfLine;
    easyView.currenViewController = currentViewController;
    return easyView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _callTagString = nil;
        [self initViews];
        [self addObservers];
    }
    return self;
}

- (void)initViews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.userInteractionEnabled = YES;
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;
    self.font = [UIFont fontWithName:kFontNormal size:12.f];
    
    ///展示已选择的图片
    [self.backgroundView addSubview:self.selectImageView];
    [self.selectImageView addSubview:self.deletePicButton];
    [self.backgroundView addSubview:self.inputBgView];
    [self.inputBgView addSubview:self.inputTextView];
    [self.inputBgView addSubview:self.wordNumberLabel];
    [self.backgroundView addSubview:self.sendButton];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:250/255.0 alpha:1.0];
    [self.backgroundView addSubview:_lineView];
        
    ///layouts
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_bottom);
    }];
        
    [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backgroundView).offset(10.f);
        make.top.equalTo(self.backgroundView).offset(10);
        make.width.mas_equalTo(50.f);
        make.height.mas_equalTo(0.f);
    }];

    [_deletePicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.selectImageView);
        make.size.mas_equalTo(CGSizeMake(15.f, 15.f));
    }];

    [_inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backgroundView).offset(5.f);
        make.top.equalTo(self.selectImageView.mas_bottom).offset(5.f);
        make.width.mas_equalTo(inputBgViewWidth);
        make.height.mas_equalTo(inputBgViewHeight);
    }];

    [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backgroundView);
        make.size.mas_equalTo(CGSizeMake(63.f, 34.f));
        make.centerY.equalTo(self.inputBgView);
    }];

    [_wordNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputBgView).offset(-5);
        make.top.bottom.equalTo(self.inputBgView);
    }];

    [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputBgView).offset(10.);
        make.right.equalTo(self.wordNumberLabel.mas_left).offset(-5);
        make.top.equalTo(self.inputBgView).offset(3.f);
        make.bottom.equalTo(self.inputBgView).offset(-3.f);
    }];

    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backgroundView);
        make.top.equalTo(self.inputBgView.mas_bottom).offset(12.f);
        make.height.mas_equalTo(1.f);
        make.bottom.equalTo(self.backgroundView).offset(-1);
    }];
    
    self.inputBgView.backgroundColor = self.bgColor;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat textHeight = abs((int)self.inputTextView.contentSize.height) + 10;
//        NSInteger lines = [self getTextViewNumberOfLines];
        CGFloat inputViewHeight = inputBgViewHeight;
        if (textHeight > self.maxNumbersOfLine*17+20) {
            inputViewHeight = _inputMaxHeight;
        }
        else {
            inputViewHeight = textHeight;
            _inputMaxHeight = inputViewHeight;
        }
        
        if (textHeight < self.maxNumbersOfLine*17+20) {
            [self resolveLayouts:inputViewHeight];
        }
    }
    if ([keyPath isEqualToString:@"attributedText"]) {
        self.wordNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.inputTextView.attributedText.length, (long)_limitNum];
    }
}

- (void)setShowLimitNum:(BOOL)showLimitNum {
    _showLimitNum = showLimitNum;
    _wordNumberLabel.hidden = !_showLimitNum;
    NSString *limtStr = _showLimitNum
    ? [NSString stringWithFormat:@"0/%ld", (long)self.limitNum]
    : @"";
    _wordNumberLabel.text = limtStr;
}

- (void)show {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputTextView becomeFirstResponder];
    });
}

- (void)resolveLayouts:(CGFloat)textHeight {
    [self.inputBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textHeight);
    }];
    [self layoutIfNeeded];
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [_inputTextView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [_inputTextView addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - sendButton action

- (void)handleSendEvent {
    NSString *inputText = self.inputTextView.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    dispatch_async(dispatch_get_main_queue(), ^{
        [params setValue:inputText forKey:@"content"];
        _publishBlock(params.copy);
    });
    [self dismiss];
}

#pragma mark - deleteButton action
- (void)handleDeletePicEvent {
    NSLog(@"=== handleDeletePicEvent ===");
    self.selectImageView.image = nil;
    [self.selectImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.f);
    }];
    self.selectImageView.hidden = YES;
}

- (void)dismiss {
    [self endEditing:YES];
    [self.inputTextView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.top.equalTo(self.mas_bottom);
        }];
        [self layoutIfNeeded];
    }];
    [self removeFromSuperview];
}


#pragma mark - Album

#pragma mark -
#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSMutableAttributedString *toBeString = [textView.attributedText mutableCopy];

    if (_showLimitNum) {
//        NSString *toBeString = textView.text;
//        NSInteger numberOfWords = toBeString.length;
        NSInteger numberOfWords = toBeString.string.length;
        NSArray *currentar = [UITextInputMode activeInputModes];
        UITextInputMode *current = [currentar firstObject];
        NSString *wordString = nil;
        if ([current.primaryLanguage isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textView markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                NSInteger textLength = textView.attributedText.string.length;
                if (textLength > _limitNum) {
                    numberOfWords = _limitNum;
                }
                wordString = [NSString stringWithFormat:@"%ld/%ld", (long)numberOfWords, (long)_limitNum];
                textView.attributedText = [JHAttributeStringTool markAtBlue:toBeString.mutableCopy];
            }
            else {
                // 有高亮选择的字符串，则暂不对文字进行统计和限制
            }
        }
        else {
            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            NSInteger textLength = textView.attributedText.string.length;
            if (textLength > _limitNum) {
                numberOfWords = _limitNum;
            }
            wordString = [NSString stringWithFormat:@"%ld/%ld", (long)numberOfWords, (long)_limitNum];
            textView.attributedText = [JHAttributeStringTool markAtBlue:toBeString.mutableCopy];
        }
        NSLog(@"%@",textView.text);
        
        if ([wordString isNotBlank]) {
            _wordNumberLabel.text = wordString;
            _wordNumberLabel.textColor = toBeString.length < _limitNum ? self.limitNumColor : [UIColor redColor];
        }
    }
}


#pragma mark -
#pragma mark - keyboard observe Action
- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"keyboardWillShow:----- %@\n%@", self.currenViewController, NSStringFromClass([JHRootController.currentViewController class]));
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-keyboardRect.size.height);
        }];
        [self layoutIfNeeded];
    }];
    self.hidden = NO;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.top.equalTo(self.mas_bottom);
        }];
        [self layoutIfNeeded];
    }];
    self.hidden = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSInteger textLength = textView.attributedText.string.length;
    if (textLength > _limitNum && text.length > range.length) {
        return NO;
    }
    if ([text isEqualToString:@"\n"]){
        ///点击了键盘上的发送按钮 需要提交输入内容
        [self handleSendEvent];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    // 去掉键盘上面带有Done的toolBarView
    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    [textView setInputAccessoryView:topView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[self class]]) {
        return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.view == self) {  ///如果当前点击的是出=除父view以外的view 则不执行消失操作
            [self dismiss];
        }
    }
}

- (void)setupPropertys {
    self.bgColor           = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:250/255.0 alpha:1.0];
    self.limitNumColor     = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    self.font              = [UIFont fontWithName:kFontNormal size:13.f];
    self.placeholder       = @"";
    self.limitNum          = 200;
    self.minNumbersOfLine  = 1;
    self.maxNumbersOfLine  = 1;
    self.showLimitNum      = YES;
    self.showSelectPicture = YES;
    self.showSelectEmoj    = YES;
    self.currenViewController = @"";
}

#pragma mark -
#pragma mark - lazy loading

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectZero];
        _selectImageView.backgroundColor = HEXCOLOR(0xF5F6FA);
        _selectImageView.contentMode = UIViewContentModeScaleAspectFill;
        _selectImageView.layer.cornerRadius = 8.f;
        _selectImageView.layer.masksToBounds = YES;
        _selectImageView.clipsToBounds = YES;
        _selectImageView.userInteractionEnabled = YES;
        _selectImageView.hidden =YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preViewPicture)];
        [_selectImageView addGestureRecognizer:tapGesture];
    }
    return _selectImageView;
}

- (void)preViewPicture {
    NSLog(@"== preViewPicture ==");
    [_inputTextView resignFirstResponder];
    JHPreviewImageView *preView = [JHPreviewImageView preImageView:self.selectImage];
    [JHKeyWindow addSubview:preView];
    [preView show];
    @weakify(self);
    preView.completionBlock = ^{
        @strongify(self);
        [self show];
    };
}

- (UIButton *)deletePicButton {
    if (!_deletePicButton) {
        ///删除已选择的图片的按钮
        _deletePicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletePicButton setImage:[UIImage imageNamed:@"icon_input_pic_del"] forState:UIControlStateNormal];
        [_deletePicButton setImage:[UIImage imageNamed:@"icon_input_pic_del"] forState:UIControlStateHighlighted];
        [_deletePicButton addTarget:self action:@selector(handleDeletePicEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletePicButton;
}

- (UIView *)inputBgView {
    if (!_inputBgView) {
        _inputBgView = [[UIView alloc] init];
        _inputBgView.backgroundColor = self.bgColor;
        _inputBgView.clipsToBounds = YES;
        _inputBgView.layer.cornerRadius = inputBgViewHeight / 2.f;
        _inputBgView.layer.masksToBounds = YES;
    }
    return _inputBgView;
}

- (UITextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _inputTextView.backgroundColor = [UIColor clearColor];
        _inputTextView.font = self.font;
        _inputTextView.delegate = self;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.showsVerticalScrollIndicator = NO;
        _inputTextView.showsHorizontalScrollIndicator = NO;
    }
    return _inputTextView;
}

- (UIColor *)limitNumColor {
    return HEXCOLOR(0x999999);
}

- (UILabel *)wordNumberLabel {
    if (!_wordNumberLabel) {
        _wordNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _wordNumberLabel.text = [NSString stringWithFormat:@"0/%ld", (long)self.limitNum];
        _wordNumberLabel.textColor = self.limitNumColor;
        _wordNumberLabel.hidden = !self.showLimitNum;
        _wordNumberLabel.font = [UIFont systemFontOfSize:11.f];
        _wordNumberLabel.textAlignment = NSTextAlignmentRight;
    }
    return _wordNumberLabel;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_sendButton addTarget:self action:@selector(handleSendEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}


#pragma mark -
#pragma mark - setter / getter method

- (void)setFont:(UIFont *)font {
    _font = font;
    _inputTextView.font = _font;
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    _inputBgView.backgroundColor = _bgColor;
}

///发布内容
- (void)toPublish:(void(^)(NSDictionary *inputInfos))publishBlock {
    _publishBlock = publishBlock;
}

- (NSInteger)getTextViewNumberOfLines {
    NSString *str = self.inputTextView.text;
    UIFont *font = [UIFont systemFontOfSize:13.f];
    CGSize size = [str boundingRectWithSize:self.inputTextView.contentSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    NSInteger lines = (NSInteger)(size.height / font.lineHeight);
    return lines;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromSuperview];
}

@end
