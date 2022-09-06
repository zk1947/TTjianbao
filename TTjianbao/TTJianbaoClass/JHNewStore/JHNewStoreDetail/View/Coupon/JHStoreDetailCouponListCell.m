//
//  JHStoreDetailCouponListCell.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCouponListCell.h"

@interface JHStoreDetailCouponListCell()
/// 优惠券金额
@property (nonatomic, strong) UILabel *moneyLabel;
/// 满多少可用
@property (nonatomic, strong) UILabel *moneyRuleLabel;
/// title
@property (nonatomic, strong) UILabel *titleLabel;
/// 日期
@property (nonatomic, strong) UILabel *dateLabel;
/// 领取
@property (nonatomic, strong) UIButton *receiveButton;

@property (nonatomic, strong) UIImageView *leftBgImageView;
@property (nonatomic, strong) UIImageView *rightBgImageView;
@property (nonatomic, strong) UIImageView *stateImageView;

@property (nonatomic, strong) UIStackView *moneyStackView;
@property (nonatomic, strong) UIStackView *titleStackView;
@end

@implementation JHStoreDetailCouponListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Life Cycle Functions
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
       
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions


#pragma mark - Action functions
- (void) didClickReceiveButton : (UIButton *)sender {
    [self.viewModel.receiveAction sendNext:nil];
}
#pragma mark - Private Functions
/// 可领取
- (void) setNomalStyle {
    [self.receiveButton setHidden:false];
    [self setNomalButtonStyleWithTitle:@"立即领取"];
    [self.stateImageView setHidden:true];
    [self setNomalBgImage];
    [self setNomalLabel];
}
/// 可继续领取
- (void) setCanContinueReciveStyle {
    [self.receiveButton setHidden:false];
    [self setNomalButtonStyleWithTitle:@"继续领取"];
    [self.stateImageView setHidden:true];
    [self setNomalBgImage];
    [self setNomalLabel];
}
/// 已领取
- (void) setReceivedStyle {
    [self.receiveButton setHidden:true];
    [self.stateImageView setHidden:false];
//    [self setReceivedButtonStyle];
    [self setReceiveBgImage];
    [self setReceiveLabel];
    self.stateImageView.image = [UIImage imageNamed:@"newStore_coupon_yilingqu_icon"];
}
/// 已失效
- (void) setInvalidStyle {
    [self.receiveButton setHidden:true];
    [self.stateImageView setHidden:false];
    [self setReceiveBgImage];
    [self setReceiveLabel];
    self.stateImageView.image = [UIImage imageNamed:@"newStore_coupon_yishixiao_icon"];
}
/// 已抢光
- (void) setAllGoneStyle {
    [self.receiveButton setHidden:true];
    [self.stateImageView setHidden:false];
    [self setReceiveBgImage];
    [self setReceiveLabel];
    self.stateImageView.image = [UIImage imageNamed:@"newStore_coupon_yiqiangguang_icon"];
}
/// 默认背景图
- (void) setNomalBgImage {
    self.leftBgImageView.image = [UIImage imageNamed:@"newStore_coupon_dark_left_bg"];
    self.rightBgImageView.image = [UIImage imageNamed:@"newStore_coupon_dark_right_bg"];
}
/// 领取、失效、抢光 背景图
- (void) setReceiveBgImage {
    self.leftBgImageView.image = [UIImage imageNamed:@"newStore_coupon_light_left_bg"];
    self.rightBgImageView.image = [UIImage imageNamed:@"newStore_coupon_light_right_bg"];
}
- (void) setNomalLabel {
    self.moneyLabel.textColor = [UIColor colorWithHexString:@"7E1C0D"];
    self.moneyRuleLabel.textColor = [UIColor colorWithHexString:@"7E1C0D"];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"222222"];
    self.dateLabel.textColor = [UIColor colorWithHexString:@"666666"];
}
- (void) setReceiveLabel {
    self.moneyLabel.textColor = [UIColor colorWithHexString:@"BE8D86"];
    self.moneyRuleLabel.textColor = [UIColor colorWithHexString:@"BE8D86"];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.dateLabel.textColor = [UIColor colorWithHexString:@"999999"];
}
/// 可领取
- (void) setNomalButtonStyleWithTitle : (NSString *)title {
    [self.receiveButton setTitle:title
                        forState:UIControlStateNormal];
    [self.receiveButton setTitleColor:[UIColor colorWithHexString:@"222222"]
                             forState:UIControlStateNormal];
    [self.receiveButton setImage:[UIImage imageNamed:@""]
                        forState:UIControlStateNormal];
    [self.receiveButton jh_borderWithColor:UIColor.whiteColor borderWidth:0];
    self.receiveButton.backgroundColor = [UIColor colorWithHexString:@"FFD70F"];
}
/// 已领取- 暂不支持去使用。
- (void) setReceivedButtonStyle {
    [self.receiveButton setTitle:@"去使用"
                        forState:UIControlStateNormal];
    [self.receiveButton setTitleColor:[UIColor colorWithHexString:@"FF6A00"]
                             forState:UIControlStateNormal];
    [self.receiveButton setImage:[UIImage imageNamed:@"newStore_more_orange_icon"]
                        forState:UIControlStateNormal];
    [self.receiveButton jh_borderWithColor:[UIColor colorWithHexString:@"FF6A00"] borderWidth:0.5];
    self.receiveButton.backgroundColor = [UIColor colorWithHexString:@"FFD70F"];
}

#pragma mark - Bind
- (void) bindData {
    RAC(self.moneyLabel, attributedText) = [RACObserve(self.viewModel, moneyText)
                                            takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.moneyRuleLabel, text) = [RACObserve(self.viewModel, moneyRuleText)
                                      takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.titleLabel, text) = [RACObserve(self.viewModel, titleText)
                                      takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.dateLabel, text) = [RACObserve(self.viewModel, dateText)
                                      takeUntil:self.rac_prepareForReuseSignal];
    
    @weakify(self)
    [[RACObserve(self.viewModel, couponStatus)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        NSInteger type = [x integerValue];

        switch (type) {
            case 0:
                [self setNomalStyle];
                break;
            case 1:
                [self setReceivedStyle];
                break;
            case 2:
                [self setInvalidStyle];
                break;
            case 3:
                [self setAllGoneStyle];
                break;
            case 4:
                [self setCanContinueReciveStyle];
                break;
            default:
                break;
        }
    }];
  
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.leftBgImageView];
    [self addSubview:self.rightBgImageView];
    [self.leftBgImageView addSubview:self.moneyStackView];
    [self.rightBgImageView addSubview:self.stateImageView];
    [self.rightBgImageView addSubview:self.titleStackView];
    [self.rightBgImageView addSubview:self.receiveButton];
}
- (void) layoutViews {
    [self.leftBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(90);
    }];
    [self.rightBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.left.equalTo(self.leftBgImageView.mas_right).offset(0);
    }];
    [self.moneyStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBgImageView).offset(2);
        make.right.equalTo(self.leftBgImageView).offset(-2);
        make.centerY.equalTo(self.leftBgImageView.mas_centerY);
    }];
    [self.titleStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightBgImageView).offset(10);
        make.right.equalTo(self.receiveButton.mas_left).offset(-10);
        make.centerY.equalTo(self.rightBgImageView.mas_centerY);
    }];
    [self.stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.rightBgImageView);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    [self.receiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightBgImageView);
        make.right.equalTo(self.rightBgImageView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 26));
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailCouponListCellViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:30];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"7E1C0D"];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.adjustsFontSizeToFitWidth = true;
    }
    return _moneyLabel;
}
- (UILabel *)moneyRuleLabel {
    if (!_moneyRuleLabel) {
        _moneyRuleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _moneyRuleLabel.font = [UIFont systemFontOfSize:11];
        _moneyRuleLabel.textColor = [UIColor colorWithHexString:@"7E1C0D"];
        _moneyRuleLabel.textAlignment = NSTextAlignmentCenter;
        _moneyRuleLabel.adjustsFontSizeToFitWidth = true;
    }
    return _moneyRuleLabel;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _titleLabel.textColor = [UIColor colorWithHexString:@"222222"];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _dateLabel.font = [UIFont systemFontOfSize:10];
        _dateLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _dateLabel;
}
- (UIStackView *)moneyStackView {
    if (!_moneyStackView) {
        _moneyStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.moneyLabel, self.moneyRuleLabel]];
        _moneyStackView.spacing = 2;
        _moneyStackView.alignment = UIStackViewAlignmentFill;
        _moneyStackView.distribution = UIStackViewDistributionFill;
        _moneyStackView.axis = UILayoutConstraintAxisVertical;
    }
    return _moneyStackView;
}
- (UIStackView *)titleStackView {
    if (!_titleStackView) {
        _titleStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.titleLabel, self.dateLabel]];
        _titleStackView.spacing = 6;
        _titleStackView.alignment = UIStackViewAlignmentFill;
        _titleStackView.distribution = UIStackViewDistributionFill;
        _titleStackView.axis = UILayoutConstraintAxisVertical;
    }
    return _titleStackView;
}
- (UIImageView *)leftBgImageView {
    if (!_leftBgImageView) {
        _leftBgImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _leftBgImageView;
}
- (UIImageView *)rightBgImageView {
    if (!_rightBgImageView) {
        _rightBgImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _rightBgImageView.userInteractionEnabled = true;
    }
    return _rightBgImageView;
}
- (UIButton *)receiveButton {
    if (!_receiveButton) {
        _receiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _receiveButton
        .jh_fontNum(12);
//        .jh_action(self, @selector(didClickReceiveButton:));
        [_receiveButton jh_cornerRadius:4];
        [_receiveButton addTarget:self action:@selector(didClickReceiveButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receiveButton;
}
- (UIImageView *)stateImageView {
    if (!_stateImageView) {
        _stateImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _stateImageView;
}
@end
