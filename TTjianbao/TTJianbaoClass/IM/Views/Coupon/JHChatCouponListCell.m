//
//  JHChatCouponCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatCouponListCell.h"

static CGFloat const LeftSpacing = 25.f;

@interface JHChatCouponListCell ()
@property (nonatomic, strong) UIImageView *leftBgView;
@property (nonatomic, strong) UIView *rightBgView;
/// 优惠券金额
@property (nonatomic, strong) UILabel *moneyLabel;
/// 满多少可用
@property (nonatomic, strong) UILabel *moneyRuleLabel;
/// 使用说明
@property (nonatomic, strong) UILabel *descLabel;
/// 优惠券名
@property (nonatomic, strong) UILabel *titleLabel;
/// 日期
@property (nonatomic, strong) UILabel *dateLabel;
/// 选中状态
@property (nonatomic, strong) UIImageView *selectState;
@property (nonatomic, strong) UIStackView *moneyStackView;
@end
@implementation JHChatCouponListCell

#pragma mark - Init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}

- (void)bindData {
    if (self.model == nil) return;
    
    [self setupDate];
    
    self.titleLabel.text = self.model.name;
    self.descLabel.text = [self.model getCouponDescText];
    self.moneyLabel.attributedText = [self.model getMoneyText:[UIFont fontWithName:kFontNormal size:12] rightFont:[UIFont fontWithName:kFontBoldDIN size:30]];
    self.moneyRuleLabel.text = [self.model getCouponRuleText];
    
    @weakify(self)
    [[RACObserve(self.model, isSelected)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        BOOL isSelected = [x boolValue];
        if (isSelected) {
            self.selectState.image = [UIImage imageNamed:@"IM_coupon_sel_icon"];
        }else {
            self.selectState.image = [UIImage imageNamed:@"IM_coupon_nor_icon"];
        }
    }];
}


- (void)setupDate {
    if ([self.model.timeType isEqualToString:@"R"]) {//使用时间类型:R相对时间,A:绝对时间"
        NSString *day = self.model.timeTypeRDay ?: @"";
        self.dateLabel.text = [NSString stringWithFormat:@"有效期%@天", day];
    }else {
        self.dateLabel.text = [NSString stringWithFormat:@"有效期至:%@", self.model.timeTypeAEndTime];
    }
}

- (void)setupUI {
    [self jh_cornerRadius:0 shadowColor:HEXCOLORA(0x000000, 0.03)];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.leftBgView];
    [self addSubview:self.rightBgView];
    [self.leftBgView addSubview:self.moneyStackView];
    [self.rightBgView addSubview:self.titleLabel];
    [self.rightBgView addSubview:self.descLabel];
    [self.rightBgView addSubview:self.dateLabel];
    [self.rightBgView addSubview:self.selectState];
}
- (void)layoutViews {
    [self.leftBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LeftSpacing);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(105);
    }];
    [self.moneyStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBgView).offset(2);
        make.right.equalTo(self.leftBgView).offset(-2);
        make.centerY.equalTo(self.leftBgView.mas_centerY);
    }];
    [self.rightBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-LeftSpacing);
        make.left.mas_equalTo(self.leftBgView.mas_right);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(6);
        
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(6);
        make.left.right.mas_equalTo(self.titleLabel);
        make.bottom.mas_lessThanOrEqualTo(self.dateLabel.mas_top).offset(-10);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(-6);
    }];
    [self.selectState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];
}
#pragma mark - LAZY
- (void)setModel:(JHChatCouponInfoModel *)model {
    _model = model;
    [self bindData];
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _moneyLabel.font = [UIFont fontWithName:kFontBoldDIN size:30];;
        _moneyLabel.textColor = HEXCOLOR(0xffffff);
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.adjustsFontSizeToFitWidth = true;
    }
    return _moneyLabel;
}
- (UILabel *)moneyRuleLabel {
    if (!_moneyRuleLabel) {
        _moneyRuleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _moneyRuleLabel.font = [UIFont fontWithName:kFontNormal size:10];;
        _moneyRuleLabel.textColor = HEXCOLOR(0xffffff);
        _moneyRuleLabel.textAlignment = NSTextAlignmentCenter;
        _moneyRuleLabel.adjustsFontSizeToFitWidth = true;
    }
    return _moneyRuleLabel;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _descLabel.numberOfLines = 2;
        _descLabel.font = [UIFont fontWithName:kFontNormal size:11];
        _descLabel.textColor = HEXCOLOR(0x999999);
        _descLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _descLabel;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _dateLabel.font = [UIFont fontWithName:kFontNormal size:10];;
        _dateLabel.textColor = HEXCOLOR(0x999999);
        _dateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _dateLabel;
}
- (UIStackView *)moneyStackView {
    if (!_moneyStackView) {
        _moneyStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.moneyLabel, self.moneyRuleLabel]];
        _moneyStackView.spacing = 6;
        _moneyStackView.alignment = UIStackViewAlignmentFill;
        _moneyStackView.distribution = UIStackViewDistributionFill;
        _moneyStackView.axis = UILayoutConstraintAxisVertical;
    }
    return _moneyStackView;
}
- (UIImageView *)leftBgView {
    if (!_leftBgView) {
        _leftBgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _leftBgView.image = [UIImage imageNamed:@"IM_coupon_left_bg"];
    }
    return _leftBgView;
}
- (UIView *)rightBgView {
    if (!_rightBgView) {
        _rightBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _rightBgView.backgroundColor = HEXCOLOR(0xffffff);
        [_rightBgView jh_cornerRadius:5];
        [_rightBgView jh_borderWithColor:HEXCOLOR(0xe8e8e8) borderWidth:0.5];
    }
    return _rightBgView;
}
- (UIImageView *)selectState {
    if (!_selectState) {
        _selectState = [[UIImageView alloc] initWithFrame:CGRectZero];
        _selectState.image = [UIImage imageNamed:@"IM_coupon_nor_icon"];
    }
    return _selectState;
}
@end
