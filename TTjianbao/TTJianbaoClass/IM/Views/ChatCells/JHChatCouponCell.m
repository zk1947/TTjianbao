//
//  JHChatCouponCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatCouponCell.h"
#import "UIView+JHGradient.h"

static CGFloat const LeftSpacing = 10.f;

@interface JHChatCouponCell ()
/// 上背景图
@property (nonatomic, strong) UIView *topBgView;
/// 下背景图
@property (nonatomic, strong) UIView *bottomBgView;
/// icon
@property (nonatomic, strong) UIImageView *icon;
/// 优惠券金额
@property (nonatomic, strong) UILabel *moneyLabel;
/// 满多少可用
@property (nonatomic, strong) UILabel *moneyRuleLabel;
/// 使用说明
//@property (nonatomic, strong) UILabel *descLabel;
/// 优惠券名
@property (nonatomic, strong) UILabel *titleLabel;
/// 日期
@property (nonatomic, strong) UILabel *dateLabel;

@end
@implementation JHChatCouponCell

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
    NSLog(@"IM释放-%@ 释放", [self class]);
}
- (void)setupCouponInfo {
    JHChatCouponInfoModel *model = self.message.couponInfo;
    self.titleLabel.text = model.name;
    UIFont *font = [UIFont fontWithName:kFontMedium size:17];
    self.moneyLabel.attributedText = [model getMoneyText : font rightFont : font];
    self.moneyRuleLabel.text = [NSString stringWithFormat:@"(%@)", [model getCouponRuleText]];
//    self.descLabel.text = [model getCouponDescText];
    NSString *state = @"已发放";
    if (self.message.senderType == JHMessageSenderTypeOther) {
        state = @"已入账";
    }
    self.dateLabel.text = [NSString stringWithFormat:@"有效期至:%@(%@)",model.timeTypeAEndTime, state];
    
    [self.messageContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(218);
    }];
}
- (void)setupData {
    @weakify(self)
    [[RACObserve(self.message, couponInfo)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        [self setupCouponInfo];
    }];
}
#pragma mark - UI
- (void)setupUI {
    [self.topBgView jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xff9e02), HEXCOLOR(0xffb43b)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [self.messageContent addSubview:self.topBgView];
    [self.messageContent addSubview:self.bottomBgView];
    [self.topBgView addSubview:self.titleLabel];
    [self.topBgView addSubview:self.moneyLabel];
    [self.topBgView addSubview:self.moneyRuleLabel];
    [self.topBgView addSubview:self.icon];
    
//    [self.bottomBgView addSubview:self.descLabel];
    [self.bottomBgView addSubview:self.dateLabel];
    
}
- (void)layoutViews {
    [self jh_cornerRadius:8];
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(65);
    }];
    [self.bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topBgView.mas_bottom);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(LeftSpacing);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-13);
        make.right.mas_equalTo(-LeftSpacing);
        make.left.mas_equalTo(self.icon.mas_right).offset(LeftSpacing);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(self.titleLabel);
    }];
    [self.moneyRuleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.moneyLabel);
        make.left.mas_equalTo(self.moneyLabel.mas_right).offset(10);
        make.right.mas_lessThanOrEqualTo(-LeftSpacing);
    }];
//    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(LeftSpacing);
//        make.top.mas_equalTo(3);
//        make.right.mas_equalTo(-LeftSpacing);
//    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(3);
        make.left.mas_equalTo(LeftSpacing);
        make.bottom.mas_equalTo(-2);
        make.right.mas_equalTo(-LeftSpacing);
    }];
}
#pragma mark - LAZY
- (UIView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _topBgView;
}
- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomBgView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _bottomBgView;
}
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _icon.image = [UIImage imageNamed:@"IM_coupon_msg_icon"];
    }
    return _icon;
}
- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _moneyLabel.font = [UIFont fontWithName:kFontMedium size:17];
        _moneyLabel.textColor = HEXCOLOR(0xffffff);
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        _moneyLabel.adjustsFontSizeToFitWidth = true;
    }
    return _moneyLabel;
}
- (UILabel *)moneyRuleLabel {
    if (!_moneyRuleLabel) {
        _moneyRuleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _moneyRuleLabel.font = [UIFont fontWithName:kFontMedium size:9];
        _moneyRuleLabel.textColor = HEXCOLOR(0xffffff);
        _moneyRuleLabel.textAlignment = NSTextAlignmentLeft;
        _moneyRuleLabel.adjustsFontSizeToFitWidth = true;
    }
    return _moneyRuleLabel;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _titleLabel.textColor = HEXCOLOR(0xffffff);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
//- (UILabel *)descLabel {
//    if (!_descLabel) {
//        _descLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _descLabel.numberOfLines = 1;
//        _descLabel.font = [UIFont fontWithName:kFontNormal size:10];
//        _descLabel.textColor = HEXCOLOR(0x999999);
//        _descLabel.textAlignment = NSTextAlignmentLeft;
//    }
//    return _descLabel;
//}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _dateLabel.font = [UIFont fontWithName:kFontNormal size:10];
        _dateLabel.textColor = HEXCOLOR(0x999999);
        _dateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _dateLabel;
}
@end
