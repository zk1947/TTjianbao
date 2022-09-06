//
//  JHRealNameAuthenticationViewController.m
//  TTjianbao
//
//  Created by 张坤 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRealNameAuthenticationViewController.h"
#import "NTESLDMainViewController.h"
#import "JHTopBottomLabelAndTFView.h"
#import "UIImage+JHColor.h"
#import "UIView+JHGradient.h"
#import "NSString+Extension.h"
#import "CommHelp.h"
#import "JHAllStatistics.h"
#import <AVFoundation/AVCaptureDevice.h>

#define kMaxLength 30

@interface JHRealNameAuthenticationViewController ()

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) JHTopBottomLabelAndTFView *cardholderView;
@property (nonatomic, strong) JHTopBottomLabelAndTFView *idCardView;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, copy) NSString *publicRealName;
@property (nonatomic, copy) NSString *publicIdCard;

@property (nonatomic, assign) Boolean isShowPublicRealName;
@property (nonatomic, assign) Boolean isShowPubIdCard;
@property(nonatomic, assign) Boolean displayLoading;
@end

@implementation JHRealNameAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.view.backgroundColor = RGB(248, 248, 248);
    self.displayLoading = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestInfo];
}

-(void)requestInfo {
    User *user = [UserInfoRequestManager sharedInstance].user;
    if (user.isFaceAuth.intValue == 0 &&
        user.authType == JHUserAuthTypeUnAuth) { // 如果没有实名认证 就不请求该接口
        [self setupUI];
        return;
    }
    
    if(self.displayLoading) {
        [SVProgressHUD show];
    }
    @weakify(self)
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/app/customer/getIdentity") Parameters:nil successBlock:^(RequestModel *respondObject) {
        @strongify(self)
        [SVProgressHUD dismiss];
        self.displayLoading = NO;
        [self setupUI];
        [self setupData:(NSDictionary *)respondObject.data];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
        [self setupUI];
    }];
}

- (void)setupData:(NSDictionary *)dic {
    self.publicRealName = [dic valueForKey:@"realName"];
    self.publicIdCard = [dic valueForKey:@"idCard"];
    self.nextBtn.hidden = YES;
    if ([UserInfoRequestManager sharedInstance].user.authType != JHUserAuthTypeUnAuth &&
        [UserInfoRequestManager sharedInstance].user.isFaceAuth.intValue == 0) {
        self.nextBtn.hidden = NO;
        self.nextBtn.enabled = YES;
        self.nextBtn.alpha = 1.0;
    }
    
    self.cardholderView.TFEnabled = NO;
    self.idCardView.TFEnabled = NO;
    
    [self.idCardView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(idCardViewTapAction)]];
    [self.cardholderView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(cardholderViewTapAction)]];
    
    self.isShowPubIdCard = NO;
    self.isShowPublicRealName = NO;
}

- (void)setupUI {
    if (self.mainView) {
        return;
    }
    [self setupTFView];
    [self setupBottomView];
}

-(void)setupTFView {
    self.mainView = [[UIView alloc] init];
    self.mainView.layer.cornerRadius = 5.f;
    self.mainView.clipsToBounds = YES;
    self.mainView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.mainView];
    
    UILabel *idCardTiplabel = [[UILabel alloc] init];
    idCardTiplabel.text = @"身份证信息";
    idCardTiplabel.numberOfLines = 1;
    idCardTiplabel.textAlignment = NSTextAlignmentLeft;
    idCardTiplabel.lineBreakMode = NSLineBreakByWordWrapping;
    idCardTiplabel.font = [UIFont boldSystemFontOfSize:20.f];
    idCardTiplabel.textColor = HEXCOLOR(0x333333);
    
    [self.mainView addSubview:idCardTiplabel];
    [idCardTiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(12.f);
    }];
    
    UIImageView *idCardTipIcon = [[UIImageView alloc] init];
    idCardTipIcon.image = [UIImage imageNamed:@"icon_realName_idCard"];
    [self.mainView addSubview:idCardTipIcon];
    
    [idCardTipIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(idCardTiplabel.mas_bottom).mas_offset(5.f);
        make.left.mas_equalTo(idCardTiplabel);
    }];
    
    UILabel *idCardSubTiplabel = [[UILabel alloc] init];
    idCardSubTiplabel.text = @"信息仅用于身份验证，我们将保障您的信息安全";
    idCardSubTiplabel.numberOfLines = 1;
    idCardSubTiplabel.textAlignment = NSTextAlignmentLeft;
    idCardSubTiplabel.lineBreakMode = NSLineBreakByWordWrapping;
    idCardSubTiplabel.font = [UIFont boldSystemFontOfSize:12.f];
    idCardSubTiplabel.textColor = HEXCOLOR(0xFF999999);
    
    [self.mainView addSubview:idCardSubTiplabel];
    [idCardSubTiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(idCardTipIcon);
        make.left.mas_equalTo(idCardTipIcon.mas_right).mas_offset(1);
    }];
    
    [self.mainView addSubview:self.cardholderView];
    [self.cardholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(74.f);
        make.left.right.mas_equalTo(0.f);
        make.top.mas_equalTo(idCardTipIcon.mas_bottom).mas_offset(38.f);
    }];
    
    [self.mainView addSubview:self.idCardView];
    [self.idCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.mas_equalTo(self.cardholderView);
        make.top.mas_equalTo(self.cardholderView.mas_bottom);
    }];
    
    UILabel *realNameTiplabel = [[UILabel alloc] init];
    realNameTiplabel.text = @"为保障您账户的财产安全，请务必使用本人身份证件进行认证，后续提现需要使用该身份证绑定的银行卡才能进行操作。";
    realNameTiplabel.numberOfLines = 0;
    realNameTiplabel.textAlignment = NSTextAlignmentLeft;
    realNameTiplabel.lineBreakMode = NSLineBreakByWordWrapping;
    realNameTiplabel.font = [UIFont boldSystemFontOfSize:12.f];
    realNameTiplabel.textColor = HEXCOLOR(0x999999);
    
    [self.mainView addSubview:realNameTiplabel];
    [realNameTiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(self.idCardView.mas_bottom).mas_equalTo(10.f);
    }];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.f+UI.statusAndNavBarHeight);
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.bottom.mas_equalTo(realNameTiplabel.mas_bottom).mas_offset(15.f);
    }];
    
}

-(void)setupBottomView {
    UIButton *nextBtn = [UIButton jh_buttonWithTitle:@"下一步，人脸验证" fontSize:16.f textColor:HEXCOLOR(0xFF333333) target:self action:@selector(nextBtnAction:) addToSuperView:self.view];
    nextBtn.layer.cornerRadius = 22.f;
    nextBtn.clipsToBounds = YES;
    nextBtn.enabled = NO;
    [nextBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mainView.mas_bottom).mas_offset(20.f);
        make.left.right.equalTo(self.mainView);
        make.height.equalTo(@44);
    }];
    nextBtn.alpha = 0.5;
    
    [self.view layoutIfNeeded];
    [nextBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100),HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    self.nextBtn = nextBtn;
}

- (void)cardholderViewTapAction {
    self.isShowPublicRealName = !self.isShowPublicRealName;
}

- (void)idCardViewTapAction {
    self.isShowPubIdCard = !self.isShowPubIdCard;
}

- (void)setIsShowPubIdCard:(Boolean)isShowPubIdCard {
    _isShowPubIdCard = isShowPubIdCard;
    
    if (_isShowPubIdCard) {
        self.idCardView.getTF.text = self.publicIdCard;
    }else {
        NSString *idCard = self.publicIdCard.copy;
        if (idCard.length <= 2) return;
        self.idCardView.getTF.text = [idCard stringByReplacingCharactersInRange:NSMakeRange(1, idCard.length-2) withString:[idCard returnCiphertext:idCard.length-2]];
    }
}

- (void)setIsShowPublicRealName:(Boolean)isShowPublicRealName {
    _isShowPublicRealName = isShowPublicRealName;
    if (_isShowPublicRealName) {
        self.cardholderView.getTF.text = self.publicRealName;
    }else {
        NSString *realName = self.publicRealName.copy;
        if (realName.length <= 1) return;
        self.cardholderView.getTF.text = [realName stringByReplacingCharactersInRange:NSMakeRange(0, realName.length-1) withString:[realName returnCiphertext:realName.length-1]];
    }
}

- (void)nextBtnAction:(UIButton *)btn {
    [self.view endEditing:YES];
    
    if (self.publicRealName.length == 0) {
        self.publicRealName = self.cardholderView.getTFText;
    }
    if (self.publicRealName.length > 30) {
        [self.view makeToast:@"请输入正确的姓名" duration:1.f position:CSToastPositionCenter];
        return;
    }
    
    if (self.publicIdCard.length == 0) {
        self.publicIdCard = self.idCardView.getTFText;
    }
    if (self.publicIdCard.length != 18 || ![CommHelp judgeIdentityStringValid:self.publicIdCard]) {
        [self.view makeToast:@"请输入正确的身份证号" duration:1.f position:CSToastPositionCenter];
        return;
    }
    [self canUserCamear];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma -mark private method
- (BOOL)canUserCamear {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [self pushVC];
                }else {
                    [JHKeyWindow makeToast:@"您暂未授予相机权限，请在系统设置中开启" duration:1.0 position:CSToastPositionCenter];
                }
            });
        }];
        return NO;
    }
    else {
        [self pushVC];
        return YES;
    }
    return YES;
}

- (void)pushVC {
    NSDictionary *par = @{
        @"page_position":@"certification"
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickNext"
                                          params:par
                                            type:JHStatisticsTypeSensors];
    
    NTESLDMainViewController *vc = [NTESLDMainViewController new];
    vc.userName = [self.cardholderView getTFText].copy;
    vc.userCardNo = [self.idCardView getTFText].copy;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma -mark 懒加载 method

- (JHTopBottomLabelAndTFView *)cardholderView {
    if (!_cardholderView) {
        _cardholderView = [[JHTopBottomLabelAndTFView alloc] initWithLabel:@"本人姓名" TFPlaceHolder:@"请输入真实姓名" TFText:@""];
        _cardholderView.TFEnabled = YES;
        [_cardholderView setErrorTip:@"请输入正确的姓名"];
        @weakify(self)
        [_cardholderView setTfEditingChangedBlock:^(NSString * _Nonnull text) {
            @strongify(self)
            NSString *idCard = [self.idCardView getTFText];
            if ([CommHelp judgeIdentityStringValid:idCard] &&
                [NSString inputCapitalAndNumLowercaseLetterChinese:text]) {
                self.publicIdCard = idCard;
                self.nextBtn.alpha = 1.0;
                self.nextBtn.enabled = YES;
            }else {
                self.nextBtn.alpha = 0.5;
                self.nextBtn.enabled = NO;
            }
        }];
        
        [_cardholderView setTextFieldShouldChangeCharactersInRangeBlock:^Boolean(UITextField * _Nonnull textField, NSRange range, NSString * _Nonnull string) {
            if (textField.text.length > 29) {
                return NO;
            }
            
            if ([string isEqual:@"·"]) {
                return YES;
            }
            
            if ([NSString onlyInputChineseCharacters:string] ||
                [NSString inputCapitalAndLowercaseLetter:string] ||
                [NSString isNineKeyBoard:string]) {
                return YES;
            }
            
            return NO;
        }];
        
        [_cardholderView setTextFieldDidEndEditingBlock:^(UITextField * _Nonnull textField) {
            @strongify(self)
            if ([NSString inputCapitalAndNumLowercaseLetterChinese:textField.text]) {
                [self.cardholderView errorLabelHidden:YES];
            }else {
                [self.cardholderView errorLabelHidden:NO];
            }

        }];
        
        [_cardholderView setTextFieldShouldReturnBlock:^Boolean(UITextField * _Nonnull textField) {
            @strongify(self)
            [self.idCardView.getTF becomeFirstResponder];
            return NO;
        }];
    }
    return _cardholderView;
}

- (JHTopBottomLabelAndTFView *)idCardView {
    if (!_idCardView) {
        _idCardView = [[JHTopBottomLabelAndTFView alloc] initWithLabel:@"本人身份证" TFPlaceHolder:@"请输入18位身份证号码" TFText:@""];
//        _idCardView.keyboardType = UIKeyboardTypeNumberPad;
        _idCardView.TFEnabled = YES;
        _idCardView.returnKeyType = UIReturnKeyDone;
        [_idCardView setErrorTip:@"请输入正确的身份证号"];
        @weakify(self)
        [_idCardView setTfEditingChangedBlock:^(NSString * _Nonnull text) {
            @strongify(self)
            if ([NSString inputCapitalAndNumLowercaseLetterChinese:[_cardholderView getTFText]] > 0 &&
                [CommHelp judgeIdentityStringValid:text]) {
                self.publicIdCard = text;
                self.nextBtn.alpha = 1.0;
                self.nextBtn.enabled = YES;
            }else {
                self.nextBtn.alpha = 0.5;
                self.nextBtn.enabled = NO;
            }
        }];
        
        [_idCardView setTextFieldShouldChangeCharactersInRangeBlock:^Boolean(UITextField * _Nonnull textField, NSRange range, NSString * _Nonnull string) {
            
//            if (textField.text.length > 17) {
//                return NO;
//            }
            
            if ([string isEqual:@"x"] || [string isEqual:@"X"] || [string isEqual:@"w"] || [string isEqual:@"W"]) {
                return YES;
            }
            
            if (![NSString validateZeroNumbers:string] ) {
                return NO;
            }
            
            return YES;
        }];
        
        [_idCardView setTextFieldDidEndEditingBlock:^(UITextField * _Nonnull textField) {
            @strongify(self)
            if (![CommHelp judgeIdentityStringValid:textField.text]) {
                [self.idCardView errorLabelHidden:YES];
            }else {
                [self.idCardView errorLabelHidden:NO];
            }
        }];
        
        [_idCardView setTextFieldShouldReturnBlock:^Boolean(UITextField * _Nonnull textField) {
            @strongify(self)
            [textField resignFirstResponder];
            [self nextBtnAction:nil];
            return NO;
        }];
    }
    return _idCardView;
}

@end
