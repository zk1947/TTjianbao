//
//  JHRecycleOrderNodeItem.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderNodeItem.h"
@interface JHRecycleOrderNodeItem()
@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@end
@implementation JHRecycleOrderNodeItem
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
    RAC(self.numLabel, text) = RACObserve(self.viewModel, numText);
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
    [self addSubview:self.numLabel];
    [self addSubview:self.detailLabel];
}
- (void) layoutViews {
    [self.numLabel jh_cornerRadius:12];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(RecycloOrderNodeNumWidth, RecycloOrderNodeNumWidth));
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self).offset(0);
    }];
}
- (void)setHighlightUI {
    self.numLabel.textColor = HEXCOLOR(0xf8461F);
    self.detailLabel.textColor = HEXCOLOR(0xffffff);
    self.numLabel.backgroundColor = HEXCOLOR(0xffffff);
}
- (void)setNoHighlightUI {
    self.numLabel.textColor = HEXCOLORA(0xf8461F, 0.5);
    self.detailLabel.textColor = HEXCOLORA(0xffffff, 0.5);
    self.numLabel.backgroundColor = HEXCOLORA(0xffffff, 0.5);
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderNodeItemViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _numLabel.textColor = HEXCOLOR(0xf8461f);
        _numLabel.backgroundColor = HEXCOLOR(0xffffff);
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.font = [UIFont fontWithName:kFontBoldDIN size:16];
    }
    return _numLabel;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.textColor = HEXCOLOR(0xffffff);
        _detailLabel.font = [UIFont fontWithName:kFontMedium size:13];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}
@end
