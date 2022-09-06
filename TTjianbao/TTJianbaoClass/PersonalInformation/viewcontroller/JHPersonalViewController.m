//
//  JHPersonalViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHPersonalViewController.h"
#import "NIMAvatarImageView.h"
#import "JHMyTableViewCell.h"
#import "JHEditViewController.h"
#import "AdressManagerViewController.h"
#import "AlterPhoneNumberViewController.h"
#import "NOSUpImageTool.h"
#import "JHUnionSignShowHomeController.h"
#import "TTjianbaoBussiness.h"
#import "JHUnionPayManager.h"
#import "UIImageView+JHWebImage.h"
#import "JHBankCardManagerViewController.h"
#import "JHRealNameAuthenticationViewController.h"
#import "CommAlertView.h"
#import "JHAllStatistics.h"
#import "JHWebViewController.h"
#import "UserInfoRequestManager.h"
#import "JHChatBlackListViewController.h"

@interface JHPersonalViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *desArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footorView;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation JHPersonalViewController
- (void)dealloc {
    NSLog(@"%@*************被释放",[self class])
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 背景颜色不一致
    self.title = @"个人信息";
    [self makeUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)makeUI {
    self.navigationItem.title = @"个人信息";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
    }];
    self.tableView.tableFooterView = self.footorView;
}

#pragma mark - GET

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHMyTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"JHMyTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
        
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataArray[indexPath.row] isEqualToString:@""])
    {
        if (indexPath.row == 0) {
            return 1;
        }
        return 10;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHMyTableViewCell"];
    if ([self.dataArray[indexPath.row] isEqualToString:@""]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.desLabel.hidden = YES;
        cell.rightArrow.hidden = YES;
        cell.headImage.hidden = YES;
        
    }else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.desLabel.hidden = NO;
//        cell.desLabel.backgroundColor = UIColor.redColor;
        cell.rightArrow.hidden = NO;
        cell.headImage.hidden = YES;
        if (indexPath.row == 1) {
            cell.headImage.hidden = NO;
            cell.desLabel.hidden = YES;
            [cell.headImage jhSetImageWithURL:[NSURL URLWithString:self.desArray[indexPath.row]] placeholder:kDefaultAvatarImage];
        }else {
            cell.desLabel.text = self.desArray[indexPath.row];
        }
    }
    cell.titleDesLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)showRealNameAlertView {
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"实名认证" andDesc:@"为了提现账号安全，请先进行实名认证" cancleBtnTitle:@"去认证"];
    [alert dealTitleToCenter];
    @weakify(self)
    [alert setCancleHandle:^{
        @strongify(self)
        JHRealNameAuthenticationViewController *vc = [[JHRealNameAuthenticationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [alert setDesFont: [UIFont systemFontOfSize:13.f]];
    [alert addCloseBtn];
    [alert addBackGroundTap];
    [alert show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *par = @{
        @"page_position":@"myinfo"
    };
    if ([self.dataArray[indexPath.row] isEqual:@"实名认证"]) {
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickCertification"
                                                  params:par
                                                    type:JHStatisticsTypeSensors];
        JHRealNameAuthenticationViewController *vc = [[JHRealNameAuthenticationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    User *user = [UserInfoRequestManager sharedInstance].user;
    if ([self.dataArray[indexPath.row] isEqual:@"银行卡管理"] ) {
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickBankCardManage"
                                                  params:par
                                                    type:JHStatisticsTypeSensors];
       
        if (user.authType == JHUserAuthTypeCommonBunsiness &&
            user.isBindBank.intValue == 0) {  // 是企业账号并且没有绑定过卡。
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = H5_BASE_STRING(@"/jianhuo/app/recycle/tiedCard.html");
            [self.navigationController pushViewController:webView animated:YES];
            return;
        }
        
        if (user.authType != JHUserAuthTypeCommonBunsiness &&
            user.isFaceAuth.intValue == 0) {
            [self showRealNameAlertView];
            return;
        }
        
        JHBankCardManagerViewController *vc = [[JHBankCardManagerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    /**
     [self.dataArray addObject:@""];
     [self.dataArray addObject:@"头像"];
     [self.dataArray addObject:@"昵称"];
     [self.dataArray addObject:@""];
     [self.dataArray addObject:@"手机号"];
     [self.dataArray addObject:@"微信"];
     [self.dataArray addObject:@"我的收货地址"];
     if ([UserInfoRequestManager sharedInstance].unionSignStatus == JHUnionSignStatusComplete) {
         [self.dataArray addObject:@""];
         [self.dataArray addObject:@"银联商务签约"];
     }
     
     if (user.authType != JHUserAuthTypeCommonBunsiness) {
         [self.dataArray addObject:@"实名认证"];
     }
     [self.dataArray addObject:@"银行卡管理"];
     
     [self.dataArray addObject:@""];
     [self.dataArray addObject:@"注销账号"];
     [self.dataArray addObject:@""];
     [self.dataArray addObject:@"黑名单"];
     */
    
    
    if ([self.dataArray[indexPath.row] isEqual:@"头像"]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [sheet showInView:self.view];
        return;
    }
    
    if ([self.dataArray[indexPath.row] isEqual:@"昵称"]) {
        JHEditViewController *vc = [[JHEditViewController alloc] init];
        vc.nickname = self.desArray[2];
        vc.navigationItem.title = @"修改昵称";
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([self.dataArray[indexPath.row] isEqual:@"手机号"]) {
        AlterPhoneNumberViewController *vc = [[AlterPhoneNumberViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([self.dataArray[indexPath.row] isEqual:@"微信"]) {
        JH_WEAK(self)
        [JHRootController bindWxWithSource:@"1" block:^{
            [[UserInfoRequestManager sharedInstance] getUserInfoSuccess:^(RequestModel *respondObject) {
                JH_STRONG(self)
                [self loadData];
            }];
        }];
        return;
    }
    
    if ([self.dataArray[indexPath.row] isEqual:@"我的收货地址"]) {
        AdressManagerViewController *vc = [[AdressManagerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([self.dataArray[indexPath.row] isEqual:@"银联商务签约"]) {
        [self.navigationController pushViewController:[JHUnionSignShowHomeController new] animated:YES];
        return;
    }
    
    if ([self.dataArray[indexPath.row] isEqual:@"注销账号"]) {
        JHWebViewController *webView = [[JHWebViewController alloc] init];
        webView.urlString = H5_BASE_STRING(@"/jianhuo/app/accountCancellation/accountCancellation.html");
        [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
        return;
    }
    
    if ([self.dataArray[indexPath.row] isEqual:@"黑名单"]) {
        [self.navigationController pushViewController:[JHChatBlackListViewController new] animated:YES];
        return;
    }
    
//    switch (indexPath.row) {
//            
//        case 1:{
//            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
//            sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//            [sheet showInView:self.view];
//        }
//            break;
//        case 2:{
//            
//            JHEditViewController *vc = [[JHEditViewController alloc] init];
//            vc.nickname = self.desArray[2];
//            vc.navigationItem.title = @"修改昵称";
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
//            
//            
//        case 4:{
//            AlterPhoneNumberViewController *vc = [[AlterPhoneNumberViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        }
//            break;
//            
//        case 5:{
//            
//            JH_WEAK(self)
//            [JHRootController bindWx:^{
//                [[UserInfoRequestManager sharedInstance] getUserInfoSuccess:^(RequestModel *respondObject) {
//                    JH_STRONG(self)
//                    [self loadData];
//                }];
//                
//            }];
//        }
//            break;
//            
//        case 6:{
//            AdressManagerViewController *vc = [[AdressManagerViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            
//            break;
//            
//            
//        case 8:{
//            [self.navigationController pushViewController:[JHUnionSignShowHomeController new] animated:YES];
//        }
//            
//            break;
//        
//        case 10:{
//            /// 注销账号
//            JHWebViewController *webView = [[JHWebViewController alloc] init];
//            webView.urlString = H5_BASE_STRING(@"/jianhuo/app/accountCancellation/accountCancellation.html");
//            [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
//        }
//            break;
//            
//        case 12:{
//            [self.navigationController pushViewController:[JHChatBlackListViewController new] animated:YES];
//        }
//            
//            break;
//        default:
//            break;
//    }
}

- (void)requestData {
    
    
}

- (void)dealDataWithDic:(NSArray *)array {
    
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];
}

- (void)loadData {
    [SVProgressHUD show];
    @weakify(self);
    [[UserInfoRequestManager sharedInstance] getUserInfoSuccess:^(RequestModel * _Nullable respondObject) {
        @strongify(self);
        [SVProgressHUD dismiss];
        [self loadLocalData];
    } failure:^(RequestModel * _Nullable respondObject) {
        @strongify(self);
        [SVProgressHUD dismiss];
        [self loadLocalData];
    }];
}

- (void)loadLocalData {
    
    [self.dataArray removeAllObjects];
    [self.desArray removeAllObjects];
    
    User *user = [UserInfoRequestManager sharedInstance].user;
    [self.dataArray addObject:@""];
    [self.dataArray addObject:@"头像"];
    [self.dataArray addObject:@"昵称"];
    [self.dataArray addObject:@""];
    [self.dataArray addObject:@"手机号"];
    [self.dataArray addObject:@"微信"];
    [self.dataArray addObject:@"我的收货地址"];
    if ([UserInfoRequestManager sharedInstance].unionSignStatus == JHUnionSignStatusComplete) {
        [self.dataArray addObject:@""];
        [self.dataArray addObject:@"银联商务签约"];
    }
    
    if (user.authType != JHUserAuthTypeCommonBunsiness) {
        [self.dataArray addObject:@"实名认证"];
    }
    [self.dataArray addObject:@"银行卡管理"];
    
    [self.dataArray addObject:@""];
    [self.dataArray addObject:@"注销账号"];
    [self.dataArray addObject:@""];
    [self.dataArray addObject:@"黑名单"];
    
    [self.desArray addObject:@""];
    [self.desArray addObject:user.icon?:@""];
    [self.desArray addObject:user.name?:@""];
    [self.desArray addObject:@""];
    [self.desArray addObject:user.mobile?:@""];
    [self.desArray addObject:user.bindThird==1?@"已绑定":@"未绑定"];
    if ([UserInfoRequestManager sharedInstance].unionSignStatus == JHUnionSignStatusComplete) {
        [self.desArray addObject:@""];
        [self.desArray addObject:@""];
    }
   
    [self.desArray addObject:@""];
    if (user.authType != JHUserAuthTypeCommonBunsiness) {
        [self.desArray addObject:user.isFaceAuth.intValue ==1 ? @"已认证":@"未认证"];
    }
    [self.desArray addObject:user.isBindBank.intValue ==1 ? @"已绑定":@"未绑定"];
    [self.desArray addObject:@""];
    [self.tableView reloadData];
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)desArray {
    if (_desArray == nil) {
        _desArray = [NSMutableArray array];
    }
    return _desArray;
}


//相册、相机调用方法
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"点击了从手机选择");
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.modalPresentationStyle  = UIModalPresentationCustom;
        [self dismissViewControllerAnimated:NO completion:nil];
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else if (buttonIndex == 1){
        NSLog(@"点击了拍照");
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            
            picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self dismissViewControllerAnimated:NO completion:nil];
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            NSLog(@"模拟无效,请真机测试");
        }
    }
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
        viewController.navigationController.navigationBar.translucent = NO;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NOSFormData *data = [[NOSFormData alloc]init];
    data.fileImage = image;
    data.fileDir = @"user";
    
    JH_WEAK(self)
    [[NOSUpImageTool getInstance] upImageWithformData:data successBlock:^(RequestModel *respondObject) {
        JH_STRONG(self)
        [self modifyImageWithUrl:respondObject.data];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
    
    [SVProgressHUD show];
}

- (void)modifyImageWithUrl:(NSString *)url {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUserHeadUpdated object:nil];
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/auth/customer/customer") Parameters:@{@"image":url} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [UserInfoRequestManager sharedInstance].user.icon = url;
        [self loadData];
         
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        [SVProgressHUD showSuccessWithStatus:respondObject.message];
        
    }];
    
}

@end
