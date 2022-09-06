//
//  JHRecycleOrderDetailStatusTitleCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailStatusTitleCell.h"
#import "UIView+JHGradient.h"
@interface JHRecycleOrderDetailStatusTitleCell()
/// 状态Icon
@property (nonatomic, strong) UIImageView *icon;
/// 状态
@property (nonatomic, strong) UILabel *statusLabel;
/// 详情
@property (nonatomic, strong) UILabel *priceLabel;

@end
@implementation JHRecycleOrderDetailStatusTitleCell

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
    RAC(self.statusLabel, text) = [RACObserve(self.viewModel, statusText)
                                   takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.priceLabel, attributedText) = [RACObserve(self.viewModel, priceText)
                                            takeUntil:self.rac_prepareForReuseSignal];
    
    @weakify(self)
             
    [[RACObserve(self.viewModel, iconUrl)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        self.icon.image = [UIImage imageNamed:x];
    }];
    
    [[RACObserve(self.viewModel, orderTitleStatus)
    takeUntil:self.rac_prepareForReuseSignal]
    subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSInteger status = [x integerValue];
        switch (status) {
            case 1: //默认
                [self setupNomalUI];
                break;
            case 2: // 金额
                [self setupPriceUI];
                break;
            case 3: // 带图片
                [self setupIconUI];
                break;
            default:
                break;
        }
    }];
}
#pragma mark - setupUI
- (void)setupUI {
    [self jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xfe5e19), HEXCOLOR(0xf12429)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [self.content addSubview:self.statusLabel];
    [self.content addSubview:self.priceLabel];
    [self.content addSubview:self.icon];
}
- (void)layoutViews {
    [self setupCornerRadiusWithRect:RecycleOrderDetailCornerTop];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(5);
        make.right.equalTo(self.priceLabel.mas_left).offset(-4);
        make.bottom.equalTo(self.content).offset(-1);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.content).offset(-LeftSpace);
        make.bottom.equalTo(self.statusLabel.mas_bottom);
//        make.centerY.equalTo(self.statusLabel.mas_centerY);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content).offset(LeftSpace);
        make.centerY.equalTo(self.statusLabel.mas_centerY).offset(0);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}
- (void)setupNomalUI {
    self.icon.hidden = true;
    self.priceLabel.hidden = true;
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content).offset(LeftSpace);
        make.right.equalTo(self.content).offset(-LeftSpace);
    }];
}
- (void)setupPriceUI {
    self.icon.hidden = true;
    self.statusLabel.hidden = false;
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content).offset(LeftSpace);
    }];
}
- (void)setupIconUI {
    self.icon.hidden = false;
    self.priceLabel.hidden = true;
    
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content).offset(LeftSpace);
    }];
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(5);
        make.right.equalTo(self.content).offset(-LeftSpace);
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderDetailStatusTitleViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _icon;
}
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.textColor = HEXCOLOR(0x333333);
        _statusLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _statusLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _statusLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.textColor = HEXCOLOR(0xff4200);
        _priceLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLabel;
}
@end
