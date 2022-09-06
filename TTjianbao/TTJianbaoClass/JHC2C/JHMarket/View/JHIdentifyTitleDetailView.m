//
//  JHIdentifyTitleDetailView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/6/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIdentifyTitleDetailView.h"

@interface JHIdentifyTitleDetailView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *deLabel;
@end

@implementation JHIdentifyTitleDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self layoutViews];
    }
    return self;
}

- (void)setupData {
    if (self.model == nil) return;
    if (self.model.attrValues.count <= 0) return;
    JHAppraisalAttrValuesModel *value = self.model.attrValues[0];
    
    self.titleLabel.text =[NSString stringWithFormat:@"%@", self.model.attrName];
    
    self.detailLabel.text = value.name;
}
- (void)setupUI {
    
}
- (void)layoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.width.mas_equalTo(@90);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_greaterThanOrEqualTo(@28);
    }];
    [self.deLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(0);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(10);
        make.height.mas_greaterThanOrEqualTo(@28);
        make.right.mas_equalTo(-10);
    }];
}
#pragma mark - Lazy
- (void)setModel:(JHAppraisalAttrsResultlModel *)model {
    _model = model;
    [self setupData];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UILabel *)deLabel {
    if (!_deLabel) {
        _deLabel = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self];
        _deLabel.text = @":";
    }
    return _deLabel;
}
@end
