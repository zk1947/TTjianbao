//
//  JHGoodsDetailAttrCell.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsDetailAttrCell.h"

@interface JHGoodsDetailAttrCell ()
@property (nonatomic, strong) UILabel *titleLabel, *valueLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JHGoodsDetailAttrCell

+ (CGFloat)cellHeight {
    return 37;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        self.selectionStyleEnabled = NO;
        //[self __addCountDownObserver];
        [self configUI];
    }
    return self;
}

- (void)configUI {

    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12.0] textColor:kColor666];
        _titleLabel.text = @"货号";
        [self.contentView addSubview:_titleLabel];
    }
    
    if (!_valueLabel) {
        _valueLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12.0] textColor:kColor333];
        _valueLabel.text = @"PV1909388884";
        [self.contentView addSubview:_valueLabel];
    }
    
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = kColorCellLine;
        [self.contentView addSubview:_lineView];
    }
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15.0)
    .topSpaceToView(self.contentView, 0)
    .widthIs(95)
    .heightIs([[self class] cellHeight]);
    
    _valueLabel.sd_layout
    .leftSpaceToView(_titleLabel, 5)
    .topSpaceToView(self.contentView, 0)
    .heightIs([[self class] cellHeight]);
    
    _lineView.sd_layout
    .bottomSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(1/[UIScreen mainScreen].scale);
}

- (void)setAttrData:(CGoodsAttrData *)attrData {
    _attrData = attrData;
    _titleLabel.text = attrData.name;
    _valueLabel.text = attrData.value;
}

@end
