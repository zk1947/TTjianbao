//
//  JHOCKAddBankCardViewController.m
//  TTjianbao
//
//  Created by 张坤 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHOCKAddBankCardViewController.h"
#import "JHAddOCKBankCardSuccessViewController.h"
#import "JHWebViewController.h"
#import "JHTopBottomLabelAndTFView.h"
#import "JHCheckBoxProtocolView.h"
#import "JHIdentifyBankCardNumberLayer.h"
#import "CommAlertView.h"
#import <AVFoundation/AVCaptureDevice.h>
#import "UIImage+JHColor.h"
#import "UIView+JHGradient.h"
#import "NSString+Extension.h"
#import "CommHelp.h"

@interface JHOCKAddBankCardViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *idCardView; /// 身份证信息view
@property (nonatomic, strong) JHTopBottomLabelAndTFView *bankCardNoView; /// 银行卡号view
@property (nonatomic, strong) JHTopBottomLabelAndTFView *bankCardTypeView; /// 银行卡类型view
@property (nonatomic, strong) JHTopBottomLabelAndTFView *bankCardOpenView; /// 开户行
@property (nonatomic, strong) JHTopBottomLabelAndTFView *bankCardIphoneNoView; /// 手机号
@property (nonatomic, strong) JHTopBottomLabelAndTFView *bankCardVerificationCodeView; /// 验证码
@property (nonatomic, strong) JHCheckBoxProtocolView *checkBoxProtocolView; /// 查看服务协议

@property (nonatomic, strong) UILabel *idCardSubTiplabel;
@property (nonatomic, strong) UILabel *idCardNamelabel;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, assign) int cardType;
//@property (nonatomic, copy) NSString *publicRealName;
//@property (nonatomic, copy) NSString *publicIdCard;
@end

@implementation JHOCKAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    self.view.backgroundColor =  RGB(248, 248, 248);
    [self requestInfo];
    [self setupUI];
}

-(void)requestInfo {
    
    [SVProgressHUD show];
    @weakify(self)
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/app/customer/getIdentity") Parameters:nil successBlock:^(RequestModel *respondObject) {
        @strongify(self)
        [SVProgressHUD dismiss];
        [self setupData:(NSDictionary *)respondObject.data];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
}

- (void)setupUI {
    [self setupContentView];
    [self setupTFView];
    [self setupBottomView];
}

- (void)setupData:(NSDictionary *)dic {
    NSString *realName = [dic valueForKey:@"realName"];
    NSString *idCard = [dic valueForKey:@"idCard"];
    
    if (idCard.length <= 2) return;
    idCard = [idCard stringByReplacingCharactersInRange:NSMakeRange(1, idCard.length-2) withString:[idCard returnCiphertext:idCard.length-2]];
    self.idCardSubTiplabel.text = [NSString stringWithFormat:@"身份证号：%@",idCard];
    
    if (realName.length <= 1) return;
    realName = [realName stringByReplacingCharactersInRange:NSMakeRange(0, realName.length-1) withString:[realName returnCiphertext:realName.length-1]];
   
    self.idCardNamelabel.text = [NSString stringWithFormat:@"持卡人：%@",realName];
}

- (void)setupContentView {
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(UI.statusAndNavBarHeight);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.width.equalTo(self.scrollView);
    }];
}

- (void)setupTFView {
    self.mainView = [[UIView alloc] init];
    self.mainView.layer.cornerRadius = 5.f;
    self.mainView.clipsToBounds = YES;
    self.mainView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.mainView];
    
    UILabel *idCardTiplabel = [[UILabel alloc] init];
    idCardTiplabel.text = @"添加银行卡";
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
    idCardSubTiplabel.text = @"信息加密处理，仅用于银行验证";
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
    
    [self.mainView addSubview:self.idCardView];
    [self.idCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(idCardSubTiplabel.mas_bottom).mas_offset(15.f);
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.height.mas_equalTo(70.f);
    }];
    
    [self.mainView addSubview:self.bankCardNoView];
    [self.bankCardNoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(74.f);
        make.left.right.mas_equalTo(0.f);
        make.top.mas_equalTo(self.idCardView.mas_bottom).mas_offset(25.f);
    }];
    
    [self.mainView addSubview:self.bankCardTypeView];
    [self.bankCardTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.mas_equalTo(self.bankCardNoView);
        make.top.mas_equalTo(self.bankCardNoView.mas_bottom);
    }];
    
    [self.mainView addSubview:self.bankCardOpenView];
    [self.bankCardOpenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.mas_equalTo(self.bankCardNoView);
        make.top.mas_equalTo(self.bankCardTypeView.mas_bottom);
    }];
    
    [self.mainView addSubview:self.bankCardIphoneNoView];
    [self.bankCardIphoneNoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.mas_equalTo(self.bankCardNoView);
        make.top.mas_equalTo(self.bankCardOpenView.mas_bottom);
    }];
    
    [self.mainView addSubview:self.bankCardVerificationCodeView];
    [self.bankCardVerificationCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.mas_equalTo(self.bankCardNoView);
        make.top.mas_equalTo(self.bankCardIphoneNoView.mas_bottom);
    }];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.f);
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.bottom.mas_equalTo(self.bankCardVerificationCodeView.mas_bottom).mas_offset(15.f);
    }];
    
    [self.view addSubview:self.checkBoxProtocolView];
    [self.checkBoxProtocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.height.mas_equalTo(20.f);
        make.top.mas_equalTo(self.mainView.mas_bottom).mas_offset(25.f);
    }];
}

- (void)setupBottomView {
    UIButton *nextBtn = [UIButton jh_buttonWithTitle:@"下一步" fontSize:16.f textColor:HEXCOLOR(0xFF333333) target:self action:@selector(nextBtnAction:) addToSuperView:self.contentView];
    nextBtn.layer.cornerRadius = 22.f;
    nextBtn.clipsToBounds = YES;
    nextBtn.alpha = 0.5;
    nextBtn.enabled = NO;
    
    [nextBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.checkBoxProtocolView.mas_bottom).mas_offset(18.f);
        make.left.right.equalTo(self.mainView);
        make.height.equalTo(@44);
    }];
    
    [self.view layoutIfNeeded];
    [nextBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100),HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    self.nextBtn = nextBtn;
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nextBtn.mas_bottom).offset(20);
    }];
}

- (void)nextBtnAction:(UIButton *)btn {
    
    if (![CommHelp IsBankCard:[self.bankCardNoView getTFText]]) {
        [self.view makeToast:@"请输入正确的银行卡号"duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.bankCardOpenView getTFText].length >= 30) {
        [self.view makeToast:@"请输入正确的开户行" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.bankCardIphoneNoView.getTFText length] != 11) {
        [self.view makeToast:@"请输入正确的手机号" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (!self.bankCardVerificationCodeView.isClickVerificationCodeBtn) {
        [self.view makeToast:@"请发送验证码" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (![self.checkBoxProtocolView getCheckBoxSelectStatus]) {
        [self.view makeToast:@"请查看支付服务协议" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    NSDictionary *par = @{
        @"page_position":@"addBindCard"
    };
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickNext"
                                          params:par
                                            type:JHStatisticsTypeSensors];
    
    NSDictionary *par1 = @{
        @"page_position":@"checkBindCardInfo"
    };
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickAgreeBindCard"
                                          params:par1
                                            type:JHStatisticsTypeSensors];
    [self addBackCardRequest];
    
}

/**
 添加银行卡 请求
 */
- (void)addBackCardRequest {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:[self.bankCardNoView.getTFText stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"accountNo"];
    // self.bankCardTypeView.getTFText
    // 默认储蓄卡
    [parameters setValue:@(self.cardType==0?1:self.cardType) forKey:@"accountType"];
    [parameters setValue:self.bankCardOpenView.getTFText forKey:@"bankBranch"];
    [parameters setValue:self.bankCardIphoneNoView.getTFText forKey:@"accountPhone"];
    [parameters setValue:self.bankCardVerificationCodeView.getTFText forKey:@"validateCode"];
    [parameters setValue:@(0) forKey:@"isPublicAccount"];
    // 商户需要传
    [parameters setValue:@"" forKey:@"bankUnionNumber"];
    [parameters setValue:@"" forKey:@"authorizationFile"];
    
    NSString *url = FILE_BASE_STRING(@"/app/bank/addBank");
    [SVProgressHUD show];
    @weakify(self)
    [HttpRequestTool postWithURL:url Parameters:parameters requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [SVProgressHUD dismiss];
        if (respondObject.code == 1000) {
            [self.navigationController pushViewController:[JHAddOCKBankCardSuccessViewController new] animated:YES];
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}

/**
 银行卡校验卡类型 请求
 */
- (void)backCardTypeRequest {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:[self.bankCardNoView.getTFText stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"cardNo"];
    NSString *url = FILE_BASE_STRING(@"/app/bank/valida");
    @weakify(self)
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        NSDictionary *dic = respondObject.data;
        if (respondObject.code == 1000) {
            self.cardType = [[dic valueForKey:@"cardType"] intValue];
            self.bankCardTypeView.getTF.text = (self.cardType == 1) ? @"储蓄卡":@"其它";
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}

-(void)sendVerificationCode:(UIButton *)btn {
    
    NSDictionary *parameters = @{ @"accountPhone":[self.bankCardIphoneNoView getTFText]
    };
    [SVProgressHUD show];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/bank/sendValidateCode") Parameters:parameters requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"发送成功" duration:1.0 position:CSToastPositionCenter];
        // 验证码获取第一响应
        [self.bankCardVerificationCodeView.getTF becomeFirstResponder];
        [self.bankCardVerificationCodeView countDown:btn];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    [self.view endEditing:YES];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIView *)idCardView {
    if (!_idCardView) {
        _idCardView = [[UIView alloc] init];
        [_idCardView jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFFF6F6F6),HEXCOLOR(0xFFFFFFFF)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
        _idCardView.layer.borderWidth = 0.5;
        _idCardView.layer.borderColor = HEXCOLOR(0xFFDDDDDD).CGColor;
        _idCardView.layer.cornerRadius = 5;
        
        UIImageView *idCardIcon = [[UIImageView alloc] init];
        //        idCardIcon.backgroundColor = UIColor.redColor;
        idCardIcon.image = [UIImage imageNamed:@"icon_bank_card_tip"];
        [self.idCardView addSubview:idCardIcon];
        
        [idCardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.idCardView);
            make.left.mas_equalTo(10.f);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        UILabel *idCardNamelabel = [[UILabel alloc] init];
        idCardNamelabel.text = @"持卡人：";
        idCardNamelabel.numberOfLines = 1;
        idCardNamelabel.textAlignment = NSTextAlignmentLeft;
        idCardNamelabel.lineBreakMode = NSLineBreakByWordWrapping;
        idCardNamelabel.font = [UIFont boldSystemFontOfSize:16.f];
        idCardNamelabel.textColor = HEXCOLOR(0xFF333333);
        self.idCardNamelabel = idCardNamelabel;
        [self.idCardView addSubview:idCardNamelabel];
        [idCardNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12.f);
            make.left.mas_equalTo(idCardIcon.mas_right).mas_offset(12.f);
        }];
        
        UILabel *idCardSubTiplabel = [[UILabel alloc] init];
        idCardSubTiplabel.text = @"身份证号：";
        idCardSubTiplabel.numberOfLines = 1;
        idCardSubTiplabel.textAlignment = NSTextAlignmentLeft;
        idCardSubTiplabel.lineBreakMode = NSLineBreakByWordWrapping;
        idCardSubTiplabel.font = [UIFont systemFontOfSize:12.f];
        idCardSubTiplabel.textColor = HEXCOLOR(0xFF999999);
        self.idCardSubTiplabel = idCardSubTiplabel;
        [self.idCardView addSubview:idCardSubTiplabel];
        [idCardSubTiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-12.f);
            make.left.mas_equalTo(idCardNamelabel);
        }];
        
    }
    return _idCardView;
}

- (JHTopBottomLabelAndTFView *)bankCardNoView {
    if (!_bankCardNoView) {
        _bankCardNoView = [[JHTopBottomLabelAndTFView alloc] initWithLabel:@"卡号" TFPlaceHolder:@"请输入正确的储蓄卡号" TFText:@""];
        _bankCardNoView.keyboardType = UIKeyboardTypeNumberPad;
        _bankCardNoView.TFEnabled = YES;
        _bankCardNoView.isCutDisplay = YES;
        [_bankCardNoView setErrorTip:@"请输入正确的银行卡号"];
        [_bankCardNoView displayScanCodeBtn];
        @weakify(self)
        //        [_bankCardNoView setTfEditingChangedBlock:^(NSString * _Nonnull text) {
        //            @strongify(self)
        //
        //        }];
        
        [_bankCardNoView setTextFieldShouldReturnBlock:^Boolean(UITextField * _Nonnull textField) {
            @strongify(self)
            [self.bankCardOpenView.getTF becomeFirstResponder];
            return NO;
        }];
        
        [_bankCardNoView setTextFieldDidEndEditingBlock:^(UITextField * _Nonnull textField) {
            @strongify(self)
            if ([CommHelp IsBankCard:textField.text]) {
                [self.bankCardNoView errorLabelHidden:YES];
            }else {
                [self.bankCardNoView errorLabelHidden:NO];
            }
            
            if ([CommHelp IsBankCard:textField.text] &&
                [_bankCardTypeView getTFText].length > 0 &&
                [NSString inputCapitalAndNumLowercaseLetterChinese:[_bankCardOpenView getTFText]] &&
                [NSString validatePhoneNumbers:[_bankCardIphoneNoView getTFText]] &&
                ([NSString validateZeroNumbers:[_bankCardVerificationCodeView getTFText]] && [_bankCardVerificationCodeView getTFText].length == 4)  &&
                _bankCardVerificationCodeView.isClickVerificationCodeBtn) {
                self.nextBtn.alpha = 1.0;
                self.nextBtn.enabled = YES;
            }else {
                self.nextBtn.alpha = 0.5;
                self.nextBtn.enabled = NO;
            }
            
            [self backCardTypeRequest];
        }];
        
        [_bankCardNoView setTfScanCodeClickBlock:^(UIButton * _Nonnull btn) {
            //            NSLog(@"setTfScanCodeClickBlock");
            @strongify(self)
            [self.view endEditing:YES];
            [self canUserCamear];
        }];
    }
    return _bankCardNoView;
}

- (BOOL)canUserCamear {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [self pushLayer];
                }else {
                    [JHKeyWindow makeToast:@"您暂未授予相机权限，请在系统设置中开启" duration:1.0 position:CSToastPositionCenter];
                }
            });
        }];
        return NO;
    }
    else {
        [self pushLayer];
        return YES;
    }
    return YES;
}

- (void)pushLayer{
    JHIdentifyBankCardNumberLayer *layer = [[JHIdentifyBankCardNumberLayer alloc] init];
    [layer setIdentifyBankCardNumberLayerBlock:^(NSDictionary * _Nonnull dic) {
        self.bankCardNoView.getTF.text = [dic valueForKey:@"bankCardNumber"];
    }];
    [layer show];
}

- (JHTopBottomLabelAndTFView *)bankCardTypeView {
    if (!_bankCardTypeView) {
        _bankCardTypeView = [[JHTopBottomLabelAndTFView alloc] initWithLabel:@"卡类型" TFPlaceHolder:@"" TFText:@"储蓄卡"];
        _bankCardTypeView.keyboardType = UIKeyboardTypeNumberPad;
        _bankCardTypeView.TFEnabled = NO;
        @weakify(self)
        [_bankCardTypeView setTfEditingChangedBlock:^(NSString * _Nonnull text) {
            @strongify(self)
            if (text.length > 0 &&
                [CommHelp IsBankCard:[_bankCardNoView getTFText]] &&
                [NSString inputCapitalAndNumLowercaseLetterChinese:[_bankCardOpenView getTFText]] &&
                [NSString validatePhoneNumbers:[_bankCardIphoneNoView getTFText]] &&
                ([NSString validateZeroNumbers:[_bankCardVerificationCodeView getTFText]] && [_bankCardVerificationCodeView getTFText].length == 4)  &&
                _bankCardVerificationCodeView.isClickVerificationCodeBtn) {
                self.nextBtn.alpha = 1.0;
                self.nextBtn.enabled = YES;
            }else {
                self.nextBtn.alpha = 0.5;
                self.nextBtn.enabled = NO;
            }
        }];
    }
    return _bankCardTypeView;
}

- (JHTopBottomLabelAndTFView *)bankCardOpenView {
    if (!_bankCardOpenView) {
        _bankCardOpenView = [[JHTopBottomLabelAndTFView alloc] initWithLabel:@"开户行" TFPlaceHolder:@"请输入正确的开户行" TFText:@""];
        _bankCardOpenView.TFEnabled = YES;
        [_bankCardOpenView setErrorTip:@"请输入正确的开户行"];
        @weakify(self)
        [_bankCardOpenView setTfEditingChangedBlock:^(NSString * _Nonnull text) {
            @strongify(self)
            if ([NSString inputCapitalAndNumLowercaseLetterChinese:text] &&
                [CommHelp IsBankCard:[_bankCardNoView getTFText]] &&
                [_bankCardTypeView getTFText].length > 0 &&
                [NSString validatePhoneNumbers:[_bankCardIphoneNoView getTFText]] &&
                ([NSString validateZeroNumbers:[_bankCardVerificationCodeView getTFText]] && [_bankCardVerificationCodeView getTFText].length == 4)  &&
                _bankCardVerificationCodeView.isClickVerificationCodeBtn) {
                self.nextBtn.alpha = 1.0;
                self.nextBtn.enabled = YES;
            }else {
                self.nextBtn.alpha = 0.5;
                self.nextBtn.enabled = NO;
            }
        }];
        
        [_bankCardOpenView setTextFieldShouldChangeCharactersInRangeBlock:^Boolean(UITextField * _Nonnull textField, NSRange range, NSString * _Nonnull string) {
            if (textField.text.length > 29) {
                return NO;
            }
            
            if ([NSString onlyInputChineseCharacters:string] ||
                [NSString inputCapitalAndLowercaseLetter:string] ||
                [NSString isNineKeyBoard:string]) {
                return YES;
            }
            
            return NO;
        }];
        
        [_bankCardOpenView setTextFieldDidEndEditingBlock:^(UITextField * _Nonnull textField) {
            @strongify(self)
            if ([NSString inputCapitalAndNumLowercaseLetterChinese:textField.text]) {
                [self.bankCardOpenView errorLabelHidden:YES];
            }else {
                [self.bankCardOpenView errorLabelHidden:NO];
            }
        }];
        
        [_bankCardOpenView setTextFieldShouldReturnBlock:^Boolean(UITextField * _Nonnull textField) {
            @strongify(self)
            [self.bankCardIphoneNoView.getTF becomeFirstResponder];
            return NO;
        }];
    }
    return _bankCardOpenView;
}

- (JHTopBottomLabelAndTFView *)bankCardIphoneNoView {
    if (!_bankCardIphoneNoView) {
        _bankCardIphoneNoView = [[JHTopBottomLabelAndTFView alloc] initWithLabel:@"手机号" TFPlaceHolder:@"请输入银行预留的手机号" TFText:@""];
        [_bankCardIphoneNoView setErrorTip:@"请输入正确的手机号"];
        [_bankCardIphoneNoView displayIphoneNoTipBtn];
        _bankCardIphoneNoView.keyboardType = UIKeyboardTypeNumberPad;
        _bankCardIphoneNoView.TFEnabled = YES;
        _bankCardIphoneNoView.returnKeyType = UIReturnKeyDone;
        @weakify(self)
        //        [_bankCardIphoneNoView setTfEditingChangedBlock:^(NSString * _Nonnull text) {
        //            @strongify(self)
        //
        //        }];
        
        [_bankCardIphoneNoView setTfTipClickBlock:^(UIButton * _Nonnull btn) {
            CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"说明" andDesc:@"手机号为办理该银行卡时填写，若遗忘或修改，需联系银行处理哦～" cancleBtnTitle:@"知道了"];
            [alert addBackGroundTap];
            [alert show];
        }];
        
        [_bankCardIphoneNoView setTextFieldShouldChangeCharactersInRangeBlock:^Boolean(UITextField * _Nonnull textField, NSRange range, NSString * _Nonnull string) {
            if (textField.text.length > 10) {
                return NO;
            }
            
            if ([string isEqual:@"·"]) {
                return YES;
            }
            
            if (![NSString validateZeroNumbers:string]) {
                return NO;
            }
            
            return YES;
        }];
        
        [_bankCardIphoneNoView setTextFieldDidEndEditingBlock:^(UITextField * _Nonnull textField) {
            @strongify(self)
            if ([NSString validatePhoneNumbers:textField.text]) {
                [self.bankCardIphoneNoView errorLabelHidden:YES];
            }else {
                [self.bankCardIphoneNoView errorLabelHidden:NO];
            }
            
            if ([NSString validatePhoneNumbers:textField.text] &&
                [CommHelp IsBankCard:[_bankCardNoView getTFText]] &&
                [_bankCardTypeView getTFText].length > 0 &&
                [NSString inputCapitalAndNumLowercaseLetterChinese:[_bankCardOpenView getTFText]] &&
                ([NSString validateZeroNumbers:[_bankCardVerificationCodeView getTFText]] && [_bankCardVerificationCodeView getTFText].length == 4)  &&
                _bankCardVerificationCodeView.isClickVerificationCodeBtn) {
                self.nextBtn.alpha = 1.0;
                self.nextBtn.enabled = YES;
            }else {
                self.nextBtn.alpha = 0.5;
                self.nextBtn.enabled = NO;
            }
        }];
        
        [_bankCardIphoneNoView setTextFieldShouldReturnBlock:^Boolean(UITextField * _Nonnull textField) {
            [textField resignFirstResponder];
            return NO;
        }];
    }
    return _bankCardIphoneNoView;
}

- (JHTopBottomLabelAndTFView *)bankCardVerificationCodeView {
    if (!_bankCardVerificationCodeView) {
        _bankCardVerificationCodeView = [[JHTopBottomLabelAndTFView alloc] initWithLabel:@"验证码" TFPlaceHolder:@"请输入验证码" TFText:@""];
        [_bankCardVerificationCodeView setErrorTip:@"请输入正确的验证码"];
        _bankCardVerificationCodeView.keyboardType = UIKeyboardTypeNumberPad;
        _bankCardVerificationCodeView.TFEnabled = YES;
        _bankCardVerificationCodeView.returnKeyType = UIReturnKeyDone;
        [_bankCardVerificationCodeView displayVerificationCodeBtn];
        @weakify(self)
        [_bankCardVerificationCodeView setTfEditingChangedBlock:^(NSString * _Nonnull text) {
            @strongify(self)
            if (([NSString validateZeroNumbers:text] && text.length == 4) &&
                [CommHelp IsBankCard:[_bankCardNoView getTFText]] &&
                [_bankCardTypeView getTFText].length > 0 &&
                [NSString inputCapitalAndNumLowercaseLetterChinese:[_bankCardOpenView getTFText]] &&
                [NSString validatePhoneNumbers:[_bankCardIphoneNoView getTFText]] &&
                _bankCardVerificationCodeView.isClickVerificationCodeBtn) {
                self.nextBtn.alpha = 1.0;
                self.nextBtn.enabled = YES;
            }else {
                self.nextBtn.alpha = 0.5;
                self.nextBtn.enabled = NO;
            }
        }];
        
        [_bankCardVerificationCodeView setTfVerificationCodeClickBlock:^(UIButton * _Nonnull btn) {
            @strongify(self)
            
            if (![NSString validatePhoneNumbers:self.bankCardIphoneNoView.getTFText]) {
                [self.view makeToast:@"请输入正确的手机号" duration:1.0 position:CSToastPositionCenter];
                return;
            }
            
            [self sendVerificationCode:btn];
        }];
        
        [_bankCardVerificationCodeView setTextFieldShouldChangeCharactersInRangeBlock:^Boolean(UITextField * _Nonnull textField, NSRange range, NSString * _Nonnull string) {
            if (textField.text.length > 3) {
                return NO;
            }
            
            if (![NSString validateZeroNumbers:string]) {
                return NO;
            }
            
            return YES;
        }];
        
        [_bankCardVerificationCodeView setTextFieldDidEndEditingBlock:^(UITextField * _Nonnull textField) {
            @strongify(self)
            if ([NSString validateZeroNumbers:textField.text] && textField.text.length == 4) {
                [self.bankCardVerificationCodeView errorLabelHidden:YES];
            }else {
                [self.bankCardVerificationCodeView errorLabelHidden:NO];
            }
        
        }];
        
        [_bankCardVerificationCodeView setTextFieldShouldReturnBlock:^Boolean(UITextField * _Nonnull textField) {
            @strongify(self)
            [textField resignFirstResponder];
            [self nextBtnAction:nil];
            return NO;
        }];
    }
    return _bankCardVerificationCodeView;
}

- (JHCheckBoxProtocolView *)checkBoxProtocolView {
    if (!_checkBoxProtocolView) {
        _checkBoxProtocolView = [[JHCheckBoxProtocolView alloc] initWithSelImageName:@"icon_banck_card_protocol_select" normalImageName:@"order_stone_protocol_nomal" tipStr:@"查看" protocolStr:@"《支付服务协议》"];
        @weakify(self)
        [_checkBoxProtocolView setCheckBoxProtocolClickBlock:^{
            @strongify(self)
            NSDictionary *par = @{
                @"page_position":@"checkBindCardInfo"
            };
            
            [JHAllStatistics jh_allStatisticsWithEventId:@"clickAgreeBindCard"
                                                  params:par
                                                    type:JHStatisticsTypeSensors];
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = H5_BASE_STRING(@"/jianhuo/app/agreement/payServiceAgreement.html");
            [self.navigationController pushViewController:webView animated:YES];
        }];
    }
    return _checkBoxProtocolView;
}

@end
