//
//  JHCoponNoteAlertView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/2/12.
//  Copyright © 2020年 YiJian Tech. All rights reserved.
//

#import "JHCoponNoteAlertView.h"
#import "TTjianbaoHeader.h"
#import "JHUIFactory.h"

@interface JHCoponNoteAlertView ()
{
    UIView *showview;
}
@property (nonatomic, strong)   UILabel * title;
@property (nonatomic, strong)   UITextView * desc;
@property (nonatomic, strong)   UIButton* sureBtn;
@property (nonatomic, strong)   UIButton* cancleBtn;
@end

@implementation JHCoponNoteAlertView
- (instancetype)initWithTitle:(NSString *)title  andDesc:(NSString *)desc  cancleBtnTitle:(NSString *)cancleTitle {
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        
        showview =  [[UIView alloc]init];
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
        
        _title=[[UILabel alloc]init];
        _title.text=title;
        _title.font=[UIFont boldSystemFontOfSize:15];
        _title.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _title.numberOfLines = 1;
        _title.textAlignment = UIControlContentHorizontalAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        [showview addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showview).offset(10);
            make.left.right.equalTo(showview);
            
        }];
    
        JHCustomLine *line = [JHUIFactory createLine];
        [showview addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title.mas_bottom).offset(10);
            make.height.equalTo(@1);
            make.left.offset(0);
            make.right.offset(0);
            
        }];
        
        _desc=[[UITextView alloc]init];
        _desc.text=desc;
        _desc.backgroundColor = [UIColor clearColor];
        _desc.font=[UIFont systemFontOfSize:14];
        _desc.textColor=[CommHelp toUIColorByStr:@"#333333"];
         _desc.textAlignment = NSTextAlignmentLeft;
        _desc.editable = NO;
        _desc.scrollEnabled = YES;//滑动
        [showview addSubview:_desc];
        
        [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
            if (desc.length>0) {
                make.top.equalTo(_title.mas_bottom).offset(20);
            }
            else{
                make.top.equalTo(_title.mas_bottom).offset(0);
            }
            make.left.equalTo(showview).offset(15);
            make.right.equalTo(showview).offset(-15);
            make.height.lessThanOrEqualTo(@(ScreenHeight/2));
        }];
        
        _cancleBtn=[[UIButton alloc]init];
        _cancleBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        _cancleBtn.layer.cornerRadius = 20;
        [_cancleBtn setBackgroundColor:kGlobalThemeColor];
        [_cancleBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_cancleBtn];
        
        [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_desc.mas_bottom).offset(30);
            make.bottom.equalTo(showview.mas_bottom).offset(-20);
            make.size.mas_equalTo(CGSizeMake(100, 40));
            make.centerX.equalTo(showview);
        }];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal ];
        closeButton.contentMode=UIViewContentModeScaleAspectFit;
        [closeButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:closeButton];
        
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showview).offset(15);
            make.right.equalTo(showview).offset(-15);
            make.size.mas_equalTo(CGSizeMake(11, 11));
        }];
    }
    return self;
}

-(void)cancel{
   
    [self HideMicPopView];
}
-(void)complete{
    
    [self HideMicPopView];
}
-(void)HideMicPopView{
    
    [self removeFromSuperview];
}


@end
