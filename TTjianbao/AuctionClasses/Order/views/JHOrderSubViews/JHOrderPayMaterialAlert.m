//
//  JHOrderPayMaterialAlert.m
//  TTjianbao
//
//  Created by jiangchao on 2021/1/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHOrderPayMaterialAlert.h"
#import "TTjianbaoHeader.h"
#import "UIImage+JHColor.h"
#import "NSString+AttributedString.h"
@interface JHOrderPayMaterialAlert ()
{
    UIView *showview;
}
@property (nonatomic, strong)    UILabel * title;
@property (nonatomic, strong)    UILabel * desc;
@property (nonatomic, strong)   UIButton* sureBtn;
@property (nonatomic, strong)   UIButton* cancleBtn;
@end

@implementation JHOrderPayMaterialAlert
- (instancetype)init{
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        
         showview =  [[UIView alloc]init];
         showview.center=self.center;
         showview.contentMode=UIViewContentModeScaleAspectFit;
         showview.userInteractionEnabled=YES;
         showview.layer.cornerRadius = 8;
         showview.backgroundColor=[CommHelp toUIColorByStr:@"#ffffff"];
         [self addSubview:showview];
        
        [showview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@260);
            make.center.equalTo(self);
            
        }];
        
        UIView *titleBack=[[UIView alloc]init];
        [showview addSubview:titleBack];
        [titleBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showview).offset(0);
            make.centerX.equalTo(showview);
            make.height.offset(0);
        }];
        
         _titleImage=[[UIImageView alloc]init];
         _titleImage.contentMode = UIViewContentModeScaleAspectFit;
         [titleBack addSubview:_titleImage];
           
        [_titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.equalTo(titleBack);
               make.centerY.equalTo(titleBack);
           }];
        
        _title=[[UILabel alloc]init];
        _title.text=@"";
        _title.font=[UIFont boldSystemFontOfSize:15];
        _title.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _title.numberOfLines = 1;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        [titleBack addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerY.equalTo(titleBack);
             make.left.equalTo(_titleImage.mas_right);
             make.right.equalTo(titleBack);
        }];
    
        _desc=[[UILabel alloc]init];
        _desc.preferredMaxLayoutWidth =260-60;
//        _desc.text=desc;
        NSString* descText = @"您购买的是定制套餐（原料+定制），需要先支付[原料订单]，再支付[定制订单]。";
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:descText];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [descText length])];
        [_desc setAttributedText:attributedString];
        _desc.font=[UIFont systemFontOfSize:14];
        _desc.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _desc.numberOfLines = 0;
        _desc.textAlignment =NSTextAlignmentCenter ;
        _desc.lineBreakMode = NSLineBreakByWordWrapping;
        [showview addSubview:_desc];
        
        [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
          
            make.top.equalTo(titleBack.mas_bottom).offset(20);
             make.left.equalTo(showview).offset(30);
             make.right.equalTo(showview).offset(-30);
        }];
        
        _cancleBtn=[[UIButton alloc]init];
        _cancleBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font=[UIFont fontWithName:kFontNormal size:15];
        _cancleBtn.layer.cornerRadius = 20;
        [_cancleBtn setBackgroundColor:[CommHelp toUIColorByStr:@"ffffff"]];
        [_cancleBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        _cancleBtn.layer.borderColor = [kColor666 colorWithAlphaComponent:0.5].CGColor;
        _cancleBtn.layer.borderWidth = 0.5f;
        [_cancleBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_cancleBtn];
        
        [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_desc.mas_bottom).offset(20);
            make.bottom.equalTo(showview.mas_bottom).offset(-20);
            make.left.offset(10);
            make.size.mas_equalTo(CGSizeMake(113, 40));
        }];
        
        _sureBtn=[[UIButton alloc]init];
        _sureBtn.contentMode=UIViewContentModeScaleAspectFit;
       // [_sureBtn setTitle:completeTitle forState:UIControlStateNormal];
       // _sureBtn.layer.cornerRadius = 20;
          UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(113, 40) radius:20];
        [_sureBtn setBackgroundImage:nor_image forState:UIControlStateNormal];
        _sureBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
      //  [_sureBtn setBackgroundColor:[CommHelp toUIColorByStr:@"fee100"]];
        [_sureBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_sureBtn];
        
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cancleBtn);
            make.bottom.equalTo(showview.mas_bottom).offset(-20);
            make.right.offset(-10);
            make.size.mas_equalTo(CGSizeMake(113, 40));
        }];
        
        UILabel * sureBtnTitle=[[UILabel alloc]init];
        sureBtnTitle.text= @"去支付\n原料订单";
        sureBtnTitle.font=[UIFont fontWithName:kFontNormal size:13];
        sureBtnTitle.textColor=kColor333;
        sureBtnTitle.numberOfLines = 2;
        sureBtnTitle.textAlignment = NSTextAlignmentCenter;
        sureBtnTitle.lineBreakMode = NSLineBreakByWordWrapping;
        [_sureBtn addSubview:sureBtnTitle];
        NSString * string=@"去支付\n(原料订单)";;
        NSRange range = [string rangeOfString:@"(原料订单)"];
        sureBtnTitle.attributedText=[string attributedFont:[UIFont fontWithName:kFontNormal size:10.f] color:kColor333 range:range];
       
        [sureBtnTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            
             make.center.equalTo(_sureBtn);
        }];
        
        
        
    }
    return self;
}
-(void)addBackGroundTap{
    
  [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel)]];
        
}
-(void)cancel{
    if (self.cancleHandle) {
        self.cancleHandle();
    }
    [self HideMicPopView];
}
-(void)complete{
    
    if (self.handle) {
        self.handle();
    }
       [self HideMicPopView];
}
-(void)HideMicPopView{
    
    [self removeFromSuperview];
}


@end
