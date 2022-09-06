//
//  JHStoneSearchConditionCell.m
//  TTjianbao
//
//  Created by apple on 2020/2/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoneSearchConditionCell.h"
#import "JHStoneSearchConditionModel.h"

@interface JHStoneSearchConditionCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JHStoneSearchConditionCell

-(void)addSelfSubViews
{
    _titleLabel = [UILabel jh_labelWithFont:12 textColor:RGB(51, 51, 51) textAlignment:1 addToSuperView:self.contentView];
    [_titleLabel jh_cornerRadius:[JHStoneSearchConditionCell itemSize].height/2.0];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

+(CGSize)itemSize
{
    return CGSizeMake(85.0, 34.0);
}

-(void)setModel:(JHStoneSearchConditionModel *)model
{
    if (model) {
        _model = model;
        _titleLabel.text = _model.label;
        _titleLabel.backgroundColor = _model.isSelected ? RGB(254, 225, 0) : RGB(248, 248, 248);
    }
}

@end
