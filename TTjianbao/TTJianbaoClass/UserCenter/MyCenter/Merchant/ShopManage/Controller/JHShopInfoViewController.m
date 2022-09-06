//
//  JHShopInfoViewController.m
//  TTjianbao
//
//  Created by lihui on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHShopInfoViewController.h"
#import "JHShopInfoHeaderTableCell.h"
#import "JHShopInfoListTableCell.h"
#import "UserInfoRequestManager.h"
#import "JHNewShopDetailInfoModel.h"
#import "NOSUpImageTool.h"
#import "SVProgressHUD.h"

@interface JHShopListInfo : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@end
@implementation JHShopListInfo
@end

@interface JHShopInfoViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <JHShopListInfo *>*listArray;
@property (nonatomic, strong) JHNewShopDetailInfoModel *shopModel;

@end

@implementation JHShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jhTitleLabel.text = @"店铺信息";
    [self configUI];
    [self loadData];
}

- (void)loadData {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/mall/shop/selfCenter") Parameters:@{@"sellerId":[NSNumber numberWithString:self.sellerId]} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHNewShopDetailInfoModel *model = [JHNewShopDetailInfoModel mj_objectWithKeyValues:respondObject.data];
        self.shopModel = model;
        [self resolveData:model];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}

- (void)resolveData:(JHNewShopDetailInfoModel *)model {
    _listArray = [NSMutableArray array];
    NSArray *titles = @[@"店铺头像", @"店铺名称", @"经营性质", @"基础店铺主营类目"];
    for (int i = 0; i < titles.count; i ++) {
        JHShopListInfo *info = [[JHShopListInfo alloc] init];
        info.title = titles[i];
        info.desc = [self businiessNature:i shopInfo:model];
        [_listArray addObject:info];
    }
    [self.tableView reloadData];
}

- (NSString *)businiessNature:(NSInteger)index shopInfo:(JHNewShopDetailInfoModel *)model {
    switch (index) {
        case 0:
            return [UserInfoRequestManager sharedInstance].user.icon;
            break;
        case 1:
            return model.shopName;
            break;
        case 2:
        {
            if (model.sellerType == JHUserAuthTypePersonal) {
                return @"个人店铺";
            }
            if (model.sellerType == JHUserAuthTypeCommonBunsiness ||
                model.sellerType == JHUserAuthTypeIndividualBunsiness) {
                return @"企业店铺";
            }
            return @"未认证";
        }
            break;
        case 3:
        {
            NSMutableArray *arr = [NSMutableArray array];
            for (JHNewShopBusinessCategory *cate in model.backCateResponses) {
                [arr addObject:cate.cateName];
            }
            return arr.count > 0 ? [arr componentsJoinedByString:@"-"] : @"";
        }
            break;
        default:
            return @"未认证";
            break;
    }
}

- (void)configUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = HEXCOLOR(0xF8F8F8);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavView.mas_bottom);
        make.bottom.left.right.mas_equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHShopListInfo *info = _listArray[indexPath.row];
    if (indexPath.row == 0) {
        ///头像
        JHShopInfoHeaderTableCell *cell = [JHShopInfoHeaderTableCell dequeueReusableCellWithTableView:tableView];
        [cell title:info.title desc:info.desc];
        return cell;
    }
    
    JHShopInfoListTableCell *cell = [JHShopInfoListTableCell dequeueReusableCellWithTableView:tableView];
    [cell title:info.title desc:info.desc];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [sheet showInView:self.view];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return  [JHShopInfoHeaderTableCell cellHeight];
    }
    return [JHShopInfoListTableCell cellHeight];
}

//相册、相机调用方法
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"点击了从手机选择");
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.modalPresentationStyle  = UIModalPresentationCustom;
        [self dismissViewControllerAnimated:NO completion:nil];
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }else if (buttonIndex == 1){
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
        }else{
            NSLog(@"模拟无效,请真机测试");
        }
    }
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        viewController.navigationController.navigationBar.translucent = NO;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    NOSFormData *data = [[NOSFormData alloc]init];
    data.fileImage = image;
    data.fileDir = @"user";
    
    [SVProgressHUD show];
    @weakify(self);
    [[NOSUpImageTool getInstance] upImageWithformData:data successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [self modifyImageWithUrl:respondObject.data];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}

- (void)modifyImageWithUrl:(NSString *)url {
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
