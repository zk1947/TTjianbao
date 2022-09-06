//
//  JHRecycleOrderDetailCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailCell.h"

static const CGFloat DuplicateButtonHeight = 22.0f;

@interface JHRecycleOrderDetailCell()
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 详情
@property (nonatomic, strong) UILabel *detailLabel;
/// 复制
@property (nonatomic, strong) UIButton *duplicateButton;

@end
@implementation JHRecycleOrderDetailCell

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
- (void)didClickCopyWithSender : (UIButton *)sender {
    [self.viewModel.clickEvent sendNext:nil];
}
#pragma mark - Bind
- (void)bindData {
    RAC(self.titleLabel, text) = [RACObserve(self.viewModel, titleText)
                                  takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.detailLabel, text) = [RACObserve(self.viewModel, detailText)
                                   takeUntil:self.rac_prepareForReuseSignal];
    @weakify(self)
    [[RACObserve(self.viewModel, isShowCopy)
     takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        BOOL show = [x boolValue];
        self.duplicateButton.hidden = !show;
        if (show == 1) {
            [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.duplicateButton.mas_left).offset(-10);
            }];
        }else {
            [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.content).offset(-LeftSpace);
            }];
        }
    }];
}
#pragma mark - Private Functions
#pragma mark - setupUI
- (void)setupUI {
    [self.content addSubview:self.titleLabel];
    [self.content addSubview:self.detailLabel];
    [self.content addSubview:self.duplicateButton];
}
- (void)layoutViews {
    [self.duplicateButton jh_cornerRadius:DuplicateButtonHeight / 2];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content).offset(LeftSpace);
        make.width.mas_equalTo(60);
        make.top.bottom.equalTo(self.content).offset(0);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(2);
        make.right.equalTo(self.duplicateButton.mas_left).offset(-10);
        make.top.bottom.equalTo(self.content).offset(0);
    }];
    [self.duplicateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.content).offset(-LeftSpace);
        make.size.mas_equalTo(CGSizeMake(40, DuplicateButtonHeight));
        make.centerY.equalTo(self.content.mas_centerY);
    }];
}
- (UILabel *)getLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont fontWithName:kFontNormal size:12];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = HEXCOLOR(0x666666);
    return label;
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderDetailInfoViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [self getLabel];
    }
    return _titleLabel;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [self getLabel];
    }
    return _detailLabel;
}
- (UIButton *)duplicateButton {
    if (!_duplicateButton) {
        _duplicateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_duplicateButton setTitle:@"复制" forState:UIControlStateNormal];
        _duplicateButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _duplicateButton.jh_action(self, @selector(didClickCopyWithSender:));
        [_duplicateButton jh_borderWithColor:HEXCOLOR(0xBDBFC2) borderWidth:0.5];
        [_duplicateButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _duplicateButton.userInteractionEnabled = false;
    }
    return _duplicateButton;
}
@end
