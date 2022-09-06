//
//  JHStoreDetailGoodsDesTitleCell.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailSectionTitleCell.h"
@interface JHStoreDetailSectionTitleCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation JHStoreDetailSectionTitleCell

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
    RAC(self.titleLabel, text) = [RACObserve(self.viewModel, titleText) takeUntil:self.rac_prepareForReuseSignal];
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLabel];
}
- (void) layoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LeftSpace);
        make.top.equalTo(self).offset(19);
        make.right.equalTo(self).offset(-LeftSpace);
//        make.bottom.equalTo(self).offset(-10);
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailSectionTitleViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel
        .jh_textColor(BLACK_COLOR);
    }
    return _titleLabel;
}
@end
