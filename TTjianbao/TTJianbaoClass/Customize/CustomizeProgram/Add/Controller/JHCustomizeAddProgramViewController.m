//
//  JHCustomizeAddProgramViewController.m
//  TTjianbao
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeAddProgramViewController.h"
#import "JHCustomizeAddProgramCategoryTableViewCell.h"
#import "JHCustomizeAddProgramPictsTableViewCell.h"
#import "JHCustomizeAddProgramDescTableViewCell.h"
#import "JHCustomizeAddProgramMoneyTableViewCell.h"
#import "UIView+JHGradient.h"
#import "JHNOAllowTabelView.h"
///
#import "JHImagePickerPublishManager.h"
#import "JHSQPublishVideoView.h"
#import "JHSQPublishModel.h"
#import "JHVideoCropViewController.h"
#import "JHVideoCropManager.h"
#import "JHAiyunOSSManager.h"

#import "JHPickerView.h"
#import "TTjianbaoHeader.h"
#import "UIView+Toast.h"
#import "JHCustomizeAddProgramModel.h"
#import "IQKeyboardManager.h"
#import "TTjianbaoMarcoNotification.h"
#import "JHMeterialsCategoryModel.h"
#import "UIView+JHToast.h"


@interface JHCustomizeAddProgramViewController () <
UITableViewDelegate,
UITableViewDataSource,
STPickerSingleDelegate>
@property (nonatomic, strong) JHNOAllowTabelView                    *addTabelView;
@property (nonatomic, strong) UIButton                              *makeSureBtn;
@property (nonatomic, strong) NSMutableArray <JHAlbumPickerModel *> *imageArray;     /// 图片数组
@property (nonatomic, assign) NSInteger                              videoDuration;  /// 视频时长
@property (nonatomic, assign) NSInteger                              type;           /// 1:image 2:video
@property (nonatomic, strong) NSMutableArray <JHCustomizeAddProgramPictsModel *> *uploadArray; /// 发布
@property (nonatomic, strong) JHPickerView                               *picker;
@property (nonatomic, strong) NSMutableArray                             *pickerDataArray;
@property (nonatomic, strong) JHCustomizeAddProgramCategoryTableViewCell *cell0;
@property (nonatomic, strong) JHCustomizeAddProgramPictsTableViewCell    *cell1;
@property (nonatomic, strong) JHCustomizeAddProgramDescTableViewCell     *cell2;
@property (nonatomic, strong) JHCustomizeAddProgramMoneyTableViewCell    *cell3;
@property (nonatomic, strong) NSString                                   *pickerSelectedId;
@property (nonatomic, assign) BOOL                                        cell0HasValue;
@property (nonatomic, assign) BOOL                                        cell1HasValue;
@property (nonatomic, assign) BOOL                                        cell2HasValue;
@property (nonatomic, assign) BOOL                                        cell3HasValue;
@property (nonatomic, assign) BOOL                                        saveBtnCannotClick;

@end

@implementation JHCustomizeAddProgramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加定制方案";
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    self.pickerSelectedId = @"";
    self.saveBtnCannotClick = NO;
    [self setupViews];
    [self getCateAll];
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
    
    _makeSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _makeSureBtn.enabled = NO;
    _makeSureBtn.backgroundColor = HEXCOLOR(0xEEEEEE);
    [_makeSureBtn jh_setGradientBackgroundWithColors:nil locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [_makeSureBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    _makeSureBtn.titleLabel.font      = [UIFont fontWithName:kFontNormal size:16.f];
    [_makeSureBtn setTitle:@"确认添加" forState:UIControlStateNormal];
    [_makeSureBtn addTarget:self action:@selector(addInfoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _makeSureBtn.layer.cornerRadius   = 22.f;
    _makeSureBtn.layer.masksToBounds  = YES;
    [self.view addSubview:_makeSureBtn];
    [_makeSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-[self bottomSpace]);
        make.left.equalTo(self.view.mas_left).offset(28.f);
        make.right.equalTo(self.view.mas_right).offset(-28.f);
        make.height.mas_equalTo(44.f);
    }];
}


- (void)getCateAll {
    [SVProgressHUD show];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/anon/customize/fee/template-list") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
        [self.pickerDataArray removeAllObjects];
        self.pickerDataArray = [JHMeterialsCategoryModel mj_objectArrayWithKeyValuesArray:respondObject.data];
//        [self.resultCollectionView reloadData];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
    }];
}


- (void)makeSureBtnStatusCanClick {
    if (!self.cell0HasValue && !self.cell1HasValue && !self.cell2HasValue && !self.cell3HasValue) {
        self.makeSureBtn.enabled = NO;
        self.makeSureBtn.backgroundColor = HEXCOLOR(0xEEEEEE);
        [_makeSureBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [self.makeSureBtn jh_setGradientBackgroundWithColors:nil locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    } else {
        self.makeSureBtn.enabled = YES;
        [_makeSureBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [self.makeSureBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    }
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
            self.automaticallyAdjustsScrollViewInsets    = NO;
        }
        
        [_addTabelView registerClass:[JHCustomizeAddProgramCategoryTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeAddProgramCategoryTableViewCell class])];
        [_addTabelView registerClass:[JHCustomizeAddProgramPictsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeAddProgramPictsTableViewCell class])];
        [_addTabelView registerClass:[JHCustomizeAddProgramMoneyTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeAddProgramMoneyTableViewCell class])];

        if ([_addTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_addTabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_addTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_addTabelView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _addTabelView;
}

- (NSMutableArray *)pickerDataArray {
    if (!_pickerDataArray) {
        _pickerDataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _pickerDataArray;
}

- (JHPickerView *)picker {
    if (!_picker) {
        _picker = [[JHPickerView alloc] init];
        _picker.widthPickerComponent = 300;
        _picker.heightPicker = 240 + UI.bottomSafeAreaHeight;
        [_picker setDelegate:self];
    }
    return _picker;
}

- (void)addInfoBtnAction:(UIButton *)sender {
    if (![self.cell0 checkValue]) {
        [self.view makeToast:@"请选择定制类别" duration:1.0 position:CSToastPositionCenter];
        return;
    }
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
    
    if (self.imageArray.count == 0) {
        [self.view makeToast:@"请添加设计稿" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (![self.cell2 checkTextViewIsLegal]) {
        [self.view makeToast:@"请输入方案说明" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (![self.cell3 checkTextFieldIsLegal]) {
        [self.view makeToast:@"请输入服务费" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (self.saveBtnCannotClick) {
        return;
    }
    [self uploadVideo:self.imageArray];
}



#pragma mark - select image
/// 图片数组
- (NSMutableArray<JHAlbumPickerModel *> *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray new];
    }
    return _imageArray;
}

/// 发布
- (NSMutableArray<JHCustomizeAddProgramPictsModel *> *)uploadArray {
    if (!_uploadArray) {
        _uploadArray = [NSMutableArray new];
    }
    return _uploadArray;
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


#pragma mark - upload pic
- (void)uploadVideo:(NSArray<JHAlbumPickerModel *> *)images {
    self.saveBtnCannotClick = YES;

    [SVProgressHUD show];
//    [self showProgressHUDWithProgress:progress WithTitle:@"上传中"];
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
                            JHCustomizeAddProgramPictsModel *model = [JHCustomizeAddProgramPictsModel new];
                            model.coverUrl = imgKeys[0];
                            model.type = 1;
                            model.url = videoKey;
                            NSArray<JHCustomizeAddProgramPictsModel *> *array = @[model];
                            [self saveVideoInfo:array];
                            /// 上传其他图片
                            [self uploadPicts:images];
                        }];
                    } else {
                        self.saveBtnCannotClick = NO;
                        [SVProgressHUD showErrorWithStatus:@"上传视频封面失败"];
                    }
                }];
            } else {
                self.saveBtnCannotClick = NO;
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
                JHCustomizeAddProgramPictsModel *model = [JHCustomizeAddProgramPictsModel new];
                model.type = 0;
                model.url = obj;
                return model;
            }];
            [self saveDataAndUpload:arr];
        } else {
            self.saveBtnCannotClick = NO;
            [SVProgressHUD showErrorWithStatus:@"图片上传失败，稍后再试！"];
        }
    }];
}

- (void)saveVideoInfo:(NSArray<JHCustomizeAddProgramPictsModel *> *)array {
    [self.uploadArray removeAllObjects];
    [self.uploadArray addObjectsFromArray:array];
}

- (void)saveDataAndUpload:(NSArray<JHCustomizeAddProgramPictsModel *> *)array {
    [self.uploadArray addObjectsFromArray:array];
    
    JHCustomizeAddProgramModel *model = [[JHCustomizeAddProgramModel alloc] init];
    model.customizeFeeId   = [self.pickerSelectedId integerValue];
    model.customizeFeeName = [self.cell0 getCagetoryValue];
    model.customizeOrderId = [self.customizeOrderId integerValue];
    model.planPrice        = [self.cell3 getServertext]; /// 服务费
    model.extPrice         = [self.cell3 getMaterialtext];
    model.planImgList      = self.uploadArray;
    model.planDesc         = [self.cell2 getDescString];
    
    NSString *url = FILE_BASE_STRING(@"/orderCustomizePlan/auth/addCustomizePlan");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[model mj_keyValues]];
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"添加成功" duration:1.0 position:CSToastPositionCenter];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];
        [JHDispatch after:1.f execute:^{
            self.saveBtnCannotClick = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        self.saveBtnCannotClick = NO;
        [self.view makeToast:@"添加失败，请稍后重试" duration:1.0 position:CSToastPositionCenter];
    }];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.cell0 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeAddProgramCategoryTableViewCell class])];
        if (!self.cell0) {
            self.cell0 = [[JHCustomizeAddProgramCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeAddProgramCategoryTableViewCell class])];
        }
        @weakify(self);
        self.cell0.cagetoryChooseBlock = ^{
            @strongify(self);
//            [self.pickerDataArray removeAllObjects];
//            [self.pickerDataArray addObjectsFromArray:[UserInfoRequestManager sharedInstance].pickerDataArray];
            if (self.pickerDataArray.count >0) {
                self.picker.arrayData = [self.pickerDataArray jh_map:^id _Nonnull(JHMeterialsCategoryModel *  _Nonnull obj, NSUInteger idx) {
                    return obj.name;
                }];
                [self.picker show];
            } else {
                [self.view makeToast:@"类别信息错误，请稍后再试" duration:1.0 position:CSToastPositionCenter];
            }
        };
        self.cell0.cagetoryHasString = ^(BOOL has) {
            @strongify(self);
            self.cell0HasValue = has;
            [self makeSureBtnStatusCanClick];
        };
        return self.cell0;
    } else if (indexPath.section == 1) {
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
            if (self.imageArray.count > index) {
//                [self.cell1 setViewModel:self.imageArray];
                [self.imageArray removeObjectAtIndex:index];
                [self.addTabelView reloadData];
            }
        };
        self.cell1.pictsHasValue = ^(BOOL has) {
            @strongify(self);
            self.cell1HasValue = has;
            [self makeSureBtnStatusCanClick];
        };
        [self.cell1 setViewModel:self.imageArray];
        return self.cell1;
        
    } else if (indexPath.section == 2) {
        self.cell2 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeAddProgramDescTableViewCell class])];
        if (!self.cell2) {
            self.cell2 = [[JHCustomizeAddProgramDescTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeAddProgramDescTableViewCell class])];
        }
        @weakify(self);
        self.cell2.descHasValue = ^(BOOL has) {
            @strongify(self);
            self.cell2HasValue = has;
            [self makeSureBtnStatusCanClick];
        };
        return self.cell2;
    } else  {
        self.cell3 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeAddProgramMoneyTableViewCell class])];
        if (!self.cell3) {
            self.cell3 = [[JHCustomizeAddProgramMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeAddProgramMoneyTableViewCell class])];
        }
        @weakify(self);
        self.cell3.moneyHasValue = ^(BOOL has) {
            @strongify(self);
            self.cell3HasValue = has;
            [self makeSureBtnStatusCanClick];
        };
        return self.cell3;
    }
}

#pragma mark - pickerDelegate
- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    NSInteger index = [self.picker.arrayData indexOfObject:selectedTitle];
    JHMeterialsCategoryModel *model = self.pickerDataArray[index];
    if (model) {
        [self.cell0 setViewModel:selectedTitle];
        self.pickerSelectedId = model.ID;
    } else {
        self.pickerSelectedId = @"";
        [self.view makeToast:@"暂时无法选择，请稍后再试" duration:1.0 position:CSToastPositionCenter];
    }
}



@end
