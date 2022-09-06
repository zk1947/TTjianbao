//
//  JHMyCenterImageAppraiserNumCell.m
//  TTjianbao
//
//  Created by liuhai on 2021/7/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCenterImageAppraiserNumCell.h"

#import "JHMyCenterDotModel.h"
#import "JHMyCenterButtonModel.h"
#import "JHMyCenterDotNumView.h"

@interface JHMyCenterImageAppraiserNumCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) JHMyCenterDotNumView *msgCountLabel;

@end

@implementation JHMyCenterImageAppraiserNumCell

-(void)addSelfSubViews
{
    _iconView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.f);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    _descLabel = [UILabel jh_labelWithFont:16 textColor:RGB(51, 51, 51) addToSuperView:self.contentView];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(10.f);
        make.centerY.equalTo(self.iconView);
    }];
    
    [self addSubview:self.msgCountLabel];
    [self.msgCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.descLabel.mas_right).offset(8);
        make.centerY.equalTo(self.iconView);
    }];
}


- (void)setModel:(JHMyCenterButtonModel *)model{
    
    _descLabel.text = model.name;
    _iconView.image = JHImageNamed(model.icon);
    
    
    _msgCountLabel.number = [JHMyCenterDotModel shareInstance].waitAppraisalNum;
}

- (JHMyCenterDotNumView *)msgCountLabel {
    if (!_msgCountLabel) {
        _msgCountLabel = [JHMyCenterDotNumView new];
        _msgCountLabel.number = 0;
    }
    return _msgCountLabel;
}
@end
