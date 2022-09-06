//
//  JHRecycleOrderCancelCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderCancelCell.h"
@interface JHRecycleOrderCancelCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selIcon;
@end
@implementation JHRecycleOrderCancelCell

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
    RAC(self.titleLabel, text) = [RACObserve(self.viewModel, titleText)
                                  takeUntil:self.rac_prepareForReuseSignal];
    @weakify(self)
    [[RACObserve(self.viewModel, isSelected)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        BOOL isSelected = [x boolValue];
        if (isSelected) {
            self.selIcon.image = [UIImage imageNamed:@"recycle_piublish_price_selected"];
        }else{
            self.selIcon.image = [UIImage imageNamed:@"recycle_piublish_price_normal"];
        }
    }];
}
#pragma mark - setupUI
- (void)setupUI {
    self.contentView.userInteractionEnabled = false;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.titleLabel];
    [self addSubview:self.selIcon];
}
- (void)layoutViews {

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.selIcon.mas_left).offset(-15);
    }];
    [self.selIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.equalTo(self).offset(-15);
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderCancelCellViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
    }
    return _titleLabel;
}
- (UIImageView *)selIcon {
    if (!_selIcon) {
        _selIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        _selIcon.image = [UIImage imageNamed:@"recycle_order_cancel_normal"];
    }
    return _selIcon;
}
@end
