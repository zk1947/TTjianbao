//
//  JHRecycleImagePickerImageCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleImagePickerImageCell.h"
@interface JHRecycleImagePickerImageCell()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIImageView *durationBg;
@property (nonatomic, strong) UIImageView *maskImageView;
@end

@implementation JHRecycleImagePickerImageCell
#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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
#pragma mark - Bind
- (void)bindData {
    
    RAC(self.bgImageView, image) = [RACObserve(self.viewModel.assetModel, thumbnailImage) takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.selectButton, selected) = [RACObserve(self.viewModel, isSelected) takeUntil:self.rac_prepareForReuseSignal];
    
    @weakify(self)
    [[RACObserve(self.viewModel, videoDuration)
      takeUntil:self.rac_prepareForReuseSignal]
    subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.durationLabel.text = x;
        if (x == nil || [x isEqualToString:@""]) {
            self.durationBg.hidden = true;
        }else {
            self.durationBg.hidden = false;
        }
    }];
    
    [[RACObserve(self.viewModel, canSelected) takeUntil:self.rac_prepareForReuseSignal]
    subscribeNext:^(id  _Nullable x) {
        BOOL canSelected = [x boolValue];
        self.maskImageView.hidden = canSelected;
    }];
}
#pragma mark - setupUI
- (void)setupUI {
    [self addSubview:self.bgImageView];
    [self addSubview:self.selectButton];
    [self addSubview:self.durationBg];
    [self addSubview:self.durationLabel];
    [self addSubview:self.maskImageView];
}
- (void)layoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(4);
        make.right.equalTo(self).offset(-4);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    [self.durationBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-4);
        make.right.mas_equalTo(-6);
    }];
    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleImagePickerCellViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.backgroundColor = HEXCOLOR(0xd8d8d8);
    }
    return _bgImageView;
}
- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _maskImageView.userInteractionEnabled = false;
        _maskImageView.image = [UIImage imageNamed:@"recycle_album_mask"];
        _maskImageView.hidden = true;
    }
    return _maskImageView;
}
- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.userInteractionEnabled = false;
        [_selectButton setImage:[UIImage imageNamed:@"recycle_album_normal"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"recycle_album_sel"] forState:UIControlStateSelected];
    }
    return _selectButton;
}
- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _durationLabel.textColor = HEXCOLOR(0xffffff);
        _durationLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _durationLabel;
}
- (UIImageView *)durationBg {
    if (!_durationBg) {
        _durationBg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _durationBg.image = [UIImage imageNamed:@"recycle_album_duration_bg"];
    }
    return _durationBg;
}
@end
