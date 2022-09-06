//
//  JHRecycleOrderDetailServiceCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailServiceCell.h"

@interface JHRecycleOrderDetailServiceCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIStackView *stackView;

@end
@implementation JHRecycleOrderDetailServiceCell

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
#pragma mark - setupUI
- (void)setupUI {
    [self.content addSubview:self.stackView];
}
- (void)layoutViews {
    [self setupCornerRadiusWithRect:RecycleOrderDetailCornerAll];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.content).offset(0);
        make.top.equalTo(self.content).offset(2);
        make.bottom.equalTo(self.content).offset(-2);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}
#pragma mark - Lazy
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc]
                      initWithArrangedSubviews:@[self.icon, self.titleLabel]];
        _stackView.spacing = 5;
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.distribution = UIStackViewDistributionEqualSpacing;
        
    }
    return _stackView;
}
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _icon.image = [UIImage imageNamed:@"order_contactService_icon"];
    }
    return _icon;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"联系客服";
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _titleLabel;
}
@end
