//
//  JHBankPayInfoViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHBankPayInfoViewController.h"
#import "JHBankPayView.h"
#import "HKClipperHelper.h"
#import "NOSUpImageTool.h"
#import "NTESAudienceLiveViewController.h"
#import "JHOrderListViewController.h"
#import "WXPayDataMode.h"
#import "JHC2CProductDetailController.h"


@interface JHBankPayInfoViewController ()<JHBankPayViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    JHBankPayView * orderView;
    BankPayDataMode * bankPayMode;
}
@property(strong,nonatomic)UIImage * photoImg;
@property(strong,nonatomic)NSString * photoString;
@end
@implementation JHBankPayInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self initToolsBar];
//    [self.navbar setTitle:@"银行卡支付"];
    self.title = @"银行卡支付";
//     [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self  initContentView];
    [self requestInfo];
}

-(void)initContentView{
    
    orderView=[[JHBankPayView alloc]init];
    orderView.delegate=self;
    [self.view addSubview:orderView];
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        
    }];
}
-(void)requestInfo{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/payway/ydbank")  Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD dismiss];
        bankPayMode=[BankPayDataMode mj_objectWithKeyValues: respondObject.data];
        [orderView setBankPayMode:bankPayMode];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    [SVProgressHUD show];
}
#pragma mark =============== addPhoto ===============
-(void)addPhoto{
    
    [HKClipperHelper shareManager].nav = self.navigationController;
    [HKClipperHelper shareManager].clippedImgSize = CGSizeMake(ScreenW, ScreenW*14./15.);
    [HKClipperHelper shareManager].clipperType = ClipperTypeImgMove;
    [HKClipperHelper shareManager].systemEditing = NO;
    [HKClipperHelper shareManager].isSystemType = YES;
    MJWeakSelf
    [HKClipperHelper shareManager].clippedImageHandler = ^(UIImage *image) {
        
        weakSelf.photoImg=image;
        [weakSelf UploadImage];
    };
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
    
}
-(void)UploadImage{
    
    NOSFormData * data=[[NOSFormData alloc]init];
    data.fileImage=self.photoImg;
    data.fileDir=@"pay_cert";
    
    JH_WEAK(self)
    [[NOSUpImageTool getInstance] upImageWithformData:data successBlock:^(RequestModel *respondObject) {
        JH_STRONG(self)
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        self.photoString=respondObject.data;
        [orderView setButtonImage:self.photoImg];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD show];
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
    
    [SVProgressHUD show];
}

-(void)Complete:(NSString*)bankCode{
    
    if ([self.photoString length]==0) {
        
      [self.view makeToast:@"请添加转账凭证" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    NSDictionary *parameters=@{
                                @"orderId":self.orderId,
                                @"payAccountNo":bankCode,
                                 @"certUrl":self.photoString,
                                };
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/order/bankTransfer") Parameters:parameters isEncryption:YES  requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
     [JHGrowingIO trackOrderEventId:JHTrackorder_pay_result_weixin orderCode:self.orderCode payWay:@"xianxiadakuan" suc:@"true"];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提交成功" message:@"请耐心等待平台确认到账，需1-2个工作日" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BOOL  isPop=NO;
            for (UIViewController* vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass: [NTESAudienceLiveViewController  class]]) {
                    isPop=YES;
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
            for (UIViewController* vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass: [JHOrderListViewController class]]) {
                    isPop=YES;
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
            for (UIViewController* vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass: [JHC2CProductDetailController class]]) {
                    isPop=YES;
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }

            if (!isPop) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }]];
        [self presentViewController:alertVc animated:YES completion:nil];
       
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
    
    
}
//相册、相机调用方法
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[HKClipperHelper shareManager] photoWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else if(buttonIndex == 0) {
        [[HKClipperHelper shareManager] photoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
}


//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info

{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

