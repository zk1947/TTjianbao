//
//  JHShopControlView.m
//  TTjianbao
//
//  Created by lihui on 2020/3/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHShopControlView.h"
#import "YYControl.h"


@interface JHShopControlView ()

@property (nonatomic, strong) UIImageView *shopIcon;
@property (nonatomic, strong) UILabel *shopLabel;

@end


@implementation JHShopControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _controlAlignment = JHShopControlViewAlignmentLeft;
        self.clipsToBounds = YES;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    _shopIcon = ({
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.backgroundColor = [UIColor whiteColor];
        imageV.image = [UIImage imageNamed:@""];
        imageV;
    });
    [self addSubview:_shopIcon];
    
    _shopLabel = ({
        UILabel *shopLabel = [[UILabel alloc] init];
        shopLabel.text = @"";
        shopLabel.textColor = HEXCOLOR(0x333333);
        shopLabel.font = [UIFont fontWithName:kFontNormal size:15];
        shopLabel;
    });
    [self addSubview:_shopLabel];
    
    ///布局
    [_shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(25);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [_shopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopIcon.mas_right).offset(10);
        make.centerY.equalTo(self.shopIcon.mas_centerY);
        make.height.equalTo(self.shopIcon);
        make.right.equalTo(self);
    }];
}

- (void)makeLayouts {
    switch (self.controlAlignment) {
        case JHShopControlViewAlignmentCenter:
        {
            ///布局
            [_shopLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).offset(12.5f);
                make.centerY.right.height.equalTo(self);
            }];

            [_shopIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.trailing.equalTo(self.shopLabel.mas_left).offset(-10);
                make.size.mas_equalTo(CGSizeMake(25, 25));
            }];
        }
            break;
        case JHShopControlViewAlignmentRight:
        {
            [_shopLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-25);
                make.centerY.height.equalTo(self);
            }];
            
            [_shopIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.trailing.equalTo(self.shopLabel.mas_leading).offset(-10);
                make.size.mas_equalTo(CGSizeMake(25, 25));
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - setting / getting method

- (void)setControlAlignment:(JHShopControlViewAlignment)controlAlignment {
    _controlAlignment = controlAlignment;
    [self makeLayouts];
}

- (void)setIcon:(NSString *)icon {
    if (!icon) {
        return;
    }
    _icon = icon;
    _shopIcon.image = [UIImage imageNamed:_icon];
}

- (void)setTitle:(NSString *)title {
    if (!title) {
        return;
    }
    _title = title;
    _shopLabel.text = _title;
}


@end
