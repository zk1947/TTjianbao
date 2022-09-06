//
//  JHQRViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/2/13.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHQRViewController.h"
#import "WSLScanView.h"
#import "WSLNativeScanTool.h"


#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define StatusBarAndUI.navBarHeighteight (iPhoneX ? 88.f : 64.f)

@interface JHQRViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)  WSLNativeScanTool * scanTool;
@property (nonatomic, strong)  WSLScanView * scanView;
@property(nonatomic, assign)SystemSoundID soundID;

@end

@implementation JHQRViewController
- (void)dealloc {
    AudioServicesDisposeSystemSoundID(_soundID);
    NSLog(@"%@*************被释放",[self class])
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self  initToolsBar];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"scanSuccess" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &_soundID);
    
    self.title = self.titleString; //背景颜色不一致
    [self initRightButtonWithName:@"相册" action:@selector(photoBtnClicked)];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
//    [self.navbar setTitle:self.titleString];
//    self.navbar.ImageView.hidden = YES;
//    self.view.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
//    
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    

//    [self.navbar addrightBtn:@"相册" withImage:nil withHImage:nil withFrame:CGRectMake(ScreenW - 80, 0, 80, 44)];
//    [self.navbar.rightBtn addTarget:self action:@selector(photoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    
    //输出流视图
    UIView *preview  = [[UIView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, self.view.frame.size.width, self.view.frame.size.height - UI.statusAndNavBarHeight)];
    [self.view addSubview:preview];
    
    __weak typeof(self) weakSelf = self;
    
    //构建扫描样式视图
    _scanView = [[WSLScanView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, self.view.frame.size.width, self.view.frame.size.height - UI.statusAndNavBarHeight)];
    _scanView.scanRetangleRect = CGRectMake(10, 120+UI.bottomSafeAreaHeight, (self.view.frame.size.width - 20),  (self.view.frame.size.width - 20)/2.);
    _scanView.colorAngle = [UIColor greenColor];
    _scanView.photoframeAngleW = 20;
    _scanView.photoframeAngleH = 20;
    _scanView.photoframeLineW = 2;
    _scanView.isNeedShowRetangle = YES;
    _scanView.colorRetangleLine = [UIColor whiteColor];
    _scanView.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _scanView.animationImage = [UIImage imageNamed:@"scanLine"];
    _scanView.myQRCodeBlock = ^{

    };
    
    _scanView.flashSwitchBlock = ^(BOOL open) {
        [weakSelf.scanTool openFlashSwitch:open];
    };
    [self.view addSubview:_scanView];
    
    //初始化扫描工具
    _scanTool = [[WSLNativeScanTool alloc] initWithPreview:preview andScanFrame:_scanView.scanRetangleRect];
    _scanTool.scanFinishedBlock = ^(NSString *scanString) {
        NSLog(@"扫描结果 %@",scanString);
//        [weakSelf.scanView handlingResultsOfScan];
        [weakSelf.scanTool sessionStopRunning];
//        [weakSelf.scanTool openFlashSwitch:NO];
        AudioServicesPlaySystemSound(weakSelf.soundID);

        
        if (weakSelf.scanFinish) {
            weakSelf.scanFinish(scanString, weakSelf);
        }
    };
    _scanTool.monitorLightBlock = ^(float brightness) {
        NSLog(@"环境光感 ： %f",brightness);
        if (brightness < 0) {
            // 环境太暗，显示闪光灯开关按钮
            [weakSelf.scanView showFlashSwitch:YES];
        }else if(brightness > 0){
            // 环境亮度可以,且闪光灯处于关闭状态时，隐藏闪光灯开关
            if(!weakSelf.scanTool.flashOpen){
                [weakSelf.scanView showFlashSwitch:NO];
            }
        }
    };
    
    [_scanTool sessionStartRunning];
    [_scanView startScanAnimation];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_scanView startScanAnimation];
    [_scanTool sessionStartRunning];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_scanView stopScanAnimation];
    [_scanView finishedHandle];
    [_scanView showFlashSwitch:NO];
    [_scanTool sessionStopRunning];
}
#pragma mark -- Events Handle
- (void)photoBtnClicked{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController * _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }else{
        NSLog(@"不支持访问相册");
    }
}
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message handler:(void (^) (UIAlertAction *action))handler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handler];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
    [self dismissViewControllerAnimated:YES completion:nil];
    [_scanTool scanImageQRCode:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        viewController.navigationController.navigationBar.translucent = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reStartDevice {
    [self.scanTool sessionStartRunning];
}

- (void)showHud {
    [SVProgressHUD show];
}

- (void)dismissHud {
    [SVProgressHUD dismiss];
}
@end

