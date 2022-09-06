//
//  JHTakeOutViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/2/28.
//  Copyright © 2019年 Netease. All rights reserved.
//
#import "UserInfoRequestManager.h"
#import "JHTakeOutViewController.h"
#import "JHAddClaimOrderCell.h"
#import "JHTakeOutRecordVC.h"
#import "JHAccountModel.h"
#import "NSString+Common.h"

@interface JHTakeOutViewController () <UITableViewDelegate,UITableViewDataSource>
{
    CGFloat footerHeight;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSMutableArray *desArray;
@property(nonatomic, strong) JHBankInfoModel *model;
@property(nonatomic, strong) UIButton *addBtn;


@end

@implementation JHTakeOutViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    footerHeight = ScreenH - 265 - self.jhNavView.height;
    self.title = @"提现"; //背景颜色不一致
    [self.view addSubview:self.tableView];
    
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenW-90, UI.statusBarHeight, 80, 44);
    [btn setTitle:@"提现记录" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(recordAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [self.jhNavView addSubview:btn];

    [self getInfo];
    
}

- (void)backActionButton:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UITableView*)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.alwaysBounceVertical=YES;
        _tableView.scrollEnabled=YES;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHAddClaimOrderCell class]) bundle:nil] forCellReuseIdentifier:@"JHAddClaimOrderCell"];
        
    }
    return _tableView;
}



- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@"可提现金额"];
        [_dataArray addObject:@"提现银行"];
        [_dataArray addObject:@"支行"];
        [_dataArray addObject:@"户名"];
        [_dataArray addObject:@"账号"];
    }
    
    return _dataArray;
}

- (NSMutableArray *)desArray {
    if (!_desArray) {
        _desArray = [NSMutableArray array];
        for (NSString *s in self.dataArray) {
            NSLog(@"%@",s);
            [_desArray addObject:@""];
        }

        
    }
    return _desArray;
}

#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"JHAddClaimOrderCell";
    JHAddClaimOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.titleLab.text = self.dataArray[indexPath.section];
    cell.desLab.text = self.desArray[indexPath.section];
    if (indexPath.section == 0) {
        cell.desLab.textColor = HEXCOLOR(0xFF4200);
        cell.desLab.font = [UIFont fontWithName:kFontBoldDIN size:18];
    }else {
        
        cell.desLab.textColor = HEXCOLOR(0x666666);
        cell.desLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 10;
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = HEXCOLOR(0xf7f7f7);
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.dataArray.count-1) {
        return footerHeight;
    }
    return CGFLOAT_MIN;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.dataArray.count-1) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, footerHeight)];
        view.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
        line.backgroundColor = HEXCOLOR(0xf7f7f7);
        [view addSubview:line];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 2;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = HEXCOLOR(0xFDA100);
        [btn setTitle:@"提现" forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [view addSubview:btn];
        btn.frame = CGRectMake(15, 0, ScreenW-30, 50);
        btn.centerY = view.mj_h/2.-50;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame)+10, ScreenW, 50)];
        label.textColor = HEXCOLOR(0x999999);
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"提现到账时间通常需1-2个工作日\n如有问题请与官方联系";
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:label];
        return view;
    }
    
    return nil;
}


- (void)addAction:(UIButton *)btn {
    if (!self.model) {
        [self.view makeToast:@"请先添加提现银行卡信息" duration:1. position:CSToastPositionCenter];
        return;
    }
    
    if (self.model.totalWithdrawMoney<=0) {
        [self.view makeToast:@"可提现金额有误" duration:1. position:CSToastPositionCenter];
        return;
    }
    
    UserInfoRequestManager *user = [UserInfoRequestManager sharedInstance];
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/withdraw/apply") Parameters:@{@"customerType" : @(user.user.type) , @"customerId":user.user.customerId,@"money":self.model.withdrawMoney,@"oldMoney":self.model.oldWithdrawMoney} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        
                [SVProgressHUD showSuccessWithStatus:@"提交申请成功"];
                [self.navigationController popViewControllerAnimated:YES];

    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
    
}

- (void)recordAction:(UIButton *)btn {
    JHTakeOutRecordVC *vc = [[JHTakeOutRecordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getInfo{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/withdraw/form") Parameters:@{} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        
        self.model = [JHBankInfoModel mj_objectWithKeyValues:respondObject.data];
        
        self.desArray[0] =  [NSString stringWithFormat:@"￥%.2f",self.model.totalWithdrawMoney];
        self.desArray[1] = [NSString notEmpty:self.model.bankName];
        self.desArray[2] = [NSString notEmpty:self.model.bankBranch];
        self.desArray[3] = [NSString notEmpty:self.model.accountName];
        self.desArray[4] = [NSString notEmpty:self.model.accountNo];
        
        [self.tableView reloadData];
        self.addBtn.enabled = YES;

    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}
@end

