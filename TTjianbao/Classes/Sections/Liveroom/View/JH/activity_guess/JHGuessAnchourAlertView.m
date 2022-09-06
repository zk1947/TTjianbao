//
//  JHConnectMicPopAlertView.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/13.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "JHGuessAnchourAlertView.h"
#import "TTjianbaoHeader.h"

@interface JHGuessAnchourAlertView (){
    
    UITextField * account;
    
}
@property (nonatomic, strong)   UIButton* sureBtn;
@property (nonatomic, strong)   UIButton* cancleBtn;
@end

@implementation JHGuessAnchourAlertView

- (instancetype)init{
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        
        UIView *showview =  [[UIView alloc]init];
        showview.center=self.center;
        showview.contentMode=UIViewContentModeScaleAspectFit;
        showview.userInteractionEnabled=YES;
        showview.layer.cornerRadius = 4;
        showview.backgroundColor=[CommHelp toUIColorByStr:@"#ffffff"];
        [self addSubview:showview];
        
        [showview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@260);
            make.center.equalTo(self);
            
        }];
        
        UILabel * viewTitle=[[UILabel alloc]init];
        viewTitle.text=@"请输入结果";
        viewTitle.font=[UIFont boldSystemFontOfSize:18];
        viewTitle.textColor=[CommHelp toUIColorByStr:@"#333333"];
        viewTitle.numberOfLines = 2;
        viewTitle.textAlignment = UIControlContentHorizontalAlignmentLeft;
        viewTitle.lineBreakMode = NSLineBreakByWordWrapping;
        [showview addSubview:viewTitle];
        
        [viewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showview).offset(20);
            make.left.right.equalTo(showview);
            
        }];
        
        UIView * inputBackView =  [[UIView alloc]init];
        inputBackView.center=self.center;
        inputBackView.userInteractionEnabled=YES;
        inputBackView.layer.cornerRadius = 2;
        inputBackView.layer.borderWidth =0.5;
        inputBackView.layer.borderColor = [[CommHelp toUIColorByStr:@"#999999"] CGColor];
        inputBackView.backgroundColor=[UIColor whiteColor];
        [self addSubview:inputBackView];
        
        [inputBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewTitle.mas_bottom).offset(20);
            make.left.equalTo(showview).offset(30);
            make.right.equalTo(showview).offset(-30);
            make.height.offset(40);

        }];
        
        account=[[UITextField alloc]init];
        account.backgroundColor=[UIColor clearColor];
        account.tag=1;
        account.tintColor = HEXCOLOR(0xfee200);
        account.returnKeyType =UIReturnKeyDone;
        account.keyboardType = UIKeyboardTypeNumberPad;
        account.placeholder=@"请输入评估价";
        account.font=[UIFont systemFontOfSize:16];
        [inputBackView addSubview:account];
        
        [account mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(inputBackView);
            make.left.equalTo(inputBackView).offset(20);
            make.right.equalTo(inputBackView).offset(-20);
        }];
        
        _sureBtn=[[UIButton alloc]init];
        _sureBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius =20;
        _sureBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        // [_sureBtn setBackgroundImage:[UIImage imageNamed:@"Mic_right_button.png"] forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:[CommHelp toUIColorByStr:@"fee100"]];
        [_sureBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_sureBtn];
        
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(inputBackView.mas_bottom).offset(20);
            make.bottom.equalTo(showview.mas_bottom).offset(-20);
            make.size.mas_equalTo(CGSizeMake(113, 40));
            make.centerX.equalTo(showview);
        }];
        
        UIButton *  closeBtn=[[UIButton alloc]init];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"copon_close.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(HideMicPopView) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.contentMode=UIViewContentModeScaleAspectFit;
        [showview addSubview:closeBtn];
        [ closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(showview).offset(5);
            make.right.equalTo(showview).offset(-5);
        }];
        
    }
    return self;
}
-(void)sureClick:(UIButton *)sender{
    
    if ([account.text length]==0) {
         [[UIApplication sharedApplication].keyWindow makeToast:@"请输入价格" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    [self HideMicPopView];
    
    if (self.compelteBlock) {
        self.compelteBlock(account.text);
    }
}
-(void)HideMicPopView{
    
    [self removeFromSuperview];
}
- (void)dealloc
{
    NSLog(@"ccccdealloc");
}
@end


