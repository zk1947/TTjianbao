//
//  JHAppraiseOrderViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2019/9/16.
//  Copyright © 2019年 Netease. All rights reserved.
//
#import "JHAppraiseOrderViewController.h"
#import "JHAppraiseOrderTableViewCell.h"
#import "JHOrderDetailViewController.h"
#import "JHOrderPayViewController.h"
#import "JHQYChatManage.h"
#define pagesize 10
#define cellRate (float)  201/345
#import "JHOrderSegmentView.h"
#import "JHSendCommentViewController.h"
#import "OrderDateChooseView.h"
#import "JHOrderExportSuccessView.h"
#import "NaiveShareManager.h"
#import "JHSellerSendOrderViewController.h"
#import "JHOrderListSegmentView.h"
#import "CommAlertView.h"
#import "JHOrderReturnViewController.h"
#import "JHQRViewController.h"
#import "JHWebViewController.h"
#import "JHQRViewController.h"
#import "JHUploadVideoViewController.h"
#import "JHLiveRoomMode.h"
#import "BYTimer.h"

@interface JHAppraiseOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSInteger PageNum;
    NSArray* rootArr;
    JHOrderListSegmentView *  headerView;
    JHLiveRoomMode * selectLiveRoom;
    BYTimer *timer;
    float titleViewHeight;
}
@property(nonatomic,strong) UITableView* homeTable;
@property(nonatomic,strong) NSMutableArray* orderModes;
@property(nonatomic,strong) NSMutableArray* bannerModes;
@property(nonatomic,strong)  NSString * searchStatus;
@property (nonatomic,strong)UIDocumentInteractionController * document;
@property (nonatomic,strong)UIButton * scanBtn;
@property (nonatomic,strong)   OrderMode * selectMode;
@property (nonatomic,strong)   UITextField * searchBar;
@end

@implementation JHAppraiseOrderViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.searchStatus=@"problem";
        // self.searchStatus=@"all";
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self  initToolsBar];
//    [self.navbar setTitle:@"我的鉴定单"];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"我的鉴定单";
    [self initSearchView];
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
-(void)initSearchView{
    
    UIView * view=[[UIView alloc]init];
    view.backgroundColor=[CommHelp  toUIColorByStr:@"#ffffff"];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.offset(48);
        make.width.offset(ScreenW);
    }];
    
    UIView * searchView=[[UIView alloc]init];
    searchView.backgroundColor=[CommHelp  toUIColorByStr:@"#f2f2f2"];
    [view addSubview:searchView];
    
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view).offset(-50);
        make.height.offset(30);
    }];
    
    UIImageView * logo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dis_glasses"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [searchView addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchView).offset(10);
        make.centerY.equalTo(searchView);
    }];
    
    [searchView addSubview:self.searchBar];
    [ self.searchBar  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logo.mas_right).offset(5);
        make.centerY.equalTo(logo);
        make.height.offset(30);
        make.right.offset(0);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"icon_scan_code"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(scanCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    [ btn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(0);
        make.centerY.equalTo(view);
        make.height.offset(48);
        make.width.offset(50);
    }];
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
    NSString *url;
    if (self.searchBar.text.length==0) {
    url =FILE_BASE_STRING(@"/order/auth/waitAppraiseNew");
    }
    else{
    url =[NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/appriasOrdereNew?code=%@"),self.searchBar.text?self.searchBar.text:@""];
    }
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        if ([respondObject.data isKindOfClass:[NSDictionary class]]) {
               [self handleDataWithArr:[NSArray arrayWithObject:respondObject.data]];
        }
        else{
              [self handleDataWithArr:respondObject.data];
          }
          [SVProgressHUD dismiss];
          [self endRefresh];
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        
          [SVProgressHUD dismiss];
        [self endRefresh];
    }];
    [SVProgressHUD show];
}

- (void)handleDataWithArr:(NSArray *)array {
    
    NSArray *arr = [OrderMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.orderModes = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.orderModes addObjectsFromArray:arr];
    }
    
    [self.homeTable reloadData];
    
//    if ([arr count]<pagesize) {
//
//        self.homeTable.mj_footer.hidden=YES;
//    }
//    else{
//        self.homeTable.mj_footer.hidden=NO;
//    }
}
- (void)endRefresh {
    [self.homeTable.mj_header endRefreshing];
    [self.homeTable.mj_footer endRefreshing];
    if (self.orderModes.count) {
        [self hiddenDefaultImage];
    }else {
        [self showDefaultImageWithView:self.homeTable];
    }
}

- (UITextField *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UITextField alloc] init];
        _searchBar.placeholder = @"宝卡号 订单号";
        _searchBar.layer.cornerRadius = 14.f;
        _searchBar.font = [UIFont systemFontOfSize:13];
        _searchBar.leftViewMode = UITextFieldViewModeAlways;
        _searchBar.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
        _searchBar.delegate = self;
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.tintColor = [UIColor colorWithHexString:@"FEE100"];
        _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_searchBar addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [_searchBar addTarget:self action:@selector(textFieldDidExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [_searchBar addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    }
    return _searchBar;
}
-(UITableView*)homeTable{
    
    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight+48, ScreenW, ScreenH-UI.statusAndNavBarHeight-48)                                      style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
        _homeTable.estimatedRowHeight = 255;
        _homeTable.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _homeTable;
}

#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.orderModes.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"cellIdentifier";
    JHAppraiseOrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[JHAppraiseOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        JH_WEAK(self)
        cell.finishBlock = ^(NSIndexPath *indexPath) {
            JH_STRONG(self)
            JHUploadVideoViewController *vc = [[JHUploadVideoViewController alloc] init];
            vc.orderModel = self.orderModes[indexPath.section];
            vc.finishBlock = ^(id sender) {
                [self loadNewData];
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        };
        
    }
    [cell setOrderMode:self.orderModes[indexPath.section]];
    cell.indexPath=indexPath;
    
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // return 245;
    return  UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==10) {
        
        return CGFLOAT_MIN;
    }
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
    
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
//    JHOrderDetailViewController * order=[[JHOrderDetailViewController alloc]init];
//    order.orderId=[self.orderModes[indexPath.section]orderId];
//    [self.navigationController pushViewController:order animated:YES];
    
}

-(void)buttonPress:(UIButton*)button withOrder:(OrderMode*)mode{
    
    self.selectMode=mode;
    switch (button.tag) {
        case JHOrderButtonTypeOrderDetail:
        {
            JHOrderDetailViewController * order=[[JHOrderDetailViewController alloc]init];
            order.orderId=mode.orderId;
            order.isSeller=YES;
            order.isProblem=YES;
            [self.navigationController pushViewController:order animated:YES];
        }
            break;
        case JHOrderButtonTypeQuestionDetail: {
            
            JHWebViewController *webVC = [JHWebViewController new];
            webVC.urlString = [H5_BASE_STRING(@"/jianhuo/app/problemDetails.html?orderId=") stringByAppendingString:OBJ_TO_STRING(mode.orderId)];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        default:
            break;
            
    }
}

#pragma mark - UITextFieldActions
- (void)textFieldDidBegin:(UITextField *)field {
    
}

- (void)textFieldChanged:(UITextField *)field {
    
}

- (void)textFieldDidExit:(UITextField *)field {
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
     [self loadNewData];
    return YES;
}
- (void)scanCodeAction:(UIButton *)btn {
    
    JHQRViewController *vc = [[JHQRViewController alloc] init];
    vc.titleString = @"扫描宝卡号 订单号";
    MJWeakSelf
    vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController *obj) {
        weakSelf.searchBar.text = scanString;
        [obj.navigationController popViewControllerAnimated:YES];
        if (scanString>0) {
            [self loadNewData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)orderOut:(UIButton*)button{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end




