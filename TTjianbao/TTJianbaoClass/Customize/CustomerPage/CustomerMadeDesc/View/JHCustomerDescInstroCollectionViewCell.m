//
//  JHCustomerDescInstroCollectionViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerDescInstroCollectionViewCell.h"
#import "YYControl.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "TTjianbaoUtil.h"
#import "UIButton+ImageTitleSpacing.h"

@interface JHCustomerDescInstroCollectionViewCell ()
@property (nonatomic, strong) UIView              *iconView;
@property (nonatomic, strong) UIImageView         *iconImageView;
@property (nonatomic, strong) UIView              *iconBorderView;
@property (nonatomic, strong) YYAnimatedImageView *liveGifView;
@property (nonatomic, strong) UILabel             *titleLabel;
@property (nonatomic, strong) UILabel             *subTitleLabel;
@property (nonatomic, strong) UIImageView         *logoImageView;
@property (nonatomic, strong) UILabel             *customerLabel;
@property (nonatomic, strong) UIButton            *checkMainBtn;
@end

@implementation JHCustomerDescInstroCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = HEXCOLOR(0xffffff);

    _iconView = [[UIView alloc] init];
    _iconView.backgroundColor = HEXCOLOR(0xffffff);
    [self.contentView addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(36.f, 36.f));
    }];
    
    _iconImageView = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.layer.cornerRadius  = 17.f;
    _iconImageView.layer.masksToBounds = YES;
    [_iconView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconView).insets(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
    
    /// 黄圈的view
    _iconBorderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mall_like_circle_img"]];
    [_iconView addSubview:_iconBorderView];
    _iconBorderView.hidden = YES;
    [_iconBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconView).insets(UIEdgeInsetsMake(-2, -2, -2, -2));
    }];


    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_on_live" ofType:@"gif"];
    NSData *data   = [NSData dataWithContentsOfFile:path];
    YYImage *image = [YYImage imageWithData:data];
    _liveGifView   = [[YYAnimatedImageView alloc] initWithImage:image];
    _liveGifView.contentMode = UIViewContentModeScaleAspectFit;
    _liveGifView.hidden = YES;
    [self.contentView addSubview:_liveGifView];
    [_liveGifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.iconBorderView);
        make.size.mas_equalTo(CGSizeMake(13.f, 13.f));
    }];
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(iconDidClickAction)];
    [_iconView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(iconDidClickAction)];
    [_iconBorderView addGestureRecognizer:tap2];

    

    _titleLabel                        = [[UILabel alloc] init];
    _titleLabel.textColor              = HEXCOLOR(0x333333);
    _titleLabel.textAlignment          = NSTextAlignmentLeft;
    _titleLabel.font                   = [UIFont fontWithName:kFontMedium size:15.f];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(10.f);
        make.height.mas_equalTo(21.f);
    }];


    _subTitleLabel                     = [[UILabel alloc] init];
    _subTitleLabel.textColor           = HEXCOLOR(0x999999);
    _subTitleLabel.textAlignment       = NSTextAlignmentLeft;
    _subTitleLabel.font                = [UIFont fontWithName:kFontNormal size:11.f];
    [self.contentView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(1.f);
        make.left.equalTo(self.titleLabel.mas_left);
        make.height.mas_equalTo(16.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];

    _logoImageView                     = [[UIImageView alloc] init];
    _logoImageView.layer.cornerRadius  = 7.f;
    _logoImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_logoImageView];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(5.f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.width.height.mas_equalTo(14.f);
    }];

    _customerLabel                     = [[UILabel alloc] init];
    _customerLabel.textColor           = HEXCOLOR(0x999999);
    _customerLabel.textAlignment       = NSTextAlignmentLeft;
    _customerLabel.font                = [UIFont fontWithName:kFontNormal size:11.f];
    [self.contentView addSubview:_customerLabel];
    [_customerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logoImageView.mas_centerY);
        make.left.equalTo(self.logoImageView.mas_right).offset(3.f);
        make.height.mas_equalTo(16.f);
    }];

    _checkMainBtn                      = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkMainBtn.frame                = CGRectMake(0, 0, 74.f, 17.f);
    [_checkMainBtn setTitleColor:HEXCOLOR(0xFE9100) forState:UIControlStateNormal];
    _checkMainBtn.titleLabel.font      = [UIFont fontWithName:kFontMedium size:12.f];
    [_checkMainBtn setImage:[UIImage imageNamed:@"icon_user_info_arrow_orange"] forState:UIControlStateNormal];
    [_checkMainBtn setTitle:@"查看主页" forState:UIControlStateNormal];
    [_checkMainBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5.f];
    [_checkMainBtn addTarget:self action:@selector(checkMainBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_checkMainBtn];
    [_checkMainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(74.f);
        make.height.mas_equalTo(17.f);
    }];
}

/// 点击头像
- (void)iconDidClickAction {
    if (self.iconImgAcitonBlock) {
        self.iconImgAcitonBlock ();
    }
}

/// 查看主页
- (void)checkMainBtnAction:(UIButton *)sender {
    if (self.checkMainBtnActionBlock) {
        self.checkMainBtnActionBlock();
    }
}

- (void)setViewModel:(id)viewModel {
    NSDictionary *dict = [NSDictionary cast:viewModel];
    [self.iconImageView jhSetImageWithURL:[NSURL URLWithString:dict[@"customizeUserImg"]] placeholder:kDefaultAvatarImage];
    
    NSString *titleStr = dict[@"customizeUserName"];
    if (titleStr.length >8) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@...",[titleStr substringWithRange:NSMakeRange(0, 8)]];
    } else {
        self.titleLabel.text = titleStr;
    }
        
    if (!isEmpty(dict[@"customizeTitle"])) {
        self.subTitleLabel.text  = dict[@"customizeTitle"];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView.mas_top);
            make.left.equalTo(self.iconImageView.mas_right).offset(10.f);
            make.height.mas_equalTo(21.f);
        }];
    } else {
        self.subTitleLabel.text  = @"";
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconView.mas_centerY);
            make.left.equalTo(self.iconImageView.mas_right).offset(10.f);
            make.height.mas_equalTo(21.f);
        }];
    }
    
    if ([dict[@"authCustomize"] boolValue]) {
        self.logoImageView.image = [UIImage imageNamed:@"customize_authen_icon"];
        self.customerLabel.text  = @"认证定制师";
    } else {
        self.logoImageView.image = nil;
        self.customerLabel.text  = @"";
    }
    if ([dict[@"channelStatus"] isEqualToString:@"2"]) {
        self.liveGifView.hidden = NO;
        self.iconBorderView.hidden = NO;
    } else {
        self.liveGifView.hidden = YES;
        self.iconBorderView.hidden = YES;
    }
    
}


@end
