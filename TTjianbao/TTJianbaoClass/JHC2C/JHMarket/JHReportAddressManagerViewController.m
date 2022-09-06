//
//  JHReportAddressManagerViewController.m
//  TTjianbao
//
//  Created by 张坤 on 2021/5/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHReportAddressManagerViewController.h"

#import "JHReportAddressManagerCell.h"
#import "AddAdressViewController.h"
#import "JHOrderViewModel.h"
#import "TTjianbaoBussiness.h"
#import "AdressManagerViewController.h"
#import "AddAdressViewController.h"

#define pagesize 10

@interface JHReportAddressManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *selectAdressId;
    NSInteger PageNum;
}
@property(nonatomic,strong) UITableView *contentTalbe;
@property (nonatomic,strong) NSMutableArray  *adressModels;
@property (nonatomic,strong) AdressMode *selModel;
@property (nonatomic, strong) UIView *addView;
@property (nonatomic, assign) BOOL isShowAddView;
@end

@implementation JHReportAddressManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发送退货地址";
    
    [self.view addSubview:self.contentTalbe];
    [self requestInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestInfo) name:ADRESSALTERSUSSNotifaction object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didClickAddAddress : (UIButton *)sender {
    [self pushAddAddress];
}
- (void)pushAdressManager {
    @weakify(self);
    //修改地址/新增地址
    AdressManagerViewController *addressVC = [AdressManagerViewController new];
    addressVC.selectedBlock = ^(AdressMode *model) {
        @strongify(self);
        [self.adressModels removeAllObjects];
        [self.adressModels appendObject:model];
        self.selModel = model;
        [self hideAddAddressView];
        [self.contentTalbe reloadData];
        
    };
    addressVC.deleteBlock = ^(AdressMode *model) {
        [self.adressModels removeAllObjects];
        [self.contentTalbe reloadData];
        [self showAddAddressView];
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}
- (void)pushAddAddress {
    AddAdressViewController *addAdessVC = [[AddAdressViewController alloc]init];
    addAdessVC.isUpdateAdress = NO;
    addAdessVC.fromType = 1;
    [self.navigationController pushViewController: addAdessVC animated:YES];
}
-(void)requestInfo {
    [self hideAddAddressView];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/address/default") Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        if (respondObject.data[@"id"] != nil) {
            [self handleDataWithArr:@[respondObject.data]];
        }else {
            self.adressModels = [NSMutableArray new];
            [self showAddAddressView];
            [self.contentTalbe reloadData];
        }
        
        [self endRefresh];
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    [SVProgressHUD show];
}
- (void)showAddAddressView {
    self.isShowAddView = true;
    [self.view addSubview: self.addView];
    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(UI.statusAndNavBarHeight + 56);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(70);
    }];
}
- (void)hideAddAddressView {
    if (!self.isShowAddView) return;
    [self.addView removeFromSuperview];
    self.isShowAddView = false;
}
- (void)handleDataWithArr:(NSArray *)array {
    
    NSArray *arr = [AdressMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.adressModels = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.adressModels addObjectsFromArray:arr];
    }
    [self.contentTalbe reloadData];
    
    if ([arr count]<pagesize) {
        self.contentTalbe.mj_footer.hidden=YES;
    }
    else{
        self.contentTalbe.mj_footer.hidden=NO;
    }
    
    for (AdressMode *adressMode in self.adressModels ) {
        if (adressMode.isDefault) {
            self.selModel = adressMode;
        }
       
    }
    
    [self setupBottomView];
}
- (void)endRefresh {
    [self.contentTalbe.mj_header endRefreshing];
    [self.contentTalbe.mj_footer endRefreshing];
}

- (UITableView*)contentTalbe {
    if (!_contentTalbe) {
        _contentTalbe = [[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, self.view.frame.size.width, self.view.frame.size.height-UI.statusAndNavBarHeight-69) style:UITableViewStylePlain];
        _contentTalbe.delegate=self;
        _contentTalbe.dataSource=self;
        _contentTalbe.estimatedRowHeight = 66;
        _contentTalbe.alwaysBounceVertical=YES;
        _contentTalbe.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [_contentTalbe setSeparatorStyle:UITableViewCellSeparatorStyleNone];

        UIView *headView = [UIView jh_viewWithColor:HEXCOLOR(0xFFFFFAF2) addToSuperview:_contentTalbe];
        headView.frame = CGRectMake(0, 0, ScreenW, 46);
        
        UILabel *label = [UILabel jh_labelWithFont:13 textColor:HEXCOLOR(0xFFFF6A00) addToSuperView:headView];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(46);
        }];
        
        label.backgroundColor = HEXCOLOR(0xFFFFFAF2);
        label.numberOfLines = 0;
        label.text = @"如因您提供的退货地址错误，导致买家无法退货或者退回商品无法送达，由您承当因此产生的后果";

        _contentTalbe.tableHeaderView = headView;
    }
    return _contentTalbe;
}

- (void)setupBottomView {
    UIView *bottomView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.view];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(@69);
        make.bottom.mas_equalTo(-UI.bottomSafeAreaHeight);
    }];
    
    UIButton *recyclingMoney = [UIButton jh_buttonWithTitle:@"取消并返回" fontSize:16 textColor:HEXCOLOR(0xFF333333) target:self action:@selector(recyclingMoneyAction:) addToSuperView:bottomView];
    recyclingMoney.backgroundColor = UIColor.whiteColor;
    recyclingMoney.titleLabel.font = JHMediumFont(16);
    
    recyclingMoney.layer.cornerRadius = 22;
    recyclingMoney.layer.borderWidth = 0.5;
    recyclingMoney.layer.borderColor = RGB(189, 191, 194).CGColor;
    

    UIButton *_completeBtn = [UIButton jh_buttonWithTitle:@"新增收货地址" fontSize:16 textColor:HEXCOLOR(0xFF333333) target:self action:@selector(buttonPress:) addToSuperView:bottomView];
    _completeBtn.backgroundColor = HEXCOLOR(0xFFFECB33);
    _completeBtn.titleLabel.font = JHMediumFont(16);
    _completeBtn.layer.cornerRadius = 22;
    
    UIButton *recyclingBigMoney = [UIButton jh_buttonWithTitle:@"提交退货地址" fontSize:16 textColor:HEXCOLOR(0xFF333333) target:self action:@selector(recyclingBigMoneyAction:) addToSuperView:bottomView];
    recyclingBigMoney.backgroundColor = HEXCOLOR(0xFFFECB33);
    recyclingBigMoney.titleLabel.font = JHMediumFont(16);
    recyclingBigMoney.layer.cornerRadius = 22;
    
    [recyclingMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView);
        make.height.mas_equalTo(44.f);
    }];
    
    if(self.adressModels.count == 0){
        [recyclingBigMoney removeFromSuperview];
        [_completeBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView);
            make.height.mas_equalTo(recyclingMoney);
        }];
    }else {
        [_completeBtn removeFromSuperview];
        [recyclingBigMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView);
            make.height.mas_equalTo(recyclingMoney);
        }];
    }
    
    [bottomView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12.f leadSpacing:10.f tailSpacing:12.f];
}

#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.adressModels count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *downCellIdentifier=@"DownloadReportCell";
    JHReportAddressManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:downCellIdentifier];
    if(cell == nil)
    {
        cell = [[JHReportAddressManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downCellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
//        cell.delegate=self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    [cell setAdressMode:[self.adressModels objectAtIndex:indexPath.section]];
    [cell setCellIndex:indexPath.section];
    
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor blackColor];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = UIColor.clearColor;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self pushAdressManager];
    
}

- (void)buttonPress:(UIButton*)button {
    [self.navigationController pushViewController: [[AddAdressViewController alloc] init] animated:YES];
}

- (void)recyclingMoneyAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)recyclingBigMoneyAction:(UIButton *)btn {    
    [self agreeReturn:self.selModel.ID];
}

- (void)agreeReturn:(NSString *)addressId {
    [SVProgressHUD show];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/agreeReturn") Parameters:@{
        @"orderId":self.orderId,
        @"workOrderId":self.workOrderId,
        @"addressId":addressId,
        @"workOrderStatus":self.workOrderStatus} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.reloadUPData sendNext:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (RACSubject *)reloadUPData {
    if (!_reloadUPData) {
        _reloadUPData = [RACSubject subject];
    }
    return _reloadUPData;
}
- (UIView *)addView {
    if (!_addView) {
        _addView = [[UIView alloc] initWithFrame:CGRectZero];
        _addView.backgroundColor = HEXCOLOR(0xffffff);
        [_addView jh_cornerRadius:5];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.text = @"退货地址";
        titleLabel.textColor = HEXCOLOR(0x333333);
        titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setTitle:@"+新建地址" forState:UIControlStateNormal];
        [addButton setTitleColor:HEXCOLOR(0x007aff) forState:UIControlStateNormal];
        addButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
        [addButton addTarget:self action:@selector(didClickAddAddress:) forControlEvents:UIControlEventTouchUpInside];
        
        [_addView addSubview:titleLabel];
        [_addView addSubview:addButton];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(10);
                    make.top.mas_equalTo(10);
        }];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-6);
        }];
    }
    return _addView;
}
@end
