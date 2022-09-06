//
//  JHC2CUploadProductBottomView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CUploadProductBottomView.h"

@interface JHC2CUploadProductBottomView()

@property(nonatomic, strong) YYLabel * rulerLbl;
@property(nonatomic, strong) UIImageView * iconImageView;
@end

@implementation JHC2CUploadProductBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    JHRecycleSureButton *btn = [JHRecycleSureButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"发布商品" forState:UIControlStateNormal];
    self.publishBtn = btn;
//    btn.enabled = NO;
    [self addSubview:self.publishBtn];
    
    YYLabel * lbl = [[YYLabel alloc] init];
    NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString: @"我已同意《天天鉴宝商品及信息发布细则》"];
    NSRange range = [text.string rangeOfString:@"《天天鉴宝商品及信息发布细则》"];
    [text setAttributes:@{NSFontAttributeName: JHFont(11), NSForegroundColorAttributeName: HEXCOLOR(0x666666)}];
    @weakify(self);
    [text setTextHighlightRange:range color:HEXCOLOR(0x2F66A0) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self);
        [self jumpRuler];
    }];
    lbl.attributedText = text;
    self.rulerLbl = lbl;
    [self addSubview:self.rulerLbl];
    [self addSubview:self.iconImageView];
    
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
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rulerLbl);
        make.right.equalTo(self.rulerLbl.mas_left).offset(-4);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];

}

- (void)jumpRuler{
    if (self.jumpRulerBlock) {
        self.jumpRulerBlock();
    }
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        view.image =  [UIImage imageNamed:@"fans_setting_business_selected"];
        _iconImageView = view;
    }
    return _iconImageView;
}
@end
