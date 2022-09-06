//
//  JHRecycleGoodsDetailBottomView.m
//  TTjianbao
//
//  Created by user on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleGoodsDetailBottomView.h"
#import "UIView+JHGradient.h"
#import "TTjianbao.h"

@interface JHRecycleGoodsDetailBottomView ()
@property (nonatomic, strong) NSMutableArray             *btnArray;
@property (nonatomic, copy  ) recycleBottomActionBlock    descBtnBlock;
@end

@implementation JHRecycleGoodsDetailBottomView

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
    NSArray *names = @[@"成为回收商",@"卖钱币"];
    NSArray *images = @[@"recycle_detailInfo_people",@"recycle_detailInfo_money"];
    for (int i = 0; i < 2; i++) {
        UIButton *button           = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [button setTitle:names[i] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        if (i >0) {
            button.layer.borderWidth = 0;
            button.backgroundColor = HEXCOLOR(0xFFD70F);
        } else {
            button.backgroundColor = HEXCOLOR(0xFFFFFF);
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = HEXCOLOR(0xCCCCCC).CGColor;
        }
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setImageInsetStyle:MRImageInsetStyleLeft spacing:5.f];
        button.titleLabel.font     = [UIFont fontWithName:kFontMedium size:16.f];
        [button addTarget:self action:@selector(descBottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius  = 4.f;
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

- (void)descBottomBtnAction:(UIButton *)sender {
    if (sender == self.btnArray[0] && self.descBtnBlock) {
        sender.selected = !sender.selected;
        self.descBtnBlock(JHRecycleGoodsDetailBottomBtnStyle_wantRecycle);
    }
    if (sender == self.btnArray[1] && self.descBtnBlock) {
        self.descBtnBlock(JHRecycleGoodsDetailBottomBtnStyle_wantMoney);
    }
}

- (void)recycleBottomAction:(recycleBottomActionBlock)clickBlock {
    self.descBtnBlock = clickBlock;
}

@end
