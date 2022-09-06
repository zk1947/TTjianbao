//
//  JHOrderReturnViewController.m
//  TTjianbao
//
//  Created by jiang on 2019/9/11.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrderReturnViewController.h"
#import "JHQRViewController.h"
#import "JHPickerView.h"
#import "BYTimer.h"
#import "JHOrderRemainTimeView.h"
#import "JHUIFactory.h"
#import <IQKeyboardManager.h>
#import "NSString+AttributedString.h"
#import "CommAlertView.h"
#import "JHOrderSendExpressView.h"

#define headViewRate (float) 125/375
@interface JHOrderReturnViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, STPickerSingleDelegate>
{
    NSArray<NSArray *> *listArr;
    NSInteger selectedIndex;
    
}
@property(nonatomic,strong) UITableView *homeTable;
@property(nonatomic,strong) NSMutableArray *dataList;
@property(nonatomic,strong) JHPickerView *picker;
@property(nonatomic,strong) JHOrderRemainTimeView *titleView;
@property(nonatomic,strong) BYTimer *timer;
@property(nonatomic,strong) JHOrderSendExpressView *addressView;
@property(nonatomic,strong) UIView *returnClassView;
@property(nonatomic,strong) NSString *returnClass;
@property(nonatomic,strong) NSArray *returnClassArr;
@end
@implementation JHOrderReturnViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    [self  initToolsBar];
//    [self.navbar setTitle:@"退货至平台"];
    if (self.directDelivery) {
        self.title = @"退货至商家";
    }else{
        self.title = @"退货至平台"; //背景色不同
    }
    
    self.jhTitleLabel.textColor = HEXCOLOR(0x222222);
//    self.navbar.titleLbl.textColor = [UIColor whiteColor];
//    self.navbar.ImageView.hidden = YES;
//    self.navbar.titleLbl.textColor = HEXCOLOR(0x222222);
//    self.view.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
//    
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    self.navbar.backgroundColor = [UIColor clearColor];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    listArr = @[
        @[@""],
        @[@""],
    ];
    self.returnClassArr=@[@"已签收需寄回",@"我已拒收快递"];
    
    [self initTitleView];
    [self.view addSubview:self.homeTable];
    [self.homeTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.offset(0);
    }];
    
    [self initHeaderView];
    [self initFooterView];
    [self timeCountDown];
    [self getData];
    [self getReturnAddress];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}
-(void)timeCountDown{
    
    if (!self.refundExpireTime) {
        return;
    }
    JH_WEAK(self)
    if ([CommHelp dateRemaining:self.refundExpireTime]>0){
        if (!_timer) {
            _timer=[[BYTimer alloc]init];
        }
        [_timer createTimerWithTimeout:[CommHelp dateRemaining:self.refundExpireTime] handlerBlock:^(int presentTime) {
            JH_STRONG(self)
            self.titleView.time=[CommHelp getHMSWithSecond:presentTime];
        } finish:^{
            JH_STRONG(self)
            self.titleView.time = @"退货超时";
        }];
    }else {
        self.titleView.time = @"退货超时";
    }
}

#pragma mark------get
-(UITableView*)homeTable{
    
    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
        _homeTable.estimatedRowHeight = 100;
        _homeTable.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _homeTable.bounces = YES;
        
    }
    return _homeTable;
}
- (JHOrderSendExpressView *)addressView {
    if (!_addressView) {
        _addressView=[[JHOrderSendExpressView alloc]init];
        _addressView.backgroundColor=[UIColor whiteColor];
        _addressView.userInteractionEnabled=YES;
        
        JH_WEAK(self)
        _addressView.buttonHandle = ^(id obj) {
            JH_STRONG(self)
            [self scanCode];
        };
        _addressView.chooseExpressHandle = ^(id obj) {
            JH_STRONG(self)
            [self.picker show];
        };
        
    }
    return _addressView;
}
- (UIView *)returnClassView {
    if (!_returnClassView) {
        _returnClassView=[[UIView alloc]init];
        _returnClassView.backgroundColor=[UIColor whiteColor];
        _returnClassView.layer.cornerRadius = 8;
        _returnClassView.layer.masksToBounds = YES;
        _returnClassView.userInteractionEnabled=YES;
        
    }
    return _returnClassView;
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
#pragma mark------subviews
-(void)initTitleView{
    self.titleView=[[JHOrderRemainTimeView alloc]init];
    self.titleView.title=@"剩余时间";
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight+10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.offset(30);
        make.width.offset(ScreenW-20);
    }];
    if (!self.refundExpireTime) {
        [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
    }
}
-(void)initHeaderView{
    
    UIView * header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    header.backgroundColor=[UIColor clearColor];
    
    UIView * backView=[[UIView alloc]init];
    backView.backgroundColor=[UIColor whiteColor];
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    [header addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header).offset(0);
        make.left.equalTo(header).offset(10);
         make.width.offset(ScreenW-20);
       // make.right.equalTo(header).offset(0);
    }];
//    NSArray *arr=@[@"请寄回商品并填写快递单号",
//                   @"若您未签收快递，请直接拒收，这会让退款速度加快。",
//                   @"请在48小时内完成退货操作，超时将自动关闭售后。",
//                   @"请尽量使用顺丰快递，非平台指定的快递可能有拒收风险。",
//                   @"寄回的商品请务必附带宝卡或附带一张纸条写明您的订单号、平台昵称以及需要处理的问题。"];
    NSMutableArray * arr = [NSMutableArray array];
    [arr addObject:@"请寄回商品并填写快递单号"];
    [arr addObject:@"若您未签收快递，请直接拒收，这会让退款速度加快。"];
    [arr addObject:@"请在48小时内完成退货操作，超时将自动关闭售后。"];
    if (!self.directDelivery) {
        [arr addObject:@"请尽量使用顺丰快递，非平台指定的快递可能有拒收风险。"];
    }
    [arr addObject:@"寄回的商品请务必附带宝卡或附带一张纸条写明您的订单号、平台昵称以及需要处理的问题。"];
    
    UILabel * lastView;
    for (int i=0; i<arr.count; i++) {
        UILabel  *title=[[UILabel alloc]init];
        title.text=arr[i];
        title.backgroundColor=[UIColor clearColor];
        title.font=[UIFont fontWithName:kFontNormal size:13];
        title.textColor=kColor666;
        title.numberOfLines = 0;
        title.textAlignment = NSTextAlignmentLeft;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [backView addSubview:title];
        NSString * string;
        if (i==0) {
            title.font=[UIFont fontWithName:kFontMedium size:15];
            title.textColor=kColor333;
            string=[@"" stringByAppendingString:arr[i]];
        }
        else{
            string=[@"• " stringByAppendingString:arr[i]];
        }
        if (i==1) {
            title.font=[UIFont fontWithName:kFontNormal size:13];
            title.textColor=kColorMainRed;
        }
        
        NSRange range = [string rangeOfString:@"•"];
        title.attributedText=[string attributedFont:[UIFont fontWithName:kFontNormal size:13.f] color:kColor333 range:range];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(10);
            make.right.equalTo(backView).offset(-10);
            if (i==0) {
                make.top.equalTo(backView).offset(10);
            }
            else{
                make.top.equalTo(lastView.mas_bottom).offset(10);
            }
            if (i==[arr count]-1) {
                
                make.bottom.equalTo(backView).offset(-10);
            }
        }];
        
        lastView= title;
    }
    
    [header layoutIfNeeded];
    header.frame = CGRectMake(0, 0, ScreenW, backView.height);
    self.homeTable.tableHeaderView = header;
    
}
-(void)initFooterView{
    
       UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
       footer.backgroundColor = [UIColor clearColor];
       
       UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       cancleBtn.backgroundColor = HEXCOLOR(0xffffff);
       cancleBtn.layer.cornerRadius = 19;
       cancleBtn.layer.masksToBounds = YES;
       cancleBtn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
       cancleBtn.layer.borderWidth = 0.5;
       [cancleBtn setTitle:@"取消退货" forState:UIControlStateNormal];
       [cancleBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
       cancleBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:14];
       // cancleBtn.frame = CGRectMake((ScreenW/2-30)/2,40, 120, 30);
       [cancleBtn addTarget:self action:@selector(onCancleAction:) forControlEvents:UIControlEventTouchUpInside];
       [footer addSubview:cancleBtn];
       
       
       UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
       btn.backgroundColor = HEXCOLOR(0xfee100);
       btn.layer.cornerRadius = 19;
       btn.layer.masksToBounds = YES;
       [btn setTitle:@"确认退货" forState:UIControlStateNormal];
       [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
       btn.titleLabel.font = [UIFont fontWithName:kFontMedium size:14];
       //  btn.frame = CGRectMake(ScreenW-(ScreenW/2-30/2),40, 120, 30);
       [btn addTarget:self action:@selector(okSendAction:) forControlEvents:UIControlEventTouchUpInside];
       [footer addSubview:btn];
       
       [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.offset(40);
           make.right.offset(-(ScreenW/2+10));
           make.size.mas_equalTo(CGSizeMake(120, 38));
       }];
       [btn mas_makeConstraints:^(MASConstraintMaker *make) {
           //   make.left.equalTo(cancleBtn.mas_right).offset(20);
           make.size.mas_equalTo(CGSizeMake(120, 38));
           make.top.offset(40);
           make.left.offset(ScreenW/2+10);
       }];
    self.homeTable.tableFooterView=footer;
}
-(void)initReturnClassSubviews:(NSArray*)arr{
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.text=@"选择退货方式";
    titleLabel.font=[UIFont fontWithName:kFontMedium size:15];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=kColor333;
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_returnClassView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_returnClassView).offset(10);
        make.top.equalTo(_returnClassView).offset(10);
        make.height.offset(30);
    }];
    
    UIView * lastView;
    for (int i=0; i<[arr count]; i++) {
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(returnClassTap:)]];
        [_returnClassView addSubview:view];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"order_return_class_icon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"order_return_class_icon_select"] forState:UIControlStateSelected];
        button.contentMode=UIViewContentModeScaleAspectFit;
        button.userInteractionEnabled=NO;
        [view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view).offset(10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        button.selected=NO;
        if (i==0) {
            button.selected=YES;
            self.returnClass=self.returnClassArr[0];
        }
        
        UILabel  *title=[[UILabel alloc]init];
        title.text=arr[i];
        title.font=[UIFont systemFontOfSize:15];
        title.backgroundColor=[UIColor clearColor];
        title.textColor=[CommHelp toUIColorByStr:@"#222222"];
        title.numberOfLines = 1;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button.mas_right).offset(10);
            make.centerY.equalTo(view);
            make.right.equalTo(view).offset(-20);
        }];
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        [view addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title).offset(0);
            make.bottom.equalTo(view).offset(0);
            make.right.equalTo(view).offset(0);
            make.height.offset(1);
        }];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50);
            make.left.right.equalTo(_returnClassView);
            if (i==0) {
                make.top.equalTo(titleLabel.mas_bottom).offset(0);
            }
            else{
                make.top.equalTo(lastView.mas_bottom);
            }
            if (i==[arr count]-1) {
                
                make.bottom.equalTo(_returnClassView);
            }
        }];
        
        lastView= view;
    }
}
#pragma mark tableviewDatesource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [listArr count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[listArr objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        return [self configReturnClasssCellIndexPath:indexPath];
    }
    if (indexPath.section == 1) {
        return [self configAddressCellIndexPath:indexPath];
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return UITableViewAutomaticDimension;
    }
    if (indexPath.section==1) {
        return  UITableViewAutomaticDimension;
    }
    return  0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return  10;
    }
    if (section == 2) {
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
    
    return CGFLOAT_MIN;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == listArr.count-1) {
        
    }
    return nil;
}
- (UITableViewCell *)configAddressCellIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"AddressCell";
    UITableViewCell *cell = [self.homeTable dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:self.addressView];
        [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).offset(10);
            make.right.equalTo(cell.contentView).offset(-10);
        }];
    }
    return cell;
    
}
- (UITableViewCell *)configReturnClasssCellIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"returnClassCell";
    UITableViewCell *cell = [self.homeTable dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:self.returnClassView];
        [self.returnClassView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).offset(10);
            make.right.equalTo(cell.contentView).offset(-10);
        }];
        [self initReturnClassSubviews:self.returnClassArr];
        
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark------action
-(void)returnClassTap:(UITapGestureRecognizer*)tap{
    
    [self cancleButtonSelect:self.returnClassView];
    UITapGestureRecognizer *tapView=(UITapGestureRecognizer*)tap;
    for (UIView * view in tapView.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn=(UIButton*)view;
            btn.selected=YES;
        }
    }
    self.returnClass=self.returnClassArr[tap.view.tag];
    self.addressView.textField.userInteractionEnabled=YES;
    if ([self.returnClass isEqualToString:@"我已拒收快递"]) {
        self.addressView.textField.userInteractionEnabled=NO;
        listArr = @[
            @[@""],
        ];
    }
    else{
        listArr = @[
            @[@""],
            @[@""],
        ];
    }
    [self.homeTable reloadData];
}
- (void)cancleButtonSelect:(UIView *)view
{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)subView;
            btn.selected=NO;
        } else {
            [self cancleButtonSelect:subView];
        }
    }
}
- (void)scanCode{
    
    if ([self.returnClass isEqualToString:@"我已拒收快递"]) {
        return;
    }
    JHQRViewController *vc = [[JHQRViewController alloc] init];
    vc.titleString = @"扫描运单号";
    MJWeakSelf
    vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController *obj) {
        weakSelf.addressView.textField.text = scanString;
        [obj.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)chooseExpress{
    [self.picker show];
}
- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    if (![pickerSingle isKindOfClass:[JHPickerView class]]) {
        return;
    }
    selectedIndex = [pickerSingle.pickerView selectedRowInComponent:1];
    self.addressView.expressCompany.text= self.dataList[selectedIndex][@"name"];
}

#pragma mark------request
- (void)okSendAction:(UIButton *)btn {
    
    if ([self.returnClass isEqualToString:@"我已拒收快递"]) {
        [self refuse];
        return;
    }
    if (self.addressView.textField.text && self.addressView.textField.text.length>0) {
        [self.addressView.textField resignFirstResponder];
        [self requestData];
    }else {
        [SVProgressHUD showErrorWithStatus:@"请输入单号"];
    }
}
- (void)requestData {
    ///退货至商家 变更
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSDictionary *d = self.dataList[selectedIndex];
    
    dic[@"expressCompany"] = d[@"com"];
    dic[@"expressNumber"] = self.addressView.textField.text;
    dic[@"orderId"] = self.orderId;
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/orderRefund/auth/express/refund") Parameters:dic requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [self.view makeToast:@"提交成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:2 position:CSToastPositionCenter];
    }];
}
-(void)refuse{
    
    [HttpRequestTool postWithURL:[FILE_BASE_STRING(@"/orderRefund/auth/express/reject?orderId=") stringByAppendingString:OBJ_TO_STRING(self.orderId)] Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"已拒收" duration:1.0 position:CSToastPositionCenter];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
}
- (void)onCancleAction:(UIButton *)btn{
    
    JH_WEAK(self)
    CommAlertView * alert=[[CommAlertView alloc]initWithTitle:@"是否取消退货申请？" andDesc:@"" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
    [self.view addSubview:alert];
    alert.handle = ^{
        JH_STRONG(self)
        [self  cancleReturn];
    };
}
-(void)cancleReturn{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/orderRefund/auth/refund/cancel?") Parameters:@{@"orderId":self.orderId} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"已取消退货" duration:1.0 position:CSToastPositionCenter];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
}

///4.1.0

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
        self.addressView.expressCompany.text= self.dataList[0][@"name"];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
            
    }];
}
- (void)getReturnAddress{
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/order/auth/returnAddress") Parameters:@{@"orderId":self.orderId} successBlock:^(RequestModel *respondObject) {
        self.addressView.name.text=respondObject.data[@"receiver"];
        self.addressView.phoneNum.text=respondObject.data[@"phone"];
        self.addressView.address.text=respondObject.data[@"address"];
        
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

