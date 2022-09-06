//
//  JHMyCenterMerchantHeaderView.m
//  TTjianbao
//
//  Created by lihui on 2021/4/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCenterMerchantHeaderView.h"
#import "UIView+JHGradient.h"
#import "UserInfoRequestManager.h"
#import "JHMerchantShopManageController.h"

#define kIconSize  CGSizeMake(60, 60)

@interface JHMyCenterMerchantHeaderView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *focusLabel;
@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UILabel *likeLabel;

@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, strong) UIButton *livingButton;
@property (nonatomic, strong) UIButton *storeButton;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JHMyCenterMerchantHeaderView

+ (CGFloat)headerHeight {
    return (174 + UI.statusBarHeight);
}

- (void)reload {
    User *user = [UserInfoRequestManager sharedInstance].user;
    JHUserLevelInfoMode *levelModel = [UserInfoRequestManager sharedInstance].levelModel;
    [_iconImageView jh_setAvatorWithUrl:user.icon];
    _nameLabel.text = [user.name isNotBlank] ? user.name : @"暂无昵称";
    _focusLabel.text = [NSString stringWithFormat:@"%@ 关注", OBJ_TO_STRING(@(levelModel.follow_num))];
    _fansLabel.text = [NSString stringWithFormat:@"%@ 粉丝", OBJ_TO_STRING(@(levelModel.fans_num))];
    _likeLabel.text = [NSString stringWithFormat:@"%@ 获赞", OBJ_TO_STRING(@(levelModel.like_num))];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _defaultIndex = 0;
        [self initViews];
    }
    return self;
}

- (void)setDefaultIndex:(NSInteger)defaultIndex {
    _defaultIndex = defaultIndex;
    if (_defaultIndex == 1) {
        [self __handleStoreButtonAction];
    }
    else {
        [self __handleLivingButtonAction];
    }
}

- (void)initViews {
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = kColorFFF;
    [self addSubview:_bgView];
    
    _iconImageView = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_bgView addSubview:_iconImageView];
    _iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterShopManagePage)];
    [_iconImageView addGestureRecognizer:tap];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"暂无昵称";
    _nameLabel.font = [UIFont fontWithName:kFontMedium size:16.];
    _nameLabel.textColor = kColor333;
    [_bgView addSubview:_nameLabel];
    
    _focusLabel = [[UILabel alloc] init];
    _focusLabel.text = @"0 关注";
    _focusLabel.font = [UIFont fontWithName:kFontNormal size:12.];
    _focusLabel.textColor = HEXCOLOR(0x000000);
    [_bgView addSubview:_focusLabel];

    _fansLabel = [[UILabel alloc] init];
    _fansLabel.text = @"0 粉丝";
    _fansLabel.font = [UIFont fontWithName:kFontNormal size:12.];
    _fansLabel.textColor = HEXCOLOR(0x000000);
    [_bgView addSubview:_fansLabel];

    _likeLabel = [[UILabel alloc] init];
    _likeLabel.text = @"0 获赞";
    _likeLabel.font = [UIFont fontWithName:kFontNormal size:12.];
    _likeLabel.textColor = HEXCOLOR(0x000000);
    [_bgView addSubview:_likeLabel];
    
    _segmentView = [[UIView alloc] init];
    _segmentView.backgroundColor = kColorFFF;
    [self addSubview:_segmentView];
    
    _livingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_livingButton setTitle:@"直播" forState:UIControlStateNormal];
    [_livingButton setTitle:@"直播" forState:UIControlStateSelected];
    [_livingButton setTitleColor:kColor666 forState:UIControlStateNormal];
    [_livingButton setTitleColor:kColor333 forState:UIControlStateSelected];
    _livingButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:14.];
    [_livingButton addTarget:self action:@selector(__handleLivingButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_segmentView addSubview:_livingButton];
    _livingButton.selected = YES;
    
    _storeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_storeButton setTitle:@"商城" forState:UIControlStateNormal];
    [_storeButton setTitle:@"商城" forState:UIControlStateSelected];
    [_storeButton setTitleColor:kColor666 forState:UIControlStateNormal];
    [_storeButton setTitleColor:kColor333 forState:UIControlStateSelected];
    _storeButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:14.];
    [_storeButton addTarget:self action:@selector(__handleStoreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_segmentView addSubview:_storeButton];
    
    _lineView = [UIView jh_viewWithColor:HEXCOLOR(0xFFDB27) addToSuperview:self.segmentView];
    [_lineView jh_cornerRadius:1.5];
    [_segmentView addSubview:_lineView];
    
    [self makeLayouts];
    
    [self reload];
}

- (void)makeLayouts {
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.bottom.equalTo(self.bgView).offset(-16);
        make.size.mas_equalTo(kIconSize);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.bottom.equalTo(self.iconImageView.mas_centerY).offset(-2);
    }];
    
    [_focusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
    }];

    [_fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.focusLabel.mas_right).offset(20);
        make.centerY.equalTo(self.focusLabel);
    }];

    [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fansLabel.mas_right).offset(20);
        make.centerY.equalTo(self.focusLabel);
    }];
    
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(44.);
    }];
    
    [_livingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.segmentView.mas_centerX).offset(-30);
        make.height.mas_equalTo(15.);
        make.centerY.equalTo(self.segmentView);
    }];

    [_storeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentView.mas_centerX).offset(30);
        make.centerY.width.height.equalTo(self.livingButton);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 3.f));
        make.centerX.equalTo(self.livingButton);
        make.top.equalTo(self.livingButton.mas_bottom).offset(5);
    }];

    [self layoutIfNeeded];
    _iconImageView.layer.cornerRadius = _iconImageView.height/2;
    _iconImageView.layer.masksToBounds = YES;
    [_bgView jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFDDC65), HEXCOLOR(0xFBE07E)] locations:@[@0, @1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}

- (void)enterShopManagePage {
    JHMerchantShopManageController *vc = [[JHMerchantShopManageController alloc] init];
    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
}

- (void)__handleLivingButtonAction {
    _livingButton.selected = YES;
    _storeButton.selected = NO;
    _livingButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:14.];
    _storeButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:14.];

    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.livingButton.mas_bottom).offset(5);
        make.centerX.equalTo(self.livingButton);
        make.size.mas_equalTo(CGSizeMake(20, 3.f));
    }];
    if (self.actionBlock) {
        self.actionBlock(0);
    }
}

- (void)__handleStoreButtonAction {
    _livingButton.selected = NO;
    _storeButton.selected = YES;
    _livingButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:14.];
    _storeButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:14.];

    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storeButton.mas_bottom).offset(5);
        make.centerX.equalTo(self.storeButton);
        make.size.mas_equalTo(CGSizeMake(20, 3.f));
    }];
    
    if (self.actionBlock) {
        self.actionBlock(1);
    }
}

@end
