//
//  JHC2CProductDetailChatFooter.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailChatFooter.h"
#import <YYLabel.h>

@interface JHC2CProductDetailChatFooter()
@property(nonatomic, strong) YYLabel * titlleLbl;
@property(nonatomic, strong) UIImageView * iconImageView;
@property(nonatomic, strong) UIView * lineView;

@end

@implementation JHC2CProductDetailChatFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.titlleLbl];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.lineView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionWithSender:)];
    [self.contentView addGestureRecognizer:tap];

}

- (void)tapActionWithSender:(UIGestureRecognizer*)sender{
    if (self.tapViewAction) {
        self.tapViewAction();
    }
}

- (void)layoutItems{
    [self.titlleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.centerX.equalTo(@0).offset(-10);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
//        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.left.equalTo(self.titlleLbl.mas_right).offset(5);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.right.equalTo(@0).inset(12);
        make.height.mas_equalTo(0.5);
    }];

}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"c2c_pd_downarrow"];
        _iconImageView = view;
    }
    return _iconImageView;
}
- (YYLabel *)titlleLbl{
    if (!_titlleLbl) {
        YYLabel *label = [YYLabel new];
        label.font = JHFont(13);
        label.text = @"加载更多留言";
        label.textColor = HEXCOLOR(0x666666);
        _titlleLbl = label;
    }
    return _titlleLbl;
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xF0F0F0);
        _lineView = view;
    }
    return _lineView;
}

@end
