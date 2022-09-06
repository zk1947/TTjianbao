//
//  JHStoreDetailSpecialCell.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品专场

#import "JHStoreDetailSpecialCell.h"

@interface JHStoreDetailSpecialCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *detailIcon;
@end

@implementation JHStoreDetailSpecialCell

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

#pragma mark - Private Functions
#pragma mark - Action functions
#pragma mark - Bind
- (void) bindData {
    RAC(self.titleLabel, text) = [RACObserve(self.viewModel, titleText)
                                  takeUntil:self.rac_prepareForReuseSignal];
}
#pragma mark - setupUI
- (void) setupUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailIcon];
}
- (void) layoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LeftSpace);
        make.right.equalTo(self.detailIcon.mas_left).offset(-4);
        make.top.equalTo(self).offset(3);
    }];
    [self.detailIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 8));
        make.centerY.equalTo(self.titleLabel.mas_centerY).offset(0);
        make.right.mas_lessThanOrEqualTo(self).offset(-LeftSpace);
    }];
}
#pragma mark - Lazy
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor colorWithHexString:@"B9855D"];
    }
    return _titleLabel;
}
- (UIImageView *)detailIcon {
    if (!_detailIcon) {
        _detailIcon = [[UIImageView alloc] init];
        _detailIcon.image = [UIImage imageNamed:@"newStore_more_icon"];
    }
    return _detailIcon;
}
- (void)setViewModel:(JHStoreDetailSpecialViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
@end
