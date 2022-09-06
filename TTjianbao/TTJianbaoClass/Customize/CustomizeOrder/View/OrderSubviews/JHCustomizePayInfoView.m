//
//  JHCustomizePayInfoView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizePayInfoView.h"
#import "CommAlertView.h"
#import "JHCommMenuView.h"
#import "JHCommBubbleTipView.h"
#import "UILabel+UILabel_ChangeLineSpaceAndWordSpace.h"

@interface JHCustomizePayInfoView ()
{
    UIButton  *button;
}
@end

@implementation JHCustomizePayInfoView
-(void)initCustomizePayListSubviews:(NSArray<JHCustomizeOrderpayRecordVosModel*>*)arr{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel  * payTitle=[[UILabel alloc]init];
    payTitle.text=@"支付信息";
    payTitle.font=[UIFont fontWithName:kFontMedium size:15];
    payTitle.backgroundColor=[UIColor whiteColor];
    payTitle.textColor=kColor333;
    payTitle.numberOfLines = 1;
    payTitle.textAlignment = NSTextAlignmentLeft;
    payTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:payTitle];
    
    [payTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
    }];
    
    button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"customize_payinfo_icon"] forState:UIControlStateNormal];//
    [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
   // button.backgroundColor = [UIColor redColor];
    button.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payTitle.mas_right).offset(5);
        make.centerY.equalTo(payTitle);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    UIView * lastView;
    for (int i=0; i<[arr count]; i++) {
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.font=[UIFont systemFontOfSize:13];
        title.backgroundColor=[UIColor clearColor];
        title.textColor=kColor666;
        title.numberOfLines = 1;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UILabel  *desc=[[UILabel alloc]init];
        
        desc.font=[UIFont systemFontOfSize:13];
        desc.backgroundColor=[UIColor clearColor];
        desc.textColor=kColor999;
        desc.numberOfLines = 1;
        desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:desc];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.top.equalTo(view).offset(5);
            make.bottom.equalTo(view).offset(-10);
        }];
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(title);
            make.right.equalTo(view).offset(-10);
        }];
        
        title.text=[NSString stringWithFormat:@"%@  ¥%@",arr[i].payTypeName,arr[i].money];
        desc.text=arr[i].payTime;
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            if (i==0) {
                make.top.equalTo(payTitle.mas_bottom).offset(10);
            }
            else{
                make.top.equalTo(lastView.mas_bottom);
            }
            if (i==[arr count]-1) {
                
                make.bottom.equalTo(self);
            }
        }];
        
        lastView= view;
    }
}

-(void)btnAction{
    
    JHCommBubbleTipView * bubble = [[JHCommBubbleTipView alloc ]init];
    bubble.titleLabel.text = @"您支付的预付款会由平台保管，在服务完成后多退少补，具体的订单金额会根据实际产生的定制费用计算。";
    [UILabel changeLineSpaceForLabel:bubble.titleLabel WithSpace:5];
    [JHKeyWindow addSubview:bubble];
    [bubble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(button.mas_top).offset(-5);
        make.left.equalTo(button).offset(-25);
    }];
    
//    JHBubbleView * bubble = [[JHBubbleView alloc]init];
//    [[UIApplication sharedApplication].keyWindow addSubview:bubble];
////
//    [bubble setTitle:@"您支付的预付款" andArrowDirection:JHBubbleViewArrowDirectionenBottomCenter];
//     [bubble mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(button.mas_top).offset(-10);
//        make.centerX.equalTo(button);
//    }];
    
//    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"您支付的预付款会由平台保管，在服务完成后多退少补，具体的订单金额会根据实际产生的定制费用计算。" andDesc:@"" cancleBtnTitle:@"知道了"];
//    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    
}
@end
