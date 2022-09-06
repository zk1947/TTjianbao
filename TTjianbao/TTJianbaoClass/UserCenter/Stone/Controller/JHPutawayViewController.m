//
//  JHPutawayViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/12/2.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//
#import <GKPhotoBrowser/GKPhotoBrowser.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "JHPutawayViewController.h"
#import "JHUIFactory.h"
#import "JHAddResourceCollectionView.h"
#import "TZImagePickerController.h"
#import "JHNTESTextInputView.h"
#import "JHAiyunOSSManager.h"
#import "JHAnchorBreakPaperViewController.h"
#import "JHBackUpLoadManage.h"
#import "JHResaleStoneReeditModel.h"
#import <AVKit/AVKit.h>

@interface JHPutawayViewController ()<UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate, UIGestureRecognizerDelegate,NTESTextInputViewDelegate> {
    CGFloat cellWidth;
}
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) JHNTESTextInputView *textView;

@property (strong, nonatomic) JHAddResourceCollectionView *photosView;
@property (strong, nonatomic) JHAddResourceCollectionView *videosView;
@property (strong, nonatomic) UIView *backView1;
@property (strong, nonatomic) UIView *backView2;
@property (strong, nonatomic) UIView *backView3;
@property (strong, nonatomic) NSMutableArray<JHPublishSourceItemModel *> *allPhotos;

@property (strong, nonatomic) NSMutableArray<JHPublishSourceItemModel *> *allVideos;
@property (strong, nonatomic) JHTitleTextItemView *titleLabel;

@end

@implementation JHPutawayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(JHStoneEditTypeReqData == self.editType)
    {
        [self requestData];
    }
    self.allVideos = [NSMutableArray array];
    self.allPhotos = [NSMutableArray array];
    [self makeNav];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.jhNavView.mas_bottom).offset(1);
    }];
    
    self.contentView = [UIView new];
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.scrollView);
        make.width.equalTo(@(ScreenW));
//        make.height.equalTo(@(ScreenH));
    }];
    
    [self makeInputContentView];
    [self makeVideoView];
    [self makePictureView];

    [self takePhoto];
}

- (void)requestData
{
    JHResaleStoneReeditModel* reeditReq = [JHResaleStoneReeditModel new];
    JH_WEAK(self)
    [reeditReq requestReeditStoneId:self.stoneRestoreId response:^(JHResaleStoneReeditModel* respData, NSString *errorMsg) {
        JH_STRONG(self)
        self.titleLabel.textField.text = respData.goodsTitle;
        self.textView.textView.text = respData.goodsDesc;

        for (JHMediaModel *m in respData.urlList) {
            JHPublishSourceItemModel *obj = [JHPublishSourceItemModel new];
            obj.coverUrl = m.coverUrl;
            obj.sourceUrl = m.url;
            obj.image = m.coverUrl;
            obj.isNetwork = YES;
            obj.isVideo = (m.type == 2);
            if(m.type == 1){
                [self.allPhotos addObject:obj];
            }
            else{
                [self.allVideos addObject:obj];
            }
        }
        
        [self selfReloadCollection];
    }];
}

/// 图片视频资源 reload
- (void)selfReloadCollection {
    
        self.photosView.array = (NSMutableArray <JHPhotoItemModel *> *)self.allPhotos;
//        self.photosView.isShowAddCell = (self.allPhotos.count < 6);
        [self.photosView reloadData];
    
        self.videosView.array = (NSMutableArray <JHPhotoItemModel *> *)self.allVideos;
//        self.videosView.isShowAddCell = (self.allVideos.count < 1);
        [self.videosView reloadData];
}


- (void)makeNav
{
    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
//    [self initToolsBar];
//    [self.navbar setTitle:@"上架原石"];
    self.title = @"上架原石";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)makeInputContentView {
    UIView *backView = [UIView new];
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    self.backView1 = backView;
    JHTitleTextItemView *text1 = [[JHTitleTextItemView alloc] initWithTitle:@"标题 " textPlace:@"原石的场口、重量等" isEdit:YES isShowLine:YES];;
    [backView addSubview:text1];
    self.titleLabel = text1;
    
    JHTitleTextItemView *text2 =[[JHTitleTextItemView alloc] initWithTitle:@"内容 " textPlace:@"" isEdit:YES isShowLine:YES];
    [backView addSubview:text2];
    [text2 addSubview:self.textView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
    }];
    
    [text1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(backView);
        make.trailing.equalTo(backView);
        make.height.equalTo(@50);
        make.top.equalTo(backView);
    }];
    
    [text2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(backView);
        make.trailing.equalTo(backView);
        make.height.equalTo(@50);
        make.top.equalTo(text1.mas_bottom);
        make.bottom.equalTo(backView).offset(-10);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(text2.textField).offset(-10);
        make.leading.equalTo(text2.textField).offset(-15);

        make.top.trailing.equalTo(text2.textField).offset(10);
    }];
    
    [self.view layoutSubviews];
    
}

- (void)makeVideoView {
    
    UIView *backView = [UIView new];
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    self.backView2 = backView;
    
    JHPreTitleLabel *title = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0xFF4200) font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft preTitle:@"*"];
    [title setJHAttributedText:@"上传视频" font:[UIFont fontWithName:kFontNormal size:13] color:kColor333];
    [backView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(backView).offset(10);
        make.height.equalTo(@20);
        make.trailing.equalTo(backView).offset(-10);
    }];
    
    JH_WEAK(self)
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.videosView = [[JHAddResourceCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.videosView.addImage = @"img_add_video";
    self.videosView.addPicAction = ^(NSIndexPath *indexPath) {
        JH_STRONG(self)
        [self addAction:1];
    };
    self.videosView.didSelectedCell = ^(NSIndexPath *indexPath) {
        JH_STRONG(self)
        [self playVideo:indexPath];
    };
    self.videosView.deleteBlock = ^(NSIndexPath *indexPath) {
        JH_STRONG(self)
        [self showDeleteSheet:indexPath type:1];
    };
    [backView addSubview:self.videosView];
    
    cellWidth = (ScreenW-(15+15+20))/4.;
    [self.videosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(title);
        make.top.equalTo(title.mas_bottom).offset(10);
        make.bottom.equalTo(backView).offset(-10);
        make.height.equalTo(@(cellWidth));
    }];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backView1);
        make.top.equalTo(self.backView1.mas_bottom).offset(10);
    }];
}

- (void)makePictureView {
    UIView *backView = [UIView new];
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    self.backView3 = backView;
    
    UILabel *title = [JHUIFactory createLabelWithTitle:@"上传图片" titleColor:kColor333 font:[UIFont fontWithName:kFontNormal size:13] textAlignment:NSTextAlignmentLeft];
    [backView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(backView).offset(10);
        make.height.equalTo(@20);
        make.trailing.equalTo(backView).offset(-10);
    }];
    
    JH_WEAK(self)
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.photosView = [[JHAddResourceCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//    self.photosView.addImage = @"img_add_picture";
    self.photosView.addPicAction = ^(NSIndexPath *indexPath) {
        JH_STRONG(self)
        [self addAction:0];
    };
    self.photosView.didSelectedCell = ^(NSIndexPath *indexPath) {
        JH_STRONG(self)
        [self previewPicture:indexPath];
    };
    self.photosView.deleteBlock = ^(NSIndexPath *indexPath) {
        JH_STRONG(self)
        [self showDeleteSheet:indexPath type:0];
    };
    [backView addSubview:self.photosView];
    
    [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(title);
        make.top.equalTo(title.mas_bottom).offset(10);
        make.bottom.equalTo(backView).offset(-10);
        make.height.equalTo(@(cellWidth));
    }];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backView1);
        make.top.equalTo(self.backView2.mas_bottom).offset(10);
    }];
    
    UIButton *submitBtn = [JHUIFactory createThemeBtnWithTitle:@"上架" cornerRadius:22 target:self action:@selector(putawayBtn)];
    [self.view addSubview:submitBtn];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_bottom).offset(50);
        make.leading.equalTo(self.view).offset(60);
        make.trailing.equalTo(self.view).offset(-60);
        make.height.equalTo(@(44));
        make.bottom.equalTo(self.contentView).offset(-50);
        
    }];
    
    [self.view layoutIfNeeded];
//       [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//              make.height.equalTo(@(submitBtn.bottom+10));
//          }];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    JH_WEAK(self)
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (picker.view.tag == 0) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        [[TZImageManager manager] savePhotoWithImage:image completion:^(PHAsset *asset, NSError *error) {
            JH_STRONG(self)
            JHPublishSourceItemModel *model = [JHPublishSourceItemModel new];
            model.image = image;
            model.isVideo = NO;
            model.asset = asset;
            [self.allPhotos addObject:model];
            [self selfReloadCollection];
        }];
        
        
    }else if (picker.view.tag == 1) {
        
        [SVProgressHUD show];
        
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            JH_WEAK(self)
            [[TZImageManager manager] saveVideoWithUrl:videoUrl completion:^(PHAsset *asset, NSError *error) {
                JH_STRONG(self)
                if (!error) {
                    [self exportVideoWithAsset:asset picker:picker cover:nil];
                }
                [SVProgressHUD dismiss];
            }];
        }
    }
}

- (JHNTESTextInputView *)textView {
    if (!_textView) {
        _textView = [[JHNTESTextInputView alloc] initWithFrame:CGRectZero];
        _textView.delegate = self;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        NTESGrowingTextView *textView = _textView.textView;
        NSString *placeHolder = @"原石的场口、重量等";
        textView.font = [UIFont fontWithName:kFontNormal size:13];
        textView.placeholderAttributedText = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSFontAttributeName:textView.font,NSForegroundColorAttributeName:HEXCOLOR(0xcccccc)}];
        textView.maxNumberOfLines = 15;
    }
    return _textView;
}

#pragma mark - action
- (void)scanAction {
    
}
- (void)putawayBtn {

    if (self.titleLabel.textField.text.length>0) {
        
    }else {
        [self.view makeToast:@"请填写标题" duration:1 position:CSToastPositionCenter];
        return;
    }
    
    if (self.textView.textView.text.length>0) {

       }else {
           [self.view makeToast:@"请填写内容" duration:1 position:CSToastPositionCenter];
           return;
       }
    
    if (self.allVideos.count == 0) {
        [self.view makeToast:@"请上传视频" duration:1 position:CSToastPositionCenter];
        return;
    }
    

        
    JHPutShelveModel *model = [[JHPutShelveModel alloc] init];
    model.goodsTitle = self.titleLabel.textField.text;
    model.goodsDesc = self.textView.textView.text;
    model.stoneRestoreId = self.stoneRestoreId;
    model.depositoryLocationCode = @"";
    
    
    NSMutableArray *imageUrls = [NSMutableArray new];
    NSMutableArray *videoUrls = [NSMutableArray new];
    NSMutableArray *coverUrls = [NSMutableArray new];
    
    NSMutableArray *allPhotos = [NSMutableArray new];
    NSMutableArray *allVideos = [NSMutableArray new];
    NSMutableArray *allVideoPaths = [NSMutableArray new];
    
    model.isEdit = (self.editType == JHStoneEditTypeReqData);
    for (JHPublishSourceItemModel *obj in self.allVideos) {
        if(obj.isNetwork){
            [videoUrls addObject:obj.sourceUrl];
            [coverUrls addObject:obj.coverUrl];
        }
        else{
            [allVideos addObject:obj];
            [allVideoPaths addObject:obj.videoPath];
        }
    }
    for (JHPublishSourceItemModel *obj in self.allPhotos) {
        if(obj.isNetwork){
            [imageUrls addObject:obj.sourceUrl];
        }
        else{
            [allPhotos addObject:obj];
        }
    }
    model.imageUrls = imageUrls;
    model.videoUrls = videoUrls;
    model.coverUrls = coverUrls;
    model.allPhotos = allPhotos;
    model.allVideos = allVideos;
    model.allVideoPaths = allVideoPaths;
    
    [[JHBackUpLoadManage shareInstance] startUpLoadWithModel:model];
    [self.navigationController popViewControllerAnimated:YES];
}

/// Description
/// @param type 0 图片 1视频
- (void)addAction:(NSInteger)type {
    [self.view endEditing:YES];
    NSString *title = @"";
    if (type == 0) {
        title = @"选择图片";
    }else if (type == 1){
        title = @"选择视频";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerViewWithType:type];
    }]];
    
    if (!self.isOnlyLibrary) {
        [alert addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
              if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
                  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                  picker.navigationController.navigationBar.translucent = NO;
                  picker.delegate = self;
                  picker.allowsEditing = NO;
                  picker.sourceType = sourceType;
                  
                  picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                  
                  picker.view.tag = 0;
                  if (type == 1) {
                      picker.mediaTypes = @[(NSString *)kUTTypeMovie];
                      picker.view.tag = 1;
                      picker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
                  }
                  [self presentViewController:picker animated:YES completion:nil];
              }else {
                  NSLog(@"模拟器");
              }
          }]];
    }
    
  
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showImagePickerViewWithType:(NSInteger)type {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.showSelectedIndex = YES;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowTakeVideo = NO;
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    if (type == 1) {
        imagePickerVc.allowPickingVideo = YES;
        imagePickerVc.allowPickingImage = NO;
    }else if (type == 0) {
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingImage = YES;
    } else {
        imagePickerVc.allowPickingVideo = YES;
        imagePickerVc.allowPickingImage = YES;
    }
    //视频时长不超过5分钟
    imagePickerVc.videoMaximumDuration = 11 * 60;
    imagePickerVc.autoDismiss = NO;
    MJWeakSelf
    __weak TZImagePickerController* weakImagePickerVc = imagePickerVc;
    imagePickerVc.imagePickerControllerDidCancelHandle = ^{
        [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];
    };
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos) {
            [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                JHPublishSourceItemModel *model = [JHPublishSourceItemModel new];
                    model.image = photos[idx];
                    model.isVideo = NO;
                    model.asset = assets[idx];
                    [self.allPhotos addObject:model];
            }];
            [self selfReloadCollection];
        }
        [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];
    }];
    
    imagePickerVc.didFinishPickingVideoHandle = ^(UIImage *coverImage, PHAsset *asset) {
        [weakSelf exportVideoWithAsset:asset picker:weakImagePickerVc cover:coverImage];
    };
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)showDeleteSheet:(NSIndexPath *)indexPath type:(NSInteger)type {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (type == 0) {
            [self.allPhotos removeObjectAtIndex:indexPath.row];
            
        }else if (type == 1) {
            [self.allVideos removeObjectAtIndex:indexPath.row];
        }
        [self reloadDataWithType:type];
        
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 1000);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return videoImage;
}
- (void)exportVideoWithAsset:(PHAsset *)asset picker:(UINavigationController *)weakImagePickerVc cover:(UIImage *)coverImage {
    [SVProgressHUD showWithStatus:@"正在导出视频"];
    @weakify(self);
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        NSLog(@"%@",outputPath);
        [SVProgressHUD dismiss];
        @strongify(self);
        UIImage *image = coverImage;
        if (!image) {
            image = [self firstFrameWithVideoURL:[NSURL fileURLWithPath:outputPath] size:CGSizeZero];
        }
        JHPublishSourceItemModel *model = [JHPublishSourceItemModel new];
        model.image = image;
        model.isVideo = YES;
        model.asset = asset;
        model.videoPath = outputPath;
        [self.allVideos addObject:model];
        [self selfReloadCollection];
        [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSString *errorMessage, NSError *error) {
          dispatch_async(dispatch_get_main_queue(),  ^{
        [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];
        [SVProgressHUD dismiss];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showErrorWithStatus:@"视频导出错误，稍后重试"];
          });
    }];
}

- (void)playVideo:(NSIndexPath *)indexPath {
    JHPublishSourceItemModel *model = SAFE_OBJECTATINDEX(self.allVideos, 0);
    if(model.isNetwork){
        NSURL *url = [NSURL URLWithString:model.sourceUrl];
        AVPlayerViewController *ctrl = [AVPlayerViewController new];
        ctrl.player= [[AVPlayer alloc]initWithURL:url];
        [self presentViewController:ctrl animated:YES completion:nil];
        return;
    }
    TZVideoPlayerController *videoPlayerVc = [[TZVideoPlayerController alloc] init];
    videoPlayerVc.model = [TZAssetModel modelWithAsset:[self.allVideos objectAtIndex:indexPath.row].asset type:TZAssetModelMediaTypeVideo];
    [self.navigationController pushViewController:videoPlayerVc animated:YES];
}

- (void)previewPicture:(NSIndexPath *)indexPath {
    NSMutableArray *photoList = [NSMutableArray new];
    for (JHPublishSourceItemModel *model in self.allPhotos) {
        GKPhoto *photo = [GKPhoto new];
        if(model.isNetwork){
            photo.url = [NSURL URLWithString:model.image];
        }
        else{
            photo.image = model.image;
        }
        
        [photoList addObject:photo];
    }
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoList currentIndex:(NSInteger)indexPath.item];
    browser.isStatusBarShow = YES;
    browser.isScreenRotateDisabled = YES;
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    [browser showFromVC:self];
}

- (void)reloadDataWithType:(NSInteger)type {
    if (type == 0) {
        self.photosView.array = self.allPhotos;
        int row = ceil((self.allPhotos.count+1)/4.);
        [self.photosView reloadData];
        [self.photosView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(row*cellWidth));
        }];

    }else if (type == 1) {
        self.videosView.array = self.allVideos;
        int row = ceil((self.allVideos.count+1)/4.);
        [self.videosView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(cellWidth*row));
        }];
        [self.videosView reloadData];

    }

    [self.view layoutIfNeeded];

//    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(self.backView3.bottom+120));
//    }];

    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(ScreenW, self.contentView.height);
    
}

- (void)didChangeHeight:(CGFloat)height {
    if (height>30) {
        [self.textView.superview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height+20));
        }];
    }else {
        [self.textView.superview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
        }];
    }


    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(ScreenW, self.contentView.height);
    
}

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {
        
        NSDictionary *infoDict = [TZCommonTools tz_getInfoDictionary];
        // 无权限 做一个友好的提示
        NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
        
        NSString *message = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Please allow %@ to access your camera in \"Settings -> Privacy -> Camera\""],appName];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
             
        [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

             }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhotoLibiry];
                });
            }
        }];
    } else {
        [self takePhotoLibiry];
    }
}

- (void)takePhotoLibiry {
    [[TZImageManager manager] requestAuthorizationWithCompletion:^{
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
           if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusNotDetermined)) {
                       
                       NSDictionary *infoDict = [TZCommonTools tz_getInfoDictionary];
                       // 无权限 做一个友好的提示
                       NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
                       if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
                       
                       NSString *message = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Allow %@ to access your album in \"Settings -> Privacy -> Photos\""],appName];

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相册" message:message preferredStyle:UIAlertControllerStyleAlert];
                      [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
                           
                      [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          
                          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

                           }]];
                      [self presentViewController:alert animated:YES completion:nil];

           }
          
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
