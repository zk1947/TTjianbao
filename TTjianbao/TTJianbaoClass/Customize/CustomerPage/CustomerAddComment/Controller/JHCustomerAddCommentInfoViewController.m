//
//  JHCustomerAddCommentInfoViewController.m
//  TTjianbao
//
//  Created by user on 2020/10/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerAddCommentInfoViewController.h"
#import "JHCustomerCerEditNavView.h"
#import "JHCustomerAddCommentTextTableViewCell.h"
#import "JHCustomerAddCommentPicsTableViewCell.h"
#import "UIView+Toast.h"
#import "SVProgressHUD.h"
///
#import "JHImagePickerPublishManager.h"
#import "JHSQPublishVideoView.h"
#import "JHSQPublishModel.h"
#import "JHVideoCropViewController.h"
#import "JHVideoCropManager.h"
#import "JHAiyunOSSManager.h"
#import "JHCustomerAddCommentModel.h"
#import "JHCustomerAddCommentBusiness.h"
#import "IQKeyboardManager.h"

@interface JHCustomerAddCommentInfoViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView                           *addTabelView;
@property (nonatomic, strong) JHCustomerCerEditNavView              *navView;
@property (nonatomic, strong) JHCustomerAddCommentTextTableViewCell *cell1;
@property (nonatomic, strong) JHCustomerAddCommentPicsTableViewCell *cell2;

@property (nonatomic, strong) NSMutableArray <JHAlbumPickerModel *> *imageArray;     /// 图片数组
@property (nonatomic, strong) JHSQPublishModel                      *model;          /// 发布模型
@property (nonatomic, strong) JHAlbumPickerModel                    *videoModel;     /// 视频模型
@property (nonatomic, assign) NSInteger                              videoDuration;  /// 视频时长
@property (nonatomic, assign) NSInteger                              type;           /// 1:image 2:video

@end

@implementation JHCustomerAddCommentInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xffffff);
    [self removeNavView];
    [self setupNav];
    [self setupViews];
}

- (CGFloat)navViewHeight {
    CGFloat navHeight = UI.statusBarHeight + 60.f;
    return navHeight;
}

- (void)setupNav {
    self.navView = [[JHCustomerCerEditNavView alloc] init];
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo([self navViewHeight]);
    }];
    [self.navView reloadHCInfoName:@"添加沟通信息" btnName:@"发布"];
    @weakify(self);
    [self.navView honnerCerEditNavViewBtnAction:^(JHHonnerCerEditButtonStyle style) {
        @strongify(self);
        switch (style) {
            case JHHonnerCerEditButtonStyle_Back: {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case JHHonnerCerEditButtonStyle_Save: {
                NSLog(@"发布按钮点击事件");
                [self saveDataAndUpload];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)setupViews {
    [self.view addSubview:self.addTabelView];
    [self.addTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake([self navViewHeight], 0.f, 0.f, 0.f));
    }];
}

- (UITableView *)addTabelView {
    if (!_addTabelView) {
        _addTabelView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _addTabelView.dataSource                     = self;
        _addTabelView.delegate                       = self;
        _addTabelView.separatorColor                 = [UIColor clearColor];
        _addTabelView.separatorStyle                 = UITableViewCellSeparatorStyleSingleLine;
        _addTabelView.rowHeight                      = UITableViewAutomaticDimension;
        _addTabelView.estimatedRowHeight             = 48.f;
        if (@available(iOS 11.0, *)) {
        _addTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        self.automaticallyAdjustsScrollViewInsets    = NO;
        }

        [_addTabelView registerClass:[JHCustomerAddCommentTextTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomerAddCommentTextTableViewCell class])];
        [_addTabelView registerClass:[JHCustomerAddCommentPicsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomerAddCommentPicsTableViewCell class])];

        if ([_addTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_addTabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_addTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_addTabelView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _addTabelView;
}

- (void)saveDataAndUpload {
    if (self.cell1.textView.text.length > 0 || self.imageArray.count >0) {
        [self uploadImage:self.imageArray];
    } else {
        [self.view makeToast:@"请输入内容" duration:1.0 position:CSToastPositionCenter];
    }
}

- (void)uploadImage:(NSArray<JHAlbumPickerModel *> *)images {
    [SVProgressHUD show];
    JHAlbumPickerModel *model = images[0];
    NSString *const aliUploadPath = @"client_publish/customize/program/";
    if (images.count == 1 && model.isVideo) {
        /// 上传视频
        @weakify(self);
        [[JHAiyunOSSManager shareInstance] uploadVideoByPath:model.videoPath returnPath:aliUploadPath finishBlock:^(BOOL isFinished, NSString * _Nonnull videoKey) {
            [JHDispatch async:^{
                @strongify(self);
                if (isFinished) {
                    /// 上传封面
                    [[JHAiyunOSSManager shareInstance] uopladImage:@[model.image] returnPath:aliUploadPath finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
                        @strongify(self);
                        if (isFinished) {
                            [JHDispatch async:^{
                                JHCustomerAddCommentAttachmentVOModel *model = [JHCustomerAddCommentAttachmentVOModel new];
                                model.coverUrl = imgKeys[0];
                                model.type = 1;
                                model.url = videoKey;
                                NSArray<JHCustomerAddCommentAttachmentVOModel *> *array = @[model];
                                [self saveDataAndUpload:array];
                            }];
                        } else {
                            [SVProgressHUD showErrorWithStatus:@"上传视频封面失败"];
                        }
                    }];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"视频上传失败，稍后再试！"];
                }
            }];
        }];
    } else {
        /// 上传图片
        NSArray<UIImage *> *array = [images jh_map:^id _Nonnull(JHAlbumPickerModel * _Nonnull model, NSUInteger idx) {
            return model.image;
        }];
        @weakify(self);
        [[JHAiyunOSSManager shareInstance] uopladImage:array returnPath:aliUploadPath finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
            @strongify(self);
            if (isFinished) {
                NSArray *arr = [imgKeys jh_map:^id _Nonnull(NSString  *_Nonnull obj, NSUInteger idx) {
                    JHCustomerAddCommentAttachmentVOModel *model = [JHCustomerAddCommentAttachmentVOModel new];
                    model.type = 0;
                    model.url = obj;
                    return model;
                }];
                [self saveDataAndUpload:arr];
            } else {
                [SVProgressHUD showErrorWithStatus:@"图片上传失败，稍后再试！"];
            }
        }];
    }
}

- (void)saveDataAndUpload:(NSArray<JHCustomerAddCommentAttachmentVOModel *> *)array {
    JHCustomerAddCommentModel *model = [[JHCustomerAddCommentModel alloc] init];
    model.content                    = self.cell1.textView.text;
    model.customizeCommentId         = [self.customizeCommentId integerValue];
    model.customizeOrderId           = [self.customizeOrderId integerValue];
    model.imgList                    = array;
    /// 发布
    @weakify(self);
    [JHCustomerAddCommentBusiness publishComment:model completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        [JHDispatch ui:^{
            @strongify(self);
            [SVProgressHUD dismiss];
            if (hasError) {
                [self.view makeToast:@"保存失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
            } else {
                [self.view makeToast:@"保存成功" duration:1.0 position:CSToastPositionCenter];
                [JHDispatch after:1.f execute:^{
                    if (self.popAction) {
                        self.popAction();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    }];
}


#pragma mark - Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.cell1 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomerAddCommentTextTableViewCell class])];
        if (!self.cell1) {
            self.cell1 = [[JHCustomerAddCommentTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomerAddCommentTextTableViewCell class])];
        }
        return self.cell1;
    } else {
        self.cell2 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomerAddCommentPicsTableViewCell class])];
        if (!self.cell2) {
            self.cell2  = [[JHCustomerAddCommentPicsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomerAddCommentPicsTableViewCell class])];
        }
        @weakify(self);
        self.cell2.addBlock = ^{
            @strongify(self);
            [self selectAlbumMethod];
        };
        self.cell2.deleteBlock = ^(NSInteger index) {
            @strongify(self);
            if(self.imageArray.count > index) {
                [self.cell2 setViewModel:self.imageArray];
                [self.imageArray removeObjectAtIndex:index];
                [tableView reloadData];
            }
        };
        return self.cell2;
    }
}

#pragma mark - picts
/// 图片数组
- (NSMutableArray<JHAlbumPickerModel *> *)imageArray {
    if(!_imageArray) {
        _imageArray = [NSMutableArray new];
    }
    return _imageArray;
}

- (JHSQPublishModel *)model {
    if(!_model) {
        _model = [JHSQPublishModel new];
    }
    return _model;
}

///选择相册
- (void)selectAlbumMethod {
    if(self.imageArray.count <= 0 && !self.videoModel) {
        _type = 0;
    }
    NSMutableArray *assetArray = [NSMutableArray new];
    for (JHAlbumPickerModel *m in self.imageArray) {
        [assetArray addObject:m.asset];
    }

    [JHImagePickerPublishManager showImagePickerViewWithType:_type maxImagesCount:9 assetArray:assetArray viewController:self photoSelectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
        _type = 1;
        [self.imageArray removeAllObjects];
        [self.imageArray addObjectsFromArray:dataArray];
        [self.cell2 setViewModel:self.imageArray];
        [self.addTabelView reloadData];
    } videoSelectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
        _type = 2;
        JHAlbumPickerModel *model = dataArray.firstObject;
        [JHImagePickerPublishManager getOutPutPath:model.asset block:^(NSString * _Nonnull outPath) {
            [self pushCorpVideoWithoutPath:outPath];
        }];
    }];
}

/// 切换到显示视频截取页面
- (void)pushCorpVideoWithoutPath:(NSString *)outPath {
    JHVideoCropViewController *vc = [[JHVideoCropViewController alloc] initWithVideoWithOutPutPath:outPath];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    @weakify(self)
    vc.selectVideoBlock = ^(AVURLAsset *tmpAsset, CMTimeRange tmpTimeRange) {
        @strongify(self);
        [self showVideoViewWithAsset:tmpAsset timeRange:tmpTimeRange];
    };
}

/// 显示视频
- (void)showVideoViewWithAsset:(AVURLAsset *)asset timeRange:(CMTimeRange)timeRange {
    [JHVideoCropManager exportVideoWithAVAsset:asset timeRange:timeRange selectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
        if(dataArray.count > 0) {
            [self.imageArray addObjectsFromArray:dataArray];
            [self.cell2 setViewModel:self.imageArray];
            [self.addTabelView reloadData];
            _type = 1;
        }
    }];
}


@end
