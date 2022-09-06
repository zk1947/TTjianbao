//
//  NTESLDMainViewController.m
//  NTESLiveDetectPublicDemo
//
//  Created by Ke Xu on 2019/10/11.
//  Copyright © 2019 Ke Xu. All rights reserved.
//

#import "NTESLDMainViewController.h"
#import "JHRealNameAuthenticationSuccessViewController.h"
#import <NTESLiveDetect/NTESLiveDetect.h>
#import "NTESLiveDetectView.h"
#import "LDDemoDefines.h"
#import "UIView+JHToast.h"
#import "NTESTimeoutToastView.h"
#import "NetworkReachability.h"
#import "SVProgressHUD.h"
#import "CommAlertView.h"

static NSOperationQueue *_queue;

@interface NTESLDMainViewController () <NTESLiveDetectViewDelegate>

//@property (nonatomic, strong) UIButton *voiceButton;
// 播放状态：是否要播放
@property (nonatomic, assign) BOOL shouldPlay;

@property (nonatomic, strong) NTESLiveDetectView *mainView;

@property (nonatomic, strong) NTESLiveDetectManager *detector;

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) NSDictionary *dictionary;

//@property (nonatomic, assign) CGFloat value; /// 屏幕亮度值
@property (nonatomic, copy) NSString *token;
@end

@implementation NTESLDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人脸验证";
   
    WeakSelf(self);
    [NetworkReachability AFNReachability:^(AFNetworkReachabilityStatus status) {
        [weakSelf replyLoading];
    }];
    
    self.shouldPlay = YES;
    [self __initVoiceButton];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.detector stopLiveDetect];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)__initVoiceButton {
    [self initRightButtonWithImageName:@"ico_voice_open" action:@selector(openVoiceButton:)];
}

- (void)openVoiceButton:(UIButton *)btn {
    self.shouldPlay = !self.shouldPlay;
    
    NSString *imageName = @"ico_voice_close";
    if (self.shouldPlay) {
        imageName = @"ico_voice_open";
    }
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)__initDetectorView {
    self.mainView = [[NTESLiveDetectView alloc] init];
    self.mainView.LDViewDelegate = self;
    [self.view addSubview:self.mainView];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(UI.statusAndNavBarHeight);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)__initDetector {
    self.detector = [[NTESLiveDetectManager alloc] initWithImageView:self.mainView.cameraImage withDetectSensit:NTESSensitNormal];
    [self startLiveDetect];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveDetectStatusChange:) name:@"NTESLDNotificationStatusChange" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)startLiveDetect {
    [self.mainView.activityIndicator startAnimating];
    [self.detector setTimeoutInterval:31.f];
    
    @weakify(self)
    [self.detector startLiveDetectWithBusinessID:@"48c5039bbe63482f84df7366582f494e" actionsHandler:^(NSDictionary * _Nonnull params) {
        @strongify(self)
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.mainView.activityIndicator stopAnimating];
             NSString *actions = [params objectForKey:@"actions"];
             if (actions && actions.length != 0) {
                 [self.mainView showActionTips:actions];
                 NSLog(@"动作序列：%@", actions);
             } else {
                 [self showToastWithQuickPassMsg:@"返回动作序列为空"];
             }
         });
    } completionHandler:^(NTESLDStatus status, NSDictionary * _Nullable params) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            self.params = params;
            [self showToastWithLiveDetectStatus:status];
        });
    }];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self backBarButtonPressed];
    [self stopLiveDetect];
}

- (void)stopLiveDetect {
    [self.detector stopLiveDetect];
}

- (void)liveDetectStatusChange:(NSNotification *)infoNotification {
    [self.mainView changeTipStatus:infoNotification.userInfo];
}

- (void)showToastWithLiveDetectStatus:(NTESLDStatus)status {
    NSString *msg = @"";
  
    if ([self.params isKindOfClass:[NSDictionary class]]) {
        self.token = [self.params objectForKey:@"token"];
    }
    
    switch (status) {
        case NTESLDCheckPass:
        {
            [self addRealNameRequest];
        }
            break;
        case NTESLDCheckNotPass:
            msg = @"活体检测不通过";
            [self showAlertViewWithTitle:@"提示" andContent:msg];
            break;
        case NTESLDOperationTimeout:
        {
            msg = @"请求超时，请稍后再试";
            [self showAlertViewWithTitle:@"提示" andContent:msg];
        }
            break;
        case NTESLDGetConfTimeout:
            msg = @"活体检测获取配置信息超时";
            [self showAlertViewWithTitle:@"提示" andContent:msg];
            break;
        case NTESLDOnlineCheckTimeout:
            msg = @"云端检测结果请求超时";
            [self showAlertViewWithTitle:@"提示" andContent:msg];
            break;
        case NTESLDOnlineUploadFailure:
            msg = @"云端检测上传图片失败";
            [self showAlertViewWithTitle:@"提示" andContent:msg];
            break;
        case NTESLDNonGateway:
            msg = @"网络未连接";
            [self showAlertViewWithTitle:@"提示" andContent:msg];
            break;
        case NTESLDSDKError:
            msg = @"SDK内部错误";
            [self showAlertViewWithTitle:@"提示" andContent:msg];
            break;
        default:
            msg = @"请求超时，请稍后再试";
            [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter];
            break;
    }
    
}

/**
 活体认证 请求
 */
- (void)addRealNameRequest {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:self.userName forKey:@"name"];
    [parameters setValue:self.userCardNo forKey:@"cardNo"];
    [parameters setValue:self.token forKey:@"token"];
     
    NSString *url = FILE_BASE_STRING(@"/app/customer/face/auth");
    [SVProgressHUD show];
    @weakify(self)
    [HttpRequestTool postWithURL:url Parameters:parameters requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [SVProgressHUD dismiss];
        NSDictionary *dic = respondObject.data;
        int status = [[dic valueForKey:@"status"] intValue];
        if (status == 1) { // 认证结果，0-待定 1-通过 2-不通过
            JHRealNameAuthenticationSuccessViewController *vc = [[JHRealNameAuthenticationSuccessViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [self showAlertViewWithTitle:@"提示" andContent:[self getErrorMsgWithStatus:[[dic valueForKey:@"reasonType"] intValue]]];
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithTitle:@"提示" andContent:respondObject.message];
    }];
}

- (NSString *)getErrorMsgWithStatus:(int)status {
    NSString *msg = @"请求超时 默认：请求超时，请稍后再试";
    if (status == 2) {
        msg = @"证件信息与人脸信息不符，请确认";
    }else if (status == 3){
        msg = @"姓名与身份证号不一致，请确认";
    }else if (status == 5){
        msg = @"检测超时，请稍后重试";
    }else if (status == 6){
        msg = @"未查到此证件信息，请确认";
    }else if (status == 7){
        msg = @"未查到此证件信息，请确认";
    }else if (status == 8){
        msg = @"证件信息与人脸信息不符，请确认";
    }
    return msg;
}

- (void)showAlertViewWithTitle:(NSString *)title andContent:(NSString *)content {
//    NTESTimeoutToastView *toastView = [[NTESTimeoutToastView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [toastView setTitle:title andContent:content];
//    toastView.delegate = self;
//    [toastView show];
    
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:title andDesc:content cancleBtnTitle:@"重新认证"];
    [alert addCloseBtn];
    [alert setDescTextAlignment:NSTextAlignmentCenter];
    @weakify(self)
    [alert  setCancleHandle:^{
        @strongify(self)
        [self backBarButtonPressed];
    }];
    [alert show];
}

- (void)showToastWithQuickPassMsg:(NSString *)msg {
    [self.view showAnimalToast:msg];
}

- (void)dealloc {
    NSLog(@"-----dealloc");
}

#pragma mark - view delegate
- (void)backBarButtonPressed {
    WeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        [[UIScreen mainScreen] setBrightness:weakSelf.value];
        if ([weakSelf.navigationController.topViewController isKindOfClass:[self class]]) {
           [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    });
}

- (void)playActionMusic:(AVAudioPlayer *)player {
    if (self.shouldPlay) {
        [player play];
    } else {
        [player stop];
    }
}

#pragma mark - NTESTimeoutToastViewDelegate
//- (void)retryButtonDidTipped:(UIButton *)sender {
//    [self replyLoading];
//}

- (void)replyLoading {
    [self stopLiveDetect];
    if (self.mainView) {
        [self.mainView removeFromSuperview];
    }
    self.mainView = nil;
    self.detector = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self __initDetectorView];
    [self __initDetector];
}

//- (void)backHomePageButtonDidTipped:(UIButton *)sender {
//
//}

@end

