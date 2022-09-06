//
//  JHUnionSignShowBaseCell.m
//  TTjianbao
//
//  Created by apple on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUnionSignShowBaseCell.h"

@interface JHUnionSignShowBaseCell ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UIImageView *pushIcon;

@end


@implementation JHUnionSignShowBaseCell

- (void)addSelfSubViews{
    
    _titleLabel = [UILabel jh_labelWithFont:15 textColor:RGB515151 addToSuperView:self.contentView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    
    _descLabel = [UILabel jh_labelWithFont:15 textColor:RGB515151 addToSuperView:self.contentView];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    
    _pushIcon = [UIImageView jh_imageViewWithImage:@"icon_my_right_arrow" addToSuperview:self.contentView];
    [_pushIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

+ (CGFloat)cellHeight{
    return 51.f;
}

- (void)setTitle:(NSString *)title desc:(NSString *)desc hiddenPushIcon:(BOOL)hiddenPushIcon{
    self.titleLabel.text = title;
    self.descLabel.text = desc;
    self.pushIcon.hidden = hiddenPushIcon;
    [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(hiddenPushIcon ? -10 : -25);
    }];
}

@end
