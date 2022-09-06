//
//  JHShopHomeNavigationBar.m
//  TTjianbao
//
//  Created by apple on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHShopHomeNavigationBar.h"
#import "JHSellerInfo.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"

@interface JHShopHomeNavigationBar ()


@property (nonatomic, strong) UIView *centerOriginView;
@property (nonatomic, strong) UIView *centerDragUpView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) UILabel *merchantiseLabel;
///关注按钮
@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, strong) UIImageView *dragImageV;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) BOOL isInitail;


@end

@implementation JHShopHomeNavigationBar

- (instancetype)init {
    self = [super init];
    if (self) {
        _isInitail = NO;
        [self initSubviews];
        [self createCenterOriginView];
        [self createCenterDragUpView];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setSellerInfo:(JHSellerInfo *)sellerInfo {
    _sellerInfo = sellerInfo;
    if (!_sellerInfo) {
        return;
    }
    [_bgImageView jhSetImageWithURL:[NSURL URLWithString:_sellerInfo.bg_img] placeholder:[UIImage imageNamed:@"icon_shop_header_default.jpeg"]];
    [_iconImageView jhSetImageWithURL:[NSURL URLWithString:_sellerInfo.head_img] placeholder:kDefaultAvatarImage];
    [_dragImageV jhSetImageWithURL:[NSURL URLWithString:_sellerInfo.head_img] placeholder:kDefaultAvatarImage];
    _titleLabel.text = _sellerInfo.name;
    _fansLabel.text = [NSString stringWithFormat:@"%@\n晒宝",_sellerInfo.show_post_num];
    _likeLabel.text = [NSString stringWithFormat:@"%@\n粉丝",_sellerInfo.fans_num];
    _merchantiseLabel.text = [NSString stringWithFormat:@"%@\n获赞",_sellerInfo.like_num];
}

- (void)setIsFollow:(BOOL)isFollow {
    _isFollow = isFollow;
    _attentionButton.selected = _isFollow;
    if (_isFollow) {
        _attentionButton.backgroundColor = [UIColor clearColor];
        _attentionButton.layer.borderColor = HEXCOLOR(0xFFFFFF).CGColor;
        _attentionButton.layer.borderWidth = 1.f;
        return;
    }
    _attentionButton.backgroundColor = HEXCOLOR(0xFEE100);
    _attentionButton.layer.borderColor = HEXCOLOR(0xFEE100).CGColor;
}

- (void)initSubviews {
    UIImageView *bgImageV = [[UIImageView alloc] init];
    bgImageV.backgroundColor = HEXCOLOR(0xF8F8F8);
    bgImageV.image = [UIImage imageNamed:@"icon_shop_header_default.jpeg"];
    bgImageV.userInteractionEnabled = YES;
    bgImageV.contentMode = UIViewContentModeScaleAspectFill;
    bgImageV.clipsToBounds = YES;
    _bgImageView = bgImageV;
    
    UIView *bottomV = [[UIView alloc] init];
    bottomV.backgroundColor = HEXCOLORA(0x333333, 0.3f);
    _blackView = bottomV;
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setImage:kNavBackWhiteImg forState:UIControlStateNormal];
    [_leftButton setImage:kNavBackWhiteImg forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:kNavShareWhiteImg forState:UIControlStateNormal];
    [rightBtn setImage:kNavShareWhiteImg forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _rightButton = rightBtn;
    
    UIButton *attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionBtn.backgroundColor = HEXCOLOR(0xFEE100);
    [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    [attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [attentionBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateSelected];
    attentionBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
    [attentionBtn.titleLabel sizeToFit];
    [attentionBtn addTarget:self action:@selector(attention:) forControlEvents:UIControlEventTouchUpInside];
    _attentionButton = attentionBtn;
    
    [self addSubview:bgImageV];
    [_bgImageView addSubview:bottomV];
    [_blackView addSubview:_leftButton];
    [_blackView addSubview:_rightButton];
    [_blackView addSubview:_attentionButton];
}

- (void)createCenterOriginView {
    _centerOriginView = [[UIView alloc] init];
    _centerOriginView.hidden = YES;

    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = kDefaultAvatarImage;
    _iconImageView.clipsToBounds = YES;
    _iconImageView.sd_cornerRadiusFromHeightRatio = @0.5;
    _iconImageView.layer.borderWidth = 1;
    _iconImageView.layer.borderColor = HEXCOLOR(0xFEE100).CGColor;
    _iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(enterShopOwerPage)];
    [_iconImageView addGestureRecognizer:tap];
 
    _fansLabel = [[UILabel alloc] init];
    _fansLabel.text = @"0\n晒宝";
    _fansLabel.numberOfLines = 2;
    _fansLabel.textColor = [UIColor whiteColor];
    _fansLabel.font = [UIFont fontWithName:kFontMedium size:14];
    _fansLabel.textAlignment = NSTextAlignmentCenter;
    [_fansLabel sizeToFit];
 
    _likeLabel = [[UILabel alloc] init];
    _likeLabel.text = @"0个\n粉丝";
    _likeLabel.textColor = [UIColor whiteColor];
    [_likeLabel sizeToFit];
    _likeLabel.numberOfLines = 2;
    _likeLabel.font = [UIFont fontWithName:kFontMedium size:14];
    _likeLabel.textAlignment = NSTextAlignmentCenter;
 
    _merchantiseLabel = [[UILabel alloc] init];
    _merchantiseLabel.text = @"0个\n获赞";
    [_merchantiseLabel sizeToFit];
    _merchantiseLabel.numberOfLines = 2;
    _merchantiseLabel.textColor = [UIColor whiteColor];
    _merchantiseLabel.font = [UIFont fontWithName:kFontMedium size:14];
    _merchantiseLabel.textAlignment = NSTextAlignmentCenter;

    [self.blackView addSubview:_centerOriginView];
    [_centerOriginView addSubview:_iconImageView];
    [_centerOriginView addSubview:_fansLabel];
    [_centerOriginView addSubview:_likeLabel];
    [_centerOriginView addSubview:_merchantiseLabel];
}

- (void)createCenterDragUpView {
    _centerDragUpView = [[UIView alloc] init];
    _centerDragUpView.hidden = YES;
    
    _dragImageV = [[UIImageView alloc] init];
    _dragImageV.image = kDefaultAvatarImage;
    _dragImageV.clipsToBounds = YES;
    _dragImageV.sd_cornerRadiusFromHeightRatio = @0.5;
    _dragImageV.layer.borderWidth = 1;
    _dragImageV.layer.borderColor = HEXCOLOR(0xFEE100).CGColor;
    _dragImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(enterShopOwerPage)];
    [_dragImageV addGestureRecognizer:tap];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"--";
    _titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
    _titleLabel.textColor = [UIColor whiteColor];
    
    [self.blackView addSubview:_centerDragUpView];
    [_centerDragUpView addSubview:_dragImageV];
    [_centerDragUpView addSubview:_titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_isInitail) {
        _isInitail = YES;
        _centerOriginView.frame = CGRectMake(40, -80, self.width - 40 - 140, 40);
        _centerDragUpView.frame = CGRectMake(40, self.bottom, self.width - 40 - 140, 30);
    }
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.equalTo(@(ScreenW));
    }];
    
    [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgImageView);
    }];
    
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.blackView);
        make.bottom.equalTo(self.blackView).with.offset(-26);
        make.size.equalTo(@(CGSizeMake(44, 44)));
    }];

    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.blackView);
        make.centerY.equalTo(self.leftButton);
        make.size.equalTo(@(CGSizeMake(44, 44)));
    }];
    
    [_attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightButton.mas_left).offset(-10);
        make.centerY.equalTo(self.rightButton);
        make.size.equalTo(@(CGSizeMake(57, 25)));
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.centerOriginView);
        make.width.equalTo(@40);
    }];

    [_fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(15);
        make.height.equalTo(self.centerOriginView);
        make.top.bottom.equalTo(self.centerOriginView);
    }];

    [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fansLabel.mas_right).with.offset(15);
        make.top.bottom.height.equalTo(self.centerOriginView);
    }];

    [_merchantiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeLabel.mas_right).with.offset(15);
        make.top.height.bottom.equalTo(self.centerOriginView);
    }];
    
    [_dragImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.centerDragUpView);
        make.centerY.equalTo(self.centerDragUpView);
        make.size.equalTo(@(CGSizeMake(30, 30)));
    }];
     
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dragImageV.mas_right).with.offset(5);
        make.height.equalTo(@21);
        make.centerY.equalTo(self.dragImageV.mas_centerY);
    }];
         
    [_attentionButton layoutIfNeeded];
    [_iconImageView layoutIfNeeded];
    [_dragImageV layoutIfNeeded];
    _attentionButton.layer.cornerRadius = _attentionButton.height/2.f;
    _attentionButton.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = _iconImageView.height/2.f;
    _iconImageView.clipsToBounds = YES;
    _dragImageV.layer.cornerRadius = _dragImageV.height/2.f;
    _dragImageV.clipsToBounds = YES;
}

- (void)showOriginView {
    [self.leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-26);
    }];
    self.centerOriginView.hidden = NO;
    self.centerDragUpView.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect dragRect = self.centerDragUpView.frame;
        dragRect.origin.y = self.bottom;
        self.centerDragUpView.frame = dragRect;
       
        CGRect oriRect = self.centerOriginView.frame;
        oriRect.origin.y = self.bottom - self.centerOriginView.height - 30;
        self.centerOriginView.frame = oriRect;
    }];
}

- (void)showDragUpView {
    [self.leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(0);
    }];
    self.centerOriginView.hidden = YES;
    self.centerDragUpView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect oriRect = self.centerOriginView.frame;
        oriRect.origin.y = self.top - self.centerOriginView.height;
        self.centerOriginView.frame = oriRect;
        
        CGRect rect = self.centerDragUpView.frame;
        rect.origin.y = self.bottom - self.centerDragUpView.height - 6;
        self.centerDragUpView.frame = rect;
   }];
    
}

///关注点击事件
- (void)attention:(UIButton *)sender {
    NSLog(@"---- 关注店铺 ----");
    if ([self.delegate respondsToSelector:@selector(attentionShop:)]) {
        [self.delegate attentionShop:sender.selected];
    }
}

///进入商家主页
- (void)enterShopOwerPage {
    if ([self.delegate respondsToSelector:@selector(enterShopOwerHomePage)]) {
        [self.delegate enterShopOwerHomePage];
    }
}

- (void)leftButtonClick {
    if ([self.delegate respondsToSelector:@selector(leftButtonAction)]) {
        [self.delegate leftButtonAction];
    }
}

- (void)rightButtonClick {
    if ([self.delegate respondsToSelector:@selector(rightButtonAction)]) {
        [self.delegate rightButtonAction];
    }
}

- (void)changeBarTop:(CGFloat)top {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
    }];
}

- (void)changeBarHeight:(CGFloat)barHeight {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(barHeight));
    }];
}

- (void)layoutBar {
    [UIView animateWithDuration:0.5 animations:^{
        [self.centerOriginView layoutIfNeeded];
        [self.centerDragUpView layoutIfNeeded];
    }];
}

@end
