//
//  JHBusinessFansBottomView.m
//  TTjianbao
//
//  Created by user on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansBottomView.h"
#import "UIView+JHGradient.h"

@interface JHBusinessFansBottomView ()
@property (nonatomic, strong) NSMutableArray             *btnArray;
@property (nonatomic,   copy) businessFansBtnActionBlock  clickBlock;
@end

@implementation JHBusinessFansBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xFFFFFF);
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnArray;
}


- (void)setupViews {
    UIView *lineView                  = [[UIView alloc] init];
    lineView.backgroundColor          = HEXCOLOR(0xEEEEEE);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(1.f);
    }];
    
    NSArray *names = @[@"上一步",@"下一步"];
    for (int i = 0; i < 2; i++) {
        UIButton *button           = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [button setTitle:names[i] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        if (i >0) {
            button.userInteractionEnabled = NO;
            button.backgroundColor        = HEXCOLOR(0xEEEEEE);
            button.layer.borderWidth      = 0.f;
        } else {
            button.userInteractionEnabled = YES;
            button.backgroundColor        = HEXCOLOR(0xffffff);
            button.layer.borderWidth      = 0.5f;
            button.layer.borderColor      = HEXCOLOR(0xBDBFC2).CGColor;
        }
        button.titleLabel.font     = [UIFont fontWithName:kFontNormal size:15.f];
        [button addTarget:self action:@selector(bfansBottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius  = 19.5;
        button.layer.masksToBounds = YES;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10.f);
            make.left.equalTo(self.mas_left).offset(25.f+i*((ScreenWidth -25.f*2.f-10.f)/2.f + 10.f));
            make.width.mas_equalTo((ScreenWidth -25.f*2.f-10.f)/2.f);
            make.height.mas_equalTo(39.f);
        }];
        [self.btnArray addObject:button];
    }
}

- (void)bfansBottomBtnAction:(UIButton *)sender {
    if (sender == self.btnArray[0] && self.clickBlock) {
        sender.selected = !sender.selected;
        self.clickBlock(JHCustomerDescBottomBtnStyle_up);
    }
    if (sender == self.btnArray[1] && self.clickBlock) {
        self.clickBlock(JHCustomerDescBottomBtnStyle_down);
    }
}

- (void)renameBtns:(NSArray<NSString *>*)array {
    if (!array || array.count == 0) {
        return;
    }
    for (int i = 0; i < self.btnArray.count; i++) {
        UIButton *button = self.btnArray[i];
        [button setTitle:array[i] forState:UIControlStateNormal];
    }
}

- (void)setNextButtonStatus:(BOOL)canClick {
    UIButton *btn = self.btnArray[1];
    if (canClick) {
        btn.userInteractionEnabled = YES;
        [btn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    } else {
        btn.userInteractionEnabled = NO;
        btn.backgroundColor = HEXCOLOR(0xEEEEEE);
        [btn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xEEEEEE), HEXCOLOR(0xEEEEEE)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    }
}


- (void)businessFansBtnAction:(businessFansBtnActionBlock)clickBlock {
    self.clickBlock = clickBlock;
}


@end
