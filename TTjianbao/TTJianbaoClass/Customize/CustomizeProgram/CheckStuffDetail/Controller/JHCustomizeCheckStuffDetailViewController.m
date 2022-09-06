//
//  JHCustomizeCheckStuffDetailViewController.m
//  TTjianbao
//
//  Created by user on 2020/11/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeCheckStuffDetailViewController.h"
#import "JHNOAllowTabelView.h"

#import "JHCustomizeCheckStuffDetailPictsTableViewCell.h"
#import "JHCustomizeCheckStuffDetailNameTableViewCell.h"
#import "JHCustomizeCheckStuffDetailCagetoryTableViewCell.h"
#import "JHCustomizeCheckStuffDetailModel.h"
#import "JHCustomizeCheckStuffDetailBusiness.h"
#import "UIScrollView+JHEmpty.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>
#import "UIView+JHGradient.h"
#import <AVKit/AVKit.h>

@interface JHCustomizeCheckStuffDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong)JHNOAllowTabelView *addTabelView;
@property (nonatomic, strong) NSMutableArray    *dataSourceArray;
@end

@implementation JHCustomizeCheckStuffDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"原料详情";
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
    [JHCustomizeCheckStuffDetailBusiness getCustomizeCheckStuffDetail:self.customizeOrderId Completion:^(NSError * _Nullable error, JHCustomizeCheckStuffDetailModel * _Nullable model) {
        [JHDispatch async:^{
            @strongify(self);
            if (error || !model) {
                NSLog(@"此处空页面 + 重试按钮");
                [self.addTabelView jh_reloadDataWithEmputyView];
                return;
            }
            [self.dataSourceArray removeAllObjects];
            [self.dataSourceArray addObject:model.materialList];
            [self.dataSourceArray addObject:[NSString stringWithFormat:@"%@",model.goodsCateName]];
            [self.dataSourceArray addObject:[NSString stringWithFormat:@"%@",model.customizeFeeName]];
            [self.addTabelView reloadData];
        }];
    }];
}

- (void)setupViews {
    [self.view addSubview:self.addTabelView];
    [self.addTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake([self navViewHeight], 10.f, 0, 10.f));
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
    
        [_addTabelView registerClass:[JHCustomizeCheckStuffDetailPictsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeCheckStuffDetailPictsTableViewCell class])];
        [_addTabelView registerClass:[JHCustomizeCheckStuffDetailNameTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeCheckStuffDetailNameTableViewCell class])];
        [_addTabelView registerClass:[JHCustomizeCheckStuffDetailCagetoryTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeCheckStuffDetailCagetoryTableViewCell class])];

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
        JHCustomizeCheckStuffDetailPictsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeCheckStuffDetailPictsTableViewCell class])];
        if (!cell) {
            cell = [[JHCustomizeCheckStuffDetailPictsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeCheckStuffDetailPictsTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.section]];
        
        
        @weakify(self);
        cell.pictActionBlock = ^(NSInteger index, NSArray * _Nonnull imgArr) {
            JHCustomizeCheckStuffDetailPictsModel *model = [JHCustomizeCheckStuffDetailPictsModel cast:imgArr[index]];
            if (model.type == 1) {
                /// 视频
                NSURL *url = [NSURL URLWithString:model.url];
                AVPlayerViewController *ctrl = [AVPlayerViewController new];
                ctrl.player = [[AVPlayer alloc]initWithURL:url];
                [JHRootController presentViewController:ctrl animated:YES completion:nil];
            }

            NSMutableArray *photoList = [NSMutableArray array];
            for (JHCustomizeCheckStuffDetailPictsModel *model in imgArr) {
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
    } else if (indexPath.section == 1) {
        JHCustomizeCheckStuffDetailNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeCheckStuffDetailNameTableViewCell class])];
        if (!cell) {
            cell = [[JHCustomizeCheckStuffDetailNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeCheckStuffDetailNameTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.section]];
        return cell;
    } else  {
        JHCustomizeCheckStuffDetailCagetoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeCheckStuffDetailCagetoryTableViewCell class])];
        if (!cell) {
            cell = [[JHCustomizeCheckStuffDetailCagetoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeCheckStuffDetailCagetoryTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.section]];
        return cell;
    }
}


@end
