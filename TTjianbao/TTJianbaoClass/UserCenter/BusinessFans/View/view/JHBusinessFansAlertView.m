//
//  JHBusinessFansAlertView.m
//  TTjianbao
//
//  Created by user on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansAlertView.h"
#import "TTjianbaoHeader.h"
#import "UIImage+JHColor.h"
#import "UIView+JHGradient.h"

@interface JHBusinessFansAlertView () {
    UIView *showview;
}
@property (nonatomic, strong) UILabel  *title;
@property (nonatomic, strong) UILabel  *desc;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *cancleBtn;
@end

@implementation JHBusinessFansAlertView

- (instancetype)initWithTitle:(NSString *)title  andDesc:(NSString *)desc  cancleBtnTitle:(NSString *)cancleTitle  sureBtnTitle:(NSString *)completeTitle{
    if (self = [super init]) {
        self.frame                                  = [UIScreen mainScreen].bounds;
        self.backgroundColor                        = [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        showview                                    = [[UIView alloc] init];
        showview.center                             = self.center;
        showview.contentMode                        = UIViewContentModeScaleAspectFit;
        showview.userInteractionEnabled             = YES;
        showview.layer.cornerRadius                 = 8;
        showview.backgroundColor                    = [CommHelp toUIColorByStr:@"#ffffff"];
        [self addSubview:showview];
        [showview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@260);
            make.center.equalTo(self);
        }];

        UIView *titleBack = [[UIView alloc] init];
        [showview addSubview:titleBack];
        [titleBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showview).offset(32.f);
            make.centerX.equalTo(showview);
            if (title.length<=0) {
                 make.height.offset(0);
            } else{
                 make.height.offset(30);
            }
        }];

        _titleImage             = [[UIImageView alloc] init];
        _titleImage.contentMode = UIViewContentModeScaleAspectFit;
        [titleBack addSubview:_titleImage];
        [_titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.equalTo(titleBack);
               make.centerY.equalTo(titleBack);
        }];

        _title               = [[UILabel alloc] init];
        _title.text          = title;
        _title.font          = [UIFont fontWithName:kFontMedium size:18.f];
        _title.textColor     = HEXCOLOR(0x333333);
        _title.numberOfLines = 1;
        _title.textAlignment = UIControlContentHorizontalAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        [titleBack addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerY.equalTo(titleBack);
             make.left.equalTo(_titleImage.mas_right);
             make.right.equalTo(titleBack);
        }];

        _desc                                       = [[UILabel alloc]init];
        _desc.preferredMaxLayoutWidth               = 260-60;
        NSString *descText                          = desc ? : @"";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:descText];
        NSMutableParagraphStyle *paragraphStyle     = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [descText length])];
        [_desc setAttributedText:attributedString];
        _desc.font                                  = [UIFont fontWithName:kFontNormal size:13.f];
        _desc.textColor                             = HEXCOLOR(0x333333);
        _desc.numberOfLines                         = 0;
        _desc.textAlignment                         = NSTextAlignmentCenter;
        _desc.lineBreakMode                         = NSLineBreakByWordWrapping;
        [showview addSubview:_desc];
        [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
            if (desc.length>0) {
                make.top.equalTo(titleBack.mas_bottom).offset(15.f);
            } else{
                make.top.equalTo(titleBack.mas_bottom).offset(0);
            }
             make.left.equalTo(showview).offset(61.f);
             make.right.equalTo(showview).offset(-61.f);
        }];

        _cancleBtn                    = [[UIButton alloc]init];
        _cancleBtn.contentMode        = UIViewContentModeScaleAspectFit;
        [_cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font    = [UIFont boldSystemFontOfSize:14];
        _cancleBtn.layer.cornerRadius = 20;
        [_cancleBtn setBackgroundColor:HEXCOLOR(0xFFFFFF)];
        [_cancleBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        _cancleBtn.layer.borderColor  = [kColor666 colorWithAlphaComponent:0.5].CGColor;
        _cancleBtn.layer.borderWidth  = 0.5f;
        [_cancleBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_cancleBtn];
        [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_desc.mas_bottom).offset(30);
            make.bottom.equalTo(showview.mas_bottom).offset(-20);
            make.left.offset(12);
            make.size.mas_equalTo(CGSizeMake(113, 40));
        }];

        _sureBtn = [[UIButton alloc]init];
        _sureBtn.contentMode                        = UIViewContentModeScaleAspectFit;
        [_sureBtn setTitle:completeTitle forState:UIControlStateNormal];
        UIImage *nor_image                          = [UIImage gradientThemeImageSize:CGSizeMake(113, 40) radius:20];
        [_sureBtn setBackgroundImage:nor_image forState:UIControlStateNormal];
        _sureBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
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
- (void)addBackGroundTap {
    
  [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel)]];
        
}

- (void)cancel {
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

- (void)HideMicPopView {
    
    [self removeFromSuperview];
}

- (instancetype)initWithTitle:(NSString *)title andDesc:(NSString *)desc  cancleBtnTitle:(NSString *)cancleTitle {
    if (self = [super init]) {
        self.frame                      = [UIScreen mainScreen].bounds;
        self.backgroundColor            = HEXCOLORA(0x000000,0.5f);
        showview                        = [[UIView alloc] init];
        showview.center                 = self.center;
        showview.contentMode            = UIViewContentModeScaleAspectFit;
        showview.userInteractionEnabled = YES;
        showview.layer.cornerRadius     = 8.f;
        showview.backgroundColor        = [CommHelp toUIColorByStr:@"#f8f8f8"];
         [self addSubview:showview];
         [showview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(260.f);
            make.center.equalTo(self);
         }];

        _title                          = [[UILabel alloc]init];
        _title.text                     = title;
         _title.font                    = [UIFont fontWithName:kFontMedium size:18.f];
        _title.textColor                = HEXCOLOR(0x333333);
        _title.numberOfLines            = 1;
        _title.textAlignment            = NSTextAlignmentCenter;
        _title.lineBreakMode            = NSLineBreakByWordWrapping;
        [showview addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showview).offset(32.f);
            make.left.right.equalTo(showview);
        }];

        _desc                           = [[UILabel alloc] init];
//        _desc.preferredMaxLayoutWidth   = 260-30;
        _desc.text                      = desc;
        _desc.font                     = [UIFont fontWithName:kFontNormal size:13.f];
        _desc.textColor                 = HEXCOLOR(0x333333);
        _desc.numberOfLines             = 0;
        _desc.textAlignment             = NSTextAlignmentCenter;
 //       _desc.lineBreakMode             = NSLineBreakByWordWrapping;
        [showview addSubview:_desc];
        [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
            if (desc.length>0) {
                make.top.equalTo(_title.mas_bottom).offset(15.f);
            } else {
                make.top.equalTo(_title.mas_bottom).offset(0);
            }
            make.left.equalTo(showview).offset(61.f);
            make.right.equalTo(showview).offset(-61.f);
        }];

        _cancleBtn                      = [[UIButton alloc]init];
        _cancleBtn.contentMode          = UIViewContentModeScaleAspectFit;
        [_cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
         _cancleBtn.titleLabel.font     = [UIFont fontWithName:kFontNormal size:15.f];
        _cancleBtn.layer.cornerRadius   = 20;
        [_cancleBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        [_cancleBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_cancleBtn];
        [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_desc.mas_bottom).offset(20.f);
            make.left.equalTo(showview).offset(31.f);
            make.right.equalTo(showview).offset(-31.f);
            make.height.mas_equalTo(40.f);
            make.bottom.equalTo(showview.mas_bottom).offset(-20.f);
        }];
    }
    return self;
}
- (void)addCloseBtn {
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
     _desc.textAlignment = NSTextAlignmentCenter;
}

- (void)setDescTextAlignment:(NSTextAlignment)align {
    _desc.textAlignment = align;
}
@end

