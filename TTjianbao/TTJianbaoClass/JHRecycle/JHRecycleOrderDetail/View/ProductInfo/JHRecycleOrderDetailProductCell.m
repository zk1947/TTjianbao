//
//  JHRecycleOrderDetailProductCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailProductCell.h"

@interface JHRecycleOrderDetailProductCell()
/// 商家名
@property (nonatomic, strong) UILabel *titleLabel;
/// 分割线
@property (nonatomic, strong) UIView *topLine;
/// 产品图片
@property (nonatomic, strong) UIImageView *icon;
/// 商品详情
@property (nonatomic, strong) UILabel *detailLabel;
/// 商品分类
@property (nonatomic, strong) UILabel *sortLabel;
/// 商品报价
@property (nonatomic, strong) UILabel *priceLabel;

@end
@implementation JHRecycleOrderDetailProductCell

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
    RAC(self.titleLabel,text) = [RACObserve(self.viewModel, titleText)
                                 takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.detailLabel,text) = [RACObserve(self.viewModel, detailText)
                                 takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.sortLabel,text) = [RACObserve(self.viewModel, sortText)
                                 takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.priceLabel,attributedText) = [RACObserve(self.viewModel, priceText)
                                 takeUntil:self.rac_prepareForReuseSignal];
    @weakify(self)
    [[RACObserve(self.viewModel, productUrl)
    takeUntil:self.rac_prepareForReuseSignal]
    subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        [self.icon jh_setImageWithUrl:x placeHolder:@"newStore_default_header_placeholder"];
    }];
    
    
}
#pragma mark - setupUI
- (void)setupUI {
    [self.content addSubview:self.titleLabel];
    [self.content addSubview: self.icon];
    [self.content addSubview: self.topLine];
    [self.content addSubview:self.detailLabel];
    [self.content addSubview:self.sortLabel];
    [self.content addSubview:self.priceLabel];
}
- (void)layoutViews {
    [self setupCornerRadiusWithRect:RecycleOrderDetailCornerAll];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content).offset(37);
        make.left.equalTo(self.content).offset(LeftSpace);
        make.right.equalTo(self.content).offset(-LeftSpace);
        make.height.mas_equalTo(0.5f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content);
        make.bottom.equalTo(self.topLine.mas_top);
        make.left.equalTo(self.content).offset(LeftSpace);
        make.right.equalTo(self.content).offset(-LeftSpace);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.topLine.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    [self.sortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon);
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.right.equalTo(self.content).offset(-LeftSpace);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sortLabel.mas_bottom).offset(8);
        make.left.equalTo(self.sortLabel);
        make.right.equalTo(self.sortLabel);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.content).offset(-12);
        make.right.equalTo(self.content).offset(-LeftSpace);
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderDetailProductViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc]initWithFrame:CGRectZero];
        _topLine.backgroundColor = HEXCOLOR(0xf0f0f0);
    }
    return _topLine;
}
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_icon jh_cornerRadius:4];
    }
    return _icon;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _detailLabel.textColor = HEXCOLOR(0x666666);
        _detailLabel.numberOfLines = 2;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _detailLabel;
}
- (UILabel *)sortLabel {
    if (!_sortLabel) {
        _sortLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _sortLabel.textColor = HEXCOLOR(0x333333);
        _sortLabel.textAlignment = NSTextAlignmentLeft;
        _sortLabel.font = [UIFont fontWithName:kFontMedium size:14];
    }
    return _sortLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _priceLabel.textColor = HEXCOLOR(0x333333);
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _priceLabel;
}
@end
