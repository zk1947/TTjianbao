//
//  JHUnionSignView.m
//  TTjianbao
//
//  Created by apple on 2020/4/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUnionSignView.h"
#import "UserInfoRequestManager.h"
#import "JHWebViewController.h"
#import "SVProgressHUD.h"

#define signButtonHeight 93

@implementation JHUnionSignAlertView

-(void)dealloc
{
    NSLog(@"🔥JHUnionSignAlertView");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.6);
    }
    return self;
}

+ (JHUnionSignAlertView *)creatUnionSignAlertViewWithStatus:(JHUnionSignStatus)status{
    
    UIView *alertSuperView = [UIApplication sharedApplication].keyWindow;
    
    JHUnionSignAlertView *alertView = [[JHUnionSignAlertView alloc]initWithFrame:alertSuperView.bounds];
    [alertSuperView addSubview:alertView];
    
    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:alertView];
    [whiteView jh_cornerRadius:4];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(alertView);
        make.size.mas_equalTo(CGSizeMake(260, 147));
    }];
    
    NSString *title = @"";
    
    switch (status) {
            
        case JHUnionSignStatusUnSign:{
            title = JHLocalizedString(@"unSignTitle");
        }
            break;
            
        case JHUnionSignStatusReviewing:{
            title = JHLocalizedString(@"checkingTitle");
        }
            break;
            
        case JHUnionSignStatusFail:{
            title = JHLocalizedString(@"unPassCheckTitle");
        }
            break;
        default:{
            title = JHLocalizedString(@"unSignTitle");
        }
            break;
    }
    UILabel *titleLabel = [UILabel jh_labelWithText:title font:15 textColor:RGB(51, 51, 51) textAlignment:1 addToSuperView:whiteView];
    titleLabel.numberOfLines = 0;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView).offset(24.f);
        make.left.equalTo(whiteView).offset(25.f);
        make.right.equalTo(whiteView).offset(-25.f);
    }];
    
    UIButton *cancleButton = [UIButton jh_buttonWithTarget:alertView action:@selector(cancleAction) addToSuperView:whiteView];
    [cancleButton jh_cornerRadius:20.f];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.bottom.equalTo(whiteView).offset(-21);
    }];
    if(status == JHUnionSignStatusReviewing){
        
        cancleButton.jh_backgroundColor(RGB(254, 225, 0)).jh_title(JHLocalizedString(@"iKnow")).jh_font(JHLightFont(15)).jh_titleColor(RGB(51, 51, 51));
        [cancleButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(120);
            make.centerX.equalTo(whiteView);
        }];
    }
    else if (status == JHUnionSignStatusFail || status == JHUnionSignStatusUnSign || status == JHUnionSignStatusWaitAuth){
        cancleButton.jh_title(JHLocalizedString(@"cancel")).jh_font(JHLightFont(15)).jh_titleColor(RGB(51, 51, 51));
        [cancleButton jh_cornerRadius:20 borderColor:RGB(204, 204, 204) borderWidth:1];
        
        [cancleButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.left.equalTo(whiteView).offset(30);
        }];
        NSString *buttonTitle = (status == JHUnionSignStatusFail ? JHLocalizedString(@"resign") : JHLocalizedString(@"goToSign"));
        UIButton *signButton = [UIButton jh_buttonWithTitle:buttonTitle fontSize:15 textColor:RGB(51, 51, 51) target:alertView action:@selector(signAction) addToSuperView:whiteView];
        [signButton jh_cornerRadius:20.f];
        signButton.backgroundColor = RGB(254, 225, 0);
        [signButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.bottom.equalTo(cancleButton);
            make.right.equalTo(whiteView).offset(-20);
        }];
    }
    else{
        cancleButton.jh_backgroundColor(RGB(254, 225, 0)).jh_title(JHLocalizedString(@"iKnow")).jh_font(JHLightFont(15)).jh_titleColor(RGB(51, 51, 51));
        [cancleButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(120);
            make.centerX.equalTo(whiteView);
        }];
    }
    return alertView;
}

-(void)cancleAction{
    
    [self removeFromSuperview];
}

- (void)signAction{
    [self cancleAction];
    [JHRouterManager pushSelectContractViewController];
}

@end


@interface JHUnionSignView ()

/// 状态
@property (nonatomic, assign) JHUnionSignStatus status;

/// 失败错误信息
@property (nonatomic, copy) NSString *errorMessage;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UIButton *signButton;

@end

@implementation JHUnionSignView

-(void)dealloc
{
    NSLog(@"🐧🐧🐧🐧🐧🐧🐧🐧🐧🐧");
}

+ (CGFloat)viewHeight{
    return 90.f;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleToFill;
        self.backgroundColor = UIColor.clearColor;
        self.userInteractionEnabled = YES;
        [self addSelfSubViews];
    }
    return self;
}

- (void)addSelfSubViews{
    
    _signButton = [UIButton jh_buttonWithTarget:self action:@selector(signButtonAction) addToSuperView:self];
    
    [_signButton setBackgroundImage:JHImageNamed(@"my_center_sign_2") forState:UIControlStateNormal];
    [_signButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    
    [_signButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [_signButton setBackgroundImage:JHImageNamed(@"my_center_sign_1") forState:(UIControlStateSelected)];
    _signButton.titleLabel.font = JHLightFont(12);
    [_signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(signButtonHeight, 36));
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
    }];

    _titleLabel = [UILabel jh_labelWithBoldFont:14 textColor:UIColor.blackColor addToSuperView:self];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(21);
        make.right.equalTo(self.signButton.mas_left).offset(-10);
    }];
    
    _descLabel = [UILabel jh_labelWithBoldFont:12 textColor:RGB(153, 153, 153) addToSuperView:self];
    _descLabel.adjustsFontSizeToFitWidth = YES;
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.bottom.equalTo(self).offset(-25.f);
    }];
    
    self.status = JHUnionSignStatusUnSign;
    
    @weakify(self);
    [RACObserve([UserInfoRequestManager sharedInstance], unionSignStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.status = [x integerValue];
    }];
}

-(void)setIsOrange:(BOOL)isOrange{
    _isOrange = isOrange;
    [self setStatus:self.status];
    if (!_isOrange) {
        [self jh_updateLayouts];
    }
}

- (void)jh_updateLayouts {
    [_signButton setBackgroundImage:JHImageNamed(@"") forState:(UIControlStateNormal)];
    [_signButton setBackgroundImage:JHImageNamed(@"") forState:(UIControlStateSelected)];
    _signButton.backgroundColor = kColorMain;
    [_signButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(signButtonHeight, 30));
    }];
    [_signButton layoutIfNeeded];
    _signButton.layer.cornerRadius = _signButton.height/2.f;
    _signButton.layer.masksToBounds = YES;

    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
    }];
    [_descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
    }];
}

- (void)setStatus:(JHUnionSignStatus)status{
    if (_isOrange) {
        self.image = JHImageNamed(@"my_center_union_sign_bg_1");
    }
    
    self.signButton.selected = _isOrange;
    
    NSString *buttonTitle = JHLocalizedString(@"goToSign");
    NSString *title = JHLocalizedString(@"saleRelax_crashQuickly");
    NSString *desc = JHLocalizedString(@"unionPay_defaultTip");
    _status = status;
    switch (_status) {
        case JHUnionSignStatusUnSign:
        {
            if(_isOrange)
            {
                title = JHLocalizedString(@"finishSignQuickly");
            }
        }
        break;
        
        case JHUnionSignStatusSigning:
        {
            buttonTitle = JHLocalizedString(@"signing");
            if(_isOrange)
            {
                title = JHLocalizedString(@"finishSignQuickly");
            }
        }
        break;
            
        case JHUnionSignStatusReviewing:
        {
            buttonTitle = JHLocalizedString(@"checking");
            title = JHLocalizedString(@"checkingTitle");
            desc = JHLocalizedString(@"checkingDesc");
        }
        break;
            
        case JHUnionSignStatusFail:
        {
            buttonTitle = JHLocalizedString(@"resign");
            title = JHLocalizedString(@"checkingFailResign");
            NSString *message = [UserInfoRequestManager sharedInstance].unionSignFailReason;
            if([message isNotBlank] && ![message containsString:@"null"]){
                desc = message;
            }
            else {
                desc = @"";
            }
        }
        break;
            
        default:
            break;
    }
    
    [_signButton setTitle:buttonTitle forState:(UIControlStateNormal)];
    
    _titleLabel.text = title;
    
    _descLabel.text = desc;
    
}
#pragma mark --------------- action ---------------
- (void)forbidButtonTapRepet {
    self.signButton.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.signButton.enabled = YES;
    });
}

- (void)signButtonAction{
    ///防止按钮被连续点击多次
    [self forbidButtonTapRepet];
    [JHUnionSignView signMethod];
}

+ (void)signMethod
{
    if (![JHRootController isLogin]){
        [JHRootController presentLoginVC];
        return;
    }
    
    [JHUnionSignView getUnionSignStatusWithCustomerId:nil statusBlock:^(JHUnionSignStatus status) {
        if(status == JHUnionSignStatusSigning) {
            //签约中
            JHWebViewController *vc = [[JHWebViewController alloc] init];
            vc.titleString = JHLocalizedString(@"signContractTitle");
            vc.urlString = [UserInfoRequestManager sharedInstance].unionSignRequestInfoUrl;
            [JHRouterManager.jh_getViewController.navigationController pushViewController:vc animated:YES];
        }
        else if(status == JHUnionSignStatusUnSign ||
                status == JHUnionSignStatusWaitAuth ||
                status == JHUnionSignStatusFail) {
            [JHRouterManager pushSelectContractViewController];
        }
        else { ///审核中
            [JHUnionSignAlertView creatUnionSignAlertViewWithStatus:status];
        }
    }];
}

+ (void)getUnionSignStatusWithCustomerId:(NSString *)customerId statusBlock:(nullable void (^)(JHUnionSignStatus))statusBlock
{
    
    BOOL isSelf = NO;
    if(!customerId)
    {
        isSelf = YES;
        customerId = [UserInfoRequestManager sharedInstance].user.customerId;
    }
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/signContract/signContract/auth/querySignContract") Parameters:@{@"customerId" : customerId} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        NSDictionary *dic = respondObject.data;
        if(IS_DICTIONARY(dic)){
            JHUnionSignStatus status = (NSInteger)[[dic valueForKey:@"status"] integerValue];

           
            if(isSelf){    
                [UserInfoRequestManager sharedInstance].unionSignStatus = status;
                [UserInfoRequestManager sharedInstance].unionSignFailReason = OBJ_TO_STRING([dic valueForKey:@"failReason"]);
                [UserInfoRequestManager sharedInstance].unionSignIsShow = ([UserInfoRequestManager sharedInstance].unionSignStatus != JHUnionSignStatusComplete);
                [UserInfoRequestManager sharedInstance].unionSignRequestInfoUrl = dic[@"requestInfoUrl"];
            }
            
            if(statusBlock){
                statusBlock(status);
            }
                       
        }
        else{
            if(isSelf){
                [UserInfoRequestManager sharedInstance].unionSignIsShow = YES;
            }
            
            [SVProgressHUD showInfoWithStatus:respondObject.message];
        }
    } failureBlock:^(RequestModel *respondObject) {
//        [SVProgressHUD showInfoWithStatus:respondObject.message];
        if(isSelf){
            [UserInfoRequestManager sharedInstance].unionSignIsShow = YES;
        }
    }];
}


@end





