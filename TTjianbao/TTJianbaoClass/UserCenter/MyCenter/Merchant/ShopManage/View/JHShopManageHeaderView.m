//
//  JHShopManageHeaderView.m
//  TTjianbao
//
//  Created by lihui on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHShopManageHeaderView.h"
#import "JHUserInfoViewController.h"
#import "UserInfoRequestManager.h"

@interface JHShopManageHeaderView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *shopButton;
@end

@implementation JHShopManageHeaderView

- (void)reloadData {
    User *user = [UserInfoRequestManager sharedInstance].user;
    [_iconImageView jh_setImageWithUrl:user.icon];
}

+ (CGFloat)headerHeight {
    return 110.f;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF8F8F8);
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    User *user = [UserInfoRequestManager sharedInstance].user;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = kColorFFF;
    [self addSubview:_bgView];
    
    _iconImageView = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_bgView addSubview:_iconImageView];
    [_iconImageView jh_setImageWithUrl:user.icon];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = [user.name isNotBlank] ? user.name : @"暂无昵称";
    _nameLabel.font = [UIFont fontWithName:kFontMedium size:16.];
    _nameLabel.textColor = kColor333;
    [_bgView addSubview:_nameLabel];

    _descLabel = [[UILabel alloc] init];
    _descLabel.text = [NSString stringWithFormat:@"商家ID：%@", user.customerId];
    _descLabel.font = [UIFont fontWithName:kFontNormal size:12.];
    _descLabel.textColor = HEXCOLOR(0x000000);
    [_bgView addSubview:_descLabel];
    
    _shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shopButton setTitle:@"商家主页" forState:UIControlStateNormal];
    [_shopButton setTitle:@"商家主页" forState:UIControlStateSelected];
    [_shopButton setTitleColor:kColor666 forState:UIControlStateNormal];
    [_shopButton setTitleColor:kColor333 forState:UIControlStateSelected];
    _shopButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:11.];
    [_shopButton addTarget:self action:@selector(shopButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_shopButton];
    _shopButton.layer.cornerRadius = 4.f;
    _shopButton.layer.borderWidth = .5f;
    _shopButton.layer.borderColor = kColor333.CGColor;
    _shopButton.layer.masksToBounds = YES;
    [self makeLayouts];
}

- (void)shopButtonAction {
    JHUserInfoViewController *vc = [[JHUserInfoViewController alloc] init];
    vc.userId = [UserInfoRequestManager sharedInstance].user.customerId;
    vc.fromSource = @"JHFromShopManage";
    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
}

- (void)makeLayouts {
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.bottom.equalTo(self.bgView).offset(-16);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.bottom.equalTo(self.iconImageView.mas_centerY).offset(-2);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        make.left.equalTo(self.nameLabel);
    }];
    
    [_shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-12);
        make.size.mas_equalTo(CGSizeMake(56, 24));
        make.centerY.equalTo(self.bgView);
    }];

    [self layoutIfNeeded];
    _iconImageView.layer.cornerRadius = _iconImageView.height/2;
    _iconImageView.layer.masksToBounds = YES;
}

@end
