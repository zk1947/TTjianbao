//
//  JHRecycleProductTopTypeView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleProductTopTypeView.h"

@interface JHRecycleProductTopTypeView()


@end

@implementation JHRecycleProductTopTypeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLbl];

    
}

- (void)layoutItems{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0).offset(12);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
    }];

}


- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        _iconImageView = view;
    }
    return _iconImageView;
}

- (UILabel *)nameLbl{
    if (!_nameLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.textColor = HEXCOLOR(0x222222);
        _nameLbl = label;
    }
    return _nameLbl;
}



@end
