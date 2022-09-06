//
//  JHCustomizeCheckCompleteViewController.m
//  TTjianbao
//
//  Created by user on 2020/11/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeCheckCompleteViewController.h"
#import "JHNOAllowTabelView.h"
#import "JHCustomizeCheckProgramCompletePictsTableViewCell.h"
#import "JHCustomizeAddProgramCompleteTableViewCell.h"
#import "JHCustomizeCheckCompleteModel.h"
#import "JHCustomizeCheckCompleteBusiness.h"
#import "UIScrollView+JHEmpty.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>
#import "UIView+JHGradient.h"
#import <AVKit/AVKit.h>


@interface JHCustomizeCheckCompleteViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong)JHNOAllowTabelView *addTabelView;
@property (nonatomic, strong) NSMutableArray    *dataSourceArray;
@end

@implementation JHCustomizeCheckCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"制作完成详情";
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    [self setupViews];
    [self loadData];
}

- (CGFloat)navViewHeight {
    CGFloat navHeight = UI.statusBarHeight + 44.f;
    return navHeight;
}

- (void)setupViews {
    [self.view addSubview:self.addTabelView];
    [self.addTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake([self navViewHeight], 10.f, 0, 10.f));
    }];
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)loadData {
    if (isEmpty(self.customizeOrderId)) {
        NSLog(@"此处空页面");
        [self.addTabelView jh_reloadDataWithEmputyView];
        return;
    }
    @weakify(self);
    [JHCustomizeCheckCompleteBusiness getCustomizeCheckComplete:self.customizeOrderId Completion:^(NSError * _Nonnull error, JHCustomizeCheckCompleteModel * _Nullable model) {
        @strongify(self);
        if (error || !model) {
            NSLog(@"此处空页面 + 重试按钮");
            [self.addTabelView jh_reloadDataWithEmputyView];
            return;
        }
        [self.dataSourceArray removeAllObjects];
        [self.dataSourceArray addObject:model.worksAttachments];
        [self.dataSourceArray addObject:model.finishRemark];
        [self.addTabelView reloadData];
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
        
        [_addTabelView registerClass:[JHCustomizeCheckProgramCompletePictsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeCheckProgramCompletePictsTableViewCell class])];
        [_addTabelView registerClass:[JHCustomizeAddProgramCompleteTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeAddProgramCompleteTableViewCell class])];
        
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
        JHCustomizeCheckProgramCompletePictsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeCheckProgramCompletePictsTableViewCell class])];
        if (!cell) {
            cell = [[JHCustomizeCheckProgramCompletePictsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeCheckProgramCompletePictsTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.section]];
        @weakify(self);
        cell.pictActionBlock = ^(NSInteger index, NSArray * _Nonnull imgArr) {
            @strongify(self);
            JHCustomizeCheckCompletePictsModel *model = [JHCustomizeCheckCompletePictsModel cast:imgArr[index]];
            if (model.type == 1) {
                /// 视频
                NSURL *url = [NSURL URLWithString:model.url];
                AVPlayerViewController *ctrl = [AVPlayerViewController new];
                ctrl.player = [[AVPlayer alloc]initWithURL:url];
                [JHRootController presentViewController:ctrl animated:YES completion:nil];
            }

            NSMutableArray *photoList = [NSMutableArray array];
            for (JHCustomizeCheckCompletePictsModel *model in imgArr) {
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
    } else {
        JHCustomizeAddProgramCompleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeAddProgramCompleteTableViewCell class])];
        if (!cell) {
            cell = [[JHCustomizeAddProgramCompleteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeAddProgramCompleteTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.section]];
        return cell;
    }
}

@end
