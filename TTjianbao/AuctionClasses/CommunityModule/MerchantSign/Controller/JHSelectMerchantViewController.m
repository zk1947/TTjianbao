//
//  JHSelectMerchantViewController.m
//  TTjianbao
//
//  Created by apple on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHSelectMerchantViewController.h"
#import "JHPersonIdentViewController.h"
#import "JHCompanyIdentViewController.h"
#import "JHMerchantTypeCell.h"
#import "JHMerchantTypeModel.h"
#import "JHNoticeTableViewCell.h"
#import "JHSignViewController.h"
#import "JHWebViewController.h"

@interface JHSelectMerchantViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) dispatch_semaphore_t compeleteSema;
//@property (nonatomic, copy) NSString *authStatus;

@end

@implementation JHSelectMerchantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self initTableView];
    [self configData];
    [self loadData];
}

#pragma mark - UI
- (void)configNav {
//    [self initToolsBar];
//    [self.navbar setTitle:@"选择商家类型"];
    self.title = @"选择商家类型";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initTableView {
    _tableView = ({
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, ScreenH - UI.statusAndNavBarHeight - UI.bottomSafeAreaHeight) style:UITableViewStylePlain];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.backgroundColor = HEXCOLOR(0xF8F8F8);
        table.delegate = self;
        table.dataSource = self;
        table.tableFooterView = [[UIView alloc] init];
        table;
    });
    
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JHMerchantTypeCell class] forCellReuseIdentifier:@"JHMerchantTypeCell"];
    [_tableView registerClass:[JHNoticeTableViewCell class] forCellReuseIdentifier:@"JHNoticeTableViewCell"];
    
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHMerchantTypeModel *model = self.dataArray[indexPath.row];
    if (model.merchantType == JHMerchantTypeNone) {
        static NSString *identifer = @"JHNoticeTableViewCell";
        JHNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        cell.merchantModel = model;
        return cell;
    }
    
    static NSString *identifer = @"JHMerchantTypeCell";
    JHMerchantTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.merchantModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHMerchantTypeModel *model = self.dataArray[indexPath.row];
    if (model.merchantType == JHMerchantTypeNone) {
        return 155; ///154
    }
    return 94 + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return;
    }
    ///个人：0 未认证 1：已认证 （企业多两个状态：2 认证中 3 认证失败）
    if (!self.authStatus || self.authStatus == 3) {
        ///未认证 跳转认证界面
        JHMerchantTypeModel *model = self.dataArray[indexPath.row];
        if (model.merchantType == 1) { ///个人
            JHPersonIdentViewController *personalVC = [[JHPersonIdentViewController alloc] init];
            [self.navigationController pushViewController:personalVC animated:YES];
            return;
        }
        if (model.merchantType == 2) { ///企业
            JHCompanyIdentViewController *companyVC = [[JHCompanyIdentViewController alloc] init];
            [self.navigationController pushViewController:companyVC animated:YES];
            return;
        }
    }
    else if (self.authStatus == 1 || self.authStatus == 4) { ///已认证
        if (self.signStatus) { ///签约状态有几种状态 0 未签约  1 已签约
            [UITipView showTipStr:@"已签约"];
        }
        else {
            ///认证 未签约 直接跳转到签约界面
            [self getSignH5Page];
        }
    }
    else if (self.authStatus == 2) { ///认证中 点击跳转到审核中界面
        JHMerchantTypeModel *model = self.dataArray[indexPath.row];
        if (model.merchantType == 2) { ///企业
            JHSignViewController *vc = [[JHSignViewController alloc] init];
            vc.checkStatus = JHCheckStatusChecking;  ///审核中
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - action
- (void)getSignH5Page {
    [SVProgressHUD show];
    @weakify(self);
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/contract/sign");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSLog(@"请求成功:%@", respondObject.data);
        ///跳转签约界面
        @strongify(self);
        NSString *urlString = respondObject.data[@"url"];
        [self gotoSignFile:urlString];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSLog(@"请求失败:%@ - %zd", respondObject.message, respondObject.code);
        NSString *message = respondObject.message;
        [UITipView showTipStr:message ? message : @"跳转失败"];
    }];
}

- (void)gotoSignFile:(NSString *)htmlString {
    JHWebViewController *webVC = [[JHWebViewController alloc] init];
    webVC.urlString = htmlString;
    webVC.isNeedPoptoRoot = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - data
///公告数据
- (void)loadData {
    [SVProgressHUD show];
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/contract/announce");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSLog(@"请求成功:%zd - %@ - %@", respondObject.code,respondObject.message,respondObject.data);
        if (respondObject.data) {
            JHMerchantTypeModel *notice = [[JHMerchantTypeModel alloc] init];
            notice.imgName = @"";
            notice.titleText = respondObject.data[@"Title"];
            notice.detailDescription = [NSString stringWithFormat:@"    %@", respondObject.data[@"Text"]];
            notice.merchantType = JHMerchantTypeNone;
            [self.dataArray insertObject:notice atIndex:0];
            [self.tableView reloadData];
        }
        else {
            [UITipView showTipStr:respondObject.message ? respondObject.message : @"获取数据失败"];
        }
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSLog(@"请求失败");
        [UITipView showTipStr:respondObject.message];
    }];
}

///个人 企业列表数据
- (void)configData {
    JHMerchantTypeModel *personal = [[JHMerchantTypeModel alloc] init];
    personal.imgName = @"icon_sign_person";
    personal.titleText = @"我是个人商家";
    personal.detailDescription = @"需要身份证，认证操作只需2步";
    personal.merchantType = JHMerchantTypePerson;
    
    JHMerchantTypeModel *company = [[JHMerchantTypeModel alloc] init];
    company.imgName = @"icon_sign_company";
    company.titleText = @"我是企业商家";
    company.detailDescription = @"需要营业执照，认证操作只需2步";
    company.merchantType = JHMerchantTypeCompany;
    ///认证状态：0 未认证 1 已认证 2 认证中 3 认证失败
    switch (self.authStatus) {
        case 1: ///已认证
        {
            if (self.merchantType == 1) {
                [self.dataArray addObject:personal];
            }
            else {
                [self.dataArray addObject:company];
            }
        }
            break;
        case 2: ///认证中 只是针对企业商家 merchantType == 2
        {
            [self.dataArray addObject:company];
        }
            break;
        case 3:  ///认证失败
        default:
        {
            [self.dataArray addObjectsFromArray:@[personal,company]];
        }
            break;
    }
    
    [_tableView reloadData];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
