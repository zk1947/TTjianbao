//
//  JHCustomizePayCashView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizePayCashView.h"

@implementation JHCustomizePayCashView
-(void)initShouldPayCashSubViews:(JHCustomizeOrderModel*)mode{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
       UILabel  * title=[[UILabel alloc]init];
       title.text=@"";
       title.font=[UIFont fontWithName:kFontMedium size:15];
       title.backgroundColor=[UIColor whiteColor];
       title.textColor=kColor333;
       title.numberOfLines = 1;
       title.textAlignment = NSTextAlignmentLeft;
       title.lineBreakMode = NSLineBreakByWordWrapping;
       [self addSubview:title];
       
       [title mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self).offset(10);
           make.left.equalTo(self).offset(10);
       }];
    
    UILabel  *desc=[[UILabel alloc]init];
    desc.text=@"";
    desc.font=[UIFont fontWithName:kFontBoldDIN size:20];
    desc.backgroundColor=[UIColor whiteColor];
    desc.textColor=kColorMainRed;
    desc.numberOfLines = 0;
    desc.preferredMaxLayoutWidth = ScreenW-40;
    desc.textAlignment = NSTextAlignmentLeft;
    desc.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:desc];
    
    [desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.right.equalTo(self).offset(-10);
    }];
    
     UIView *tipView = [[UIView alloc]init];
     [self addSubview:tipView];
     [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(0);
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
    }];
    
    //应付预付款||应付差额
    if ([mode.shouldPayAdvanceValue floatValue]>0){
        title.text=@"应付预付款金额";
        NSString * string=[@"¥ " stringByAppendingString:[NSString stringWithFormat:@"%.@",mode.shouldPayAdvanceValue]];
        NSRange range = [string rangeOfString:@"¥"];
        desc.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:13.f] color:kColorMainRed range:range];
  
        //套餐文案
        if (mode.customizeType == 2) {
            
            [self showTip2Subviews:tipView];
        }
        else{
            [self showTipSubviews:tipView];
        }
    }
    else{
        title.text=@"应付差额";
        desc.text=mode.shouldPayValue;
    }
}

-(void)initConfirmOrderShouldPayCashSubViews:(JHOrderDetailMode*)mode{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
       UILabel  * title=[[UILabel alloc]init];
       title.text=@"应付预付款金额";
       title.font=[UIFont fontWithName:kFontMedium size:15];
       title.backgroundColor=[UIColor whiteColor];
       title.textColor=kColor333;
       title.numberOfLines = 1;
       title.textAlignment = NSTextAlignmentLeft;
       title.lineBreakMode = NSLineBreakByWordWrapping;
       [self addSubview:title];
       
       [title mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self).offset(10);
           make.left.equalTo(self).offset(10);
       }];
    
    
    UILabel  *desc=[[UILabel alloc]init];
    desc.font=[UIFont fontWithName:kFontBoldDIN size:20];
    desc.backgroundColor=[UIColor whiteColor];
    desc.textColor=kColorMainRed;
    desc.numberOfLines = 0;
    desc.preferredMaxLayoutWidth = ScreenW-40;
    desc.textAlignment = NSTextAlignmentLeft;
    desc.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:desc];
    
    [desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.right.equalTo(self).offset(-10);
    }];
    
    NSString * string=[@"¥ " stringByAppendingString:[NSString stringWithFormat:@"%.@",mode.orderPrice]];
    NSRange range = [string rangeOfString:@"¥"];
    desc.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:13.f] color:kColorMainRed range:range];
    
     UIView *tipView = [[UIView alloc]init];
     [self addSubview:tipView];
     [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(0);
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
    }];
    
    //套餐文案
    if (mode.customizeType == 2) {
        
        [self showTip2Subviews:tipView];
    }
    else{
        [self showTipSubviews:tipView];
    }
}
-(void)showTipSubviews:(UIView*)tipView{
    
    UIView * line=[[UIView alloc]init];
    line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
    [tipView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipView).offset(10);
        make.top.equalTo(tipView.mas_top).offset(10);
        make.right.equalTo(tipView).offset(0);
        make.height.offset(1);
    }];
    
    UILabel  *tipLabel=[[UILabel alloc]init];
    tipLabel.text=@"";
    tipLabel.font=[UIFont fontWithName:kFontNormal size:13];
    tipLabel.backgroundColor=[UIColor whiteColor];
    tipLabel.textColor=kColor999;
    tipLabel.numberOfLines = 0;
    tipLabel.preferredMaxLayoutWidth = ScreenW-20;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [tipView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipView).offset(10);
        make.top.equalTo(line.mas_bottom).offset(10);
        make.right.equalTo(tipView).offset(-10);
        make.bottom.equalTo(tipView).offset(0);
    }];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] init];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"customize_comfirm_tip_icon"];
    attch.bounds = CGRectMake(0, 0,10, 10);
    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:imgStr];
    [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@"您支付的预付款会由平台保管，在服务完成后多退少补，具体的订单金额会根据实际产生的定制费用计算。"]];
    tipLabel.attributedText = attri;
    
    
}

-(void)showTip2Subviews:(UIView*)tipView{
    
    UIView * line=[[UIView alloc]init];
    line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
    [tipView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipView).offset(10);
        make.top.equalTo(tipView.mas_top).offset(10);
        make.right.equalTo(tipView).offset(0);
        make.height.offset(1);
    }];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"customize_comfirm_tip_icon"]];
    [tipView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipView).offset(10);
        make.top.equalTo(line.mas_bottom).offset(14);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    UILabel  *tipLabel=[[UILabel alloc]init];
    tipLabel.text=@"";
    tipLabel.font=[UIFont fontWithName:kFontNormal size:13];
    tipLabel.backgroundColor=[UIColor whiteColor];
    tipLabel.textColor=kColor999;
    tipLabel.numberOfLines = 0;
    tipLabel.preferredMaxLayoutWidth = ScreenW-20;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [tipView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(5);
        make.top.equalTo(line.mas_bottom).offset(10);
        make.right.equalTo(tipView).offset(-10);
    }];
    
//    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] init];
//    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//    attch.image = [UIImage imageNamed:@"customize_comfirm_tip_icon"];
//    attch.bounds = CGRectMake(0, 0,10, 10);
//    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attch];
//    [attri appendAttributedString:imgStr];
//    [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
//    [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@"1.您支付的预付款会由平台保管，在服务完成后多退少补，具体的订单金额会根据实际产生的定制费用计算。"]];
    tipLabel.text = @"1.您支付的预付款会由平台保管，在服务完成后多退少补，具体的订单金额会根据实际产生的定制费用计算。";
    
    UILabel  *tipLabel2=[[UILabel alloc]init];
    tipLabel2.text=@"";
    tipLabel2.font=[UIFont fontWithName:kFontNormal size:13];
    tipLabel2.backgroundColor=[UIColor whiteColor];
    tipLabel2.textColor=kColor999;
    tipLabel2.numberOfLines = 0;
    tipLabel2.preferredMaxLayoutWidth = ScreenW-20;
    tipLabel2.textAlignment = NSTextAlignmentLeft;
    tipLabel2.lineBreakMode = NSLineBreakByWordWrapping;
    [tipView addSubview:tipLabel2];
    [tipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipLabel);
        make.top.equalTo(tipLabel.mas_bottom).offset(10);
        make.right.equalTo(tipView).offset(-10);
        make.bottom.equalTo(tipView).offset(0);
    }];

tipLabel2.text  = @"2.您购买的是定制套餐（原料+定制），需要先支付[原料订单]，再支付[定制订单]。";
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
