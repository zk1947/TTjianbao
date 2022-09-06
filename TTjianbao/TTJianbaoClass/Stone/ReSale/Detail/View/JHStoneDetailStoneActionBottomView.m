//
//  JHStoneDetailStoneBottomView.m
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneDetailStoneActionBottomView.h"

@interface JHStoneDetailStoneActionBottomView ()

@end

@implementation JHStoneDetailStoneActionBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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
        UIButton *rightButton = [UIButton jh_buttonWithTitle:@"一口价" fontSize:15 textColor:UIColor.whiteColor target:self action:@selector(buyAction) addToSuperView:self];
        rightButton.backgroundColor = RGB(252, 66, 0);
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(104, 40));
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self).offset(5);
        }];
        [rightButton jh_cornerRadius:20 rectCorner:UIRectCornerBottomRight | UIRectCornerTopRight bounds:CGRectMake(0, 0, 104, 40)];
        
        UIButton *leftButton = [UIButton jh_buttonWithTitle:@"出价" fontSize:15 textColor:UIColor.blackColor target:self action:@selector(cutPriceAction) addToSuperView:self];
        leftButton.backgroundColor = RGB(254, 225, 0);
        [leftButton jh_cornerRadius:20 rectCorner:UIRectCornerBottomLeft | UIRectCornerTopLeft bounds:CGRectMake(0, 0, 104, 40)];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(rightButton);
            make.right.equalTo(rightButton.mas_left);
        }];
        
        
    }
    return self;
}

#pragma mark ---------------------------- action ----------------------------
-(void)cutPriceAction
{
    if (_bottonClickBlock) {
        _bottonClickBlock(2);
    }
}

-(void)explainAction
{    
    if (_bottonClickBlock) {
        _bottonClickBlock(1);
    }
}

-(void)buyAction
{
    if (_bottonClickBlock) {
        _bottonClickBlock(3);
    }
}

+(CGFloat)viewHeight
{
    return UI.tabBarHeight + 1;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
