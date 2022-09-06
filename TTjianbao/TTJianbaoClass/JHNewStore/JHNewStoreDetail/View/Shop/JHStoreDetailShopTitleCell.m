//
//  JHStoreDetailShopTitleCell.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailShopTitleCell.h"
#import "JHUserAuthModel.h"

@interface JHStoreDetailShopSubView: UIView
@property(nonatomic, strong) UILabel * topLbl;
@property(nonatomic, strong) UILabel * desLbl;

@end

@implementation JHStoreDetailShopSubView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    [self addSubview:self.topLbl];
    [self addSubview:self.desLbl];

}

- (void)layoutItems{
    [self.topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(19);
        make.left.right.equalTo(@0);
    }];
    [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.topLbl.mas_bottom).offset(4);
    }];

}

- (UILabel *)topLbl{
    if (!_topLbl) {
        UILabel *label = [UILabel new];
        label.font = [UIFont fontWithName:kFontBoldDIN size:22];;
        label.textColor = HEXCOLOR(0x333333);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"4.9";
        _topLbl = label;
    }
    return _topLbl;
}
- (UILabel *)desLbl{
    if (!_desLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.textColor = HEXCOLOR(0x666666);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"综合评分";
        _desLbl = label;
    }
    return _desLbl;
}
@end
    
    
@interface JHStoreDetailShopTitleCell()
/// 店铺图标
@property (nonatomic, strong) UIImageView *iconImageView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 关注
@property (nonatomic, strong) UIButton *focusButton;
/// 进入店铺
@property (nonatomic, strong) UIButton *goShopButton;
/// 门头
@property (nonatomic, strong) UIImageView *authTagImageView;

/// 综合分
@property (nonatomic, strong) JHStoreDetailShopSubView *totalView;
/// 好评度
@property (nonatomic, strong) JHStoreDetailShopSubView *parView;
/// 粉丝
@property (nonatomic, strong) JHStoreDetailShopSubView *fansView;

@property(nonatomic, strong) UIView * leftLineView;
@property(nonatomic, strong) UIView * rightLineView;
@end

@implementation JHStoreDetailShopTitleCell
#pragma mark - Life Cycle Functions
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self layOutItems];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions

#pragma mark - Private Functions
#pragma mark - Action functions
- (void)didClickFocus : (UIButton *)sender {
    [self.viewModel.focusAction sendNext:nil];
}


- (void)goShowBtnAction:(UIButton *)sender {
    [self.viewModel.goShopBtnAction sendNext:nil];
}

#pragma mark - Bind
- (void) bindData {
    self.titleLabel.text = self.viewModel.titleText;
    [self.iconImageView jh_setImageWithUrl:self.viewModel.iconUrl placeHolder:@"newStore_default_avatar_placehold"];
    self.totalView.topLbl.text = [self.viewModel.totalScore isNotBlank] ? self.viewModel.totalScore : @"0";
    self.parView.topLbl.attributedText = self.viewModel.praiseTextAtt;
    self.fansView.topLbl.text = self.viewModel.fansText;
    
    @weakify(self)
    [[RACObserve(self.viewModel, focusStatus)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        NSUInteger state = [x unsignedIntegerValue];
        if (state == 1) {
            [self.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        }else {
            [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
        }
    }];
    [[self.viewModel.goShopTextSubject
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self.goShopButton setTitle:x forState:UIControlStateNormal];
    }];
    
    [[RACObserve(self.viewModel, sellerType)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        JHUserAuthType sellerType = [x integerValue];
        if (sellerType > 0) {
            NSString *authImageName = (sellerType == JHUserAuthTypePersonal)
            ? @"icon_auth_personal" : @"icon_auth_company";
            self.authTagImageView.image = [UIImage imageNamed:authImageName];
            self.authTagImageView.hidden = NO;
        }
        else {
            self.authTagImageView.hidden = YES;
        }
    }];
}

#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.focusButton];
    [self addSubview:self.goShopButton];
    [self addSubview:self.totalView];
    [self addSubview:self.fansView];
    [self addSubview:self.parView];
    [self addSubview:self.leftLineView];
    [self addSubview:self.rightLineView];
	[self addSubview:self.authTagImageView];

}
- (void)layOutItems{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LeftSpace);
        make.top.equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top).offset(2);
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.right.equalTo(self.focusButton.mas_left).offset(-8);
        make.height.mas_equalTo(22);
    }];
    [self.goShopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.right.equalTo(self).offset(-LeftSpace);
        make.size.mas_equalTo(CGSizeMake(56, 24));
    }];
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goShopButton);
        make.right.equalTo(self.goShopButton.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(42, 24));
    }];
/// 企业认证，个人认证
    self.authTagImageView.userInteractionEnabled = YES;
    self.authTagImageView.hidden = YES;
    [self.authTagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(52., 16.));
    }];
    [self.totalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(@[self.fansView,self.parView]);
        make.height.mas_equalTo(82);
    }];
    [self.parView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.totalView);
    }];
    [self.fansView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.totalView);
        make.right.equalTo(@0);
    }];
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalView);
        make.left.equalTo(self.totalView.mas_right);
        make.right.equalTo(self.parView.mas_left);
        make.size.mas_equalTo(CGSizeMake(1, 34));
    }];
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalView);
        make.left.equalTo(self.parView.mas_right);
        make.right.equalTo(self.fansView.mas_left);
        make.size.mas_equalTo(CGSizeMake(1, 34));
    }];
}



#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailShopTitleViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}

- (UIImageView *)authTagImageView {
    if (!_authTagImageView) {
        _authTagImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _authTagImageView;
}
    
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.layer.masksToBounds = true;
        _iconImageView.layer.cornerRadius = 22;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = BLACK_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}
- (UIButton *)focusButton {
    if (!_focusButton) {
        _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _focusButton
        .jh_fontNum(11)
        .jh_titleColor(GRAY_COLOR)
        .jh_action(self, @selector(didClickFocus:));
        [_focusButton jh_cornerRadius:2];
        [_focusButton jh_borderWithColor:[UIColor colorWithHexString:@"CCCCCC"] borderWidth:0.5];
    }
    return _focusButton;
}
- (UIButton *)goShopButton {
    if (!_goShopButton) {
        _goShopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _goShopButton
        .jh_fontNum(11)
        .jh_titleColor(B_COLOR)
        .jh_backgroundColor([UIColor colorWithHexString:@"FFFBEE"]);
        [_goShopButton jh_cornerRadius:2];
        [_goShopButton jh_borderWithColor:[UIColor colorWithHexString:@"FFD70F"] borderWidth:0.5];
//        _goShopButton.userInteractionEnabled = false; // 点击事件同cell
        [_goShopButton addTarget:self action:@selector(goShowBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goShopButton;
}
- (JHStoreDetailShopSubView *)totalView{
    if (!_totalView) {
        JHStoreDetailShopSubView *view = [JHStoreDetailShopSubView new];
        _totalView = view;
    }
    return _totalView;
}
- (JHStoreDetailShopSubView *)parView{
    if (!_parView) {
        JHStoreDetailShopSubView *view = [JHStoreDetailShopSubView new];
        view.desLbl.text = @"好评度";
        _parView = view;
    }
    return _parView;
}
- (JHStoreDetailShopSubView *)fansView{
    if (!_fansView) {
        JHStoreDetailShopSubView *view = [JHStoreDetailShopSubView new];
        view.desLbl.text = @"粉丝数";
        _fansView = view;
    }
    return _fansView;
}

- (UIView *)leftLineView{
    if (!_leftLineView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xF5F5F5);
        _leftLineView = view;
    }
    return _leftLineView;
}

- (UIView *)rightLineView{
    if (!_rightLineView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xF5F5F5);
        _rightLineView = view;
    }
    return _rightLineView;
}
@end
