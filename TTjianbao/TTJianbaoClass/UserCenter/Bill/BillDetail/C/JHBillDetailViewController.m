//
//  JHBillDetailViewController.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBillDetailViewController.h"
#import "JHBillDetailViewModel.h"
#import "JHBillDetailHeaderView.h"
#import "JHBillDetailTableViewCell.h"
#import "UIScrollView+JHEmpty.h"
#import "JHBillDetailConstraintView.h"
#import <MJRefresh.h>
@interface JHBillDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JHBillDetailViewModel *viewModel;

@property (nonatomic, weak) JHBillDetailConstraintView *constraintView;

@end

@implementation JHBillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"资金明细";
    
//    [self jhNavBottomLine];
    
    [self initRightButtonWithName:@"筛选" action:@selector(rightActionButton:)];
    [self.jhRightButton setImage:[UIImage imageNamed:@"icon_shop_bill_triangle_1"] forState:UIControlStateSelected];
    [self.jhRightButton setImage:[UIImage imageNamed:@"icon_shop_bill_triangle_0"] forState:UIControlStateNormal];
    self.jhRightButton.jh_titleColor(RGB(102, 102, 102));
    
    self.jhRightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, -30);
    self.jhRightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [self.viewModel.requestCommand execute:nil];
    
}

#pragma mark ---------------------------- delegate ----------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHBillDetailTableViewCell *cell = [JHBillDetailTableViewCell dequeueReusableCellWithTableView:tableView];
    cell.moneyLabel.text = [JHBillDetailViewModel numberFormatter:@123333.0123];
    if (indexPath.row < self.viewModel.dataArray.count) {
        JHBillDetailModel *model = self.viewModel.dataArray[indexPath.row];
        cell.titleLabel.text = NONNULL_STR(model.optName);
        cell.descLabel.text  = NONNULL_STR(model.serialNoOrRemark);
        cell.moneyLabel.text = NONNULL_STR(model.changeMoneyStr);
        cell.timeLabel.text  = NONNULL_STR(model.flowDate);
        cell.cellIndex       = indexPath.row;
        
        if (!isEmpty(model.remark)) {
            cell.remarkLabel.text = NONNULL_STR(model.remark);
            CGSize size = [model.remark boundingRectWithSize:CGSizeMake(ScreenW - 20.f - 15.f - 155.f, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{
                                                       NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                                       NSFontAttributeName:[UIFont systemFontOfSize:12.f]
                                                   } context:nil].size;
            [cell.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.descLabel.mas_bottom).offset(3.f);
                make.height.mas_equalTo(12.f);
            }];
            if (size.height >= 22.f) {
                cell.moreBtn.hidden = NO;
            } else {
                cell.moreBtn.hidden = YES;
            }
            @weakify(cell);
            cell.buttonBlock = ^(BOOL showAll) {
                @strongify(cell);
                [tableView beginUpdates];
                if (showAll) {
                    [cell.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.descLabel.mas_bottom).offset(3.f);
                        make.height.mas_equalTo(size.height);
                    }];
                } else {
                    [cell.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.descLabel.mas_bottom).offset(3.f);
                        make.height.mas_equalTo(12.f);
                    }];
                }
                [tableView endUpdates];
            };
        } else {
            cell.moreBtn.hidden = YES;
            cell.remarkLabel.text = @"";
            [cell.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.descLabel.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
        }
        
        if (model.sign.length == 1) {
            if ([model.sign hasPrefix:@"+"]) {
             cell.moneyLabel.textColor = RGB(255, 66, 0);
            } else if ([model.sign hasPrefix:@"-"]) {
                cell.moneyLabel.textColor = RGB(255, 66, 0);
            } else {
                cell.moneyLabel.textColor = RGB(255, 66, 0);
            }
        } else {
            cell.moneyLabel.textColor = RGB(255, 66, 0);
        }
    }
    return cell;
}

#pragma mark ---------------------------- method ----------------------------
-(void)rightActionButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (_constraintView) {
        [_constraintView removeFromSuperview];
    }
    else
    {
        [self constraintView];
    }
    
}

#pragma mark ---------------------------- get set ----------------------------
-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStyleGrouped separatorStyle:UITableViewCellSeparatorStyleSingleLine target:self addToSuperView:self.view];
        JHBillDetailHeaderView *headerView = [[JHBillDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30.f)];
        headerView.accountDate = self.accountDate;
        _tableView.tableHeaderView = headerView;
        _tableView.backgroundColor = RGB(248, 248, 248);
        _tableView.separatorColor = RGB(238, 238, 238);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
//        _tableView.estimatedRowHeight = 72.f;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.jhNavView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        @weakify(self);
        [_tableView jh_headerWithRefreshingBlock:^{
            @strongify(self);
            self.viewModel.pageIndex = 0;
            [self.viewModel.requestCommand execute:nil];
        } footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel.requestCommand execute:nil];
        }];
    }
    return _tableView;
}

-(JHBillDetailViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [JHBillDetailViewModel new];
        _viewModel.pageIndex = 0;
        _viewModel.pageSize  = 50;
        _viewModel.status    = 0;
        @weakify(self);
        [_viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.tableView jh_endRefreshing];
            [self.tableView jh_reloadDataWithEmputyView];
        }];
    }
    return _viewModel;
}

-(JHBillDetailConstraintView *)constraintView
{
    if (!_constraintView) {
        JHBillDetailConstraintView *constraintView = [JHBillDetailConstraintView new];
        [self.view addSubview:constraintView];
        constraintView.result = self.viewModel.status;
       // [constraintView reloadSelfView];
        [constraintView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.jhNavView.mas_bottom);
        }];
        @weakify(self);
        constraintView.resultBlock = ^(NSInteger result) {
            @strongify(self);
            self.viewModel.status    = result;
            self.viewModel.pageIndex = 0;
            [self.viewModel.requestCommand execute:nil];
            self.jhRightButton.selected = !self.jhRightButton.selected;
        };
        _constraintView = constraintView;
    }
    return _constraintView;
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
