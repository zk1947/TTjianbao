//
//  JHConnectMicPopAlertView.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/13.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "JHConnectMicPopAlertView.h"
#import "JHGrowingIO.h"
#import "CommHelp.h"
#import "UIImage+JHColor.h"
@interface JHConnectMicPopAlertView (){
    NSTimeInterval beginShowTime;
}
@property (nonatomic, strong)   UIButton* sureBtn;
@property(nonatomic,copy)sureBlock sureClick;
@property(nonatomic,copy)cancleBlock cancleClick;
@end

@implementation JHConnectMicPopAlertView

- (instancetype)initWithTitle:(NSString *)title cancleBtnTitle:(NSString *)cancleTitle  sureBtnTitle:(NSString *)completeTitle {
    if (self = [super init]) {
        beginShowTime = [[NSDate date] timeIntervalSince1970];
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        
        UIImageView *showview =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        showview.backgroundColor = [UIColor whiteColor];
        //        showview.center=self.center;
        //        showview.size=CGSizeMake(260, 149);
        showview.layer.cornerRadius = 8;
        showview.layer.masksToBounds = YES;
        showview.contentMode=UIViewContentModeScaleAspectFit;
        showview.userInteractionEnabled=YES;
        [self addSubview:showview];
        [showview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(260, 149));
            
        }];
        
        UILabel * viewTitle=[[UILabel alloc]init];
        viewTitle.text=title;
        viewTitle.font=[UIFont fontWithName:kFontMedium size:15];
        viewTitle.textColor=[CommHelp toUIColorByStr:@"#333333"];
        viewTitle.numberOfLines = 2;
        viewTitle.textAlignment = UIControlContentHorizontalAlignmentLeft;
        viewTitle.lineBreakMode = NSLineBreakByWordWrapping;
        [showview addSubview:viewTitle];
        
        [viewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showview).offset(30);
            make.left.right.equalTo(showview);
            
        }];
        
        
        UIButton* cancleBtn=[[UIButton alloc]init];
        cancleBtn.contentMode=UIViewContentModeScaleAspectFit;
        [cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
        cancleBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        cancleBtn.layer.cornerRadius = 20;
        [cancleBtn setBackgroundColor:[CommHelp toUIColorByStr:@"ffffff"]];
        [cancleBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        cancleBtn.layer.borderColor = [kColor666 colorWithAlphaComponent:0.5].CGColor;
        cancleBtn.layer.borderWidth = 0.5f;
        [cancleBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:cancleBtn];
        
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(showview.mas_bottom).offset(-20);
            make.left.offset(10);
            make.size.mas_equalTo(CGSizeMake(113, 40));
            
        }];
        
        _sureBtn=[[UIButton alloc]init];
        _sureBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_sureBtn setTitle:completeTitle forState:UIControlStateNormal];
        _sureBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(113, 40) radius:20];
        [_sureBtn setBackgroundImage:nor_image forState:UIControlStateNormal];
        //  [_sureBtn setBackgroundColor:[CommHelp toUIColorByStr:@"fee100"]];
        [_sureBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_sureBtn];
        
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(showview.mas_bottom).offset(-20);
            //  make.right.offset(-25);
            make.right.offset(-10);
            make.size.mas_equalTo(CGSizeMake(113, 40));
            
        }];
        
        // [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }
    return self;
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
    if (self.delegate) {
        [self.delegate ConnectViewButtonCancle:self];
    }
    
}
-(void)sureClick:(UIButton *)sender{
    
    [self HideMicPopView];
    
    if (self.sureClick) {
        self.sureClick();
    }
    if (self.delegate) {
        [self.delegate ConnectViewButtonComplete:self];
    }
    
}
-(void)HideMicPopView{
    
    [self removeFromSuperview];
    [self trackPageShowTime];
}

-(void)setTimeCount:(NSInteger)timeCount{
    
    [_sureBtn setTitle:[NSString stringWithFormat:@"接受连麦(%lds)",(long)timeCount] forState:UIControlStateNormal];
}

//页面停留时间
- (void)trackPageShowTime
{
    NSTimeInterval endShowTime = [[NSDate date] timeIntervalSince1970];
    NSString *duration = [NSString stringWithFormat:@"%.f", endShowTime - beginShowTime];
    [JHGrowingIO trackPublicEventId:JHIdentifyActivityOnlickTimeClick paramDict:@{ @"duration":duration}];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}
@end
