//
//  JHCustomerCerEditViewController.m
//  TTjianbao
//  定制师主页主态 - 编辑荣誉证书
//  Created by user on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerCerEditViewController.h"
#import "JHCustomerCerEditNavView.h"
#import "JHCustomerCerAddImgTableViewCell.h"
#import "JHCustomerCerAddNameTableViewCell.h"
#import "JHCustomerCerAddInstroTableViewCell.h"
#import "JHImagePickerPublishManager.h"
#import "TZImagePickerController.h"

#import "UIView+Toast.h"
#import "JHCustomerCerDatePickerView.h"
#import "NSObject+Cast.h"
#import "JHCustomerCerEditBusiness.h"
#import "JHCustomerPublishModel.h"
#import "JHAiyunOSSManager.h"
#import "SVProgressHUD.h"
#import "JHCustomerApiManager.h"
#import "IQKeyboardManager.h"

@interface JHCustomerCerEditViewController ()<
UITableViewDelegate,
UITableViewDataSource,
JHDatePickerViewDelegate>
@property (nonatomic, strong) UITableView                          *hcTabelView;
@property (nonatomic, strong) JHCustomerCerEditNavView             *navView;
@property (nonatomic, strong) JHCustomerCerEditBusiness            *business;
@property (nonatomic, strong) JHCustomerCerAddImgTableViewCell     *cell1;
@property (nonatomic, strong) JHCustomerCerAddNameTableViewCell    *cell2;
@property (nonatomic, strong) JHCustomerCerAddInstroTableViewCell  *cell3;
@property (nonatomic, strong) JHCustomerCerDatePickerView          *timePicker;
@property (nonatomic, strong) NSMutableArray                       *cellArray;
@property (nonatomic, assign) BOOL                                  isSaving;
@end

@implementation JHCustomerCerEditViewController
- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xffffff);
    self.business = [[JHCustomerCerEditBusiness alloc] init];
    self.isSaving = NO;
    [self removeNavView];
    [self setupNav];
    [self setupViews];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable                     = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable                     = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
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
    [self.navView reloadHCInfoName:@"荣誉证书" btnName:@"保存"];
    @weakify(self);
    [self.navView honnerCerEditNavViewBtnAction:^(JHHonnerCerEditButtonStyle style) {
        @strongify(self);
        switch (style) {
            case JHHonnerCerEditButtonStyle_Back: {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case JHHonnerCerEditButtonStyle_Save: {
                if (!self.isSaving) {
                    [self saveDataAndUpload];
                }
            }
                break;
            default:
                break;
        }
    }];
}

- (void)setupViews {
    [self.view addSubview:self.hcTabelView];
    [self.hcTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake([self navViewHeight], 0.f, 0.f, 0.f));
    }];
}

- (UITableView *)hcTabelView {
    if (!_hcTabelView) {
        _hcTabelView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _hcTabelView.dataSource                     = self;
        _hcTabelView.delegate                       = self;
        _hcTabelView.separatorColor                 = [UIColor clearColor];
        _hcTabelView.separatorStyle                 = UITableViewCellSeparatorStyleSingleLine;
        _hcTabelView.estimatedRowHeight             = 10.f;
        if (@available(iOS 11.0, *)) {
            _hcTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }

        [_hcTabelView registerClass:[JHCustomerCerAddImgTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomerCerAddImgTableViewCell class])];
        [_hcTabelView registerClass:[JHCustomerCerAddNameTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomerCerAddNameTableViewCell class])];
        [_hcTabelView registerClass:[JHCustomerCerAddInstroTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomerCerAddInstroTableViewCell class])];

        if ([_hcTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_hcTabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_hcTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_hcTabelView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _hcTabelView;
}


#pragma mark - Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.cell1 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomerCerAddImgTableViewCell class])];
        if (!self.cell1) {
            self.cell1 = [[JHCustomerCerAddImgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomerCerAddImgTableViewCell class])];
        }
        [self.cellArray addObject:self.cell1];
        return self.cell1;
    } else if (indexPath.row == 1) {
        self.cell2 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomerCerAddNameTableViewCell class])];
        if (!self.cell2) {
            self.cell2 = [[JHCustomerCerAddNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomerCerAddNameTableViewCell class])];
        }
        @weakify(self);
        self.cell2.addNameBlock = ^(NSString * _Nonnull str) {
            @strongify(self);
            [self.business replaceObjectStyle:JHCerEditCellStyle_Title value:str];
        };
        [self.cellArray addObject:self.cell2];
        return self.cell2;
    } else {
        self.cell3 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomerCerAddInstroTableViewCell class])];
        if (!self.cell3) {
            self.cell3 = [[JHCustomerCerAddInstroTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomerCerAddInstroTableViewCell class])];
        }
        [self.cell3 setViewModel:self.business.dataArray[indexPath.row]];
        [self.cellArray addObject:self.cell3];
        @weakify(self);
        self.cell3.addInstroBlock = ^(NSString * _Nonnull str, JHCerEditCellStyle style) {
            @strongify(self);
            [self.business replaceObjectStyle:style value:str];
        };
        return self.cell3;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self selectAlbumMethod];
    } else if (indexPath.row == 4) {
        [self.timePicker show];
    }
}

#pragma mark - load Data
- (JHCustomerCerDatePickerView *)timePicker {
    if (!_timePicker) {
        _timePicker = [[JHCustomerCerDatePickerView alloc] init];
        [_timePicker setYearLeast:([self getNowYear] - 50)];
        [_timePicker setYearSum:51];
        [_timePicker setDelegate:self];
    }
    return _timePicker;
}


- (NSInteger)getNowYear {
    NSDate *date = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy"];
    NSString *thisYearString = [dateformatter stringFromDate:date];
    return [thisYearString integerValue];
}


- (NSMutableArray *)cellArray {
    if (!_cellArray) {
        _cellArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _cellArray;
}

- (void)loadData {
    [self.cellArray removeAllObjects];
    [self.hcTabelView reloadData];
}

///选择相册
- (void)selectAlbumMethod {
    TZImagePickerController *imagePickerVc        = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePickerVc.alwaysEnableDoneBtn             = YES;
    imagePickerVc.allowTakeVideo                  = NO;
    imagePickerVc.allowPickingVideo               = NO;
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.allowPreview                    = YES;
    imagePickerVc.modalPresentationStyle          = UIModalPresentationFullScreen;
    imagePickerVc.showPhotoCannotSelectLayer      = YES;
    @weakify(self);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
         @strongify(self);
        [self.cell1 setViewModel:photos.firstObject];
        [self.business replaceObjectStyle:JHCerEditCellStyle_Image value:photos.firstObject];
        [self.cellArray removeAllObjects];
        [self.hcTabelView reloadData];
        [self uploadImage:photos];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


- (void)uploadImage:(NSArray<UIImage *> *)images {
    NSString *const aliUploadPath = @"client_publish/customize/cert";
    [SVProgressHUD show];
    @weakify(self);
    [[JHAiyunOSSManager shareInstance] uopladImage:images returnPath:aliUploadPath finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
        @strongify(self);
        [SVProgressHUD dismiss];
        if (isFinished) {
            [self.business replaceObjectStyle:JHCerEditCellStyle_Image value:imgKeys.firstObject];
        }
    }];
}

- (void)saveDataAndUpload {
    for (int i = 0; i< self.business.dataArray.count; i++) {
        NSDictionary *dict = (NSDictionary *)self.business.dataArray[i];
        if (!dict[@"value"] || isEmpty(dict[@"value"]) || [dict[@"status"] integerValue] == JHCerEditCellStatus_NoMess) {
            NSString *toast = dict[@"noMess"];
            [self.view makeToast:toast duration:1.0 position:CSToastPositionCenter];
            return;
        }
    }
    self.isSaving = YES;
    [SVProgressHUD show];
    NSString *awards          = [self.business.dataArray[JHCerEditCellStyle_Prize] objectForKey:@"value"];
    NSString *time            = [self.business.dataArray[JHCerEditCellStyle_Date] objectForKey:@"value"];
    NSString *certificateTime = [NSString stringWithFormat:@"%@-01 00:00:00",time];
    NSString *holder          = [self.business.dataArray[JHCerEditCellStyle_Owner] objectForKey:@"value"];
    NSString *imgUrl          = [self.business.dataArray[JHCerEditCellStyle_Image] objectForKey:@"value"];
    NSString *name            = [self.business.dataArray[JHCerEditCellStyle_Title] objectForKey:@"value"];
    NSString *organization    = [self.business.dataArray[JHCerEditCellStyle_Business] objectForKey:@"value"];
    
    JHCustomerEditCerPublishModel *publishModel = [[JHCustomerEditCerPublishModel alloc] init];
    publishModel.awards          = awards;
    publishModel.certificateTime = certificateTime;
    publishModel.holder          = holder;
    publishModel.imgUrl          = imgUrl;
    publishModel.name            = name;
    publishModel.organization    = organization;
    publishModel.ID              = 0;

    /// 上传
    @weakify(self);
    [JHCustomerApiManager saveCertificate:publishModel completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        [JHDispatch ui:^{
            @strongify(self);
            [SVProgressHUD dismiss];
            if (!hasError) {
                if (self.callbackMethod) {
                    self.callbackMethod();
                }
                [self.view makeToast:@"保存成功" duration:1.0 position:CSToastPositionCenter];
                [JHDispatch after:1.f execute:^{
                    self.isSaving = NO;
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                self.isSaving = NO;
                [self.view makeToast:@"保存失败，请稍后再试" duration:1.0 position:CSToastPositionCenter];
            }
        }];
    }];
}


#pragma mark - Date Delegate
- (void)pickerDate:(JHCustomerCerDatePickerView *)pickerDate
              year:(NSInteger)year
             month:(NSInteger)month {
    JHCustomerCerAddInstroTableViewCell *cell = [JHCustomerCerAddInstroTableViewCell cast:self.cellArray[4]];
    if (cell) {
        NSString *monthStr = [NSString stringWithFormat:@"%zd", month];
        if (month < 10) {
            monthStr = [NSString stringWithFormat:@"0%zd", month];
        }
        NSString *str = [NSString stringWithFormat:@"%zd-%@",year, monthStr];
        [self.business replaceObjectStyle:JHCerEditCellStyle_Date value:str];
        [cell setViewModel:self.business.dataArray[JHCerEditCellStyle_Date]];
    }
}


@end
