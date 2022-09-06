//
//  JHStoneDetailStoneBuyyerBottomView.m
//  TTjianbao
//
//  Created by apple on 2019/12/28.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneDetailStoneBuyyerBottomView.h"

@implementation JHStoneDetailStoneBuyyerBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSelfViews];
    }
    return self;
}

-(void)addSelfViews
{
    UIView *lineView = [UIView jh_viewWithColor:RGB(238, 238, 238) addToSuperview:self];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    _explainButton = [UIButton jh_buttonWithTitle:@"去直播间" fontSize:13 textColor:UIColor.blackColor target:self action:@selector(explainAction) addToSuperView:self];
    [_explainButton setImage:[UIImage imageNamed:@"stone_detail_explain"] forState:UIControlStateNormal];
    _explainButton.titleEdgeInsets = UIEdgeInsetsMake(10, -20, -10, 20);
    _explainButton.imageEdgeInsets = UIEdgeInsetsMake(-10, 15, 10, -15);
    [_explainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 50));
        make.left.equalTo(self).offset(22.f);
        make.top.equalTo(self);
    }];
    
    _nameLabel = [UILabel jh_labelWithFont:14 textColor:RGB(51, 51, 51) addToSuperView:self];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(5.f);
    }];
    
    _avatorView = [UIImageView jh_imageViewAddToSuperview:self];
    [_avatorView jh_cornerRadius:8];
    [_avatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nameLabel.mas_left).offset(-5.f);
        make.centerY.equalTo(self.nameLabel);
        make.height.width.mas_equalTo(16.f);
    }];
    
    _priceLabel = [UILabel jh_labelWithFont:14 textColor:RGB(252, 66, 0) addToSuperView:self];
     _priceLabel.font = JHDINBoldFont(17);
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    UILabel *tip2Label = [UILabel jh_labelWithText:@"成交价：" font:14 textColor:RGB(51, 51, 51) textAlignment:0 addToSuperView:self];
    [tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel.mas_left);
        make.centerY.equalTo(self.priceLabel);
    }];
}

+(CGFloat)viewHeight
{
    return UI.tabBarHeight;
}

-(void)explainAction
{
    if(_clickIntoLiveRoomBlock)
    {
        _clickIntoLiveRoomBlock();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
