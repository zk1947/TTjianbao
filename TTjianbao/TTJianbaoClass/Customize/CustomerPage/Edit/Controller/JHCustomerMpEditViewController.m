//
//  JHCustomerMpEditViewController.m
//  TTjianbao
//  定制师主页主态 - 编辑代表作
//  Created by user on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerMpEditViewController.h"
#import "JHCustomerMpEditNavView.h"
#import "JHCustomerMpEditPictsTableViewCell.h"
#import "JHCustomerMpEditInstroTableViewCell.h"
#import "JHCustomerMpEditTitleTableViewCell.h"
#import "JHImagePickerPublishManager.h"
#import "UIView+Toast.h"
#import "JHCustomerApiManager.h"
#import "SVProgressHUD.h"
#import "JHAiyunOSSManager.h"
#import "IQKeyboardManager.h"

@interface JHCustomerMpEditViewController () <
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) JHCustomerMpEditNavView               *navView;
@property (nonatomic, strong) UITableView                           *mpTabelView;
@property (nonatomic, strong) NSMutableArray<JHAlbumPickerModel*>   *imageArray;
@property (nonatomic, strong) JHCustomerMpEditPictsTableViewCell    *cell1;
@property (nonatomic, strong) JHCustomerMpEditTitleTableViewCell    *cell2;
@property (nonatomic, strong) JHCustomerMpEditInstroTableViewCell   *cell3;
@property (nonatomic, strong) NSMutableArray<JHCustomerEditOpusPicsPublishModel *>            *imageUrlsArray;
@end

@implementation JHCustomerMpEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xffffff);
    [self removeNavView];
    [self setupNav];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (CGFloat)navViewHeight {
    CGFloat navHeight = UI.statusBarHeight + 60.f;
    return navHeight;
}

- (void)setupNav {
    self.navView = [[JHCustomerMpEditNavView alloc] init];
    self.navView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo([self navViewHeight]);
    }];
    [self.navView reloadNavInfo:self.userIcon name:self.userName subName:self.userDesc];
    @weakify(self);
    [self.navView customerEditNavButtonAction:^(JHCustomerMpEditNavButtonStyle style) {
        @strongify(self);
        switch (style) {
            case JHCustomerMpEditNavButtonStyle_Back: {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case JHCustomerMpEditNavButtonStyle_Save: {
                [self controlAndUpload];
            }
                break;
            default:
                break;
        }
    }];
    
}

- (void)setupViews {
    [self.view addSubview:self.mpTabelView];
    [self.mpTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake([self navViewHeight], 0.f, 0.f, 0.f));
    }];
    [self.mpTabelView reloadData];
}

- (UITableView *)mpTabelView {
    if (!_mpTabelView) {
        _mpTabelView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mpTabelView.dataSource                     = self;
        _mpTabelView.delegate                       = self;
        _mpTabelView.separatorColor                 = [UIColor clearColor];
        _mpTabelView.separatorStyle                 = UITableViewCellSeparatorStyleSingleLine;
        _mpTabelView.estimatedRowHeight             = 10.f;
        _mpTabelView.bounces                        = NO;
        if (@available(iOS 11.0, *)) {
            _mpTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }

        [_mpTabelView registerClass:[JHCustomerMpEditPictsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomerMpEditPictsTableViewCell class])];
        [_mpTabelView registerClass:[JHCustomerMpEditTitleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomerMpEditTitleTableViewCell class])];
        [_mpTabelView registerClass:[JHCustomerMpEditInstroTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomerMpEditInstroTableViewCell class])];

        if ([_mpTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mpTabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_mpTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mpTabelView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _mpTabelView;
}



#pragma mark - Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.cell1 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomerMpEditPictsTableViewCell class])];
        if (!self.cell1) {
            self.cell1  = [[JHCustomerMpEditPictsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomerMpEditPictsTableViewCell class])];
        }
        @weakify(self);
        self.cell1.addBlock = ^{
            @strongify(self);
            [self selectAlbumMethod];
        };
        self.cell1.deleteBlock = ^(NSInteger index) {
            @strongify(self);
            if(self.imageArray.count > index) {
                [self.imageArray removeObjectAtIndex:index];
                [self.cell1 setViewModel:self.imageArray];
                [tableView reloadData];
            }
        };
        return self.cell1;
    } else if (indexPath.row == 1) {
        self.cell2 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomerMpEditTitleTableViewCell class])];
        if (!self.cell2) {
            self.cell2 = [[JHCustomerMpEditTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomerMpEditTitleTableViewCell class])];
        }
        return self.cell2;
    } else {
        self.cell3 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomerMpEditInstroTableViewCell class])];
        if (!self.cell3) {
            self.cell3 = [[JHCustomerMpEditInstroTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomerMpEditInstroTableViewCell class])];
        }
        return self.cell3;
    }
}


#pragma mark - picts
- (NSMutableArray<JHAlbumPickerModel *> *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageArray;
}

- (NSMutableArray<JHCustomerEditOpusPicsPublishModel *> *)imageUrlsArray {
    if (!_imageUrlsArray) {
        _imageUrlsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageUrlsArray;
}

///选择相册
- (void)selectAlbumMethod {
    if(self.imageArray.count <= 0) {
        NSLog(@"");
    }
    NSMutableArray *assetArray = [NSMutableArray new];
    for (JHAlbumPickerModel *m in self.imageArray) {
        [assetArray addObject:m.asset];
    }
    /// type == 1,当前代表作只支持图片，不支持视频
    [JHImagePickerPublishManager showImagePickerViewWithType:1 maxImagesCount:9 assetArray:assetArray viewController:self photoSelectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
        [self.imageArray removeAllObjects];
        [self.imageArray addObjectsFromArray:dataArray];
        [self.cell1 setViewModel:self.imageArray];
        [self.mpTabelView reloadData];
    } videoSelectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
        NSLog(@"不支持视频");
    }];
}

#pragma mark -  Data
- (void)controlAndUpload {
    if (![self isAllowUpload]) {
        return;
    }
    [self uploadImage:self.imageArray];
}

- (BOOL)isAllowUpload {
    if (self.cell2.textField.text.length < 1) {
        [self.view makeToast:@"请输入代表作名称" duration:1.0 position:CSToastPositionCenter];
        return NO;
    }
    if (self.cell3.textView.text.length < 1) {
        [self.view makeToast:@"请输入代表作描述" duration:1.0 position:CSToastPositionCenter];
        return NO;
    }
    return YES;
}

- (void)uploadImage:(NSArray<JHAlbumPickerModel *> *)images {
    [SVProgressHUD show];
    NSString *const aliUploadPath = @"client_publish/customize/rep";
    NSArray<UIImage *> *array = [images jh_map:^id _Nonnull(JHAlbumPickerModel * _Nonnull model, NSUInteger idx) {
        return model.image;
    }];
    @weakify(self);
    [[JHAiyunOSSManager shareInstance] uopladImage:array returnPath:aliUploadPath finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
        @strongify(self);
        if (isFinished) {
            [self saveDataAndUpload:imgKeys];
        } else {
            [SVProgressHUD dismiss];
            [self.view makeToast:@"保存失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)saveDataAndUpload:(NSArray<NSString *> *)array {
    [self.imageUrlsArray removeAllObjects];
    self.imageUrlsArray = [array jh_map:^id _Nonnull(NSString * _Nonnull obj, NSUInteger idx) {
        JHCustomerEditOpusPicsPublishModel *model = [[JHCustomerEditOpusPicsPublishModel alloc] init];
        model.type     = 0;
        model.url      = obj;
        return model;
    }];
    
    JHCustomerEditOpusPublishModel *model = [[JHCustomerEditOpusPublishModel alloc] init];
    model.title                           = self.cell2.textField.text;
    model.desc                            = self.cell3.textView.text;
    model.opusImgs                        = self.imageUrlsArray;
//    model.ID                              = [self.ID integerValue];
    model.ID                              = 0;
    
    /// 发布
    @weakify(self);
    [JHCustomerApiManager saveCustomizeOpus:model completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        [JHDispatch ui:^{
            @strongify(self);
            [SVProgressHUD dismiss];
            if (hasError) {
                [self.view makeToast:@"保存失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
            } else {
                if (self.callbackMethod) {
                    self.callbackMethod();
                }
                [self.view makeToast:@"保存成功" duration:1.0 position:CSToastPositionCenter];
                
                [JHDispatch after:1.f execute:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    }];
}







@end
