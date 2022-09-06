//
//  JHStoreDetailPricePreview.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailPricePreview.h"

@interface JHStoreDetailPricePreview()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIStackView *stackView;

@end
@implementation JHStoreDetailPricePreview

#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self bindData];
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
    @weakify(self)
    [RACObserve(self.numLabel, text)
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) {
            self.stackView.spacing = 0;
        }else{
            self.stackView.spacing = 6;
        }
    }];
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"FDF0C8"];
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.stackView];
}

- (void) layoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.right.equalTo(self).offset(-PriceRightDetailWidth);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LeftSpace);
        make.top.equalTo(self).offset(PriceTitleTopSpace);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-2);
        make.centerY.equalTo(self);
        make.left.equalTo(self.bgImageView.mas_right).offset(-6);
    }];
}

#pragma mark - Lazy
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"专场价";
        _titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _titleLabel;
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"newStore_price_bg"]];
    }
    return _bgImageView;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textColor = [UIColor colorWithHexString:@"9B541F"];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}
- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _numLabel.font = [UIFont systemFontOfSize:11];
        _numLabel.textColor = [UIColor colorWithHexString:@"222222"];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.adjustsFontSizeToFitWidth = true;
    }
    return _numLabel;
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc]initWithArrangedSubviews:@[self.dateLabel, self.numLabel]];
//        _stackView.spacing = 6;
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.distribution = UIStackViewDistributionFill;
    }
    return _stackView;
}
@end
