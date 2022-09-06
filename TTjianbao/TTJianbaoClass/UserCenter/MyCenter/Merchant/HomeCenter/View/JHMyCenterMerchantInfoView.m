//
//  JHMyCenterMerchantInfoCell.m
//  TTjianbao
//
//  Created by apple on 2020/4/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHMyCenterMerchantCellModel.h"
#import "JHUnionSignView.h"
#import "JHMyCenterMerchantInfoView.h"
#import "JHMyCenterUserHeaderView.h"
#import "JHMyShopHeaderView.h"
#import "UserInfoRequestManager.h"
#import "JHWebViewController.h"

@interface JHMyCenterMerchantInfoView ()

@property (nonatomic, strong) JHMyCenterUserHeaderView *userInfoView;

@property (nonatomic, strong) JHMyShopHeaderView *moneyInfoView;

@end

@implementation JHMyCenterMerchantInfoView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSelfSubViews];
    }
    return self;
}

- (void)addSelfSubViews{
    
    _userInfoView = [JHMyCenterUserHeaderView new];
    [self addSubview:_userInfoView];
    [_userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo([JHMyCenterUserHeaderView viewHeight]);
    }];
    
    UIView *whiteView = [UIView jh_viewWithColor:[UIColor whiteColor] addToSuperview:self];
    [whiteView jh_cornerRadius:8];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10.f);
        make.right.equalTo(self).offset(-10.f);
#ifdef JH_UNION_PAY
        make.height.mas_equalTo(153.f); //249
#else
        make.height.mas_equalTo(249.f);
#endif
        make.top.equalTo(self).offset(135.f + UI.statusAndNavBarHeight);
    }];
            
    UIButton *moneyButton = [UIButton jh_buttonWithImage:@"my_center_switch_money_push" target:self action:@selector(moneyAction) addToSuperView:self];
    [moneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteView);
        make.top.equalTo(whiteView).offset(10);
        make.size.mas_equalTo(CGSizeMake(90, 26));
    }];
            
    UILabel *totalTipLabel = [UILabel jh_labelWithText:@"可提现（元）" font:12 textColor:RGB(102, 102, 102) textAlignment:0 addToSuperView:whiteView];
    [totalTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).offset(10);
        make.top.equalTo(whiteView).offset(16);
    }];
    
#ifdef JH_UNION_PAY
    _totalMoneyLabel = [UILabel jh_labelWithBoldText:@"0.00" font:24 textColor:RGB(51, 51, 51) textAlignment:0 addToSuperView:whiteView];
#else
    _totalMoneyLabel = [UILabel jh_labelWithBoldText:@"0.00" font:22 textColor:RGB(51, 51, 51) textAlignment:0 addToSuperView:whiteView];
#endif
    _totalMoneyLabel.jh_font(JHDINBoldFont(22));
    [_totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalTipLabel);
        make.top.equalTo(totalTipLabel.mas_bottom).offset(10.f);
    }];
            
    UIView *lineView = [UIView jh_viewWithColor:RGB(238, 238, 238) addToSuperview:whiteView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).offset(10.f);
        make.right.equalTo(whiteView).offset(-10.f);
        make.top.equalTo(_totalMoneyLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo(1.f);
    }];

#ifdef JH_UNION_PAY
    UILabel *newTipLabel2 = [UILabel jh_labelWithText:@"待结算（元）" font:12 textColor:RGB(153.f, 153.f, 153.f) textAlignment:0 addToSuperView:whiteView];
    [newTipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalTipLabel);
        make.top.equalTo(lineView.mas_bottom).offset(14.f);
    }];
            
    _incomeFreezeLabel = [UILabel jh_labelWithBoldText:@"0.00" font:18 textColor:RGB(51, 51, 51) textAlignment:0 addToSuperView:whiteView];
    [_incomeFreezeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalTipLabel);
        make.top.equalTo(newTipLabel2.mas_bottom).offset(4.f);
    }];
            

    {
        _withdrawLabel = [UILabel jh_labelWithBoldText:@"0.00" font:18 textColor:RGB(51.f, 51.f, 51.f) textAlignment:0 addToSuperView:whiteView];

        UILabel *newTipLabel22 = [UILabel jh_labelWithText:@"已结算（元）" font:12 textColor:RGB(153.f, 153.f, 153.f) textAlignment:0 addToSuperView:whiteView];
        [newTipLabel22 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.withdrawLabel);
            make.top.equalTo(newTipLabel2);
        }];
        
        [_withdrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteView.mas_right).offset(-115);
            make.top.equalTo(_incomeFreezeLabel);
        }];
        
        
    }
#else
        UILabel *newTipLabel = [UILabel jh_labelWithText:@"" font:12 textColor:RGB(153.f, 153.f, 153.f) textAlignment:0 addToSuperView:whiteView];
        [newTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(totalTipLabel);
             make.top.equalTo(lineView.mas_bottom).offset(5.f);
         }];
        _dateNewTipLabel = newTipLabel;
        _incomeFreezeLabel = [UILabel jh_labelWithBoldText:@"0.00" font:12 textColor:RGB(51, 51, 51) textAlignment:0 addToSuperView:whiteView];
         [_incomeFreezeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(totalTipLabel);
            make.top.equalTo(newTipLabel.mas_bottom).offset(10.f);
         }];
                 
        UILabel *newTipLabel2 = [UILabel jh_labelWithText:@"待结算（元）" font:12 textColor:RGB(153.f, 153.f, 153.f) textAlignment:0 addToSuperView:whiteView];
        [newTipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(totalTipLabel);
            make.top.equalTo(self.incomeFreezeLabel.mas_bottom).offset(10.f);
        }];
         {
            _withdrawLabel = [UILabel jh_labelWithBoldText:@"0.00" font:12 textColor:RGB(51.f, 51.f, 51.f) textAlignment:0 addToSuperView:whiteView];
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
            make.left.equalTo(totalTipLabel);
            make.top.equalTo(lineView2.mas_bottom).offset(5.f);
        }];
        _oldDateTipLabel = oldTipLabel;
        _oldIncomeFreezeLabel = [UILabel jh_labelWithBoldText:@"0.00" font:12 textColor:RGB(51, 51, 51) textAlignment:0 addToSuperView:whiteView];
        [_oldIncomeFreezeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(totalTipLabel);
            make.top.equalTo(oldTipLabel.mas_bottom).offset(10.f);
            make.width.mas_greaterThanOrEqualTo(20);
        }];
    
        UILabel *oldTipLabel2 = [UILabel jh_labelWithText:@"待结算（元）" font:12 textColor:RGB(153.f, 153.f, 153.f) textAlignment:0 addToSuperView:whiteView];
        [oldTipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(totalTipLabel);
            make.top.equalTo(self.oldIncomeFreezeLabel.mas_bottom).offset(10.f);
        }];
    
        {
            _oldWithdrawLabel = [UILabel jh_labelWithBoldText:@"0.00" font:12 textColor:RGB(51, 51, 51) textAlignment:0 addToSuperView:whiteView];
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

#endif
}

#pragma mark --------------- action ---------------
- (void)moneyAction {
    JHMyCenterMerchantCellButtonModel *model = [JHMyCenterMerchantCellButtonModel new];
    model.cellType = JHMyCenterMerchantPushTypeMoneyManger;
    [model pushViewController];
}

-(void)reload{
    [self.userInfoView reload];
}
@end
