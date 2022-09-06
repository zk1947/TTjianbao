//
//  JHSearchTextfield.m
//  TTjianbao
//
//  Created by LiHui on 2020/2/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSearchTextfield.h"
#import "NSString+YYAdd.h"

@interface JHSearchTextfield () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *iconImageView; ///放大镜
@property (nonatomic, strong) UILabel *showLabel;   ///显示label
@property (nonatomic, strong) UILabel *hideLabel;   ///隐藏label

@property (nonatomic, strong) RACDisposable *racDisposable;
@property (nonatomic, assign) BOOL isShowing;  ///是否在正在显示label
@property (nonatomic, copy) void(^tapAction)(id);

@end

@implementation JHSearchTextfield

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = HEXCOLOR(0xF5F6FA);
        _currentIndex = 0;
        _isShowing = YES;
        [self initViews];
        
    }
    return self;
}

- (void)initViews {
    
    _iconImageView = ({
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dis_glasses"]];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV;
    });
    
    _showLabel = ({
        UILabel *phLabel = [[UILabel alloc] init];
        phLabel.text = @"";
        phLabel.textColor = HEXCOLOR(0x999999);
        phLabel.textAlignment = NSTextAlignmentLeft;
        phLabel.font = [UIFont fontWithName:kFontNormal size:13];
        phLabel;
    });
    
    _hideLabel = ({
        UILabel *phbLabel = [[UILabel alloc] init];
        phbLabel.text = @"";
        phbLabel.textColor = HEXCOLOR(0x999999);
        phbLabel.textAlignment = NSTextAlignmentLeft;
        phbLabel.font = [UIFont fontWithName:kFontNormal size:13];
        phbLabel;
    });
    
    _searchTextField = ({
        UITextField *textfield = [[UITextField alloc] init];
        textfield.text = @"";
        textfield.font = [UIFont fontWithName:kFontNormal size:13];
        textfield.textColor = HEXCOLOR(0x666666);
        textfield.returnKeyType = UIReturnKeySearch;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        textfield.delegate = self;
        [self addSubview:textfield];
        [textfield addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [textfield addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        textfield;
    });
    
    [self addSubview:_iconImageView];
    [self addSubview:_showLabel];
    [self addSubview:_hideLabel];
    [self addSubview:_searchTextField];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(7);
        make.bottom.mas_equalTo(-7);
        make.width.mas_equalTo(13);
    }];
    
    [_showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(6);
        make.right.equalTo(self);
        make.height.mas_equalTo(self.height-4);
        make.centerY.equalTo(self);
    }];
    
    [_hideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(6);
        make.right.equalTo(self);
        make.height.equalTo(self.showLabel.mas_height);
        make.centerY.equalTo(self).offset(self.height);
    }];
    
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(6);
        make.right.equalTo(self);
        make.height.mas_equalTo(self.height-4);
        make.centerY.equalTo(self);
    }];
    
//    [self.searchTextField addObserver:self forKeyPath:@"searchTextField.text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"text"]) {
//        if (self.searchTextField.text.length != 0) {
//            [self hidePlaceholder];
//        }
//    }
//}

#pragma mark - textfield 监听事件
- (void)textFieldDidBegin:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTextFieldDidBegin:)]) {
        [self.delegate searchTextFieldDidBegin:self];
    }
}

///textfield中的text改变
- (void)textFieldChanged:(UITextField *)textField {
    [self hidePlaceholder];

    ///当文字为0时
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTextfieldTextDidChange: searchFieldText:)]) {
        [self.delegate searchTextfieldTextDidChange:self searchFieldText:textField.text];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self hidePlaceholder];
    
    BOOL isClear = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTextfieldTextDidClear:)]) {
        isClear = [self.delegate searchTextfieldTextDidClear:self];
    }
    return isClear;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL isReturn = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTextfieldShouldReturn:)]) {
        isReturn = [self.delegate searchTextfieldShouldReturn:self];
    }
    return isReturn;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL isChange = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTextfieldShouldChangeCharactersInRange:searchTextField:)]) {
        isChange = [self.delegate searchTextfieldShouldChangeCharactersInRange:range searchTextField:self];
    }
    return isChange;
}

#pragma mark -
#pragma mark - setting/getting method
- (void)hidePlaceholder {
    if (_isShowing) {
        _showLabel.hidden = [_searchTextField.text isNotBlank];
    }
    else {
        _hideLabel.hidden = [_searchTextField.text isNotBlank];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (!textColor) { return; }
    _textColor = textColor;
    _searchTextField.textColor = _textColor;
}

- (void)setFont:(UIFont *)font {
    if (!font) {
        return;
    }
    _font = font;
    _searchTextField.font = _font;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (!placeholder) {
        return;
    }
    _placeholder = placeholder;
    if (_isShowing) {
        _showLabel.text = _placeholder;
    }
    else {
        _hideLabel.text = _placeholder;
    }
}

- (void)setPlaceholders:(NSArray *)placeholders {
    if (!placeholders) {
        return;
    }
    _placeholders = placeholders;
    _currentIndex = 0;
    _isShowing = YES;
    
    _showLabel.text = self.placeholders[_currentIndex++];
    _showLabel.hidden = [_searchTextField.text isNotBlank];
    _hideLabel.hidden = [_searchTextField.text isNotBlank];
        
    [_showLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
    }];
    
    if (_placeholders.count > 1) {
        [self startCycle];
    }
}

- (void)startCycle {
    //RAC中的GCD
    @weakify(self);
    _racDisposable = [[[RACSignal interval:15.f onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDate * _Nullable x) {
        @strongify(self);
        [self changeSearchPlaceholder];
    }];
}

- (void)changeSearchPlaceholder {
    if (_searchTextField.text.length) {
        return;
    }

    if (_currentIndex >= self.placeholders.count) {
        _currentIndex = 0;
    }
    
    if (_isShowing) {
        ///现在正在显示
        _hideLabel.text = self.placeholders[_currentIndex];
        [self showPlaceholderBottomLabel];
    }
    else {
        _showLabel.text = self.placeholders[_currentIndex];
        [self showPlaceholderLabel];
    }
        
    _currentIndex ++;
}

- (void)showPlaceholderLabel {
    _isShowing = YES;
    _showLabel.hidden = NO;
    
    [_showLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
    }];
    
    [_hideLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-self.height/2);
    }];
    
    //更新约束
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        _hideLabel.alpha = 0;
    } completion:^(BOOL finished) {
        _hideLabel.hidden = YES;
        _hideLabel.alpha = 1;
        [_hideLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(self.height);
        }];
    }];
}

- (void)showPlaceholderBottomLabel {
    _isShowing = NO;
    _hideLabel.hidden = NO;
    
    [_showLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-self.height/2);
    }];
    
    [_hideLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
    }];
    
    //更新约束
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        _showLabel.alpha = 0;
    } completion:^(BOOL finished) {
        _showLabel.hidden = YES;
        _showLabel.alpha = 1;
        [_showLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(self.height);
        }];
    }];
}

- (void)addTapBlock:(void(^)(id obj))tapAction {
    self.tapAction = tapAction;
    if (![self gestureRecognizers]) {
        self.searchTextField.userInteractionEnabled = NO;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}

- (void)tap {
    if (self.tapAction) {
        self.tapAction(self);
    }
}

- (void)dealloc {
    [_racDisposable dispose];
}


@end
