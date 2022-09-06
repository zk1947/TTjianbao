//
//  JHConnectMicPopAlertView.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/13.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "JHUpdateAlertView.h"
#import "TTjianbaoHeader.h"
#import "UILabel+UILabel_ChangeLineSpaceAndWordSpace.h"

@interface JHUpdateAlertView (){
    
    UILabel * title;
    UILabel * desc;
    
}
@property (nonatomic, strong)   UIButton* sureBtn;
@property (nonatomic, strong)   UIButton* cancleBtn;
@property(nonatomic,copy)sureBlock sureClick;
@property(nonatomic,copy)cancleBlock cancleClick;
@property(nonatomic,strong)JHUpdateAppModel *mode;
@end

@implementation JHUpdateAlertView

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
            make.width.equalTo(@260);
            make.center.equalTo(self);
            
        }];
        
        UILabel * viewTitle=[[UILabel alloc]init];
        viewTitle.text=@"更新提示";
        viewTitle.font=[UIFont boldSystemFontOfSize:16];
        viewTitle.textColor=[CommHelp toUIColorByStr:@"#030303"];
        viewTitle.numberOfLines = 2;
        viewTitle.textAlignment = UIControlContentHorizontalAlignmentLeft;
        viewTitle.lineBreakMode = NSLineBreakByWordWrapping;
        [showview addSubview:viewTitle];
        
        [viewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showview).offset(30);
            make.left.right.equalTo(showview);
            
        }];
        
        title=[[UILabel alloc]init];
        title.font=[UIFont boldSystemFontOfSize:15];
        title.textColor=[CommHelp toUIColorByStr:@"#333333"];
       // title.backgroundColor=[UIColor redColor];
        title.numberOfLines = 1;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [showview addSubview:title];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewTitle.mas_bottom).offset(10);
            make.left.equalTo(showview).offset(30);
            make.right.equalTo(showview).offset(-30);
        }];
        
        desc=[[UILabel alloc]init];
        desc.text=@"";
        desc.preferredMaxLayoutWidth =260-60;
       // desc.backgroundColor=[UIColor redColor];
        desc.font=[UIFont systemFontOfSize:14];
        desc.textColor=[CommHelp toUIColorByStr:@"#030303"];
        desc.numberOfLines = 0;
//        [desc setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//        [desc setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        [showview addSubview:desc];
        
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(20);
            make.left.equalTo(showview).offset(30);
            make.right.equalTo(showview).offset(-30);
        }];
        
        _cancleBtn=[[UIButton alloc]init];
        _cancleBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        _cancleBtn.layer.cornerRadius = 4;
        [_cancleBtn setBackgroundColor:[CommHelp toUIColorByStr:@"ffffff"]];
        [_cancleBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_cancleBtn];
        
        [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(desc.mas_bottom).offset(20);
            make.bottom.equalTo(showview.mas_bottom).offset(-10);
            make.left.offset(10);
            make.size.mas_equalTo(CGSizeMake(113, 40));
            
        }];
        
        _sureBtn=[[UIButton alloc]init];
        _sureBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_sureBtn setTitle:@"更新" forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 4;
        _sureBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
       // [_sureBtn setBackgroundImage:[UIImage imageNamed:@"Mic_right_button.png"] forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:[CommHelp toUIColorByStr:@"fee100"]];
        [_sureBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_sureBtn];
        
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_cancleBtn);
            make.bottom.equalTo(showview.mas_bottom).offset(-10);
            make.right.offset(-10);
            make.size.mas_equalTo(CGSizeMake(113, 40));
        }];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }
    return self;
}
- (void)showAlertWithModel:(JHUpdateAppModel *)model{
    
    self.mode=model;
    
    if (model) {
        title.text= [NSString stringWithFormat:@"V%@新版本驾到了",model.latestVersion];
        NSString *string = @"";
        for (NSInteger i = 0; i<model.content.count; i++) {
            NSString *s = model.content[i];
            if (i==0) {
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%@",s]];
            }
            else{
                string = [string stringByAppendingString:[NSString stringWithFormat:@"\n%@",s]];
            }
        }
        desc.text=string;
        [UILabel changeLineSpaceForLabel:desc WithSpace:5];
        
        if (model.isUpDate == 1) {
            [_cancleBtn setHidden:NO];
            [_sureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-10);
            }];
        }
        
      else  if (model.isUpDate == 2) {
            [_cancleBtn setHidden:YES];
            [_sureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-(260-113)/2);
            }];
        }
    }
}
-(void)withSureClick:(sureBlock)block{
    
    self.sureClick = block;
    
}
-(void)withCancleClick:(cancleBlock)block{
    
    self.cancleClick = block;
    
}
- (void)cancelClick:(UIButton *)sender{
    
    [self HideMicPopView];
    if (self.cancleClick) {
        self.cancleClick();
    }
}
-(void)sureClick:(UIButton *)sender{
    
    if (self.mode.isUpDate != 2) {
        
      [self HideMicPopView];
    }
    if (self.sureClick) {
        self.sureClick();
    }
}
-(void)HideMicPopView{
    
    [self removeFromSuperview];
}

+ (void)showUpdateAlertWithModel:(JHUpdateAppModel *)model {
    JHUpdateAlertView * alert = [JHUpdateAlertView new];
    [alert showAlertWithModel:model];
    @weakify(model);
    [alert withSureClick:^{
        @strongify(model);
        NSString *string = model.url;
        if(string&&string.length){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        }else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
        }
    }];
}

@end

