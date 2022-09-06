//
//  JHStoreDetailTitleCell.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailTitleCell.h"


@interface JHStoreDetailTitleCell()
@property (nonatomic, strong) YYLabel *titleLabel;
@end
@implementation JHStoreDetailTitleCell

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
    RAC(self.titleLabel, attributedText) = [RACObserve(self.viewModel, titleText) takeUntil:self.rac_prepareForReuseSignal];

}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLabel];
}
- (void) layoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LeftSpace);
        make.right.equalTo(self).offset(-LeftSpace);
        make.top.equalTo(self).offset(TitleTopSpace);
        make.bottom.equalTo(self).offset(-TitleTopSpace);
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailTitleViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = B_COLOR;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentJustified;
        _titleLabel.font = [UIFont boldSystemFontOfSize:TitleFontSize];
    }
    return _titleLabel;
}
@end
