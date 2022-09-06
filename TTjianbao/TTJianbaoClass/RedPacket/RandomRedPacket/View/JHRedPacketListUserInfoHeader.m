//
//  JHRedPacketListUserInfoHeader.m
//  TTjianbao
//
//  Created by apple on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRedPacketListUserInfoHeader.h"

@implementation JHRedPacketListUserInfoHeader

-(void)addSelfSubViews
{
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    self.backgroundView = [UIView new];
    
    _bgViewBottom = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.contentView];
    [_bgViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.contentView);
        make.height.mas_equalTo(77.f);
    }];
    
    _avatorView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_avatorView jh_cornerRadius:17.5 borderColor:RGB(255, 240, 219) borderWidth:1];
    [_avatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(15.f);
        make.height.width.mas_equalTo(35.f);
    }];
    
    _nameLabel = [UILabel jh_labelWithFont:14 textColor:RGB(51, 51, 51) addToSuperView:self.contentView];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatorView);
        make.top.equalTo(self.avatorView.mas_bottom).offset(5.f);
    }];
    
    _descLabel = [UILabel jh_labelWithFont:12 textColor:RGB(102, 102, 102) addToSuperView:self.contentView];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.f);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    UIView *lineView = [UIView jh_viewWithColor:RGB(238, 238, 238) addToSuperview:self.contentView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.f);
        make.right.equalTo(self.contentView).offset(-10.f);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self setData];
}

-(void)setData
{
    [self.avatorView jh_setAvatorWithUrl:@"https://cdnnos.ttjianbao.com/user_dir/user/15768417641193201.jpg"];
    self.nameLabel.text = @"XXX";
    self.descLabel.text = @"10个红包，已领完";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
