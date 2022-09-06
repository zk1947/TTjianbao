//
//  JHAddClaimListViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/3/4.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHAddClaimListViewController.h"

#import "JHClaimOrderListCell.h"
#import "JHQRViewController.h"
#import "OrderMode.h"
@interface JHAddClaimListViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSIndexPath *deleteIndexPath;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UIButton *addBtn;


@end

@implementation JHAddClaimListViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self  initToolsBar];
//    [self.navbar setTitle:@"商城鉴定订单"];
//    self.navbar.ImageView.hidden = YES;
//    self.navbar.backgroundColor = HEXCOLOR(0xf7f7f7);
//    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"商城鉴定订单";
    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
    self.jhNavView.backgroundColor = HEXCOLOR(0xf7f7f7);
    [self.view addSubview:self.tableView];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = kGlobalThemeColor;
    [btn setTitle:@"确定认领" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.enabled = NO;
    [self.view addSubview:btn];
    self.addBtn = btn;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-100);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(25);
        make.trailing.equalTo(self.view).offset(-15);
        
        make.leading.equalTo(self.view).offset(15);
        make.height.equalTo(@(50));
    }];
    
    [self showDefaultImageWithView:self.tableView];
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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHClaimOrderListCell class]) bundle:nil] forCellReuseIdentifier:@"JHClaimOrderListCell"];
        
    }
    return _tableView;
}


- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, ScreenW-90-80, 50)];
        _textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _textField.placeholder = @"请输入运单号";
        _textField.textColor = HEXCOLOR(0x666666);
        _textField.delegate = self;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.returnKeyType = UIReturnKeyDone;
    }
    return _textField;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
    }
    
    return _dataArray;
}


#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count]+1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self configExpressIdCellIndexPath:indexPath];
    }
    static NSString *CellIdentifier = @"JHClaimOrderListCell";
    JHClaimOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.model = self.dataArray[indexPath.section-1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }
    return  106;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = HEXCOLOR(0xeeeeee);
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return CGFLOAT_MIN;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
 
    
    return nil;
}



- (UITableViewCell *)configExpressIdCellIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 90, 50)];
        label.textColor = HEXCOLOR(0x222222);
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"快递单号";
        [cell addSubview:label];
        
        [cell addSubview:self.textField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.navigationController) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"icon_scan_code"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(ScreenW-50, 0, 40, 50);
            [btn addTarget:self action:@selector(scanCodeAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            
        }
        
    }
    return cell;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self getOrder];
    return NO;
}

- (void)scanCodeAction:(UIButton *)btn {
    
    JHQRViewController *vc = [[JHQRViewController alloc] init];
    MJWeakSelf
    __weak JHQRViewController *wVC = vc;
    vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController *obj) {
        weakSelf.textField.text = scanString;
        [wVC.navigationController popViewControllerAnimated:YES];
        [weakSelf getOrder];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (void)addAction:(UIButton *)btn {
    if (self.dataArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请查询订单"];
        return;
    }
    NSMutableArray *orders = [NSMutableArray array];
    for (OrderMode *model in self.dataArray) {
        [orders addObject:model.orderId];
    }
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/order/auth/claim") Parameters:@{@"orderIds":[orders componentsJoinedByString:@","]} successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showSuccessWithStatus:@"认领成功"];
        if (self.finishBlock) {
            self.finishBlock(nil);
        }
        [self backActionButton:nil];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
        
    }];
    
}

- (void)showImage {
//    if (self.model.goodsImg) {
//        [[EnlargedImage sharedInstance] enlargedImage:self.imageView enlargedTime:0.3 images:@[self.model.goodsImg].mutableCopy andIndex:0 result:^(NSInteger index) {
//            
//        }];
//        
//    }
}


- (void)getOrder{
    if (_textField.text.length) {
        
    }else {
        [SVProgressHUD showErrorWithStatus:@"请填写运单号"];
        return;
    }
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/order/auth/detailByExpress") Parameters:@{@"expressNumber":self.textField.text} successBlock:^(RequestModel *respondObject) {
        self.dataArray = [OrderMode mj_objectArrayWithKeyValuesArray:respondObject.data];
        self.addBtn.enabled = YES;
        if (self.dataArray.count) {
            [self hiddenDefaultImage];
            [self.textField resignFirstResponder];

        }else {
            [self showDefaultImageWithView:self.tableView];
            [SVProgressHUD showErrorWithStatus:@"查无数据"];

        }
        
        [self.tableView reloadData];


    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}
@end
