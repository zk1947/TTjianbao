//
//  JHSendOutViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/2/11.
//  Copyright © 2019年 Netease. All rights reserved.
//


#import "JHSendOutViewController.h"
#import "JHQRViewController.h"
#import "JHPickerView.h"
#import "JHOrderAdressView.h"

@interface JHOrderAddressDirectDeliveryViewCell : UITableViewCell
@property (nonatomic, strong) JHOrderAdressView *addressView;
- (void)setViewModel:(JHOrderDetailMode *)viewModel;
@end

@implementation JHOrderAddressDirectDeliveryViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _addressView = [[JHOrderAdressView alloc] init];
    [self.contentView addSubview:_addressView];
    [_addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(77.f);
    }];
}

- (void)setViewModel:(JHOrderDetailMode *)viewModel {
    self.addressView.orderMode = viewModel;
}
@end


@interface JHSendOutViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, STPickerSingleDelegate>
{
    NSArray<NSArray *> *listArr;
    NSInteger selectedIndex;
}
@property (nonatomic,strong) UITableView    *homeTable;
@property (nonatomic,strong) UITextField    *textField;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) JHPickerView   *picker;

@end

@implementation JHSendOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发货"; //背景颜色不一致
    self.jhTitleLabel.textColor = HEXCOLOR(0x222222);
    if (self.directDelivery) {
        listArr = @[
                    @[@""],
                    @[@"选择快递公司"],
                    @[@""],
                    ];
    } else {
        listArr = @[
                    @[@"选择快递公司"],
                    @[@""],
                    ];
    }
    [self.view addSubview:self.homeTable];
    [self getData];
}

- (UITableView *)homeTable {
    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight) style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
        _homeTable.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_homeTable registerClass:[JHOrderAddressDirectDeliveryViewCell class] forCellReuseIdentifier:NSStringFromClass([JHOrderAddressDirectDeliveryViewCell class])];
        _homeTable.bounces = NO;
    }
    return _homeTable;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, ScreenW-80, 50)];
        _textField.font = [UIFont systemFontOfSize:17];
        _textField.placeholder = @"请输入运单号";
        _textField.delegate = self;
    }
    return _textField;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (JHPickerView *)picker {
    if (!_picker) {
        _picker = [[JHPickerView alloc] init];
        _picker.widthPickerComponent = 300;
        _picker.heightPicker = 240 + UI.bottomSafeAreaHeight;
        [_picker setDelegate:self];
    }
    return _picker;
}

#pragma mark tableviewDatesource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [listArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[listArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.directDelivery) {
        if (indexPath.section == 0) {
            JHOrderAddressDirectDeliveryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHOrderAddressDirectDeliveryViewCell class])];
            if (!cell) {
                cell = [[JHOrderAddressDirectDeliveryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHOrderAddressDirectDeliveryViewCell class])];
            }
            [cell setViewModel:self.orderShowModel];
            return  cell;
        } else if (indexPath.section == 1) {
            static NSString *CellIdentifier = @"CellIdentifier";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            cell.textLabel.text = [[listArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            if (self.dataList.count>selectedIndex) {
                cell.detailTextLabel.text = self.dataList[selectedIndex][@"name"];

            } else {
                selectedIndex = 0;
            }
            return  cell;
        }
        return [self configExpressIdCellIndexPath:indexPath];
    } else {
        if (indexPath.section == 0) {
            static NSString *CellIdentifier = @"CellIdentifier";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            cell.textLabel.text = [[listArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            if (self.dataList.count>selectedIndex) {
                cell.detailTextLabel.text = self.dataList[selectedIndex][@"name"];

            } else {
                selectedIndex = 0;
            }
            return  cell;
        }
        return [self configExpressIdCellIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.directDelivery) {
        if (indexPath.section == 0) {
            return 85.f;
        }
        return  50;
    }
    return  50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == listArr.count-1) {
        return 120;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == listArr.count-1) {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
        footer.backgroundColor = [UIColor clearColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = HEXCOLOR(0xfba028);
        btn.layer.cornerRadius = 2;
        btn.layer.masksToBounds = YES;
        [btn setTitle:@"确认发货" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        btn.frame = CGRectMake(15, 70, ScreenW-30, 47);
        [btn addTarget:self action:@selector(okSendAction:) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:btn];
        return footer;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.directDelivery) {
        if (indexPath.section == 1) {
            [self.picker show];
        }
    } else {
        if (indexPath.section == 0) {
            [self.picker show];
        }
    }
}

- (UITableViewCell *)configExpressIdCellIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ExpressIdCell";
    
    UITableViewCell *cell = [self.homeTable dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell.contentView addSubview:self.textField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"icon_scan_code"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(ScreenW-50, 0, 40, 50);
        [btn addTarget:self action:@selector(scanCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
    }
    return cell;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_textField resignFirstResponder];
    return NO;
}

- (void)scanCodeAction:(UIButton *)btn {
    JHQRViewController *vc = [[JHQRViewController alloc] init];
    vc.titleString = @"扫描运单号";
    MJWeakSelf
    vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController *obj) {
        weakSelf.textField.text = scanString;
        [obj.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)okSendAction:(UIButton *)btn {
    if (self.textField.text && self.textField.text.length>0) {
        [self.textField resignFirstResponder];
        [self requestData];
    } else {
        [SVProgressHUD showErrorWithStatus:@"请输入单号"];
    }
}

- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSDictionary *d = self.dataList[selectedIndex];
    dic[@"expressCompany"] = d[@"com"];
    dic[@"expressNumber"] = self.textField.text;
    dic[@"orderId"] = self.orderId;
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/express/send") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [self.view makeToast:@"提交成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message];
    }];
}

- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    if (![pickerSingle isKindOfClass:[JHPickerView class]]) {
        return;
    }
    selectedIndex = [pickerSingle.pickerView selectedRowInComponent:1];
    [self.homeTable reloadData];
}

- (void)getData {
    NSMutableDictionary *aaa = [NSMutableDictionary dictionary];
    aaa[@"orderId"] = self.orderId;

    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/express/comlist") Parameters:aaa requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        self.dataList = respondObject.data;
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dic in self.dataList) {
            [muArray addObject:dic[@"name"]];
        }
        self.picker.arrayData = muArray;
        [self.homeTable reloadData];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
            
    }];
}


@end
