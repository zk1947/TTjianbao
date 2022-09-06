//
//  JHCommentTypeHeader.m
//  TTjianbao
//
//  Created by lihui on 2021/2/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHCommentTypeHeader.h"

@interface JHCommentTypeHeader ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation JHCommentTypeHeader

- (void)setTitle:(NSString *)title icon:(NSString *)icon {
    if ([icon isNotBlank]) {
        _iconImageView.image = [UIImage imageNamed:icon];
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(10.);
        }];
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(3);
        }];
    }
    else {
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.);
        }];
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(0);
        }];
    }
    ///设置标题
    _titleLabel.text = [title isNotBlank] ? title : @"";
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorFFF;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"最热评论";
    _titleLabel.font = [UIFont fontWithName:kFontMedium size:15.];
    _titleLabel.textColor = kColor333;
    
    [self addSubview:_iconImageView];
    [self addSubview:_titleLabel];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-3);
        make.left.equalTo(self).offset(15.);
        make.height.mas_equalTo(15.);
        make.width.mas_equalTo(0);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self.iconImageView.mas_right).offset(0);
        make.right.equalTo(self).offset(-15);
    }];
}
@end
