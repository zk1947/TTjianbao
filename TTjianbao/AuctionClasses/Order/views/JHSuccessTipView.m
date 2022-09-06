//
//  JHSuccessTipView.m
//  TTjianbao
//
//  Created by 张坤 on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSuccessTipView.h"
#import "BYTimer.h"

@interface JHSuccessTipView()
@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) BYTimer *timer;
@end

@implementation JHSuccessTipView

- (instancetype)initWithTitle:(NSString *)title des:(NSString *)des imageStr:(NSString *)imageStr btnTitle:(NSString *)btnTitle {
    self = [super init];
    if (self) {
        [self.iconIV setImage:[UIImage imageNamed:imageStr]];
        [self.titleLabel setText:title];
        [self.desLabel setText:des];
        [self.backBtn setTitle:btnTitle forState:UIControlStateNormal];
        
        [self addSubview:self.iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.mas_equalTo(self);
            make.height.mas_equalTo(40.f);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconIV.mas_bottom).mas_offset(14.f);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(25.f);
        }];
        
        if (des.length) {
            [self addSubview:self.desLabel];
            [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(4.f);
                make.centerX.mas_equalTo(self);
                make.height.mas_equalTo(20.f);
            }];
        }
        
        [self addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (des.length) {
                make.top.mas_equalTo(self.desLabel.mas_bottom).mas_offset(40.f);
            }else {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(40.f);
            }
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(102.f);
            make.height.mas_equalTo(40.f);
            make.bottom.mas_equalTo(self);
        }];
        
        [self countDown];
    }
    return  self;
}
- (void)dealloc {
    [self.timer stopGCDTimer];
}

- (void)backAction:(UIButton *)btn {
    if (self.successTipViewBlock) {
        self.successTipViewBlock(self.backBtn);
    }
}

-(void)countDown {
    if (!self.timer) {
        self.timer = [[BYTimer alloc]init];
    }
    
    [self.timer createTimerWithTimeout:3.f handlerBlock:^(int presentTime) {
        [self.backBtn setTitle:[NSString stringWithFormat:@"返回（%ds）",presentTime] forState:UIControlStateNormal];
    } finish:^{
        [self backAction:self.backBtn];
    }];
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc] init];
        _iconIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconIV;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _titleLabel.textColor = HEXCOLOR(0xFF333333);
    }
    return _titleLabel;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.numberOfLines = 0;
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.font = [UIFont systemFontOfSize:14.f];
        _desLabel.textColor = HEXCOLOR(0xFF333333);
    }
    return _desLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton jh_buttonWithTitle:@"返回" fontSize:15.f textColor:HEXCOLOR(0xFF333333) target:self action:@selector(backAction:) addToSuperView:self];
        _backBtn.layer.cornerRadius = 20.f;
        _backBtn.layer.borderWidth = 0.5;
        _backBtn.layer.borderColor = HEXCOLOR(0xFFBDBFC2).CGColor;
        _backBtn.clipsToBounds = YES;
        _backBtn.adjustsImageWhenHighlighted = NO;
        _backBtn.adjustsImageWhenDisabled = NO;
    }
    return _backBtn;
}

@end
