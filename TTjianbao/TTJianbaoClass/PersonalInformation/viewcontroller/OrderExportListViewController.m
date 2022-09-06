//
//  OrderExportListViewController.h
//  TTjianbao
//
//  Created by jiang on 2019/8/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "OrderExportListViewController.h"
#import "JHOrderListTableViewCell.h"
#define pagesize 10
#define cellRate (float)  201/345
#import "JHOrderSegmentView.h"
#import "OrderExportTableViewCell.h"
#import "HttpDownLoadFileTool.h"
#import "NaiveShareManager.h"

@interface OrderExportListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger PageNum;
    NSArray* rootArr;
}
@property(nonatomic,strong) UITableView* homeTable;
@property(nonatomic,strong) NSMutableArray<ExportOrderMode*>* exportModes;
@property(nonatomic,strong)  NSString * searchStatus;
@end

@implementation OrderExportListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    [self  initToolsBar];
//    [self.navbar setTitle:@"订单导出记录"];
    self.title = @"订单导出记录";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.exportModes=[NSMutableArray arrayWithCapacity:10];
    
    [self.view addSubview:self.homeTable];
    __weak typeof(self) weakSelf = self;
    
    self.homeTable.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    self.homeTable.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.homeTable.mj_footer.hidden=YES;
    [self.homeTable.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}
-(void)loadNewData{
    
    PageNum=0;
    [self requestInfo];
}
-(void)loadMoreData{
    
    PageNum++;
    [self requestInfo];
}

-(void)requestInfo{
    
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/exportlogs?pageNo=%ld&pageSize=%ld"),PageNum,pagesize];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self handleDataWithArr:respondObject.data];
        [self endRefresh];
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        
        [self endRefresh];
    }];
}

- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr = [ExportOrderMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.exportModes = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.exportModes addObjectsFromArray:arr];
    }
    
    [self.homeTable reloadData];
    
    if ([arr count]<pagesize) {
        
        self.homeTable.mj_footer.hidden=YES;
    }
    else{
        self.homeTable.mj_footer.hidden=NO;
    }
}
- (void)endRefresh {
    
    [self.homeTable.mj_header endRefreshing];
    [self.homeTable.mj_footer endRefreshing];
    if (self.exportModes.count) {
        [self hiddenDefaultImage];
    }else {
        [self showDefaultImageWithView:self.homeTable];
    }
}

-(UITableView*)homeTable{
    
    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight)                                      style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
        _homeTable.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    return _homeTable;
}
#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.exportModes.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"cellIdentifier";
    
    OrderExportTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[OrderExportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        MJWeakSelf
        cell.buttonClick = ^(NSIndexPath *indexPath) {
            [weakSelf exportOrder:[weakSelf.exportModes objectAtIndex:indexPath.section]];
        };
    }
    cell.indexPath=indexPath;
    [cell setMode:self.exportModes [indexPath.section]];
    
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  90;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        return 10;
    }
    return 5;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView  *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)exportOrder:(ExportOrderMode*)mode{
    
    NSString *fullPath =  [NSString stringWithFormat:@"%@/%@%@",[HttpDownLoadFileTool shareInstance ].orderDirectory,mode.orderTime,@".pdf"];
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        NSLog(@"这个文件已经存在");
        [[NaiveShareManager shareInstance] nativeShare:fullPath];
    }
    else {
       [[HttpDownLoadFileTool shareInstance ]downLoadFileByURL:mode.docUrl andFilePath:fullPath progress:^(NSProgress * _Nonnull downloadProgress) {
        [SVProgressHUD showProgress:1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount status:@"正在导出中" maskType:SVProgressHUDMaskTypeGradient];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
         [SVProgressHUD dismiss];
          [[NaiveShareManager shareInstance] nativeShare:filePath.path];
    }];
    [SVProgressHUD show];
    
  }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end






