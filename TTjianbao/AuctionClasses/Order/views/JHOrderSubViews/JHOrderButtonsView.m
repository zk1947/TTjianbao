//
//  JHOrderButtonsView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderButtonsView.h"
#import "UIImage+JHColor.h"
@implementation JHOrderButtonsView

-(void)setSubViews{
    
    self.layer.cornerRadius = 0;
}
-(void)setupBuyerButtons:(NSArray*)buttonArr{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIButton * lastView;
    for (int i=0; i<[buttonArr count]; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[[buttonArr objectAtIndex:i]objectForKey:@"buttonTitle"] forState:UIControlStateNormal];
        button.tag=[[[buttonArr objectAtIndex:i]objectForKey:@"buttonTag"] intValue];
        button.titleLabel.font= [UIFont systemFontOfSize:13];
        button.layer.cornerRadius = 15.0;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
        button.layer.borderWidth = 0.5f;
        [button setTitleColor:kColor222 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:button];
        
        if  (button.tag==JHOrderButtonTypePay||
             button.tag==JHOrderButtonTypeCommit||
             button.tag==JHOrderButtonTypeReceive||
             button.tag==JHOrderButtonTypeReturnGood)
        {
//            [button setBackgroundColor:kColorMain];
            button.layer.borderWidth = 0;
            UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(72, 30) radius:17];
            [button setBackgroundImage:nor_image forState:UIControlStateNormal];
            
        }
        
        if (button.tag==JHOrderButtonTypeAppraiseIssue) {
            button.layer.borderWidth = 0;
            [button setBackgroundColor:kColorMain];
        }
        if (button.tag==JHOrderButtonTypeComment) {
            button.layer.borderColor = kColorMain.CGColor;
            button.layer.borderWidth = 1.0;
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setImage:[UIImage imageNamed:@"order_receivePadge"] forState:UIControlStateNormal];
            
        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (button.tag==JHOrderButtonTypeComment){
                make.size.mas_equalTo(CGSizeMake(95, 30));
            }
            else if (button.tag==JHOrderButtonTypeAppraiseIssue){
                make.size.mas_equalTo(CGSizeMake(108, 30));
            }
            else{
                make.size.mas_equalTo(CGSizeMake(72, 30));
            }
            make.centerY.equalTo(self);
            
            if (i==0) {
                make.right.equalTo(self).offset(-10);
            }
            else{
                make.right.equalTo(lastView.mas_left).offset(-10);
            }
        }];
        
        if (button.tag==JHOrderButtonTypeComment){
            [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                                    imageTitleSpace:5];
        }
        
        lastView= button;
    }
}
-(void)setupSellerButtons:(NSArray*)buttonArr{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIButton * lastView;
    for (int i=0; i<[buttonArr count]; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[[buttonArr objectAtIndex:i]objectForKey:@"buttonTitle"] forState:UIControlStateNormal];
        button.tag=[[[buttonArr objectAtIndex:i]objectForKey:@"buttonTag"] intValue];
        button.titleLabel.font= [UIFont systemFontOfSize:13];
        button.layer.cornerRadius = 15.0;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
        button.layer.borderWidth = 0.5f;
        [button setTitleColor:kColor222 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:button];
        if(button.tag==JHOrderButtonTypeSend||
           button.tag==JHOrderButtonTypePrintCard||
           button.tag==JHOrderButtonTypeCompleteInfo) {
          [button setBackgroundColor:kColorMain];
          button.layer.borderWidth = 0;
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(72, 30));
            make.centerY.equalTo(self);
            if (i==0) {
                make.right.equalTo(self).offset(-10);
            }
            else{
                make.right.equalTo(lastView.mas_left).offset(-10);
            }
        }];
        
        lastView= button;
    }
}

-(void)setupGraphicalButtons:(NSArray*)buttonArr {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIButton * lastView;
    for (int i=0; i<buttonArr.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font= [UIFont systemFontOfSize:12];
        [button setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:button];
       
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(72, 30));
            make.centerY.equalTo(self);
            if (i==0) {
                make.right.equalTo(self).offset(-10);
            }
            else{
                make.right.equalTo(lastView.mas_left).offset(-10);
            }
        }];
        
        lastView= button;
    }
}

- (void)buttonPress:(UIButton*)button{
    
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
