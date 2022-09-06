//
//  JHUserAuthEnterpriseController.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUserAuthEnterpriseController.h"
#import "JHUserAuthEnterpriseHeader.h"
#import "JHUserAuthOtherCertTableCell.h"
#import "JHUserAuthInfoImageCell.h"
#import "JHUserAuthInfoCommitCell.h"
#import "JHUserAuthModel.h"
#import "UserInfoRequestManager.h"
#import "JHUploadManager.h"
#import "SVProgressHUD.h"
#import "JHPhotoBrowserManager.h"
#import "JHUserAuthAlertTableCell.h"

@interface JHUserAuthEnterpriseController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) id idCardFrontImg;
@property (nonatomic, strong) id idCardBackImg;
///营业执照
@property (nonatomic, strong) id certLicenseImage;
///其他营业执照
@property (nonatomic, strong) NSMutableArray *otherLicenseArray;
@end

@implementation JHUserAuthEnterpriseController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.authModel = [[JHUserAuthModel alloc] init];
        self.authModel.authType = JHUserAuthTypeIndividualBunsiness;
        self.authModel.authState = JHUserAuthStateUnCommit;
    }
    return self;
}

- (void)setAuthModel:(JHUserAuthModel *)authModel {
    _authModel = authModel;
    ///身份证正面
    if ([_authModel.idCardFrontImg isNotBlank]) {
        self.idCardFrontImg = _authModel.idCardFrontImg;
    }
    ///身份证反面
    if ([_authModel.idCardBackImg isNotBlank]) {
        self.idCardBackImg = _authModel.idCardBackImg;
    }
    ///营业执照
    if ([_authModel.businessLicense isNotBlank]) {
        self.certLicenseImage = _authModel.businessLicense;
    }
    ///其他营业执照
    if (_authModel.otherLicense && _authModel.otherLicense.count > 0) {
        for (NSString *str in _authModel.otherLicense) {
            [self.otherLicenseArray addObject:str];
        }
    }
}

- (NSMutableArray *)otherLicenseArray {
    if (!_otherLicenseArray) {
        _otherLicenseArray = [NSMutableArray array];
    }
    return _otherLicenseArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.jhNavView removeFromSuperview];
    [self configUI];
}

- (void)configUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.backgroundColor = APP_BACKGROUND_COLOR;
    tableView.tableFooterView = [UIView new];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    _mainTableView = tableView;
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark -
#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.authModel.authState == JHUserAuthStateChecking) {
        return 4;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == JHEnterpriseSectionTypeAuthState) {///审核状态的提示信息
        if ([self hasAuth] && self.authModel.authState != JHUserAuthStateUnCommit) {
            return 1;
        }
        return 0;
    }
    if (section == JHEnterpriseSectionTypeBusiness) {
        return 3;
    }
    if (section == JHEnterpriseSectionTypeOthers) {
        if(self.authModel && self.authModel.authState == JHUserAuthStateChecking && self.otherLicenseArray.count <= 0) {
                return 0;
            }
        ///没有认证默认是要显示其他执照的
        return 1;
    }
    if (section == JHEnterpriseSectionTypeSelectAuthType) {
        ///选择认证类型
        if (self.authModel.authState == JHUserAuthStateUnCommit) {
            return 1;
        }
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JHEnterpriseSectionTypeAuthState) {///审核状态的提示信息
        if ([self hasAuth] && self.authModel.authState != JHUserAuthStateUnCommit) {
            JHUserAuthAlertTableCell *cell = [JHUserAuthAlertTableCell dequeueReusableCellWithTableView:tableView];
            cell.authModel = self.authModel;
            return cell;
        }
        return [UITableViewCell new];
    }
    if (indexPath.section == JHEnterpriseSectionTypeSelectAuthType &&
        self.authModel.authState == JHUserAuthStateUnCommit) {
        ///选择认证类型
        JHUserAuthEnterpriseHeader *cell = [JHUserAuthEnterpriseHeader dequeueReusableCellWithTableView:tableView];
        @weakify(self);
        cell.actionBlock = ^(JHUserAuthType authType) {
            @strongify(self);
            self.authModel.authType = authType;
        };
        return cell;
    }
    if (indexPath.section == JHEnterpriseSectionTypeBusiness) {
        JHUserAuthInfoImageCell *cell = [JHUserAuthInfoImageCell dequeueReusableCellWithTableView:tableView];
        cell.indexPath = indexPath;
        cell.type = indexPath.row+2;
        cell.reCommit = (self.authModel.authState != JHUserAuthStateChecking);
        if (indexPath.row == 0 && self.idCardFrontImg != nil) {
            cell.uploadImage = self.idCardFrontImg;
        }
        if (indexPath.row == 1 && self.idCardBackImg != nil) {
            cell.uploadImage = self.idCardBackImg;
        }
        if (indexPath.row == 2 && self.certLicenseImage != nil) {
            cell.uploadImage = self.certLicenseImage;
        }
        @weakify(self);
        cell.clickBlock = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            self.currentIndexPath = indexPath;
            if ([self hasAuth] && self.authModel.authState == JHUserAuthStateChecking) {
                id image = [self showImage];
                if (image && [image isKindOfClass:[NSString class]]) {
                    JHUserAuthInfoImageCell *cell = (JHUserAuthInfoImageCell *)[tableView cellForRowAtIndexPath:self.currentIndexPath];
                    [JHPhotoBrowserManager showPhotoBrowserThumbImages:@[image] mediumImages:@[image] origImages:@[image] sources:@[cell.leftImageView] currentIndex:0 canPreviewOrigImage:NO showStyle:GKPhotoBrowserShowStyleZoom];
                }
            }
            else {
                [self showImagePicker];
            }
        };
        return cell;
    }
    if (indexPath.section == JHEnterpriseSectionTypeOthers) {
        JHUserAuthOtherCertTableCell *cell = [JHUserAuthOtherCertTableCell dequeueReusableCellWithTableView:tableView];
        cell.authModel = self.authModel;
        cell.certImageArray = self.otherLicenseArray;
        @weakify(self);
        @weakify(cell);
        cell.updateBlock = ^ {
            @strongify(self);
            @strongify(cell);
            self.otherLicenseArray = cell.certImageArray;
            [self.mainTableView reloadData];
        };
        return cell;
    }
    JHUserAuthInfoCommitCell *cell = [JHUserAuthInfoCommitCell dequeueReusableCellWithTableView:tableView];
    cell.authState = self.authModel.authState;
    @weakify(self);
    cell.commitBlock = ^{
        @strongify(self);
        [self toCommitAuthInfo];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JHEnterpriseSectionTypeAuthState) {///审核状态的提示信息
        if ([self hasAuth] && self.authModel.authState != JHUserAuthStateUnCommit) {
            return UITableViewAutomaticDimension;
        }
        return CGFLOAT_MIN;
    }
    if (indexPath.section == JHEnterpriseSectionTypeSelectAuthType) {///选择认证类型
        if (self.authModel.authState == JHUserAuthStateUnCommit) {
            return [JHUserAuthEnterpriseHeader headerHeight];
        }
        return CGFLOAT_MIN;
    }
    if (indexPath.section == JHEnterpriseSectionTypeBusiness) {
        return [JHUserAuthInfoImageCell cellHeight];
    }
    if (indexPath.section == JHEnterpriseSectionTypeOthers) {
        
        if(self.authModel && self.authModel.authState == JHUserAuthStateChecking && self.otherLicenseArray.count <= 0) {
                return CGFLOAT_MIN;
            }
        return UITableViewAutomaticDimension;
    }
    return [JHUserAuthInfoCommitCell cellHeight];
}

- (BOOL)hasAuth {
    if ([self.authModel.idCardFrontImg isNotBlank] &&
        [self.authModel.idCardBackImg isNotBlank] &&
        [self.authModel.businessLicense isNotBlank]) {
        return YES;
    }
    return NO;
}

- (id)showImage {
    switch (self.currentIndexPath.row) {
        case 0:
            return self.idCardFrontImg;
            break;
        case 1:
            return self.idCardBackImg;
            break;
        case 2:
            return self.certLicenseImage;
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)alertMessage {
    if (self.idCardFrontImg == nil && self.idCardBackImg == nil && self.certLicenseImage == nil) {
        return @"请先上传照片再提交";
    }
    if (self.idCardFrontImg == nil && self.idCardBackImg == nil) {
        return @"请先上传法人身份证人像面和国徽面再提交";
    }
    if (self.idCardFrontImg == nil) {
        return @"请先上传法人身份证人像面再提交";
    }
    if (self.idCardBackImg == nil) {
        return @"请先上传法人身份证国徽面再提交";
    }
    if (self.certLicenseImage == nil) {
        return @"请先上传营业执照副本再提交";
    }
    if (self.idCardFrontImg == nil && self.certLicenseImage == nil && self.idCardBackImg != nil) {
        return @"请先上传法人身份证人像面和营业执照副本再提交";
    }
    if (self.idCardFrontImg != nil && self.certLicenseImage == nil && self.idCardBackImg == nil) {
        return @"请先上传法人身份证国徽面和营业执照副本再提交";
    }
    return  @"";
}

- (void)toCommitAuthInfo {
    NSString * str = [self alertMessage];
    if ([str isNotBlank]) {
        [UITipView showTipStr:str];
        return;
    }
//    JHUserAuthOtherCertTableCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//    self.otherLicenseArray = [NSMutableArray arrayWithArray:cell.certImageArray.copy];
//    BOOL noModify = (self.otherLicenseArray.count > 0);
//    if (self.otherLicenseArray.count > 0) {
//        for (id obj in self.otherLicenseArray) {
//            if ([obj isKindOfClass:[UIImage class]]) {
//                noModify = NO;
//                break;
//            }
//        }
//    }
    if ([self.idCardFrontImg isKindOfClass:[NSString class]] &&
        [self.idCardBackImg isKindOfClass:[NSString class]] &&
        [self.certLicenseImage isKindOfClass:[NSString class]]) {
        [UITipView showTipStr:@"请选择您重新上传的资质信息"];
        return;
    }
    
    [SVProgressHUD show];
    ///需要将图片先上传到阿里云
    dispatch_group_t group = dispatch_group_create();

    @weakify(self);
    if ([self.idCardFrontImg isKindOfClass:[UIImage class]]) {
        dispatch_group_enter(group);
        [[JHUploadManager shareInstance] uploadSingleImage:self.idCardFrontImg filePath:kJHAiyunRoomAnchorPath finishBlock:^(BOOL isFinished, NSString * _Nonnull imgKey) {
            @strongify(self);
            self.authModel.idCardFrontImg = imgKey;
            dispatch_group_leave(group);
        }];
    }
    if ([self.idCardBackImg isKindOfClass:[UIImage class]]) {
        dispatch_group_enter(group);
        [[JHUploadManager shareInstance] uploadSingleImage:self.idCardBackImg filePath:kJHAiyunRoomAnchorPath finishBlock:^(BOOL isFinished, NSString * _Nonnull imgKey) {
            @strongify(self);
            self.authModel.idCardBackImg = imgKey;
            dispatch_group_leave(group);
        }];
    }
    if ([self.certLicenseImage isKindOfClass:[UIImage class]]) {
        dispatch_group_enter(group);
        [[JHUploadManager shareInstance] uploadSingleImage:self.certLicenseImage filePath:kJHAiyunRoomAnchorPath finishBlock:^(BOOL isFinished, NSString * _Nonnull imgKey) {
            @strongify(self);
            self.authModel.businessLicense = imgKey;
            dispatch_group_leave(group);
        }];
    }
    
    ///其他执照
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *urlArray = [NSMutableArray array];
    for (id obj in self.otherLicenseArray) {
        if ([obj isKindOfClass:[UIImage class]]) {
            [arr addObject:obj];
        }
        else if([obj isKindOfClass:[NSString class]]) {
            [urlArray addObject:obj];
        }
    }
    if (arr.count > 0) {
        dispatch_group_enter(group);
        [[JHUploadManager shareInstance] uploadImage:arr uploadProgress:^(CGFloat progress) {
        } finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
            [urlArray addObjectsFromArray:imgKeys];
            self.authModel.otherLicense = urlArray;
            dispatch_group_leave(group);
        }];
    }
    else {
        self.authModel.otherLicense = urlArray;
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        @strongify(self);
        [self sendAuthInfoToServe];
    });
}
- (void)dealloc {
    NSLog(@"");
}
//- (JHUserAuthEnterpriseHeader *)header {
//    if (!_header) {
//        _header = [[JHUserAuthEnterpriseHeader alloc] initWithFrame:CGRectMake(0, 0, ScreenW, [JHUserAuthEnterpriseHeader headerHeight])];
//        @weakify(self);
//        _header.actionBlock = ^(JHUserAuthType authType) {
//            @strongify(self);
//            self.authModel.authType = authType;
//        };
//    }
//    return _header;
//}

- (void)sendAuthInfoToServe {
    if (self.authModel.authState == JHUserAuthStatePassed ||
        self.authModel.authState == JHUserAuthStateUnPassed) {
        ///通过和不通过 重新提交
        [JHUserAuthModel reCommitAuthInfoToServe:self.authModel completeBlock:^(id  _Nullable respObj, BOOL hasError) {
            [SVProgressHUD dismiss];
            if (!hasError) {
                [UITipView showTipStr:@"提交成功"];
                [JHRootController.currentViewController.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else {
        [JHUserAuthModel commitAuthInfoToServe:self.authModel completeBlock:^(id  _Nullable respObj, BOOL hasError) {
            [SVProgressHUD dismiss];
            if (!hasError) {
                [UITipView showTipStr:@"提交成功"];
                [JHRootController.currentViewController.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

#pragma mark - 吊起相机相册相关
- (void)showImagePicker {
    ///点击了点击上传的item 需要吊起选择图片
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
     [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self selectPictureFromAblum];
     }]];
     [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self selectPictureFromCamera];
     }]];
     
     [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     }]];
     [JHRootController.currentViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - //相册、相机调用方法
- (void)selectPictureFromCamera {
    NSLog(@"点击了拍照");
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [JHRootController.currentViewController dismissViewControllerAnimated:NO completion:nil];
        [JHRootController.currentViewController presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"模拟无效,请真机测试");
    }
}

- (void)selectPictureFromAblum
{
    NSLog(@"点击了从手机选择");
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.modalPresentationStyle  = UIModalPresentationCustom;
    [JHRootController.currentViewController dismissViewControllerAnimated:NO completion:nil];
    [JHRootController.currentViewController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        viewController.navigationController.navigationBar.translucent = NO;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (self.currentIndexPath.row == 0) {
        ///身份证正面照片
        self.idCardFrontImg = image;
    }
    if (self.currentIndexPath.row == 1) {
        ///身份证正面照片
        self.idCardBackImg = image;
    }
    if (self.currentIndexPath.row == 2) {
        ///身份证正面照片
        self.certLicenseImage = image;
    }

    [self.mainTableView reloadData];
}


@end
