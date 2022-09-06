//
//  CodeInputView.m
//  JDZBorrower
//
//  Created by WangXueqi on 2018/4/20.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "CodeInputView.h"
#import "CALayer+Category.h"

#define K_W 55
#define K_Screen_Width               [UIScreen mainScreen].bounds.size.width
#define K_Screen_Height              [UIScreen mainScreen].bounds.size.height

@interface CodeInputView()<UITextFieldDelegate>
@property(nonatomic,strong)NSString * textViewOldText;
@property(nonatomic,strong)UITextField * textView;
@property(nonatomic,strong)NSMutableArray <CAShapeLayer *> * lines;
@property(nonatomic,strong)NSMutableArray <UILabel *> * labels;
@property(nonatomic,strong)NSMutableArray <UIButton *> * buttons;
@end

@implementation CodeInputView

- (instancetype)initWithFrame:(CGRect)frame inputType:(NSInteger)inputNum selectCodeBlock:(SelectCodeBlock)CodeBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.CodeBlock = CodeBlock;
        self.inputNum = inputNum;
        [self initSubviews];
    
    }
    return self;
}

- (void)initSubviews {
    CGFloat W = CGRectGetWidth(self.frame);
    CGFloat H = CGRectGetHeight(self.frame);
    CGFloat Padd = 20;
    [self addSubview:self.textView];
    self.textView.backgroundColor=[UIColor clearColor];
    self.textView.frame = CGRectMake(Padd, 0, W-Padd*2, H);
    //默认编辑第一个.
    [self beginEdit];
    for (int i = 0; i < _inputNum; i ++) {
//        UIView *subView = [UIView new];
//        subView.frame = CGRectMake(Padd+(K_W+Padd)*i, 0, K_W, H);
//        subView.userInteractionEnabled = NO;
//        subView.backgroundColor=[UIColor redColor];
//        [self addSubview:subView];
        
         UIButton *subView=[UIButton buttonWithType:UIButtonTypeCustom];
         subView.frame = CGRectMake(40+(K_W+Padd)*i, 0, K_W, H);
          subView.userInteractionEnabled = NO;
         [subView setBackgroundColor:[UIColor clearColor]];
         [subView setBackgroundImage:[UIImage imageNamed:@"codeInput_Nomal"] forState:UIControlStateNormal];//
         [subView setBackgroundImage:[UIImage imageNamed:@"codeInput_select"] forState:UIControlStateSelected];//
         [self addSubview:subView];
        if (i==0) {
             [subView setSelected:YES];
        }
        
       // [CALayer addSubLayerWithFrame:CGRectMake(0, H-2, K_W, 2) backgroundColor:[UIColor lightGrayColor] backView:subView];
        //Label
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, K_W, H);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HEXCOLOR(0x333333);
        label.font = [UIFont systemFontOfSize:38];
        [subView addSubview:label];
        //光标
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(K_W / 2, 15, 2, H - 30)];
        CAShapeLayer *line = [CAShapeLayer layer];
        line.path = path.CGPath;
        line.fillColor =  HEXCOLOR(0xfede00).CGColor;
        [subView.layer addSublayer:line];
        if (i == 0) {
            [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            //高亮颜色
            line.hidden = NO;
        }else {
            line.hidden = YES;
        }
        //把光标对象和label对象装进数组
        [self.lines addObject:line];
        [self.labels addObject:label];
        [self.buttons addObject:subView];
    }
}

-(void)textFieldTextChange:(UITextField *)textField{
    
    NSString *verStr = textField.text;
    if([verStr isEqualToString:self.textViewOldText])
        return;
    self.textViewOldText = verStr;
    if (verStr.length > _inputNum) {
       textField.text = [textField.text substringToIndex:_inputNum];
    }
    //大于等于最大值时, 结束编辑
    if (verStr.length >= _inputNum) {
        [self endEdit];
    }
    if (self.CodeBlock) {
        self.CodeBlock(textField.text);
    }
    for (int i = 0; i < _labels.count; i ++) {
        UILabel *bgLabel = _labels[i];
        
        if (i < verStr.length) {
            [self changeViewLayerIndex:i linesHidden:YES];
            bgLabel.text = [verStr substringWithRange:NSMakeRange(i, 1)];
            [self.buttons[i] setSelected:YES];
        }else {
            [self changeViewLayerIndex:i linesHidden:i == verStr.length ? NO : YES];
            [self.buttons[i] setSelected:NO];
            //textView的text为空的时候
            if (!verStr && verStr.length == 0) {
                [self changeViewLayerIndex:0 linesHidden:NO];
                [self.buttons[i] setSelected:NO];
            }
            bgLabel.text = @"";
            
            if (i == verStr.length) {
                
                  [self.buttons[i] setSelected:YES];
            }
           
        }
    }
    
}
//设置光标显示隐藏
- (void)changeViewLayerIndex:(NSInteger)index linesHidden:(BOOL)hidden {
    CAShapeLayer *line = self.lines[index];
    if (hidden) {
        [line removeAnimationForKey:@"kOpacityAnimation"];
    }else{
        [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
    }
    [UIView animateWithDuration:0.25 animations:^{
        line.hidden = hidden;
    }];
}
//开始编辑
- (void)beginEdit{
    [self.textView becomeFirstResponder];
}
//结束编辑
- (void)endEdit{
    [self.textView resignFirstResponder];
}
//闪动动画
- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.9;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}
//对象初始化
- (NSMutableArray *)lines {
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}
- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}
- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
- (UITextField *)textView {
    if (!_textView) {
        _textView = [UITextField new];
        _textView.tintColor = [UIColor clearColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.keyboardType = UIKeyboardTypeNumberPad;
        [_textView addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textView;
}

@end
