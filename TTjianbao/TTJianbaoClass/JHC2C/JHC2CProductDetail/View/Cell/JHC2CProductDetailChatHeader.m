//
//  JHC2CProductDetailChatHeader.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailChatHeader.h"
#import <YYLabel.h>

@interface JHC2CProductDetailChatHeader()
@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) UIImageView * iconImageView;
@property(nonatomic, strong) YYLabel * placeHolderLbl;

@end

@implementation JHC2CProductDetailChatHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.contentView.backgroundColor = HEXCOLOR(0xF5F5F8);
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.titlleLbl];
    [self.backView addSubview:self.placeHolderLbl];
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@0).offset(10);
    }];
    [self.titlleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(13);
        make.left.equalTo(@0).offset(12);
    }];

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titlleLbl.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.left.equalTo(@0).offset(12);
    }];
    [self.placeHolderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.right.equalTo(@0).offset(-12);
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
    }];
}

- (void)tapActionWithSender:(UIGestureRecognizer*)sender{
    if (self.tapViewAction) {
        self.tapViewAction();
    }
}


- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        _backView = view;
    }
    return _backView;
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        view.layer.cornerRadius = 13;
        view.layer.masksToBounds = YES;
        NSString *userID = UserInfoRequestManager.sharedInstance.user.icon;
        [view jhSetImageWithURL:[NSURL URLWithString:userID] placeholder:kDefaultAvatarImage];
        _iconImageView = view;
    }
    return _iconImageView;
}
- (UILabel *)titlleLbl{
    if (!_titlleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(16);
        label.text = @"全部留言";
        label.textColor = HEXCOLOR(0x333333);
        _titlleLbl = label;
    }
    return _titlleLbl;
}
- (YYLabel *)placeHolderLbl{
    if (!_placeHolderLbl) {
        YYLabel *label = [YYLabel new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionWithSender:)];
        [label addGestureRecognizer:tap];
        label.font = JHFont(12);
        label.textContainerInset = UIEdgeInsetsMake(8, 14, 8, 0);
        label.backgroundColor = HEXCOLOR(0xF6F6F7);
        label.layer.cornerRadius = 16;
        label.text = @"喜欢就留言，了解更多细节~";
        label.textColor = HEXCOLOR(0x999999);
        _placeHolderLbl = label;
    }
    return _placeHolderLbl;

}

@end
