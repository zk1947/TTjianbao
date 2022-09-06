//
//  LookLogisticsViewController.m
//  TaoDangPuMall
//
//  Created by jiangchao on 2017/2/14.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "JHExpressViewController.h"
#import "JHExpressTableViewCell.h"
#import "JHExpressHeaderView.h"
#import "JHOrderExpressViewMode.h"
#import "JHExpressSectionHeaderView.h"

@interface JHExpressViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    JHExpressHeaderView* headerView;
}
@property (nonatomic, strong) UITableView* homeTable;
@property (nonatomic, strong) ExpressVo *expressMode;
@property (nonatomic, strong) JHOrderExpressViewMode *viewModel;
@end

@implementation JHExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看物流";
    [self setHeaderView];
    [self.view addSubview:self.homeTable];
    [self bindData];
    [self.viewModel getExpressInfo];
}

#pragma mark - Bind
- (void)bindData {
    @weakify(self)
    [self.viewModel.refreshTableView subscribeNext:^(id  _Nullable x) {
        @strongify(self)
      
        headerView.expressStep = self.viewModel.expressStep;
        [self.homeTable reloadData];
    }];
}
- (UITableView*)homeTable{
    
    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight) style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
        _homeTable.estimatedRowHeight = 100;
        _homeTable.tableHeaderView=headerView;
        _homeTable.backgroundColor=HEXCOLOR(0xf5f6fa);;
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _homeTable;
}
- (JHOrderExpressViewMode *)viewModel {
    if (!_viewModel) {
        _viewModel = [[JHOrderExpressViewMode alloc] init];
        _viewModel.orderId = self.orderId;
    }
    return _viewModel;
}

- (void)setHeaderView
{
     headerView=[[JHExpressHeaderView alloc]initWithFrame:CGRectMake(0, 0,0,100)];
}
#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.viewModel.sectionList.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    JHOrderExpressSectionMode *sectionModel = self.viewModel.sectionList[section];
    if (sectionModel.sectionType == JHExpressSectionSellerSend) {
        return self.viewModel.orderStatusModel.orderStatusLogVos.count;
    }
   else if (sectionModel.sectionType == JHExpressSectionPlatAppraise) {
        return self.viewModel.orderMlOptHisVos.count;
    }
   else if (sectionModel.sectionType == JHExpressSectionPlatSend) {
       
        return self.viewModel.platSendExpressVo.data.count;
    }
    return  0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *SimpleTableIdentifier = @"Expressdentifier";
    JHExpressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    JHOrderExpressSectionMode *sectionModel = self.viewModel.sectionList[indexPath.section];
    if(cell == nil){
    cell = [[JHExpressTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    cell.accessoryType=UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (sectionModel.sectionType == JHExpressSectionSellerSend) {
        [cell setOrderStatusLogMode:self.viewModel.orderStatusModel.orderStatusLogVos[indexPath.row]];
        [cell setCellIndex:indexPath.row andListCount:self.viewModel.orderStatusModel.orderStatusLogVos.count andViewMode:self.viewModel andSectionType:sectionModel.sectionType];
    }
    else if (sectionModel.sectionType == JHExpressSectionPlatAppraise) {
        [cell  setExpressAppraiseMode:self.viewModel.orderMlOptHisVos[indexPath.row]];
        [cell setCellIndex:indexPath.row andListCount:self.viewModel.orderMlOptHisVos.count andViewMode:self.viewModel andSectionType:sectionModel.sectionType];
    }
    else if (sectionModel.sectionType == JHExpressSectionPlatSend)   {
        [cell setExpressMode:self.viewModel.platSendExpressVo.data[indexPath.row]];
        [cell setCellIndex:indexPath.row andListCount:self.viewModel.platSendExpressVo.data.count andViewMode:self.viewModel andSectionType:sectionModel.sectionType];
    }
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
      return  UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    JHOrderExpressSectionMode *sectionModel = self.viewModel.sectionList[section];
    return sectionModel.headerHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JHExpressSectionHeaderView *header = [JHExpressSectionHeaderView dequeueReusableHeaderFooterViewWithTableView:tableView];
    header.backgroundColor=[UIColor whiteColor];
    JHOrderExpressSectionMode *sectionModel = self.viewModel.sectionList[section];
    header.cellType = sectionModel.sectionType;
    if (sectionModel.sectionType == JHExpressSectionPlatSend) {
        [header setPlatSendExpressVo:self.viewModel.platSendExpressVo];
    }
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=HEXCOLOR(0xf5f6fa);
    
    return headerView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)requestData {
//    NSString *string = [NSString stringWithFormat:@"/auth/express/%@",self.orderId];
//    [HttpRequestTool getWithURL:FILE_BASE_STRING(string) Parameters:nil successBlock:^(RequestModel *respondObject) {
//
//        [SVProgressHUD dismiss];
//        self.expressMode = [ExpressVo mj_objectWithKeyValues:respondObject.data];
//        headerView.model = self.expressMode;
//        [self.homeTable reloadData];
//
//    } failureBlock:^(RequestModel *respondObject) {
//
//        [SVProgressHUD dismiss];
//        [self.view makeToast:respondObject.message];
//    }];
//
//    [SVProgressHUD show];
//}

@end

