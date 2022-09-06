//
//  JHRedPacketDetailController.m
//  TTjianbao
//
//  Created by apple on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRedPacketDetailController.h"
#import "JHRedPacketFullTableViewCell.h"
#import "JHRedPacketDetailHeader.h"
#import "UIScrollView+JHEmpty.h"

@interface JHRedPacketDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) JHRedPacketDetailViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JHRedPacketDetailHeader *header;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation JHRedPacketDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"领取详情";
    [self jhSetLightStatusBarStyle];
    self.jhNavView.backgroundColor = UIColor.clearColor;
    [self tableView];
    [self jhBringSubviewToFront];
    
    _tipLabel = [UILabel jh_labelWithText:@"未领取的红包将于24小时后退回" font:12 textColor:RGB(153, 153, 153) textAlignment:1 addToSuperView:self.view];
    _tipLabel.backgroundColor = RGB(245, 245, 245);
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35.f);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.viewModel.requestCommand execute:@1];
}

#pragma mark --------------- method ---------------
-(void)reladHeaderData
{
    JHGetRedpacketModel *model = self.viewModel.dataSources;
    [self.header setWishes:model.wishes price:model.takeMoney avavtorUrl:model.sendCustomerImg name:model.sendCustomerName descStr:model.countDesc];
    [self.tableView reloadData];
}

- (void)balanceClick
{
    [JHRouterManager pushAllowanceWithController:self];
}

#pragma mark --------------- tabViewDelegate ---------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSources.takeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRedPacketFullTableViewCell *cell = [JHRedPacketFullTableViewCell dequeueReusableCellWithTableView:tableView];
    NSArray *array = self.viewModel.dataSources.takeList;
    if(indexPath.row < array.count){
        JHGetRedpacketDetailModel *model = array[indexPath.row];
        cell.model = model;
    }
    return cell;
}


#pragma mark --------------- scrollview ---------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if (contentOffsetY < [JHRedPacketDetailHeader viewHeight] - UI.statusAndNavBarHeight - 97) {
        [self jhSetLightStatusBarStyle];
        self.jhNavView.backgroundColor = UIColor.clearColor;
    }
    else
    {
        [self jhSetBlackStatusBarStyle];
        self.jhNavView.backgroundColor = UIColor.whiteColor;
    }
}

#pragma mark --------------- get set ---------------
-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLine target:self addToSuperView:self.view];
        _tableView.tableHeaderView = self.header;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1.f)];
        _tableView.rowHeight = 65.f;
        _tableView.backgroundColor = RGB(245.f, 245.f, 245.f);
        _tableView.separatorColor = RGB(238.f, 238.f, 238.f);
        _tableView.separatorInset = UIEdgeInsetsMake(0.f, 15.f, 0.f, 15.f);
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 35.f, 0));
        }];
        @weakify(self);
        [_tableView jh_headerWithRefreshingBlock:nil footerWithRefreshingBlock:^{
            @strongify(self);
            if(self.viewModel.dataSources.tips2)
            {
                _tipLabel.text = self.viewModel.dataSources.tips2;
            }
            self.viewModel.pageIndex = 1;
            [self.viewModel.requestCommand execute:@1];
            [self.tableView jh_endRefreshing];
        }];
    }
    return _tableView;
}

- (JHRedPacketDetailHeader *)header
{
    if(!_header){
        _header = [[JHRedPacketDetailHeader alloc]initWithFrame:CGRectMake(0, 0, ScreenW, [JHRedPacketDetailHeader viewHeight])];
        @weakify(self);
        _header.balanceClickBlock = ^{
            @strongify(self);
            [self balanceClick];
        };
    }
    return _header;
}

-(JHRedPacketDetailViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [JHRedPacketDetailViewModel new];
        _viewModel.pageIndex = 0;
        _viewModel.pageSize = 100;
        @weakify(self);
        [_viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self reladHeaderData];
            [self.tableView jh_endRefreshing];
        }];
    }
    _viewModel.redPacketId = _redPacketId;
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
