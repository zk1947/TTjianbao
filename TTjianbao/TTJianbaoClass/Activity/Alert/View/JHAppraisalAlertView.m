//
//  JHAppraisalAlertView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/5/31.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAppraisalAlertView.h"
#import "CommHelp.h"

@interface JHAppraisalAlertView (){
    
    UILabel * title;
    UILabel * desc;
    
}
@property (nonatomic, strong)   UIButton* sureBtn;
@property (nonatomic, strong)   UIButton* cancleBtn;
@property (nonatomic, strong)   UIButton* otherBtn;

@end

@implementation JHAppraisalAlertView

- (instancetype)init{
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        
        UIView *showview =  [[UIView alloc]init];
        showview.center=self.center;
        showview.contentMode=UIViewContentModeScaleAspectFit;
        showview.userInteractionEnabled=YES;
        showview.layer.cornerRadius = 4;
        showview.backgroundColor=[CommHelp toUIColorByStr:@"#f8f8f8"];
        [self addSubview:showview];
        
        [showview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@285);
            make.center.equalTo(self);
        }];
        
        UILabel * viewTitle=[[UILabel alloc]init];
        viewTitle.text=@"如果您觉得我们还不错，请给些鼓励";
        viewTitle.font=[UIFont boldSystemFontOfSize:14];
        viewTitle.textColor=[CommHelp toUIColorByStr:@"#222222"];
        viewTitle.numberOfLines = 2;
        viewTitle.textAlignment = UIControlContentHorizontalAlignmentLeft;
        viewTitle.lineBreakMode = NSLineBreakByWordWrapping;
        [showview addSubview:viewTitle];
        
        [viewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showview).offset(50);
            make.left.right.equalTo(showview).offset(10);
            make.right.equalTo(showview).offset(-10);
        }];
        
        _sureBtn=[[UIButton alloc]init];
        _sureBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_sureBtn setTitle:@"ok,五星好评" forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 20;
        _sureBtn.tag=1;
        _sureBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_sureBtn setBackgroundColor:[CommHelp toUIColorByStr:@"fee200"]];
        [_sureBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_sureBtn];
        
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
              make.top.equalTo(viewTitle.mas_bottom).offset(30);
              make.right.offset(-10);
              make.left.offset(10);
              make.height.offset(40);
        }];
        
        _otherBtn=[[UIButton alloc]init];
        _otherBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_otherBtn setTitle:@"想去吐槽" forState:UIControlStateNormal];
        _otherBtn.layer.cornerRadius = 20;
        [_otherBtn.layer setBorderColor:[CommHelp toUIColorByStr:@"#e0e0e0"].CGColor];
        [_otherBtn.layer setBorderWidth:0.5];
        _otherBtn.tag=2;
        _otherBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_otherBtn setBackgroundColor:[UIColor whiteColor]];
        [_otherBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [_otherBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_otherBtn];
        
        [_otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_sureBtn.mas_bottom).offset(10);
            make.right.offset(-10);
            make.left.offset(10);
            make.height.offset(40);
        }];
        
        _cancleBtn=[[UIButton alloc]init];
        _cancleBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_cancleBtn setTitle:@"下次再说" forState:UIControlStateNormal];
        [_cancleBtn.layer setBorderColor:[CommHelp toUIColorByStr:@"#e0e0e0"].CGColor];
        [_cancleBtn.layer setBorderWidth:0.5];
        _cancleBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        _cancleBtn.layer.cornerRadius = 20;
        _cancleBtn.tag=3;
        [_cancleBtn setBackgroundColor:[UIColor whiteColor]];
        [_cancleBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_cancleBtn];
        
        [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_otherBtn.mas_bottom).offset(10);
            make.right.offset(-10);
            make.left.offset(10);
            make.height.offset(40);
            make.bottom.equalTo(showview.mas_bottom).offset(-30);
        }];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }
    return self;
}

-(void)HideMicPopView{
    
    [self removeFromSuperview];
}
-(void)buttonClick:(UIButton*)button{
    
    [self HideMicPopView];
    if (button.tag==1||button.tag==2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1457794084?mt=8"]];
    }
}
@end


