//
//  JHBillInstructionAlertView.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBillInstructionAlertView.h"

@interface JHBillInstructionAlertView ()

@property (nonatomic, copy) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation JHBillInstructionAlertView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        
        UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
        [whiteView jh_cornerRadius:8.f];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.equalTo(self).offset(57.f);
            make.right.equalTo(self).offset(-57.f);
        }];
        
        _titleLabel = [UILabel jh_labelWithBoldText:@"待结算说明" font:15 textColor:UIColor.blackColor textAlignment:1 addToSuperView:whiteView];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteView).offset(15.f);
            make.left.equalTo(whiteView).offset(32.f);
            make.right.equalTo(whiteView).offset(-32.f);
        }];
        
        _descLabel = [UILabel jh_labelWithText:@"待结算说明" font:13 textColor:UIColor.blackColor textAlignment:1 addToSuperView:whiteView];
        _descLabel.numberOfLines = 0;
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(19.f);
            make.centerX.equalTo(whiteView);
            make.left.right.equalTo(self.titleLabel);
        }];
        
        {
            UIButton *button = [UIButton jh_buttonWithImage:@"icon_shop_bill_close" target:self action:@selector(cancleAction) addToSuperView:whiteView];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(whiteView).offset(10.f);
                make.right.equalTo(whiteView);
                make.width.height.mas_equalTo(32.f);
            }];
        }
        
        {
            UIButton *button = [UIButton jh_buttonWithTitle:@"确认" fontSize:15 textColor:UIColor.blackColor target:self action:@selector(cancleAction) addToSuperView:whiteView];
            button.backgroundColor = RGB(254, 225, 0);
            [button jh_cornerRadius:20];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.descLabel.mas_bottom).offset(20.f);
                make.left.equalTo(whiteView).offset(51.f);
                make.right.equalTo(whiteView).offset(-51.f);
                make.height.mas_equalTo(40.f);
            }];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(whiteView).offset(-15.f);
            }];
        }
        
    }
    return self;
}

-(void)setAlertViewTitle:(NSString *)alertViewTitle
{
    if ([alertViewTitle hasPrefix:@"待结算"]) {
        self.titleLabel.text = @"待结算说明";
        self.descLabel.text = @"指所有未到达结算时间的订单等待结算的金额之和";
    }
    else if ([alertViewTitle hasPrefix:@"已结算"]) {
        self.titleLabel.text = @"已结算说明";
        self.descLabel.text = @"已结算 = 销售额-商家代金券-平台分成";
    }
    else if ([alertViewTitle hasPrefix:@"销售额"]) {
        self.titleLabel.text = @"销售额说明";
        self.descLabel.text = @"销售额 = 全部已售订单金额";
    }
    else if ([alertViewTitle hasPrefix:@"提现中"]) {
        self.titleLabel.text = @"提现中说明";
        self.descLabel.text = @"您已提交提现申请，等待平台审核";
    }
    
    else if ([alertViewTitle hasPrefix:@"退款处理中"]) {
        self.titleLabel.text = @"退款处理中说明";
        self.descLabel.text = @"订单因发生买家投诉等争议问题被暂时冻结，待平台处理完毕后将进行解冻或退款";
    }
}
-(void)cancleAction
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

