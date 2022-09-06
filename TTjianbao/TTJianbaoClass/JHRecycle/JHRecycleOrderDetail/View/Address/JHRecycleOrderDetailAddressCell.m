//
//  JHRecycleOrderDetailAddressCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailAddressCell.h"

@interface JHRecycleOrderDetailAddressCell()
/// 取件图标
@property (nonatomic, strong) UIImageView *icon;
/// 地址信息
@property (nonatomic, strong) UILabel *addressLabel;
/// 用户信息
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UIStackView *stackView;

@end
@implementation JHRecycleOrderDetailAddressCell

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
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Action functions
#pragma mark - Private Functions

#pragma mark - Bind
- (void)bindData {
    RAC(self.addressLabel,text) = [RACObserve(self.viewModel, addressText)
                                   takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.userLabel,text) = [RACObserve(self.viewModel, userText)
                                   takeUntil:self.rac_prepareForReuseSignal];
   
}
#pragma mark - setupUI
- (void)setupUI {
    [self.content addSubview:self.icon];
    [self.content addSubview:self.stackView];
    
}
- (void)layoutViews {
    [self setupCornerRadiusWithRect:RecycleOrderDetailCornerAll];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content).offset(LeftSpace);
        make.centerY.equalTo(self.content.mas_centerY).offset(2);
        make.size.mas_equalTo(CGSizeMake(IconWidth, 27));
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(AddressLeftSpace);
        make.right.equalTo(self.content).offset(-LeftSpace);
        make.centerY.equalTo(self.icon.mas_centerY);
    }];
//    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.icon.mas_right).offset(AddressLeftSpace);
//        make.bottom.equalTo(self.icon.mas_centerY).offset(0);
//        make.right.equalTo(self.content).offset(-LeftSpace);
//    }];
//    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.addressLabel);
//        make.right.equalTo(self.addressLabel);
//        make.top.equalTo(self.icon.mas_centerY).offset(0);
//    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderDetailAddressViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _icon.image = [UIImage imageNamed:@"recycle_orderDetail_address_icon"];
    }
    return _icon;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _addressLabel.textColor = HEXCOLOR(0x333333);
        _addressLabel.numberOfLines = 0;
        _addressLabel.textAlignment = NSTextAlignmentJustified;
        _addressLabel.font = [UIFont fontWithName:kFontNormal size:AddressFontSize];
    }
    return _addressLabel;
}
- (UILabel *)userLabel {
    if (!_userLabel) {
        _userLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userLabel.textColor = HEXCOLOR(0x666666);
        _userLabel.textAlignment = NSTextAlignmentLeft;
        _userLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _userLabel;
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.addressLabel, self.userLabel]];
        _stackView.spacing = 6;
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.distribution = UIStackViewDistributionEqualSpacing;
    }
    return _stackView;
}
@end
