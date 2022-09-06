//
//  CommAlertView.m
//  TTjianbao
//
//  Created by jiang on 2019/9/11.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "CommAlertView.h"
#import "TTjianbaoHeader.h"
#import "UIImage+JHColor.h"
@interface CommAlertView () <UITextFieldDelegate>
{
    UIView *showview;
}
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * desc;
@property (nonatomic, strong) UIButton* sureBtn;
@property (nonatomic, strong) UIButton* cancleBtn;
@property (nonatomic, strong) UITextField *centerTF;
@end

@implementation CommAlertView
- (instancetype)initWithTitle:(NSString *)title  andDesc:(NSString *)desc  cancleBtnTitle:(NSString *)cancleTitle  sureBtnTitle:(NSString *)completeTitle{
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
            make.top.equalTo(showview).offset(20);
            make.centerX.equalTo(showview);
            if (title.length<=0) {
                make.height.offset(0);
            }
            else{
                make.height.offset(30);
            }
        }];
        
        _titleImage=[[UIImageView alloc]init];
        _titleImage.contentMode = UIViewContentModeScaleAspectFit;
        [titleBack addSubview:_titleImage];
        
        [_titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleBack);
            make.centerY.equalTo(titleBack);
        }];
        
        _title=[[UILabel alloc]init];
        _title.text=title;
        _title.font=[UIFont boldSystemFontOfSize:15];
        _title.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _title.numberOfLines = 1;
        _title.textAlignment = NSTextAlignmentLeft;
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
        NSString* descText = desc ? : @"";
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:descText];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [descText length])];
        [_desc setAttributedText:attributedString];
        _desc.font=[UIFont systemFontOfSize:14];
        _desc.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _desc.numberOfLines = 0;
        _desc.textAlignment =NSTextAlignmentCenter ;
        _desc.lineBreakMode = NSLineBreakByWordWrapping;
        [showview addSubview:_desc];
        
        [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
            if (desc.length>0) {
                make.top.equalTo(titleBack.mas_bottom).offset(20);
            }
            else{
                make.top.equalTo(titleBack.mas_bottom).offset(0);
            }
            make.left.equalTo(showview).offset(10);
            make.right.equalTo(showview).offset(-10);
        }];
        
        _cancleBtn=[[UIButton alloc]init];
        _cancleBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        _cancleBtn.layer.cornerRadius = 20;
        [_cancleBtn setBackgroundColor:[CommHelp toUIColorByStr:@"ffffff"]];
        [_cancleBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        _cancleBtn.layer.borderColor = [kColor666 colorWithAlphaComponent:0.5].CGColor;
        _cancleBtn.layer.borderWidth = 0.5f;
        [_cancleBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_cancleBtn];
        
        [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_desc.mas_bottom).offset(30);
            make.bottom.equalTo(showview.mas_bottom).offset(-20);
            make.left.offset(12);
            make.size.mas_equalTo(CGSizeMake(113, 40));
        }];
        
        _sureBtn=[[UIButton alloc]init];
        _sureBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_sureBtn setTitle:completeTitle forState:UIControlStateNormal];
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
            make.right.offset(-12);
            make.size.mas_equalTo(CGSizeMake(113, 40));
        }];
        
    }
    return self;
}

- (void)dealTitleToCenter{
    _title.textAlignment = NSTextAlignmentCenter;
}

- (instancetype)initWithTitle:(NSString *)title andMutableDesc:(NSMutableAttributedString *)mutableDesc cancleBtnTitle:(NSString *)cancleTitle sureBtnTitle:(NSString *)completeTitle andIsLines:(BOOL)isLines{
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
        
        _closeButton=[[UIButton alloc]init];
        [_closeButton setImage:[UIImage imageNamed:@"c2c_class_alert_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_closeButton];
        
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showview).offset(0);
            make.right.equalTo(showview).offset(-5);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        UIView *titleBack=[[UIView alloc]init];
        [showview addSubview:titleBack];
        [titleBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showview).offset(20);
            make.centerX.equalTo(showview);
            if (title.length<=0) {
                make.height.offset(0);
            }
            else{
                make.height.offset(30);
            }
        }];
        
        _titleImage=[[UIImageView alloc]init];
        _titleImage.contentMode = UIViewContentModeScaleAspectFit;
        [titleBack addSubview:_titleImage];
        
        [_titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleBack);
            make.centerY.equalTo(titleBack);
        }];
        
        _title=[[UILabel alloc]init];
        _title.text=title;
        _title.font=[UIFont boldSystemFontOfSize:15];
        _title.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _title.numberOfLines = 1;
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        [titleBack addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleBack);
            make.left.equalTo(_titleImage.mas_right);
            make.right.equalTo(titleBack);
        }];
        
        _desc=[[UILabel alloc]init];
        _desc.preferredMaxLayoutWidth =260-60;
        _desc.numberOfLines = 0;
        _desc.textAlignment = NSTextAlignmentCenter;
        _desc.attributedText = mutableDesc;
        
        [showview addSubview:_desc];
        
        [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
            if (mutableDesc.length>0) {
                make.top.equalTo(titleBack.mas_bottom).offset(10);
            }
            else{
                make.top.equalTo(titleBack.mas_bottom).offset(0);
            }
            make.left.equalTo(showview).offset(20);
            make.right.equalTo(showview).offset(-20);
        }];
        
        _sureBtn=[[UIButton alloc]init];
        _sureBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_sureBtn setTitle:completeTitle forState:UIControlStateNormal];
        _sureBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        [_sureBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_sureBtn];
        
        _cancleBtn=[[UIButton alloc]init];
        _cancleBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        [_cancleBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_cancleBtn];
        
        if (isLines) {
            UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(182, 40) radius:20];
            [_sureBtn setBackgroundImage:nor_image forState:UIControlStateNormal];
            [_cancleBtn setTitleColor:[CommHelp toUIColorByStr:@"#408ffe"] forState:UIControlStateNormal];
            
            [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_desc.mas_bottom).offset(20);
                make.centerX.mas_equalTo(showview);
                make.size.mas_equalTo(CGSizeMake(182, 40));
            }];
            
            [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_sureBtn.mas_bottom).offset(10);
                make.bottom.equalTo(showview.mas_bottom).offset(-20);
                make.centerX.mas_equalTo(showview);
                make.size.mas_equalTo(CGSizeMake(80, 20));
            }];
        } else {
            UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(113, 40) radius:20];
            [_sureBtn setBackgroundImage:nor_image forState:UIControlStateNormal];
            _cancleBtn.layer.cornerRadius = 20;
            [_cancleBtn setBackgroundColor:[CommHelp toUIColorByStr:@"ffffff"]];
            [_cancleBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
            _cancleBtn.layer.borderColor = [kColor666 colorWithAlphaComponent:0.5].CGColor;
            _cancleBtn.layer.borderWidth = 0.5f;
            
            [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_desc.mas_bottom).offset(20);
                make.bottom.equalTo(showview.mas_bottom).offset(-20);
                make.right.offset(-12);
                make.size.mas_equalTo(CGSizeMake(113, 40));
            }];
            
            [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_sureBtn);
                make.left.offset(12);
                make.size.mas_equalTo(CGSizeMake(113, 40));
            }];
        }
        
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;   //height 就是键盘的高度
    
    [showview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@260);
        make.centerX.equalTo(self);
        make.bottom.mas_equalTo(-height);
    }];
}

-(void)addBackGroundTap {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HideMicPopView)]];
}

-(void)cancel {
    if (self.cancleHandle) {
        self.cancleHandle();
    }
    [self HideMicPopView];
}

- (void)complete {
    if (self.handle) {
        self.handle();
    }
    
    [self HideMicPopView];
}
-(void)close{
    if (self.closeBlock) {
        self.closeBlock();
    }
    [self HideMicPopView];
}
- (void)HideMicPopView {
    [self removeFromSuperview];
}

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
        [showview  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(showViewAction)]];
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
        _title.textAlignment = NSTextAlignmentCenter;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        [showview addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showview).offset(20);
            make.left.right.equalTo(showview);
            
        }];
        
        _desc=[[UILabel alloc]init];
        _desc.preferredMaxLayoutWidth =260-30;
        _desc.font=[UIFont systemFontOfSize:14];
        _desc.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _desc.numberOfLines = 0;
        _desc.textAlignment = NSTextAlignmentCenter;
        _desc.text=desc;
//        _desc.lineBreakMode = NSLineBreakByWordWrapping;
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
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillShow:)
                                                         name:UIKeyboardWillShowNotification
                                                       object:nil];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title  andMutableDesc:(NSMutableAttributedString *)mdesc  cancleBtnTitle:(NSString *)cancleTitle {
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        
        showview =  [[UIView alloc]init];
        showview.center=self.center;
        showview.contentMode=UIViewContentModeScaleAspectFit;
        showview.userInteractionEnabled=YES;
        showview.layer.cornerRadius = 4;
        showview.backgroundColor=[CommHelp toUIColorByStr:@"#f8f8f8"];
        [showview  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(showViewAction)]];
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
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        [showview addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showview).offset(20);
            make.left.right.equalTo(showview);
            
        }];
        
        _desc=[[UILabel alloc]init];
        _desc.preferredMaxLayoutWidth =260-30;
        _desc.font=[UIFont systemFontOfSize:14];
        _desc.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _desc.numberOfLines = 0;
        _desc.textAlignment = NSTextAlignmentCenter;
        _desc.attributedText=mdesc;
//        _desc.lineBreakMode = NSLineBreakByWordWrapping;
        [showview addSubview:_desc];
        
        [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
            if (mdesc.length>0) {
                make.top.equalTo(_title.mas_bottom).offset(20);
            }
            else{
                make.top.equalTo(_title.mas_bottom).offset(0);
            }
            make.left.equalTo(showview).offset(15);
            make.right.equalTo(showview).offset(-15);
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
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillShow:)
                                                         name:UIKeyboardWillShowNotification
                                                       object:nil];
    }
    return self;
}


- (void)showViewAction {
    
}

- (void)setDesFont:(UIFont *)font {
    self.desc.font = font;
    self.desc.textAlignment = NSTextAlignmentCenter;
//    self.desc.backgroundColor = UIColor.redColor;
    [self.desc mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title.mas_bottom).mas_offset(20.f);
        make.centerX.mas_equalTo(showview);
    }];
    
    [self setNeedsLayout];
}

- (void)show {
    _title.font = [UIFont boldSystemFontOfSize:17.f];
    
    if (_centerTF) {
        [_centerTF becomeFirstResponder];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)addCloseBtn {
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal ];
    closeButton.contentMode=UIViewContentModeScaleAspectFit;
    [closeButton addTarget:self action:@selector(HideMicPopView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [showview addSubview:closeButton];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showview).offset(10);
        make.right.equalTo(showview).offset(-10);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    
    _desc.textAlignment = NSTextAlignmentLeft;
}

- (NSString *)getTextFiledText {
    return self.centerTF.text;
}

- (void)displayTextFiledWithPlaceHoldStr:(NSString *)placeHoldStr {
    [self addSubview:self.centerTF];
    self.centerTF.placeholder = placeHoldStr;
    
    [_title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showview).offset(32);
    }];
    
    [self.centerTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_title.mas_bottom).offset(20);
        make.left.equalTo(showview).offset(15);
        make.right.equalTo(showview).offset(-15);
        make.height.mas_equalTo(40.f);
    }];
    
    [self.cancleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerTF.mas_bottom).offset(20);
    }];
    
    [self layoutIfNeeded];
}
//输入框键盘样式
- (void)setTfKeyboardType:(UIKeyboardType)tfKeyboardType{
    _tfKeyboardType = tfKeyboardType;
    self.centerTF.keyboardType = tfKeyboardType;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        [self HideMicPopView];
    }
    
    if (self.textFieldShouldReturnBlock) {
       return self.textFieldShouldReturnBlock(textField);
    }
    return YES;
}

- (UITextField *)centerTF {
    if (!_centerTF) {
        _centerTF = [[UITextField alloc] init];
//        _centerTF.backgroundColor = [UIColor redColor];
        _centerTF.tintColor = HEXCOLOR(0xFFF7B500);
        _centerTF.textColor = HEXCOLOR(0x333333);
        _centerTF.returnKeyType = UIReturnKeyDone;
        _centerTF.userInteractionEnabled = YES;
        _centerTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _centerTF.font = [UIFont systemFontOfSize:14.f];
        _centerTF.layer.borderWidth = 1;
        _centerTF.layer.borderColor = RGB(221, 221, 221).CGColor;
        _centerTF.layer.cornerRadius = 5;
        _centerTF.textAlignment = NSTextAlignmentCenter;
        _centerTF.delegate = self;
//        [_centerTF addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _centerTF;
}
-(void)setDescTextAlignment:(NSTextAlignment)align{
    _desc.textAlignment = align;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
