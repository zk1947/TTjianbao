//
//  JHOrderPayListView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderPayListView.h"

@implementation JHOrderPayListView

-(void)initSellerPayListSubviews:(NSArray*)arr{
    
    UILabel  * payTitle=[[UILabel alloc]init];
    payTitle.text=@"订单支付明细";
    payTitle.font=[UIFont systemFontOfSize:15];
    payTitle.backgroundColor=[UIColor whiteColor];
    payTitle.textColor=kColor333;
    payTitle.numberOfLines = 1;
    payTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    payTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:payTitle];
    
    [payTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(0);
    }];
    UIView * lastView;
    for (int i=0; i<[arr count]; i++) {
        
        OrderFriendAgentPayMode * mode=arr[i];
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.font=[UIFont systemFontOfSize:14];
        title.backgroundColor=[UIColor clearColor];
        title.textColor=kColor666;
        title.numberOfLines = 1;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UILabel  *desc=[[UILabel alloc]init];
        
        desc.font=[UIFont systemFontOfSize:9];
        desc.backgroundColor=[UIColor clearColor];
        desc.textColor=kColor999;
        desc.numberOfLines = 1;
        desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:desc];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.top.equalTo(view).offset(5);
        }];
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.bottom.equalTo(view).offset(-10);
        }];
        
        UIImageView * logo=[[UIImageView alloc]init];
        logo.contentMode = UIViewContentModeScaleAspectFit;
        [logo setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [logo setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [view addSubview:logo];
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title.mas_right).offset(10);
            make.centerY.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(25,25));
        }];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.contentMode=UIViewContentModeScaleAspectFit;
        button.titleLabel.font= [UIFont systemFontOfSize:13];
        button.layer.cornerRadius = 2;
        button.tag=i;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderColor = kColor222.CGColor;
        button.layer.borderWidth = 0.5f;
        [button setTitle:@"找他代付" forState:UIControlStateNormal];
        [button setTitleColor:kColor222 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(OrderAgentpayShare:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        button.hidden=YES;
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-20);
            make.centerY.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(72,30));
        }];
        if (mode.payResult==0||mode.payResult==-1) {
            title.text=[NSString stringWithFormat:@"%@暂未付款 ¥%@",mode.payChannelName,mode.cash];
            desc.text=[NSString stringWithFormat:@"剩余支付时间:%@",[CommHelp getHMSWithSecond:[CommHelp dateRemaining:mode.expireTime]]];
            //  button.hidden=NO;
        }
        else  if (mode.payResult==1) {
            title.text=[NSString stringWithFormat:@"%@ 成功支付 ¥%@",mode.payChannelName,mode.cash];
            desc.text=[NSString stringWithFormat:@"支付时间:%@",mode.payTime];
            logo.image=[UIImage imageNamed:@"friend_agnet_pay_success"];
            //  button.hidden=YES;
        }
        else  if (mode.payResult==2){
            title.text=[NSString stringWithFormat:@"%@ 未帮您支付 ¥%@",mode.payChannelName,mode.cash];
            desc.text=[NSString stringWithFormat:@"支付失效时间:%@",mode.expireTime];
            logo.image=[UIImage imageNamed:@"friend_agnet_pay_fail"];
            //  button.hidden=NO;
        }
        if ([mode.targetUrl length]>0) {
            button.hidden=NO;
        }
        else{
            button.hidden=YES;
        }
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        [view addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(view).offset(15);
            make.bottom.equalTo(view).offset(0);
            make.right.equalTo(view).offset(-15);
            make.height.offset(1);
        }];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50);
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
        [view layoutIfNeeded];
        if (title.width>=desc.width) {
            [logo mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_right).offset(5);
                make.centerY.equalTo(view);
                make.size.mas_equalTo(CGSizeMake(25,25));
            }];
        }
        else{
            [logo mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(desc.mas_right).offset(5);
                make.centerY.equalTo(view);
                make.size.mas_equalTo(CGSizeMake(25,25));
            }];
        }
    }
}

-(void)initBuyerPayListSubviews:(NSArray*)arr{
    
    UILabel  * payTitle=[[UILabel alloc]init];
    payTitle.text=@"订单支付明细";
    payTitle.font=[UIFont systemFontOfSize:15];
    payTitle.backgroundColor=[UIColor whiteColor];
    payTitle.textColor=kColor333;
    payTitle.numberOfLines = 1;
    payTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    payTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:payTitle];
    
    [payTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(0);
    }];
    UIView * lastView;
    for (int i=0; i<[arr count]; i++) {
        
        OrderFriendAgentPayMode * mode=arr[i];
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.font=[UIFont systemFontOfSize:14];
        title.backgroundColor=[UIColor clearColor];
        title.textColor=kColor666;
        title.numberOfLines = 1;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UILabel  *desc=[[UILabel alloc]init];
        
        desc.font=[UIFont systemFontOfSize:9];
        desc.backgroundColor=[UIColor clearColor];
        desc.textColor=kColor999;
        desc.numberOfLines = 1;
        desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:desc];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.top.equalTo(view).offset(5);
        }];
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.bottom.equalTo(view).offset(-10);
        }];
        
        UIImageView * logo=[[UIImageView alloc]init];
        logo.contentMode = UIViewContentModeScaleAspectFit;
        [logo setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [logo setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [view addSubview:logo];
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title.mas_right).offset(10);
            make.centerY.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(25,25));
        }];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.contentMode=UIViewContentModeScaleAspectFit;
        button.titleLabel.font= [UIFont systemFontOfSize:13];
        button.layer.cornerRadius = 2;
        button.tag=i;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderColor = kColor222.CGColor;
        button.layer.borderWidth = 0.5f;
        [button setTitle:@"找他代付" forState:UIControlStateNormal];
        [button setTitleColor:kColor222 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(OrderAgentpayShare:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        button.hidden=YES;
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-20);
            make.centerY.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(72,30));
        }];
        if (mode.payResult==0||mode.payResult==-1) {
            title.text=[NSString stringWithFormat:@"%@暂未付款 ¥%@",mode.payChannelName,mode.cash];
            desc.text=[NSString stringWithFormat:@"剩余支付时间:%@",[CommHelp getHMSWithSecond:[CommHelp dateRemaining:mode.expireTime]]];
            //  button.hidden=NO;
        }
        else  if (mode.payResult==1) {
            title.text=[NSString stringWithFormat:@"%@ 成功支付 ¥%@",mode.payChannelName,mode.cash];
            desc.text=[NSString stringWithFormat:@"支付时间:%@",mode.payTime];
            logo.image=[UIImage imageNamed:@"friend_agnet_pay_success"];
            //  button.hidden=YES;
        }
        else  if (mode.payResult==2){
            title.text=[NSString stringWithFormat:@"%@ 未帮您支付 ¥%@",mode.payChannelName,mode.cash];
            desc.text=[NSString stringWithFormat:@"支付失效时间:%@",mode.expireTime];
            logo.image=[UIImage imageNamed:@"friend_agnet_pay_fail"];
            //  button.hidden=NO;
        }
        if ([mode.targetUrl length]>0) {
            button.hidden=NO;
        }
        else{
            button.hidden=YES;
        }
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        [view addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(view).offset(15);
            make.bottom.equalTo(view).offset(0);
            make.right.equalTo(view).offset(-15);
            make.height.offset(1);
        }];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50);
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
        [view layoutIfNeeded];
        if (title.width>=desc.width) {
            [logo mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_right).offset(5);
                make.centerY.equalTo(view);
                make.size.mas_equalTo(CGSizeMake(25,25));
            }];
        }
        else{
            [logo mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(desc.mas_right).offset(5);
                make.centerY.equalTo(view);
                make.size.mas_equalTo(CGSizeMake(25,25));
            }];
        }
    }
}
-(void)OrderAgentpayShare:(UIButton*)button{
    
    if (self.buttonHandle) {
        self.buttonHandle(button);
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
