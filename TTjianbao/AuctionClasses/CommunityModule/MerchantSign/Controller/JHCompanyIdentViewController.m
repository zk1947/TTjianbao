//
//  JHCompanyIdentViewController.m
//  TTjianbao
//
//  Created by apple on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHCompanyIdentViewController.h"
#import "JHCustomTextField.h"
#import "JHUploadImgView.h"
#import "JHUploadManager.h"
#import "JHWebViewController.h"
#import "JHSignViewController.h"
#import "UIImage+JHCompressImage.h"
#import "NSString+AES.h"
#import "NSObject+JHTools.h"
#import "CommHelp.h"

@interface JHCompanyIdentViewController () <JHUploadImgViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, strong) JHCustomTextField *companyNameField;
@property (nonatomic, strong) JHCustomTextField *identNumberField;
@property (nonatomic, strong) JHCustomTextField *legalPersonField;
@property (nonatomic, strong) JHCustomTextField *legalNumberField;

@property (nonatomic, strong) JHUploadImgView *uploadBottomView;
@property (nonatomic, strong) UIImage *selectImage;


@end

NSString *const companyNamePlaceholder = @"请输入企业名称";
NSString *const codeNumberPlaceholder = @"统一社会信用代码";
NSString *const legalNamePlaceholder = @"企业法人或经营者";
NSString *const legalNumberPlaceholder = @"法人身份证号";


@implementation JHCompanyIdentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF8F8F8);
    [self configNav];
    [self initUI];
}

- (void)initUI {
    UIView *backgroundView = [[UIView alloc] init];
       
    UIView *textFieldView = [[UIView alloc] init];
    textFieldView.backgroundColor = [UIColor whiteColor];

    _companyNameField = [[JHCustomTextField alloc] initWithLeftWith:130];
    _companyNameField.leftText = @"企业名称";
    _companyNameField.placeholder = companyNamePlaceholder;
    _companyNameField.showBottomLine = YES;

    _identNumberField = [[JHCustomTextField alloc] initWithLeftWith:130];
    _identNumberField.leftText = @"统一社会信用代码";
    _identNumberField.placeholder = codeNumberPlaceholder;
    _identNumberField.showBottomLine = YES;

    _legalPersonField = [[JHCustomTextField alloc] initWithLeftWith:130];
    _legalPersonField.leftText = @"企业法人/经营者";
    _legalPersonField.placeholder = legalNamePlaceholder;
    _legalPersonField.showBottomLine = YES;

    _legalNumberField = [[JHCustomTextField alloc] initWithLeftWith:130];
    _legalNumberField.leftText = @"法人身份证号";
    _legalNumberField.placeholder = legalNumberPlaceholder;
    _legalNumberField.showBottomLine = NO;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(commitData) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"提交认证" forState:UIControlStateNormal];
    btn.backgroundColor = HEXCOLOR(0xFEE100);
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _commitButton = btn;

    UIButton *preLookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [preLookButton addTarget:self action:@selector(watchProtocolFile) forControlEvents:UIControlEventTouchUpInside];
    [preLookButton setTitle:@"预览协议范本" forState:UIControlStateNormal];
    [preLookButton setTitleColor:HEXCOLOR(0x235E96) forState:UIControlStateNormal];
    preLookButton.titleLabel.font = [UIFont fontWithName:kFontBoldPingFang size:13];

    ///添加副本的界面
    _uploadBottomView = [[JHUploadImgView alloc] init];
    _uploadBottomView.backgroundColor = [UIColor whiteColor];
    _uploadBottomView.delegate = self;
    _uploadBottomView.title = @"添加营业执照副本";
    _uploadBottomView.addImageName = @"icon_add_image";
    _uploadBottomView.alertString = @"上传营业执照副本图片";
    _uploadBottomView.bottomAlertString = @"*要求三证合一，否则无法通过";
    _uploadBottomView.clipCorner = YES;

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:backgroundView];
    [backgroundView addSubview:textFieldView];
    [textFieldView addSubview:_companyNameField];
    [textFieldView addSubview:_identNumberField];
    [textFieldView addSubview:_legalPersonField];
    [textFieldView addSubview:_legalNumberField];
    [backgroundView addSubview:_uploadBottomView];
    [backgroundView addSubview:_commitButton];
    [backgroundView addSubview:preLookButton];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
    }];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).with.offset(15);
        make.right.equalTo(backgroundView).with.offset(-15);
        make.top.equalTo(backgroundView).with.offset(16);
        make.height.equalTo(@(47*4));
    }];

    [_companyNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textFieldView).with.offset(15);
        make.right.equalTo(textFieldView).with.offset(-15);
        make.top.equalTo(textFieldView);
        make.height.equalTo(@47);
    }];

    [_identNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.companyNameField.mas_bottom);
        make.left.right.height.equalTo(self.companyNameField);
    }];

    [_legalPersonField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.identNumberField.mas_bottom);
        make.left.right.height.equalTo(self.companyNameField);
    }];

    [_legalNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.legalPersonField.mas_bottom);
        make.left.right.height.equalTo(self.companyNameField);
    }];

    [_uploadBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(textFieldView);
        make.top.equalTo(textFieldView.mas_bottom).with.offset(19);
        make.height.equalTo(@280);
    }];

    [_commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).with.offset(15);
        make.right.equalTo(backgroundView).with.offset(-15);
        make.top.equalTo(self.uploadBottomView.mas_bottom).with.offset(61);
        make.bottom.equalTo(backgroundView).with.offset(-(UI.bottomSafeAreaHeight + 77));
        make.height.equalTo(@44);
    }];

    [preLookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commitButton.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.commitButton);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];

    [self.view layoutIfNeeded];
    textFieldView.layer.cornerRadius = 4.f;
    textFieldView.layer.masksToBounds = YES;
    _commitButton.layer.cornerRadius = _commitButton.height/2.f;
    _commitButton.layer.masksToBounds = YES;
}

- (void)showPhotoView:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationController.navigationBar.translucent = YES;
    picker.delegate = self;
    //设置拍照后的图片可被编辑
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

///选择图片上传的api
- (void)uploadImage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
            [self showPhotoView:sourceType];
        }
        else {
            NSLog(@"模拟器");
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            [self showPhotoView:sourceType];
        }else {
            NSLog(@"模拟器");
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cancelSelect {
    self.uploadBottomView.selectImageView.image = nil;
    self.uploadBottomView.isSelected = NO;
    self.selectImage = nil;
}

#pragma mark imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (!image) {
        return;
    }
    
    self.uploadBottomView.selectImageView.image = image;
    self.uploadBottomView.isSelected = YES;
    self.selectImage = image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.uploadBottomView.isSelected = self.selectImage ? YES : NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)commitData {
    if (!(_companyNameField && _companyNameField.text.length)) {
        [UITipView showTipStr:@"请输入企业名称"];
        return;
    }
    if (!(_identNumberField && _identNumberField.text.length)) {
        [UITipView showTipStr:@"请输入企业统一信用代码"];
        return;
    }
    if (!(_legalPersonField && _legalPersonField.text.length)) {
        [UITipView showTipStr:@"请输入法人/经营人名称"];
       return;
    }
    if (![CommHelp judgeIdentityStringValid:_legalNumberField.text]) {
        [UITipView showTipStr:@"请输入正确的身份证号"];
        return;
    }
    ///先将图片上传至阿里云 然后拿获取到的图片地址传递到服务器
    @weakify(self);
    ///图片限制最大500k
    [SVProgressHUD show];
    UIImage *compressImage = [self.selectImage compressedImageFiles:self.selectImage imageMaxSizeKB:500];
    [[JHUploadManager shareInstance] uploadSingleImage:compressImage filePath:kJHAiyunCertificationPath finishBlock:^(BOOL isFinished, NSString * _Nonnull imgKey) {
//        NSLog(@"imgKey:--- %@", imgKey);
        @strongify(self);
        if (isFinished) {
            ///图片上传成功  将相关信息上传至server
            dispatch_async(dispatch_get_main_queue(), ^{
                [self submmitToServer:imgKey];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [UITipView showTipStr:@"图片上传失败，请重试"];
            });
        }
    }];
}

- (void) submmitToServer:(NSString *)imageURL {
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/contract/orgCreate");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_companyNameField.text forKey:@"name"];    ///企业名称
    [params setValue:_identNumberField.text forKey:@"orgno"];   ///组织代码
    [params setValue:_legalPersonField.text forKey:@"lname"];   ///法人
    [params setValue:_legalNumberField.text forKey:@"lcard"];   ///法人证件号
    [params setValue:imageURL forKey:@"pic"];                   ///营业执照副本
    
    NSString *paraJsonString = [NSObject convertJSONWithDic:params];
    NSString *paraMD5String = [paraJsonString aci_encryptAESWithKey:SIGN_AES_KEY iv:SIGN_AES_IV_KEY];
    NSLog(@"paraMD5String:---- %@  -  %@", paraMD5String, @{@"ept":paraMD5String});
    [HttpRequestTool postWithURL:url Parameters:@{@"ept":paraMD5String} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSLog(@"respondObject:--- %@\n%zd\n%@", respondObject.message,respondObject.code, respondObject.data);
        JHSignViewController *vc = [[JHSignViewController alloc] init];
        vc.checkStatus = JHCheckStatusChecking;  ///审核中
        [self.navigationController pushViewController:vc animated:YES];

    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSLog(@"respondObject:--- %@\n%zd\n%@", respondObject.message,respondObject.code, respondObject.data);
        [self toast:respondObject.message];
    }];
}

///查看协议范本
- (void)watchProtocolFile {
    JHWebViewController *webVC = [[JHWebViewController alloc] init];
    webVC.urlString = H5_BASE_STRING(@"/previewAgreementEE.html");
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)toast:(NSString *)message {
    NSString *toastString = message ? message : @"认证失败";
    [self.view makeToast:toastString duration:1.0 position:CSToastPositionCenter];
}

- (void)configNav {
//    [self initToolsBar];
    self.title = @"企业实名认证";
//    [self.navbar setTitle:@"企业实名认证"];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - lazy loading
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end
