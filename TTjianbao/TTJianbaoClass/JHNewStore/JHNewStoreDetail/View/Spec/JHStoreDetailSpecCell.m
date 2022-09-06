//
//  JHStoreDetailSpecCell.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailSpecCell.h"
@interface JHStoreDetailSpecCell()
@property(nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UIView * lineView;
@property(nonatomic, strong) UIButton * detailBtn;
@end
@implementation JHStoreDetailSpecCell

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
        [self layoutItems];

    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions

#pragma mark - Private Functions
#pragma mark - Action functions

- (void)showIntroduceBtn:(UIButton*)sender{
    NSDictionary *par = @{@"proID" : self.viewModel.ID,
                          @"name" : self.viewModel.titleText,
                          @"attTitle" : self.viewModel.attrDescTitle};
    NSDictionary *dic = @{@"type" : @"Introduct",
                          @"parameter" : par};
    [self.viewModel.pushvc sendNext:dic];
}

#pragma mark - Bind
- (void) bindData {
    RAC(self.titleLabel, text) = [RACObserve(self.viewModel, titleText) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.detailLabel, text) = [RACObserve(self.viewModel, detailText) takeUntil:self.rac_prepareForReuseSignal];
    self.backView.backgroundColor = self.viewModel.index%2 == 0 ? HEXCOLOR(0xFAFAFA) : UIColor.whiteColor;
    CGFloat btnWide = self.viewModel.hasIntroduct ? 85.f : 1;
    self.detailBtn.hidden = !self.viewModel.hasIntroduct;
    if (self.viewModel.hasIntroduct) {
        [self.detailBtn setTitle:self.viewModel.attrDescTitle forState:UIControlStateNormal];
    }else{
        [self.detailBtn setTitle:@"" forState:UIControlStateNormal];
    }
    [self.detailBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0).offset(-10);
        make.centerY.equalTo(@0);
        make.height.mas_equalTo(40.f);
        make.width.mas_lessThanOrEqualTo(btnWide);
    }];
}
#pragma mark - setupUI
- (void) setupUI {
    self.contentView.userInteractionEnabled = true;
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.detailLabel];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.detailBtn];

}
- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0).inset(LeftSpace);
        make.top.bottom.equalTo(@0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).offset(20);
        make.right.equalTo(self.lineView.mas_left).offset(-5);
        make.top.equalTo(@0).offset(10);
        make.bottom.equalTo(@0).offset(-10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@92);
        make.top.bottom.equalTo(@0);
        make.width.mas_equalTo(0.5f);
    }];
    CGFloat btnWide = self.viewModel.hasIntroduct ? 85.f : 1;
    [self.detailBtn setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.detailBtn setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.detailLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.detailLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0).offset(-5);
        make.centerY.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(btnWide, 40));
    }];

    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.detailBtn.mas_left);
        make.left.equalTo(self.lineView.mas_right).offset(20);
        make.top.equalTo(@0).offset(10);
        make.bottom.equalTo(@0).offset(-10);
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailSpecViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = GRAY_COLOR;
        _titleLabel.font = [UIFont systemFontOfSize:SpecFontSize];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.numberOfLines = 0;
        _detailLabel.textColor = BLACK_COLOR;
        _detailLabel.font = [UIFont systemFontOfSize:SpecFontSize];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _detailLabel;
}
- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.layer.borderWidth = 0.5f;
        view.layer.borderColor = HEXCOLOR(0xE6E6E6).CGColor;
        _backView = view;
    }
    return _backView;
}
- (UIView *)lineView{
    if (!_lineView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xE6E6E6);
        _lineView = view;
    }
    return _lineView;
}
- (UIButton *)detailBtn{
    if (!_detailBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"c2c_class_alert_alert"] forState:UIControlStateNormal];
        [btn setTitle:@"作用说明" forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x2F66A0) forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(12);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
        [btn addTarget:self action:@selector(showIntroduceBtn:) forControlEvents:UIControlEventTouchUpInside];
        _detailBtn = btn;
    }
    return _detailBtn;
}
@end
