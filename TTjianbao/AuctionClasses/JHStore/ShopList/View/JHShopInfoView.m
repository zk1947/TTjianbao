//
//  JHShopInfoView.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHShopInfoView.h"
#import "UIImageView+JHWebImage.h"
#import "JHSellerInfo.h"
#import "YYControl.h"
#import "JHShopHomeController.h"

@interface JHShopInfoView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *focusButton;

@property (nonatomic, strong) YYControl *control;

@end

@implementation JHShopInfoView

- (void)setSellerInfo:(JHSellerInfo *)sellerInfo {
    _sellerInfo = sellerInfo;
    if (!_sellerInfo) {
        return;
    }
    [_iconImageView jhSetImageWithURL:[NSURL URLWithString:_sellerInfo.head_img] placeholder:[UIImage imageNamed:@"icon_live_default_avatar"]];
    _titleLabel.text = _sellerInfo.name;
      
    NSString *descString = [_sellerInfo.desc stringByReplacingOccurrencesOfString:@"%s" withString:[NSString stringWithFormat:@"%@", sellerInfo.fans_num]];
    _detailLabel.text = descString;
    self.isFocus = [_sellerInfo.follow_status boolValue];
}

///是否关注
- (void)setIsFocus:(BOOL)isFocus {
    _isFocus = isFocus;
    _focusButton.selected = _isFocus;
    if (_isFocus) {
        _focusButton.backgroundColor = [UIColor clearColor];
        _focusButton.layer.borderColor = [HEXCOLOR(0x999999) CGColor];
        _focusButton.layer.borderWidth = 1.f;
    }
    else {
        _focusButton.backgroundColor = HEXCOLOR(0xFEE100);
        _focusButton.layer.borderColor = [HEXCOLOR(0xFEE100) CGColor];
        _focusButton.layer.borderWidth = 1.f;
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    YYControl *control = [[YYControl alloc] initWithFrame:CGRectZero];
    control.exclusiveTouch = YES;
    _control = control;
    @weakify(self);
    control.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *touch = touches.anyObject;
            CGPoint p = [touch locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                [self enterShopDetail];
            }
        }
    };

    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = [UIImage imageNamed:@"icon_live_default_avatar"];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"";
    _titleLabel.font = [UIFont fontWithName:kFontBoldPingFang size:15];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.text = @"0件商品 0个粉丝";
    _detailLabel.font = [UIFont fontWithName:kFontNormal size:11];
    _detailLabel.textColor = HEXCOLOR(0x999999);
  
    ///关注按钮
    _focusButton = [[UIButton alloc] init];
    _focusButton.backgroundColor = HEXCOLOR(0xFEE100);
    [_focusButton setTitle:@"关注" forState:UIControlStateNormal];
    [_focusButton setTitle:@"关注" forState:UIControlStateHighlighted];
    [_focusButton setTitle:@"已关注" forState:UIControlStateSelected];
    _focusButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
    [_focusButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_focusButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateSelected];
    [_focusButton addTarget:self action:@selector(focusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:control];
    [control addSubview:_iconImageView];
    [control addSubview:_titleLabel];
    [control addSubview:_detailLabel];
    [self addSubview:_focusButton];
    
    _focusButton.sd_layout
    .centerYEqualToView(self)
    .rightSpaceToView(self, 15)
    .widthIs(53)
    .heightIs(26);
    
    control.sd_layout
    .leftEqualToView(self)
    .rightSpaceToView(_focusButton, 5)
    .topEqualToView(self)
    .bottomEqualToView(self);
    
    _iconImageView.sd_layout
    .leftSpaceToView(control, 15)
    .topSpaceToView(control, 10)
    .widthIs(36)
    .heightEqualToWidth();
    
    _titleLabel.sd_layout
    .topEqualToView(_iconImageView)
    .leftSpaceToView(_iconImageView, 12)
    .rightSpaceToView(_focusButton, 10)
    .heightIs(21);
    
    _detailLabel.sd_layout
    .bottomEqualToView(_iconImageView)
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
    .heightIs(16);
    
    _iconImageView.layer.cornerRadius = _iconImageView.height/2;
    _iconImageView.layer.masksToBounds = YES;
    _focusButton.layer.cornerRadius = _focusButton.height/2;
    _focusButton.layer.masksToBounds = YES;
}

- (void)focusButtonClick {
    if (self.focusBlock) {
        self.focusBlock();
    }
}

///进入店铺主页
- (void)enterShopDetail {
    JHShopHomeController *shopVC = [[JHShopHomeController alloc] init];
    shopVC.sellerId = [self.sellerInfo.seller_id integerValue];
    [[JHRootController currentViewController].navigationController pushViewController:shopVC animated:YES];
}

@end
