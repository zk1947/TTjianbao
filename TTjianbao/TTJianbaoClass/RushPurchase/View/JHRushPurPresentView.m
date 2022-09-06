//
//  JHRushPurPresentView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/9/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRushPurPresentView.h"

@interface JHRushPurPresentView()

@property(nonatomic, strong) UIView * backView;

@property(nonatomic, strong) UIView *bottomRedView;
@property(nonatomic, strong) UIView *bottomEmptyView;

@property(nonatomic, strong) UIImageView *iconImageView;

@property(nonatomic, strong) UILabel *preLbl;

@property(nonatomic, strong) UIImageView *sepIconImageView;

@end
//100 15
@implementation JHRushPurPresentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setPeresent:(NSInteger)peresent{
    _peresent = peresent;
    [self refershWihtPresent:peresent];
}

-  (void)setSepStatus:(BOOL)sepStatus{
    _sepStatus = sepStatus;
    if (sepStatus) {
        self.bottomRedView.hidden = YES;
        self.iconImageView.hidden = YES;
        self.sepIconImageView.hidden = NO;
        self.preLbl.textColor = HEXCOLOR(0xffffff);
        self.preLbl.text = @"100%";
        [self.preLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
        }];
    }
}

- (void)refershWihtPresent:(NSInteger)peresent{
    if (peresent < 0 || peresent > 100) {return;}
    self.bottomRedView.hidden = NO;
    self.iconImageView.hidden = NO;
    self.sepIconImageView.hidden = YES;
    CGFloat wide = 108.f/100.f * peresent;
    //右侧
    if (peresent < 25) {
        [self.bottomRedView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(wide + 3, 9.f));
        }];
        [self.preLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(self.iconImageView.mas_right).offset(4);
        }];
        self.preLbl.textColor = HEXCOLOR(0xFF5200);
    }else{
        [self.bottomRedView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(wide + 3, 9.f));
        }];
        [self.preLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.centerX.equalTo(self.bottomRedView).offset(-2);
        }];
        self.preLbl.textColor = HEXCOLOR(0xffffff);
    }
    self.preLbl.text = [@(peresent).stringValue stringByAppendingString:@"%"];
}



- (void)setItems{
    [self addSubview:self.backView];
    [self.backView addSubview:self.bottomEmptyView];
    [self.backView addSubview:self.bottomRedView];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.preLbl];
    [self.backView addSubview:self.sepIconImageView];
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.bottomEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(108.f, 9.f));
    }];
    [self.bottomRedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(1.f, 9.f));
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(self.bottomRedView.mas_right).offset(-5);
    }];
    [self.preLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(self.iconImageView.mas_right).offset(4);
    }];
    [self.sepIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(self.preLbl.mas_left);
    }];

}

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xffffff);
        _backView = view;
    }
    return _backView;
}
- (UIView *)bottomRedView{
    if (!_bottomRedView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xFF5200);
        view.layer.cornerRadius = 4.5;
        _bottomRedView = view;
    }
    return _bottomRedView;
}

- (UIView *)bottomEmptyView{
    if (!_bottomEmptyView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLORA(0xFF5200, 0.15);
        view.layer.cornerRadius = 4.5;
        _bottomEmptyView = view;
    }
    return _bottomEmptyView;
}

- (UILabel *)preLbl{
    if (!_preLbl) {
        UILabel *label = [UILabel new];
        label.font = JHBoldFont(9);
        label.text = @"0%";
        label.textColor = HEXCOLOR(0xFF5200);
        _preLbl = label;
    }
    return _preLbl;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"miaosha_shandian"];
        _iconImageView = view;
    }
    return _iconImageView;
}

- (UIImageView *)sepIconImageView{
    if (!_sepIconImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"miaosha_man_star"];
        _sepIconImageView = view;
    }
    return _sepIconImageView;
}

@end
