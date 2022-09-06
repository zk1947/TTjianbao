//
//  JHCustomizeAddCompleteViewController.m
//  TTjianbao
//
//  Created by user on 2020/11/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeAddCompleteViewController.h"
#import "UIView+JHGradient.h"
#import "JHNOAllowTabelView.h"
#import "JHImagePickerPublishManager.h"
#import "JHSQPublishVideoView.h"
#import "JHSQPublishModel.h"
#import "JHVideoCropViewController.h"
#import "JHVideoCropManager.h"

#import "UIView+Toast.h"
#import "IQKeyboardManager.h"
#import "JHAiyunOSSManager.h"
#import "TTjianbaoHeader.h"
#import "JHCustomizeAddCompleteModel.h"

#import "JHCustomizeAddProgramPictsTableViewCell.h"
#import "JHCustomizeAddCompleteDescTableViewCell.h"

@interface JHCustomizeAddCompleteViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) JHNOAllowTabelView   *addTabelView;
@property (nonatomic, strong) UIButton             *makeSureCompleteBtn;
/// data
@property (nonatomic, strong) NSMutableArray <JHAlbumPickerModel *> *imageArray; /// 图片数组
@property (nonatomic, assign) NSInteger                       type;/// 1:image     2:video
@property (nonatomic, strong) JHCustomizeAddProgramPictsTableViewCell *cell1;
@property (nonatomic, strong) JHCustomizeAddCompleteDescTableViewCell *cell2;
@property (nonatomic, strong) NSMutableArray <JHCustomizeAddCompletePictModel *> *uploadArray; /// 发布

@end

@implementation JHCustomizeAddCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加制作完成信息";
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (CGFloat)navViewHeight {
    CGFloat navHeight = UI.statusBarHeight + 44.f;
    return navHeight;
}

- (CGFloat)bottomSpace {
    CGFloat navHeight = UI.bottomSafeAreaHeight + 10.f;
    return navHeight;
}

- (void)setupViews {
    [self.view addSubview:self.addTabelView];
    [self.addTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake([self navViewHeight], 10.f, [self bottomSpace]+ 54.f, 10.f));
    }];
    [self.addTabelView reloadData];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(54.f + [self bottomSpace]);
    }];
    
    _makeSureCompleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_makeSureCompleteBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [_makeSureCompleteBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _makeSureCompleteBtn.titleLabel.font      = [UIFont fontWithName:kFontNormal size:16.f];
    [_makeSureCompleteBtn setTitle:@"确认完成" forState:UIControlStateNormal];
    [_makeSureCompleteBtn addTarget:self action:@selector(makeSureCompleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _makeSureCompleteBtn.layer.cornerRadius   = 22.f;
    _makeSureCompleteBtn.layer.masksToBounds  = YES;
    [self.view addSubview:_makeSureCompleteBtn];
    [_makeSureCompleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-[self bottomSpace]);
        make.left.equalTo(self.view.mas_left).offset(28.f);
        make.right.equalTo(self.view.mas_right).offset(-28.f);
        make.height.mas_equalTo(44.f);
    }];
}

/// 确认完成
- (void)makeSureCompleteBtnAction:(UIButton *)sender {
    if (self.imageArray.count <2) {
        [self.view makeToast:@"请添加至少一个视频一个图片" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (self.imageArray.count >=2) {
        JHAlbumPickerModel *model = self.imageArray.firstObject;
        if (!model.isVideo) {
            [self.view makeToast:@"请添加视频" duration:1.0 position:CSToastPositionCenter];
            return;
        }
    }
    [self uploadVideo:self.imageArray];
}

#pragma mark - upload pic
- (void)uploadVideo:(NSArray<JHAlbumPickerModel *> *)images {
    [SVProgressHUD show];
    NSString *const aliUploadPath = @"client_publish/customize/program/";
    JHAlbumPickerModel *vModel = images[0];
        /// 上传视频
    @weakify(self);
    [[JHAiyunOSSManager shareInstance] uploadVideoByPath:vModel.videoPath returnPath:aliUploadPath finishBlock:^(BOOL isFinished, NSString * _Nonnull videoKey) {
        [JHDispatch async:^{
            @strongify(self);
            if (isFinished) {
                /// 上传视频封面
                [[JHAiyunOSSManager shareInstance] uopladImage:@[vModel.image] returnPath:aliUploadPath finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
                    if (isFinished) {
                        [JHDispatch async:^{
                            @strongify(self);
                            JHCustomizeAddCompletePictModel *model = [JHCustomizeAddCompletePictModel new];
                            model.coverUrl = imgKeys[0];
                            model.type = 1;
                            model.url = videoKey;
                            NSArray<JHCustomizeAddCompletePictModel *> *array = @[model];
                            [self saveVideoInfo:array];
                            /// 上传其他图片
                            [self uploadPicts:images];
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
}

- (void)uploadPicts:(NSArray<JHAlbumPickerModel *> *)images {
    /// 上传图片
    NSString *const aliUploadPath = @"client_publish/customize/program/";
    NSArray *newImages = [images subarrayWithRange:NSMakeRange(1, images.count-1)];
    NSArray<UIImage *> *array = [newImages jh_map:^id _Nonnull(JHAlbumPickerModel * _Nonnull model, NSUInteger idx) {
        return model.image;
    }];
    @weakify(self);
    [[JHAiyunOSSManager shareInstance] uopladImage:array returnPath:aliUploadPath finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
        @strongify(self);
        if (isFinished) {
            NSArray *arr = [imgKeys jh_map:^id _Nonnull(NSString  *_Nonnull obj, NSUInteger idx) {
                JHCustomizeAddCompletePictModel *model = [JHCustomizeAddCompletePictModel new];
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

- (void)saveVideoInfo:(NSArray<JHCustomizeAddCompletePictModel *> *)array {
    [self.uploadArray removeAllObjects];
    [self.uploadArray addObjectsFromArray:array];
}

- (void)saveDataAndUpload:(NSArray<JHCustomizeAddCompletePictModel *> *)array {
    [self.uploadArray addObjectsFromArray:array];
    JHCustomizeAddCompleteModel *model = [[JHCustomizeAddCompleteModel alloc] init];
    model.customizeOrderId = [self.customizeOrderId integerValue];
    model.finishRemark     = [self.cell2 getDescString];
    model.worksImgList     = self.uploadArray;
    NSString *url = FILE_BASE_STRING(@"/app/appraisal/customizeWorks/finishWorks");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[model mj_keyValues]];
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"添加成功" duration:1.0 position:CSToastPositionCenter];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];
        [JHDispatch after:1.f execute:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"添加失败，请稍后重试" duration:1.0 position:CSToastPositionCenter];
    }];
}


- (UITableView *)addTabelView {
    if (!_addTabelView) {
        _addTabelView                                = [[JHNOAllowTabelView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _addTabelView.dataSource                     = self;
        _addTabelView.delegate                       = self;
        _addTabelView.backgroundColor                = HEXCOLOR(0xF5F6FA);
        _addTabelView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _addTabelView.estimatedRowHeight             = 10.f;
        _addTabelView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _addTabelView.estimatedSectionHeaderHeight   = 0.1f;
            _addTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        [_addTabelView registerClass:[JHCustomizeAddProgramPictsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeAddProgramPictsTableViewCell class])];
        [_addTabelView registerClass:[JHCustomizeAddCompleteDescTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeAddCompleteDescTableViewCell class])];

        if ([_addTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_addTabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_addTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_addTabelView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _addTabelView;
}

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = HEXCOLOR(0xF5F6FA);
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.cell1 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeAddProgramPictsTableViewCell class])];
        if (!self.cell1) {
            self.cell1 = [[JHCustomizeAddProgramPictsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeAddProgramPictsTableViewCell class])];
        }
        @weakify(self);
        self.cell1.addBlock = ^(BOOL isImage) {
            @strongify(self);
            [self selectAlbumMethod:isImage];
        };
        self.cell1.deleteBlock = ^(NSInteger index) {
            @strongify(self);
            if(self.imageArray.count > index) {
//                [self.cell1 setViewModel:self.imageArray];
                [self.imageArray removeObjectAtIndex:index];
                [tableView reloadData];
            }
        };
        [self.cell1 setViewModel:self.imageArray];
        return self.cell1;
    } else {
        self.cell2 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeAddCompleteDescTableViewCell class])];
        if (!self.cell2) {
            self.cell2 = [[JHCustomizeAddCompleteDescTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeAddCompleteDescTableViewCell class])];
        }
        return self.cell2;
    }
}

#pragma mark - select image
/// 发布
- (NSMutableArray<JHCustomizeAddCompletePictModel *> *)uploadArray {
    if (!_uploadArray) {
        _uploadArray = [NSMutableArray new];
    }
    return _uploadArray;
}

///图片数组
- (NSMutableArray<JHAlbumPickerModel *> *)imageArray {
    if(!_imageArray) {
        _imageArray = [NSMutableArray new];
    }
    return _imageArray;
}

///选择相册
- (void)selectAlbumMethod:(BOOL)isImage {
    _type = isImage? 1 : 2;
    
    NSMutableArray *assetArray = [NSMutableArray new];
    if (isImage) {
        for (JHAlbumPickerModel *m in self.imageArray) {
            [assetArray addObject:m.asset];
        }
    }

    [JHImagePickerPublishManager showImagePickerViewWithType:_type maxImagesCount:7 assetArray:assetArray viewController:self photoSelectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
        _type = 1;
        if (self.imageArray.count >0) {
            JHAlbumPickerModel *model = self.imageArray.firstObject;
            if (model.isVideo) {
                [self.imageArray removeObjectsInRange:NSMakeRange(1, self.imageArray.count-1)];
            } else {
                [self.imageArray removeAllObjects];
            }
        }
        [self.imageArray addObjectsFromArray:dataArray];
        [self.cell1 setViewModel:self.imageArray];
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
            NSRange range = NSMakeRange(0, 1);
            NSIndexSet *nsindex = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.imageArray insertObjects:dataArray atIndexes:nsindex];
//            [self.imageArray addObjectsFromArray:dataArray];
            [self.cell1 setViewModel:self.imageArray];
            [self.addTabelView reloadData];
        }
    }];
}




@end
