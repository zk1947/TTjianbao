//
//  JHAllowanceDetailController.m
//  TTjianbao
//
//  Created by apple on 2020/2/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "NSString+Common.h"
#import "JHAllowanceDetailController.h"
#import "JHAllowanceDetailDescCell.h"
#import "JHAllowanceDetailMoneyCell.h"
#import "JHAllowanceListModel.h"
@interface JHAllowanceDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JHAllowanceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(245, 245, 245);
    
    [self updateUI];
    
}

-(void)updateUI{
    self.title = _model.isGetMoney ? @"获取详情" : @"支出详情";
    
    _dataArray = [NSMutableArray arrayWithCapacity:5];
    if (_model.isGetMoney) {
        [_dataArray addObject:@[@"有效期至",[NSString notEmpty:_model.expiredDate]]];
    }
    [_dataArray addObject:@[@"津贴总数", [NSString notEmpty:_model.changeAfterAmount]]];
    [_dataArray addObject:@[@"详情", [NSString notEmpty:_model.describe]]];
    [_dataArray addObject:@[_model.isGetMoney ? @"获取时间" : @"支出时间", [NSString notEmpty:_model.createDate]]];
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.dataArray.count;
    }
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, CGFLOAT_MIN)];
    view.backgroundColor = RGB(245, 245, 245);
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    view.backgroundColor = RGB(245, 245, 245);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? [JHAllowanceDetailMoneyCell cellHeight] : [JHAllowanceDetailDescCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0)
    {
        JHAllowanceDetailMoneyCell *cell = [JHAllowanceDetailMoneyCell dequeueReusableCellWithTableView:tableView];
        cell.titleLabel.text = self.model.name;
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@ %@",_model.changeType,_model.changeAmount];
        cell.moneyLabel.textColor = _model.isGetMoney ? HEXCOLOR(0xFF4200) : HEXCOLOR(0x222222);
        return cell;
    }
    
    JHAllowanceDetailDescCell *cell = [JHAllowanceDetailDescCell dequeueReusableCellWithTableView:tableView];
    if(indexPath.row < self.dataArray.count)
    {
        cell.titleLabel.text = self.dataArray[indexPath.row][0];
        cell.descLabel.text = self.dataArray[indexPath.row][1];
    }
    return cell;
}

-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStyleGrouped separatorStyle:UITableViewCellSeparatorStyleNone target:self addToSuperView:self.view];
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        _tableView.sectionHeaderHeight = 10;
        _tableView.backgroundColor = RGB(245, 245, 245);
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.jhNavView.mas_bottom);
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
        }];
    }
    return _tableView;
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
