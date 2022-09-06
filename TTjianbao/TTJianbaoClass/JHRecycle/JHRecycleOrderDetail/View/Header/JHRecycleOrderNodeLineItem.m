//
//  JHRecycleOrderNodeLineItem.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderNodeLineItem.h"
@interface JHRecycleOrderNodeLineItem()
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *detailLabel;
@end
@implementation JHRecycleOrderNodeLineItem
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
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions

#pragma mark - Private Functions

#pragma mark - Action functions
- (void)didClickPlay : (UIButton *)sender {
    
}
#pragma mark - Bind
- (void) bindData {
    RAC(self.detailLabel, text) = RACObserve(self.viewModel, detailText);
    
    @weakify(self)
    [RACObserve(self.viewModel, isHighlight)
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        BOOL isHighlight = [x boolValue];
        if (isHighlight == true) {
            [self setHighlightUI];
        }else {
            [self setNoHighlightUI];
        }
    }];
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.line];
    [self addSubview:self.detailLabel];
}
- (void) layoutViews {
    CGFloat width = (ScreenW - LeftSpace * 2) / 7 + 6;
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(22);
        make.left.equalTo(self).offset(-((width - RecycloOrderNodeNumWidth) / 2 - 8));
        make.right.equalTo(self).offset((width - RecycloOrderNodeNumWidth) / 2 - 8);
        make.height.mas_equalTo(2);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.centerX.equalTo(self).offset(0);
//        make.left.right.equalTo(self.line);
    }];
}
- (void)setHighlightUI {
    self.line.backgroundColor = HEXCOLOR(0xffffff);
    self.detailLabel.textColor = HEXCOLOR(0xffffff);
}
- (void)setNoHighlightUI {
    self.line.backgroundColor = HEXCOLORA(0xffffff, 0.5);
    self.detailLabel.textColor = HEXCOLORA(0xffffff, 0.5);
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderNodeLineItemViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _line;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.textColor = HEXCOLOR(0xffffff);
        _detailLabel.font = [UIFont fontWithName:kFontNormal size:10];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}
@end
