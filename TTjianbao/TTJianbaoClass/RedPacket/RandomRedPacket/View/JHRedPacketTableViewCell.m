//
//  JHRedPacketTableViewCell.m
//  TTjianbao
//
//  Created by apple on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "TTjianbaoMarcoKeyword.h"
#import "JHRedPacketTableViewCell.h"

@interface JHRedPacketTableViewCell ()

@property (nonatomic, strong) UIImageView *avatorView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation JHRedPacketTableViewCell

-(void)addSelfSubViews
{
    _avatorView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_avatorView jh_cornerRadius:[self avatorHeight]/2.0];
    [_avatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset([self viewSpace]);
        make.centerY.equalTo(self.contentView);
        make.height.width.mas_equalTo([self avatorHeight]);
    }];
    
    _nameLabel = [UILabel jh_labelWithFont:12 textColor:RGB(51, 51, 51) addToSuperView:self.contentView];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatorView.mas_right).offset(5);
        make.top.equalTo(self.avatorView);
        make.right.equalTo(self.contentView).offset(-60);
    }];
    
    _timeLabel = [UILabel jh_labelWithFont:10 textColor:RGB(151, 151, 151) addToSuperView:self.contentView];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.bottom.equalTo(self.avatorView);
    }];
    
    _priceLabel = [UILabel jh_labelWithFont:12 textColor:RGB(51, 51, 51) addToSuperView:self.contentView];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-[self viewSpace]);
        make.centerY.equalTo(self.avatorView);
    }];
}

-(void)setModel:(JHGetRedpacketDetailModel *)model
{
    _model = model;
    
    [_avatorView jh_setAvatorWithUrl:_model.takeCustomerImg];
    
    _nameLabel.text = _model.takeCustomerName;
    
    _priceLabel.text = [NSString stringWithFormat:@"%@元",PRICE_FLOAT_TO_STRING(_model.takeMoney)];
    
    _timeLabel.text = _model.createTime;
}

-(CGFloat)viewSpace
{
    return 10.f;
}

-(CGFloat)avatorHeight
{
    return 25.f;
}
@end
