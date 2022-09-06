//
//  JHCustomTextField.m
//  TTjianbao
//
//  Created by apple on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHCustomTextField.h"

@interface JHCustomTextField ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, assign) CGFloat leftWidth;



@end

@implementation JHCustomTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        self.borderStyle = UITextBorderStyleNone;
        self.font = [UIFont fontWithName:kFontNormal size:15];
        [self addViews];
    }
    return self;
}

- (instancetype)initWithLeftWith:(CGFloat)leftWith {
    self = [super init];
    if (self) {
        _leftWidth = leftWith;
        self.borderStyle = UITextBorderStyleNone;
        self.font = [UIFont fontWithName:kFontNormal size:15];
        [self addViews];
    }
    return self;
}

- (void)setLeftText:(NSString *)leftText {
    _leftText = leftText;
    _leftLabel.text = _leftText;
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    _showBottomLine = showBottomLine;
    _bottomLineView.hidden = !_showBottomLine;
}

- (void)addViews {
    _leftLabel = [[UILabel alloc] init];
    _leftLabel.text = @"";
    _leftLabel.font = [UIFont fontWithName:kFontNormal size:15];
    self.leftView = _leftLabel;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = HEXCOLOR(0xF0F0F0);
    [self addSubview:_bottomLineView];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    return CGRectMake(0, 0, _leftWidth, self.bounds.size.height);
}

// 返回placeholderLabel的bounds，改变返回值，是调整placeholderLabel的位置
//- (CGRect)placeholderRectForBounds:(CGRect)bounds {
//    return CGRectMake(0, 0, 100, self.bounds.size.height);
//}

// 这个函数是调整placeholder在placeholderLabel中绘制的位置以及范围
//- (void)drawPlaceholderInRect:(CGRect)rect {
//    [super drawPlaceholderInRect:CGRectMake(0, 0, 100, self.bounds.size.height)];
//}

//
//- (CGRect)textRectForBounds:(CGRect)bounds {
//    return CGRectInset(bounds, 0, 0);
//}


@end
