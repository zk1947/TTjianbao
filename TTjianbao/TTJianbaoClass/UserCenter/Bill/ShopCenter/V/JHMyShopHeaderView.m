//
//  JHMyShopHeaderView.m
//  TTjianbao
//
//  Created by apple on 2019/12/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMyShopHeaderView.h"
#import "UserInfoRequestManager.h"
@implementation JHMyShopHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *bgView = [UIImageView jh_imageViewAddToSuperview:self];
        bgView.image = [UIImage imageNamed:@"bg_shop_top"];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0.f, 0.f, 44.f, 0.f));
        }];
        
        UIView *whiteView = [UIView jh_viewWithColor:[UIColor whiteColor] addToSuperview:self];
        [whiteView jh_cornerRadius:8];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15.f);
            make.right.equalTo(self).offset(-15.f);
            make.height.mas_equalTo(279.f);
            make.bottom.equalTo(self).offset(-10.f);
        }];
        
        _avatorView = [UIImageView jh_imageViewAddToSuperview:whiteView];
        [_avatorView jh_cornerRadius:15.f];
        [_avatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(whiteView).offset(10.f);
            make.size.mas_equalTo(CGSizeMake(30.f, 30.f));
        }];
        
        _nickNameLabel = [UILabel jh_labelWithBoldFont:13 textColor:[UIColor blackColor] addToSuperView:whiteView];
        [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatorView.mas_right).offset(5.f);
            make.centerY.equalTo(self.avatorView);
            make.width.mas_lessThanOrEqualTo(ScreenW-200.f);
        }];
        _nickNameLabel.text = @"";
        
        {
            UIView *buttonView = [UIView jh_viewWithColor:RGB(253,161,0) addToSuperview:whiteView];
            [buttonView jh_cornerRadius:13 rectCorner:UIRectCornerBottomLeft | UIRectCornerTopLeft bounds:CGRectMake(0, 0, 95, 26)];
            [buttonView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moneyAction)]];
            [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(whiteView);
                make.centerY.equalTo(self.avatorView);
                make.size.mas_equalTo(CGSizeMake(95, 26));
            }];
            
            
            UIImageView *icon = [UIImageView jh_imageViewWithImage:@"icon_shop_bill_money" addToSuperview:buttonView];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(buttonView).offset(13);
                make.centerY.equalTo(buttonView);
                make.size.mas_equalTo(CGSizeMake(12, 12));
            }];
            
            UILabel *buttonLabel = [UILabel jh_labelWithText:@"资金管理" font:12 textColor:UIColor.whiteColor textAlignment:0 addToSuperView:buttonView];
            buttonLabel.backgroundColor = RGB(253,161,0);
            [buttonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(icon.mas_right).offset(5);
                make.centerY.equalTo(buttonView);
            }];
            
            UIImageView *icon2 = [UIImageView jh_imageViewWithImage:@"icon_shop_bill_white_push" addToSuperview:buttonView];
            [icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(buttonLabel.mas_right).offset(5);
                make.centerY.equalTo(buttonView);
                make.size.mas_equalTo(CGSizeMake(4.5, 8));
            }];
        }
        
        UILabel *totalTipLabel = [UILabel jh_labelWithText:@"可提现（元）" font:12 textColor:[UIColor blackColor] textAlignment:0 addToSuperView:whiteView];
        [totalTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatorView);
            make.top.equalTo(self.avatorView.mas_bottom).offset(13.f);
        }];
        
        _totalMoneyLabel = [UILabel jh_labelWithText:@"0.00" font:25 textColor:[UIColor blackColor] textAlignment:0 addToSuperView:whiteView];
        _totalMoneyLabel.jh_font(JHDINBoldFont(24));
        [_totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatorView);
            make.top.equalTo(totalTipLabel.mas_bottom).offset(10.f);
        }];
        
        UIView *lineView = [UIView jh_viewWithColor:RGB(238, 238, 238) addToSuperview:whiteView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteView).offset(10.f);
            make.right.equalTo(whiteView).offset(-10.f);
            make.top.equalTo(_totalMoneyLabel.mas_bottom).offset(10.f);
            make.height.mas_equalTo(1.f);
        }];
        
        UILabel *newTipLabel = [UILabel jh_labelWithText:@"" font:12 textColor:RGB(153.f, 153.f, 153.f) textAlignment:0 addToSuperView:whiteView];
        [newTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatorView);
            make.top.equalTo(lineView.mas_bottom).offset(5.f);
        }];
        _dateNewTipLabel = newTipLabel;
        
        _incomeFreezeLabel = [UILabel jh_labelWithText:@"0.00" font:12 textColor:RGB(153.f, 153.f, 153.f) textAlignment:0 addToSuperView:whiteView];
        [_incomeFreezeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatorView);
            make.top.equalTo(newTipLabel.mas_bottom).offset(10.f);
        }];
        
        UILabel *newTipLabel2 = [UILabel jh_labelWithText:@"待结算（元）" font:12 textColor:RGB(153.f, 153.f, 153.f) textAlignment:0 addToSuperView:whiteView];
        [newTipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatorView);
            make.top.equalTo(self.incomeFreezeLabel.mas_bottom).offset(10.f);
        }];
        {
            _withdrawLabel = [UILabel jh_labelWithText:@"0.00" font:12 textColor:RGB(51.f, 51.f, 51.f) textAlignment:0 addToSuperView:whiteView];
            _withdrawLabel.jh_font(JHLightFont(12));
            [_withdrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(whiteView.mas_right).offset(-115);
                make.top.equalTo(newTipLabel.mas_bottom).offset(10.f);
            }];
            
            UILabel *newTipLabel22 = [UILabel jh_labelWithText:@"可提现（元）" font:12 textColor:RGB(153.f, 153.f, 153.f) textAlignment:0 addToSuperView:whiteView];
            [newTipLabel22 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.withdrawLabel);
                make.top.equalTo(self.withdrawLabel.mas_bottom).offset(10.f);
            }];
        }
        UIView *lineView2 = [UIView jh_viewWithColor:RGB(238, 238, 238) addToSuperview:whiteView];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteView).offset(10.f);
            make.right.equalTo(whiteView).offset(-10.f);
            make.top.equalTo(newTipLabel2.mas_bottom).offset(10.f);
            make.height.mas_equalTo(1.f);
        }];
        
        UILabel *oldTipLabel = [UILabel jh_labelWithText:@"" font:12 textColor:RGB(153.f, 153.f, 153.f) textAlignment:0 addToSuperView:whiteView];
        [oldTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatorView);
            make.top.equalTo(lineView2.mas_bottom).offset(5.f);
        }];
        _oldDateTipLabel = oldTipLabel;
        _oldIncomeFreezeLabel = [UILabel jh_labelWithText:@"0.00" font:12 textColor:RGB(153.f, 153.f, 153.f) textAlignment:0 addToSuperView:whiteView];
        [_oldIncomeFreezeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatorView);
            make.top.equalTo(oldTipLabel.mas_bottom).offset(10.f);
            make.width.mas_greaterThanOrEqualTo(20);
        }];
        
        UILabel *oldTipLabel2 = [UILabel jh_labelWithText:@"待结算（元）" font:12 textColor:RGB(153.f, 153.f, 153.f) textAlignment:0 addToSuperView:whiteView];
        [oldTipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatorView);
            make.top.equalTo(self.oldIncomeFreezeLabel.mas_bottom).offset(10.f);
        }];
        {
            _oldWithdrawLabel = [UILabel jh_labelWithText:@"0.00" font:12 textColor:RGB(51.f, 51.f, 51.f) textAlignment:0 addToSuperView:whiteView];
            _oldWithdrawLabel.jh_font(JHLightFont(12));
            [_oldWithdrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(whiteView.mas_right).offset(-115);
                make.top.equalTo(self.oldIncomeFreezeLabel);
                make.width.mas_greaterThanOrEqualTo(20);
            }];
            
            UILabel *oldTipLabel22 = [UILabel jh_labelWithText:@"可提现（元）" font:12 textColor:RGB(153.f, 153.f, 153.f) textAlignment:0 addToSuperView:whiteView];
            [oldTipLabel22 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.oldWithdrawLabel);
                make.top.equalTo(self.oldWithdrawLabel.mas_bottom).offset(10.f);
            }];
        }
        
    }
    return self;
}

-(void)moneyAction
{
    if (_buttonClick) {
        _buttonClick();
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
