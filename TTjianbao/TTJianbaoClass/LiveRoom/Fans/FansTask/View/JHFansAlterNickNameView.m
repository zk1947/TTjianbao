//
//  JHFansAlterNickNameView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansAlterNickNameView.h"
#import "TTjianbaoHeader.h"
#import "UIImage+JHColor.h"
@interface JHFansAlterNickNameView ()<UITextFieldDelegate>
{
    UIView *showview;
}
@property (nonatomic, strong)    UILabel * title;
@property (nonatomic, strong)    UILabel * desc;
@property (nonatomic, strong)   UIButton* sureBtn;
@property (nonatomic, strong)   UIButton* cancleBtn;
@end

@implementation JHFansAlterNickNameView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        
    }
    return self;
}
- (void)configUI{
    
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
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"fans_alert_close"] forState:UIControlStateNormal ];
    closeButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [closeButton addTarget:self action:@selector(hiddenAlert) forControlEvents:UIControlEventTouchUpInside];
    [showview addSubview:closeButton];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(showview).offset(-5);
        make.top.equalTo(showview).offset(5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    
    _title=[[UILabel alloc]init];
    _title.text=@"修改粉丝团昵称";
    _title.font=[UIFont fontWithName:kFontMedium size:18];
    _title.textColor=kColor333;
    _title.numberOfLines = 1;
    _title.textAlignment = NSTextAlignmentLeft;
    _title.lineBreakMode = NSLineBreakByWordWrapping;
    [showview addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showview).offset(20);
        make.centerX.equalTo(showview);
    }];
    
    UIView *inputBackView = [[UIView alloc]init];
    inputBackView.layer.cornerRadius = 2;
    inputBackView.backgroundColor=kColorFFF;
    inputBackView.layer.masksToBounds = YES;
    inputBackView.layer.borderWidth = 0.5;
    inputBackView.layer.borderColor = kColorDDD.CGColor;
    [showview addSubview:inputBackView];
    
    [inputBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@134);
        make.height.equalTo(@32);
        make.top.equalTo(_title.mas_bottom).offset(20);
        make.left.equalTo(showview).offset(10);
    }];
    
    _textField = [[UITextField alloc]init];
    _textField.delegate = self;
    [inputBackView addSubview:_textField];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(inputBackView);
        make.left.equalTo(inputBackView).offset(5);
        make.right.equalTo(inputBackView.mas_right).offset(-5);
    }];
    
    _desc=[[UILabel alloc]init];
    _desc.text = @"的粉丝团";
    _desc.font=[UIFont fontWithName:kFontNormal size:15];
    _desc.textColor=kColor333;
    _desc.numberOfLines = 1;
    _desc.textAlignment =NSTextAlignmentCenter ;
    _desc.lineBreakMode = NSLineBreakByWordWrapping;
    [showview addSubview:_desc];
    
    [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(inputBackView).offset(0);
        make.left.equalTo(inputBackView.mas_right).offset(5);
    }];
    
    
    _sureBtn=[[UIButton alloc]init];
    _sureBtn.contentMode=UIViewContentModeScaleAspectFit;
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(113, 40) radius:20];
    [_sureBtn setBackgroundImage:nor_image forState:UIControlStateNormal];
    _sureBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    [_sureBtn setTitleColor:kColor222 forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    [showview addSubview:_sureBtn];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBackView.mas_bottom).offset(20);
        make.bottom.equalTo(showview.mas_bottom).offset(-20);
        make.centerX.equalTo(showview);
        make.size.mas_equalTo(CGSizeMake(113, 40));
    }];
    
}
-(void)complete{
    
    if (self.alterNameBlock) {
        self.alterNameBlock();
    }
}
-(void)hiddenAlert{
    
    [self removeFromSuperview];
}

@end
