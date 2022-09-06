//
//  JHFoucsShopListController.m
//  TTjianbao
//
//  Created by apple on 2020/2/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHStoneDetailSectionFooterView.h"
#import "JHShopHomeController.h"
#import "JHFoucsShopListController.h"
#import "JHFoucsShopListInfoCell.h"
#import "JHFoucsShopListImageCell.h"
#import "UIScrollView+JHEmpty.h"
#import "JHFoucsListShopViewModel.h"
#import "GrowingManager.h"
#import "JHNewShopDetailViewController.h"

@interface JHFoucsShopListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) JHFoucsListShopViewModel *viewModel;

@end

@implementation JHFoucsShopListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.jhNavView.hidden = YES;
    
    [self.viewModel.requestCommand execute:@1];
}

#pragma mark --------------- UITableViewDelegate DataSource ---------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.viewModel.dataArray.count;
    return self.viewModel.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section < self.viewModel.dataArray.count)
    {
        JHFoucsShopInfo *model = self.viewModel.dataArray[section];
        if (model.goodsArray.count >= 1) {
            return 2;
        }
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 55;
    }
    return [JHFoucsShopListImageCell cellSize].height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    JHStoneDetailSectionFooterView *footer = [JHStoneDetailSectionFooterView dequeueReusableHeaderFooterViewWithTableView:tableView];
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JHStoneDetailSectionFooterView *header = [JHStoneDetailSectionFooterView dequeueReusableHeaderFooterViewWithTableView:tableView];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHFoucsShopInfo *model = nil;
    if(indexPath.section < self.viewModel.dataArray.count)
    {
        model = self.viewModel.dataArray[indexPath.section];
    }
    if (indexPath.row == 0) {
        JHFoucsShopListInfoCell *cell = [JHFoucsShopListInfoCell dequeueReusableCellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
    else{//row = 1
        JHFoucsShopListImageCell *cell = [JHFoucsShopListImageCell dequeueReusableCellWithTableView:tableView];
        @weakify(self);
        cell.enterShopBlock = ^{
            @strongify(self);
            if(indexPath.section < self.viewModel.dataArray.count)
            {
                [self enterShopPageIndex:indexPath.section];
            }
        };
        
        cell.goodsArray = model.goodsArray;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section < self.viewModel.dataArray.count)
    {
        [self enterShopPageIndex:indexPath.section];
    }
}

-(void)enterShopPageIndex:(NSInteger)index
{
    
    @weakify(self);
    JHFoucsShopInfo *model = self.viewModel.dataArray[index];
    JHNewShopDetailViewController *shopVC = [[JHNewShopDetailViewController alloc] init];
    shopVC.shopId = model.sellerId;
    
    [[RACObserve(shopVC, isFollow) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        BOOL isFollow = [x boolValue];
        BOOL curIsFocus = (model.followed.intValue == 1);
        if (isFollow != curIsFocus) {
            model.followed = isFollow == true ? @0 : @1;
            [JHFoucsListShopViewModel changeFocusStatuModel:model];
            [self.tableView reloadData];
        }
    }];

    [self.navigationController pushViewController:shopVC animated:YES];
    
    //埋点：进入店铺
    [self GIOEnterShopPage:model.sellerId];
}

//埋点：进入店铺
- (void)GIOEnterShopPage:(NSString *)sellerId {
    [GrowingManager enterShopHomePage:@{@"shopId":sellerId,
                                        @"from":JHFromStoreFollowShopList
    }];
}

-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStyleGrouped separatorStyle:UITableViewCellSeparatorStyleNone target:self addToSuperView:self.view];
        _tableView.sectionFooterHeight = 10.f;
        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
        self.tableView.backgroundColor = RGB(248, 248, 248);
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        @weakify(self);
        [_tableView jh_headerWithRefreshingBlock:^{
            @strongify(self);
            self.viewModel.pageIndex = 1;
            [self.viewModel.requestCommand execute:@1];
            if(self.updateNumberBlock){
                self.updateNumberBlock();
            }
        } footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel.requestCommand execute:@1];
        }];
    }
    return _tableView;
}

#pragma mark --------------- get set ---------------

-(JHFoucsListShopViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [JHFoucsListShopViewModel new];
        _viewModel.pageIndex = 1;
        _viewModel.pageSize = 20;
        _viewModel.userId = self.userId;
        @weakify(self);
        [_viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.tableView jh_reloadDataWithEmputyView];
            [self.tableView jh_endRefreshing];
        }];
    }
    return _viewModel;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
