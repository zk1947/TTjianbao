//
//  JHBaseOperationViewCell.m
//  TTjianbao
//
//  Created by apple on 2020/4/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseOperationViewCell.h"
#import "CommHelp.h"

@interface JHBaseOperationViewCell ()

@property (nonatomic, weak) UIImageView *iconView;

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation JHBaseOperationViewCell

-(void)addSelfSubViews{
    
   // self.backgroundColor = [CommHelp randomColor];
    
    UIView *content = [[UIView alloc]init];
    [self.contentView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
    _iconView = [UIImageView jh_imageViewAddToSuperview:content];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content);
        make.height.mas_equalTo(55);
        make.centerX.equalTo(content);
    }];
    
    _titleLabel = [UILabel jh_labelWithFont:12 textColor:kColor333 textAlignment:1 addToSuperView:content];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_iconView.mas_bottom).offset(2);
        make.bottom.equalTo(content);
        make.centerX.equalTo(content);
    }];
}

-(void)setModel:(JHBaseOperationModel *)model{
    _iconView.image = JHImageNamed(model.icon);
    _titleLabel.text = model.title;
}

@end
