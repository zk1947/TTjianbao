//
//  JHGoodManagerListChannelBottomView.m
//  TTjianbao
//
//  Created by user on 2021/8/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerListChannelBottomView.h"
#import "UIView+JHGradient.h"
#import "TTjianbao.h"

@interface JHGoodManagerListChannelBottomView ()
@property (nonatomic, strong) NSMutableArray                            *btnArray;
@property (nonatomic,   copy) goodManagerListChannelBottomActionBlock    descBtnBlock;
@end

@implementation JHGoodManagerListChannelBottomView

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
    NSArray *names = @[@"重置",@"确认"];
    for (int i = 0; i < 2; i++) {
        UIButton *button           = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [button setTitle:names[i] forState:UIControlStateNormal];
        if (i == 0) {
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = HEXCOLOR(0xD8D8D8).CGColor;
            button.backgroundColor = HEXCOLOR(0xFFFFFF);
            button.titleLabel.font = [UIFont fontWithName:kFontMedium size:14.f];
            [button setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        } else {
            button.backgroundColor = HEXCOLOR(0xFFD70F);
            button.layer.borderWidth = 0.f;
            button.titleLabel.font = [UIFont fontWithName:kFontMedium size:14.f];
            [button setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(descBottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius  = 4.f;
        button.layer.masksToBounds = YES;
        CGFloat btnWidth = (ScreenWidth - 39.f -(22.f*2.f)-8.f)/2.f;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10.f);
            make.left.equalTo(self.mas_left).offset(22.f+i*(btnWidth + 8.f));
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(40.f);
        }];
        [self.btnArray addObject:button];
    }
}

- (void)descBottomBtnAction:(UIButton *)sender {
    if (sender == self.btnArray[0] && self.descBtnBlock) {
        sender.selected = !sender.selected;
        self.descBtnBlock(JHGoodManagerListChannelBottomBtnStyle_reset);
    }
    if (sender == self.btnArray[1] && self.descBtnBlock) {
        self.descBtnBlock(JHGoodManagerListChannelBottomBtnStyle_makeSure);
    }
}

- (void)goodManagerListChannelBottomAction:(goodManagerListChannelBottomActionBlock)clickBlock {
    self.descBtnBlock = clickBlock;
}

@end
