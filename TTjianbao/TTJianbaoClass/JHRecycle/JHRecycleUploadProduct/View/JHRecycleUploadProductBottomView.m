//
//  JHRecycleUploadProductBottomView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleUploadProductBottomView.h"

@interface JHRecycleUploadProductBottomView()

@property(nonatomic, strong) YYLabel * rulerLbl;

@end

@implementation JHRecycleUploadProductBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    JHRecycleSureButton *btn = [JHRecycleSureButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"发布并等待报价" forState:UIControlStateNormal];
    self.publishBtn = btn;
//    btn.enabled = NO;
    [self addSubview:self.publishBtn];
    
    YYLabel * lbl = [[YYLabel alloc] init];
    NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString: @"确认发布即表示同意《天天鉴宝商品发布细则》"];
    NSRange range = [text.string rangeOfString:@"《天天鉴宝商品发布细则》"];
    [text setAttributes:@{NSFontAttributeName: JHFont(11), NSForegroundColorAttributeName: HEXCOLOR(0x666666)}];
    @weakify(self);
    [text setTextHighlightRange:range color:HEXCOLOR(0x2F66A0) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self);
        [self jumpRuler];
    }];
    lbl.attributedText = text;
    self.rulerLbl = lbl;
    [self addSubview:self.rulerLbl];
}

- (void)layoutItems{
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).offset(12);
        make.right.equalTo(@0).offset(-12);
        make.height.equalTo(@50);
        make.top.equalTo(@0).offset(9);
    }];
    [self.rulerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.publishBtn.mas_bottom).offset(10);
    }];
}

- (void)jumpRuler{
    if (self.jumpRulerBlock) {
        self.jumpRulerBlock();
    }
}


@end
