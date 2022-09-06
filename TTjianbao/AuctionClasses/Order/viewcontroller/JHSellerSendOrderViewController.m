//
//  JHSellerSendOrderViewController.m
//  TTjianbao
//
//  Created by jiang on 2019/9/10.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "JHSellerSendOrderViewController.h"
#import "JHOrderListViewController.h"
#import "JHOrderListTableViewCell.h"
#import "JHSellerOrderListTableViewCell.h"
#import "JHOrderDetailViewController.h"
#import "JHQRViewController.h"
#import "BaseNavViewController.h"
#import "TTjianbaoBussiness.h"


#define pagesize 10
#define cellRate (float)  201/345
#import "JHOrderSegmentView.h"
@interface JHSellerSendOrderViewController ()<UITableViewDelegate,UITableViewDataSource,JHOrderListTableViewCellDelegate,JHSellerOrderListTableViewCellDelegate>
{
       NSInteger PageNum;
}
@property(nonatomic,strong) UITableView* homeTable;
@property(nonatomic,strong) NSMutableArray* orderModes;
@property(nonatomic,strong) UIView* buttonView;
@property(nonatomic,strong) NSMutableArray *cardIds;

@property(nonatomic, strong) UIView * sendInfoView;
@property(nonatomic, strong) UILabel * infoLable;

@end

@implementation JHSellerSendOrderViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isSeller = YES;
//    [self  initToolsBar];
//    self.title = [NSString stringWithFormat:@"快递单%@",self.expressNumber];
    self.title = @"批量发货";
//    [self.navbar setTitle:[NSString stringWithFormat:@"快递单%@",self.expressNumber]];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.homeTable];
    [self.view addSubview:self.buttonView];
    [self.view addSubview:self.sendInfoView];
    JH_WEAK(self)
    [self takeOutData:^(NSArray *array) {
        JH_STRONG(self)
        if (array) {
            [self.orderModes addObjectsFromArray:array];
           
            for (OrderMode *order in array) {
                if (order.barCode) {
                    [self.cardIds addObject:order.barCode];
                }
            }
            [self.homeTable reloadData];
        }
       
    }];
    
    self.infoLable.text = [NSString stringWithFormat:@"%@: %@",self.expressName,self.expressNumber];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //和手势删除冲突
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    nav.isForbidDragBack = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

//根据订单号 获取订单详情
-(void)requestInfo:(NSString*)orderId{
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSString * type;
    if (self.isSeller) {
        type=user.isAssistant?@"2":@"1";
    }
    else{
        type=@"0";
    }
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/detail?orderId=%@&userType=%@"),orderId,type];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
     //   OrderMode * order= [OrderMode mj_objectWithKeyValues: respondObject.data];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
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
    if (self.orderModes.count) {
        [self hiddenDefaultImage];
    }else {
        [self showDefaultImageWithView:self.homeTable];
    }
}
-(void)backActionButton:(UIButton *)sender{
    
    
    if (self.orderModes.count) {
        [self saveData:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];

    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSMutableArray *)orderModes {
    
    if (!_orderModes) {
        _orderModes = [NSMutableArray array];
    }
    return _orderModes;
}

- (NSMutableArray *)cardIds {
    
    if (!_cardIds) {
        _cardIds = [NSMutableArray array];
    }
    return _cardIds;
}


- (UIView *)sendInfoView{
    if (!_sendInfoView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, 40)];
        view.backgroundColor = UIColor.whiteColor;
        [view jh_borderWithColor:HEXCOLOR(0xE6E6E6) borderWidth:1];
        _sendInfoView = view;
        [view addSubview:self.infoLable];
        [self.infoLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(@0).offset(20);
        }];
    }
    return _sendInfoView;
}

- (UILabel *)infoLable{
    if (!_infoLable) {
        UILabel *label = [UILabel new];
        label.text = @"顺丰快递";
        label.font = JHFont(13);
        label.textColor = HEXCOLOR(0x333333);
        _infoLable = label;
    }
    return _infoLable;
}

-(UITableView*)homeTable{
    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight + 40, ScreenW,ScreenH-UI.statusAndNavBarHeight-90)                                      style:UITableViewStyleGrouped];
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
-(UIView*)buttonView{
    if (!_buttonView) {
        _buttonView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenH-50,ScreenW, 50)];
        _buttonView.backgroundColor=[CommHelp toUIColorByStr:@"#fee100"];
        UIButton  * addBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame=CGRectMake(0, 0,ScreenW/2, 50);
        addBtn.titleLabel.font= [UIFont systemFontOfSize:18];
        [addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [addBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addGood:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_buttonView addSubview:addBtn];
        UIButton  * sendBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.frame=CGRectMake(ScreenW/2, 0,ScreenW/2, 50);
        sendBtn.titleLabel.font= [UIFont systemFontOfSize:18];
        [sendBtn setTitle:@"发货" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendGood:) forControlEvents:UIControlEventTouchUpInside];
        sendBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_buttonView addSubview:sendBtn];
        UIView * line=[[UIView alloc]initWithFrame:CGRectMake(ScreenW/2, (50-26)/2,1, 26)];
        line.backgroundColor=[CommHelp toUIColorByStr:@"#666666"];
        [_buttonView addSubview:line];
        
    }
    return _buttonView;
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
        JHSellerOrderListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[JHSellerOrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.delegate=self;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [cell setOrderMode:self.orderModes[indexPath.section]];
        cell.hideButtonView=YES;
        return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
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
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath{
    return  YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath{
    return  @"删除";
}
//执行删除操作
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
   
     [self.orderModes removeObjectAtIndex:indexPath.section];
    [self.cardIds removeObjectAtIndex:indexPath.section];
     [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
    
    [self.homeTable reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
         JHOrderDetailViewController * detail=[[JHOrderDetailViewController alloc]init];
         detail.orderId=[self.orderModes[indexPath.section]orderId];
         detail.isSeller=self.isSeller;
         [self.navigationController pushViewController:detail animated:YES];
}
-(void)addGood:(UIButton*)button{
    JHQRViewController *vc = [[JHQRViewController alloc] init];

    vc.titleString = @"扫描宝卡";
    JH_WEAK(self)
    vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController *obj) {
        JH_STRONG(self)
        [self requestCardID:scanString obj:obj];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)sendGood:(UIButton*)button{
    if (self.orderModes.count) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"确认发货吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self sendRequestData];
        }]];
        [self presentViewController:alertVc animated:YES completion:nil];
        
    }

}



- (void)requestCardID:(NSString *)cardId obj:(JHQRViewController *)vc {
    
    if ([self.cardIds containsObject:cardId]) {
        [vc.view makeToast:@"扫描重复" duration:1.5 position:CSToastPositionCenter];
        [vc performSelector:@selector(reStartDevice) withObject:nil afterDelay:2];

        return;
    }
    
    [vc showHud];
    User *user = [UserInfoRequestManager sharedInstance].user;
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/order/auth/sellerOrderByBarCode") Parameters:@{@"barCode":cardId,@"isAssistant":user.isAssistant?@"1":@"0"} successBlock:^(RequestModel *respondObject) {
        [vc dismissHud];

        [vc performSelector:@selector(reStartDevice) withObject:nil afterDelay:2];
        OrderMode *model = [OrderMode mj_objectWithKeyValues:respondObject.data];
        
        if (![model.orderStatus isEqualToString:@"waitsellersend"]) {
            [vc.view makeToast:@"不是待发货订单" duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        
        [vc.view makeToast:@"扫描成功" duration:1.5 position:CSToastPositionCenter];

        [self.orderModes addObject:model];
        [self.cardIds addObject:cardId];
        [self.homeTable reloadData];
    } failureBlock:^(RequestModel *respondObject) {
        [vc dismissHud];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:respondObject.message message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [vc presentViewController:alert animated:YES completion:nil];
        [vc performSelector:@selector(reStartDevice) withObject:nil afterDelay:2];
        
    }];
    
}


- (void)sendRequestData {
    [SVProgressHUD show];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"expressCompany"] = @"顺丰";
    dic[@"expressNumber"] = self.expressNumber;
    NSMutableArray *orders = [NSMutableArray array];
    for (OrderMode *order in self.orderModes) {
        [orders addObject:order.orderId];
    }
    dic[@"orderIds"] = orders;
    
    JH_WEAK(self)
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/express/batchSend") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JH_STRONG(self)
        [self removeData:^{
            [SVProgressHUD dismiss];
            [self.view makeToast:@"提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        
    } failureBlock:^(RequestModel *respondObject) {
        JH_STRONG(self)
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message];
    }];
}

- (void)saveData:(void (^)(void))complete {
    [SVProgressHUD showWithStatus:@"缓存中..."];
    
    __weak __typeof(self) weakself= self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *array = [OrderMode mj_keyValuesArrayWithObjectArray:weakself.orderModes];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:weakself.expressNumber];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (complete) {
                complete();
            }
        });
        
    
    });
}

- (void)takeOutData:(void (^)(NSArray *array))complete {
    
    JH_WEAK(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JH_STRONG(self)
        NSArray *dicarray = [[NSUserDefaults standardUserDefaults] objectForKey:self.expressNumber];

        NSArray *array = nil;
        if (dicarray) {
            array = [OrderMode mj_objectArrayWithKeyValuesArray:dicarray];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(array);
            }
        });
        
        
    });
}

- (void)removeData:(void (^)(void))complete  {
    
    __weak __typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:weakself.expressNumber];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if (complete) {
                complete();
            }
        });
        
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
}
@end
