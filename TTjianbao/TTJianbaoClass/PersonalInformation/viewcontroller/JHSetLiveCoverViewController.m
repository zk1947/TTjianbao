//
//  JHSetLiveCoverViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/23.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "JHSetLiveCoverViewController.h"
#import "JHCoverView.h"
#import "HttpUpImageTool.h"
#import "HKClipperHelper.h"
#import "JHCoverModel.h"
#import "NOSUpImageTool.h"


@interface JHSetLiveCoverViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate,JHCoverViewDelegate>
{
      JHCoverView * coverView;
    
}
@property (strong, nonatomic) NSMutableArray *dataList;
@property (nonatomic, strong) JHCoverModel *selectedModel;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (strong, nonatomic) UIImage *coverImg;
@end

@implementation JHSetLiveCoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initToolsBar];
//    [self.navbar setTitle:@"封面设置"];
    self.title = @"封面设置"; //背景颜色不一致
//    self.view.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self initContentView];
    [self requestData];
    
}

-(void)initContentView{
    
    coverView=[[JHCoverView alloc]init];
    coverView.delegate=self;
    [self.view addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
        make.left.right.equalTo(self.view);
        
    }];
}
- (void)requestData {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/channelImg") Parameters:nil successBlock:^(RequestModel *respondObject) {
       
         [SVProgressHUD dismiss];
          self.dataList=[NSMutableArray arrayWithCapacity:10];
          self.dataList = [JHCoverModel mj_objectArrayWithKeyValuesArray:respondObject.data];
           [coverView setPhotos:self.dataList];
       
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
    
     [SVProgressHUD show];
}

-(void)deletePhoto:(JHCoverModel*)mode{
    
    if (mode) {
        
        [HttpRequestTool deleteWithURL:FILE_BASE_STRING(@"/auth/channelImg") Parameters:@{@"imgId":mode.Id} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
           
            [SVProgressHUD dismiss];
            [self.dataList removeObject:mode];
            [coverView setPhotos:self.dataList];
             [self.view makeToast:@"删除成功" duration:1.0 position:CSToastPositionCenter];
            
        } failureBlock:^(RequestModel *respondObject) {
            
            [SVProgressHUD showErrorWithStatus:respondObject.message];
        }];
    }
    
    [SVProgressHUD show];
}

-(void)addPhoto{
    
    [HKClipperHelper shareManager].nav = self.navigationController;
    [HKClipperHelper shareManager].clippedImgSize = CGSizeMake(ScreenW, ScreenW*14./15.);
    
    [HKClipperHelper shareManager].clipperType = ClipperTypeImgMove;
    [HKClipperHelper shareManager].systemEditing = NO;
    [HKClipperHelper shareManager].isSystemType = YES;
    MJWeakSelf
    [HKClipperHelper shareManager].clippedImageHandler = ^(UIImage *image) {
        
        weakSelf.coverImg = image;
        [weakSelf UploadImage];
    };
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
    
}
-(void)UploadImage{

    NOSFormData * data=[[NOSFormData alloc]init];
    data.fileImage=_coverImg;
    data.fileDir=@"channel_img";

    JH_WEAK(self)
    [[NOSUpImageTool getInstance] upImageWithformData:data successBlock:^(RequestModel *respondObject) {
        JH_STRONG(self)
        [self subitImageFilePath:respondObject.data];
        
    } failureBlock:^(RequestModel *respondObject) {

        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];

     [SVProgressHUD show];
}
-(void)subitImageFilePath:(NSString*)filePath{
    
    [HttpRequestTool postWithURL:[FILE_BASE_STRING(@"/auth/channelImg?coverImgUrl=") stringByAppendingString:OBJ_TO_STRING(filePath)]  Parameters:nil requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:@"上传成功" duration:1.0 position:CSToastPositionCenter];
        [self requestData];
        
    } failureBlock:^(RequestModel *respondObject) {
        
           [SVProgressHUD showErrorWithStatus:respondObject.message];
        
    }];
      [SVProgressHUD show];
}
-(void)photoImageSelect:(JHCoverModel*)mode{
    
    self.selectedModel=mode;
    
}
-(void)Complete{
    
    if (self.selectedModel) {
        [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/auth/channelImg") Parameters:@{@"imgId":self.selectedModel.Id} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            
            self.selectedModel=nil;
            [self requestData];
            [self.view makeToast:@"设置成功" duration:1.0 position:CSToastPositionCenter];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failureBlock:^(RequestModel *respondObject) {
            
             [SVProgressHUD showErrorWithStatus:respondObject.message];
        }];
           [SVProgressHUD show];
        
    }
    
    else{
        
         [self.view makeToast:@"请选择一张封面" duration:1.0 position:CSToastPositionCenter];
        
    }
   
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

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    
    UIImage *image = info[UIImagePickerControllerEditedImage];

    _coverImg = image;
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
- (void)dealloc
{
   
    
}
@end
