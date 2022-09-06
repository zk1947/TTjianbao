//
//  JHCustomizeCheckProgramViewController.m
//  TTjianbao
//
//  Created by user on 2020/11/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeCheckProgramViewController.h"
#import "JHNOAllowTabelView.h"
#import "UIView+JHGradient.h"
#import "JHCustomizeCheckProgramStatsusTableViewCell.h"
#import "JHCustomizeCheckProgramMoneyTableViewCell.h"
#import "JHCustomizeCheckProgramDesTableViewCell.h"
#import "JHCustomizeCheckProgramPictsTableViewCell.h"
#import "JHCustomizeCheckProgramCagetoryTableViewCell.h"
#import "JHCustomizeCheckProgramBusiess.h"
#import "UIView+Toast.h"
#import "SVProgressHUD.h"
#import "UserInfoRequestManager.h"
#import "UIScrollView+JHEmpty.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>
#import "UIView+JHGradient.h"
#import <AVKit/AVKit.h>


@interface JHCustomizeCheckProgramViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) JHNOAllowTabelView *addTabelView;
@property (nonatomic, strong) UIButton           *deleteProBtn;
@property (nonatomic, assign) BOOL                isUser; /// 是否是用户，用于区分当前是用户还是主播
@property (nonatomic, strong) NSMutableArray     *dataSourceArray;
@property (nonatomic, strong) UIView             *backView;
@property (nonatomic, strong) NSString           *mStatus;
@end

@implementation JHCustomizeCheckProgramViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看定制方案";
    self.isUser = !self.isSeller;
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    [self setupViews];
    [self loadData];
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
    
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(54.f + [self bottomSpace]);
    }];
    
    _deleteProBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteProBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [_deleteProBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _deleteProBtn.titleLabel.font      = [UIFont fontWithName:kFontNormal size:16.f];
    _deleteProBtn.hidden = YES;
    [_deleteProBtn addTarget:self action:@selector(deleteProBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _deleteProBtn.layer.cornerRadius   = 22.f;
    _deleteProBtn.layer.masksToBounds  = YES;
    [self.view addSubview:_deleteProBtn];
    [_deleteProBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-[self bottomSpace]);
        make.left.equalTo(self.view.mas_left).offset(28.f);
        make.right.equalTo(self.view.mas_right).offset(-28.f);
        make.height.mas_equalTo(44.f);
    }];
    
    self.backView.hidden = YES;
    self.deleteProBtn.hidden = YES;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)loadData {
    if (isEmpty(self.customizePlanId)) {
        NSLog(@"此处空页面");
        [self.addTabelView jh_reloadDataWithEmputyView];
        return;
    }
    [SVProgressHUD show];
    @weakify(self);
    [JHCustomizeCheckProgramBusiess getCustomizeCheckProgram:self.customizePlanId Completion:^(NSError * _Nonnull error, JHCustomizeCheckProgramModel * _Nullable model) {
        [JHDispatch async:^{
            @strongify(self);
            [SVProgressHUD dismiss];
            if (error || !model) {
                NSLog(@"此处空页面 + 重试按钮");
                [self.addTabelView jh_reloadDataWithEmputyView];
                return;
            }
            self.backView.hidden = NO;
            self.deleteProBtn.hidden = NO;
            [self.dataSourceArray removeAllObjects];
            [self.dataSourceArray addObject:NONNULL_STR(model.customizeFeeName)];
            [self.dataSourceArray addObject:model.attachmentVOs.count>0?model.attachmentVOs:@[]];
            [self.dataSourceArray addObject:NONNULL_STR(model.planDesc)];
            [self.dataSourceArray addObject:@{
                @"extPrice":NONNULL_STR(model.extPrice),
                @"planDesc":NONNULL_STR(model.planPrice)
            }];
            [self.dataSourceArray addObject:NONNULL_STR(model.status)];
            self.mStatus = NONNULL_STR(model.status);
            if (self.isUser) {
                /// 用户
                 self.deleteProBtn.hidden = YES;
            } else {
                /// 状态 0 待提交 1 待确认 2 已确认 3 拒绝 ,
                if ([model.status isEqualToString:@"0"] || [model.status isEqualToString:@"1"]) {
                    self.deleteProBtn.hidden = NO;
                    [self.deleteProBtn setTitle:@"确认删除" forState:UIControlStateNormal];
                } else {
                    self.deleteProBtn.hidden = YES;
                }
            }
            [self.addTabelView reloadData];
        }];
    }];
}


/// 点击
- (void)deleteProBtnAction:(UIButton *)sender {
    if (!self.isUser) { /// 主播端
       /// 删除
       [self deleteCustomizePlanAndOrder];
    }
}

/// 删除方案
- (void)deleteCustomizePlanAndOrder {
    if (isEmpty(self.customizePlanId) || isEmpty(self.customizeOrderId)) {
        [self.view makeToast:@"删除失败，请稍后重试" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    [SVProgressHUD show];
    @weakify(self);
    [JHCustomizeCheckProgramBusiess deleteCustomizeCheckProgram:self.customizePlanId customizeOrderId:self.customizeOrderId Completion:^(NSError * _Nullable error) {
        [JHDispatch ui:^{
            [SVProgressHUD dismiss];
            @strongify(self);
            if (error) {
                [self.view makeToast:@"删除失败，请稍后重试" duration:1.0 position:CSToastPositionCenter];
            } else {
                [self.view makeToast:@"删除成功" duration:1.0 position:CSToastPositionCenter];
                [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];
                [JHDispatch after:1.f execute:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    }];
}

/// 提交方案
- (void)makeSureCustomizeOrder {
//    if (isEmpty(self.customizeOrderId)) {
//        [self.view makeToast:@"提交失败，请稍后重试" duration:1.0 position:CSToastPositionCenter];
//        return;
//    }
//    @weakify(self);
//    [JHCustomizeCheckProgramBusiess uploadCustomizeCheckProgram:self.customizeOrderId Completion:^(NSError * _Nullable error) {
//        [JHDispatch ui:^{
//            @strongify(self);
//            if (error) {
//                [self.view makeToast:@"提交失败，请稍后重试" duration:1.0 position:CSToastPositionCenter];
//            } else {
//                [self.view makeToast:@"提交成功" duration:1.0 position:CSToastPositionCenter];
//                [JHDispatch after:1.f execute:^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                }];
//            }
//        }];
//    }];
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
        
        [_addTabelView registerClass:[JHCustomizeCheckProgramCagetoryTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeCheckProgramCagetoryTableViewCell class])];
        [_addTabelView registerClass:[JHCustomizeCheckProgramPictsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeCheckProgramPictsTableViewCell class])];
        [_addTabelView registerClass:[JHCustomizeCheckProgramDesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeCheckProgramDesTableViewCell class])];
        [_addTabelView registerClass:[JHCustomizeCheckProgramMoneyTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeCheckProgramMoneyTableViewCell class])];
        [_addTabelView registerClass:[JHCustomizeCheckProgramStatsusTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeCheckProgramStatsusTableViewCell class])];
        
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
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JHCustomizeCheckProgramCagetoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeCheckProgramCagetoryTableViewCell class])];
        if (!cell) {
            cell = [[JHCustomizeCheckProgramCagetoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeCheckProgramCagetoryTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.section]];
        return cell;
    } else if (indexPath.section == 1) {
        JHCustomizeCheckProgramPictsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeCheckProgramPictsTableViewCell class])];
        if (!cell) {
            cell = [[JHCustomizeCheckProgramPictsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeCheckProgramPictsTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.section]];
        @weakify(self);
        cell.pictActionBlock = ^(NSInteger index, NSArray * _Nonnull imgArr) {
            @strongify(self);
            JHCustomizeCheckProgramPictsModel *model = [JHCustomizeCheckProgramPictsModel cast:imgArr[index]];
            if (model.type == 1) {
                /// 视频
                NSURL *url = [NSURL URLWithString:model.url];
                AVPlayerViewController *ctrl = [AVPlayerViewController new];
                ctrl.player = [[AVPlayer alloc]initWithURL:url];
                [JHRootController presentViewController:ctrl animated:YES completion:nil];
            }

            NSMutableArray *photoList = [NSMutableArray array];
            for (JHCustomizeCheckProgramPictsModel *model in imgArr) {
                if (model.type == 0) {
                    GKPhoto *photo = [[GKPhoto alloc]init];
                    photo.url = [NSURL URLWithString:model.url];
                    [photoList addObject:photo];
                } else {
                    index = index-1>0?index-1:0;
                }
            }
            
            GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoList currentIndex:index];
            browser.isStatusBarShow = YES;
            browser.isScreenRotateDisabled = YES;
            browser.showStyle = GKPhotoBrowserShowStyleNone;
            browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
            [browser showFromVC:self];
        };
        return cell;
    } else if (indexPath.section == 2) {
        JHCustomizeCheckProgramDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeCheckProgramDesTableViewCell class])];
        if (!cell) {
            cell = [[JHCustomizeCheckProgramDesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeCheckProgramDesTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.section]];
        return cell;
    } else if (indexPath.section == 3) {
        JHCustomizeCheckProgramMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeCheckProgramMoneyTableViewCell class])];
        if (!cell) {
            cell = [[JHCustomizeCheckProgramMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeCheckProgramMoneyTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.section]];
        return cell;
    } else {
        JHCustomizeCheckProgramStatsusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeCheckProgramStatsusTableViewCell class])];
        if (!cell) {
            cell = [[JHCustomizeCheckProgramStatsusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeCheckProgramStatsusTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.section]];
        return cell;
    }
}


@end
