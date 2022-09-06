//
//  JHCustomerDescBottomView.m
//  TTjianbao
//
//  Created by user on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerDescBottomView.h"
#import "UIView+JHGradient.h"
#import "TTjianbao.h"

@interface JHCustomerDescBottomView ()
@property (nonatomic, strong) NSMutableArray             *btnArray;
@property (nonatomic, copy  ) customerDescBtnActionBlock  descBtnBlock;
@end

@implementation JHCustomerDescBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF5F6FA);
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
    NSArray *names = @[@"点赞",@"分享"];
    NSArray *images = @[@"sq_toolbar_icon_like_normal",@"navi_icon_share_black"];
    for (int i = 0; i < 2; i++) {
        UIButton *button           = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [button setTitle:names[i] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        if (i >0) {
            [button jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        } else {
            button.backgroundColor = HEXCOLOR(0xffffff);
        }
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_normal"] forState:UIControlStateNormal];
//            [button setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_selected"] forState:UIControlStateSelected];
        }
        button.titleLabel.font     = [UIFont fontWithName:kFontNormal size:15.f];
        [button setImageInsetStyle:MRImageInsetStyleLeft spacing:5.f];
        [button addTarget:self action:@selector(descBottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius  = 19.5;
        button.layer.masksToBounds = YES;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0.f, -5.f, 0.f, 0.f)];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10.f);
            make.left.equalTo(self.mas_left).offset(25.f+i*((ScreenWidth -25.f*2.f-10.f)/2.f + 10.f));
            make.width.mas_equalTo((ScreenWidth -25.f*2.f-10.f)/2.f);
            make.height.mas_equalTo(39.f);
        }];
        [self.btnArray addObject:button];
    }
}

- (void)descBottomBtnAction:(UIButton *)sender {
    if (sender == self.btnArray[0] && self.descBtnBlock) {
        sender.selected = !sender.selected;
        self.descBtnBlock(JHCustomerDescBottomBtnStyle_Fav);
    }
    if (sender == self.btnArray[1] && self.descBtnBlock) {
        self.descBtnBlock(JHCustomerDescBottomBtnStyle_Share);
    }
}

- (void)setFavBtnStatus:(BOOL)isSelected {
    UIButton *btn = self.btnArray[0];
//    btn.selected = isSelected;
    if (isSelected) {
        [btn setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_selected"] forState:UIControlStateNormal];
    } else {
        [btn setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_normal"] forState:UIControlStateNormal];
    }
}

- (void)setFavBtnCount:(NSInteger)praiseNum {
    UIButton *btn = self.btnArray[0];
    if (praiseNum >0) {
//        [self setFavBtnStatus:YES];
//        [btn setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_selected"] forState:UIControlStateNormal];
        [btn setTitle:[NSString stringWithFormat:@"%ld",praiseNum] forState:UIControlStateNormal];
    } else {
//        [self setFavBtnStatus:NO];
//        [btn setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_normal"] forState:UIControlStateNormal];
        [btn setTitle:@"点赞" forState:UIControlStateNormal];
    }
}

- (void)customerDescBtnAction:(customerDescBtnActionBlock)clickBlock {
    self.descBtnBlock = clickBlock;
}


@end
