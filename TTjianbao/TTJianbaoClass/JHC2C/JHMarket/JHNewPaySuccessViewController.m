//
//  JHNewPaySuccessViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewPaySuccessViewController.h"
#import "JHWebViewController.h"
#import "JHC2CProductDetailController.h"
#import "JHMarketOrderDetailViewController.h"
#import "JHMarketOrderListViewController.h"
#import "JHOrderPayViewController.h"
#import "JHQYChatManage.h"
#import "JHAuthorize.h"
@interface JHNewPaySuccessViewController ()
{
    
    UIButton* completeBtn;
    UIButton* lookOrderBtn;
}
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) UIView * titleView;

@property(nonatomic,strong) UIView * orderInfoView;
@property(nonatomic,strong) UIView * customizeInfoView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView * combinedOrderInfoView;
@property(nonatomic,strong) UIView * homePickupInfoView;
@property(nonatomic,strong) UITextView *descriptionTextview;
@property(nonatomic,strong) UIView *remindView;
@property(nonatomic,strong) UILabel *remindLabel;
@property(nonatomic,strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *cash;
@property (nonatomic, strong) OrderMode *orderModel;
@end

@implementation JHNewPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initScrollview];
    [self requestInfo];
    [JHAuthorize clickTriggerPushAuthorizetion:JHAuthorizeClickTypePaymentSuccess];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.jhNavView];
}

- (void)didClickOrder : (UIButton *)sender {
    JHMarketOrderDetailViewController *vc = [[JHMarketOrderDetailViewController alloc] init];
    vc.orderId = self.orderId;
    vc.isBuyer = true;
    [self.navigationController pushViewController:vc animated:true];
}
- (void)backActionButton:(UIButton *)sender {
    [self backToVC];
}
//
- (void)didClickBack : (UIButton *)sender {
    
    NSDecimalNumber *numberAll = [NSDecimalNumber decimalNumberWithString:self.orderModel.orderPrice];
    NSDecimalNumber *numberPay = [NSDecimalNumber decimalNumberWithString:self.orderModel.payedMoney];
    
    if ([numberPay compare:numberAll] == NSOrderedAscending) {
        for (UIViewController* vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass: [JHOrderPayViewController class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:OrderPayInfoStatusChangeNotifaction object:nil];//
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
        return;
    }
    
    [self backToVC];
}
- (void)backToVC {
    UIViewController *backVC;
    for (UIViewController* vc in self.navigationController.viewControllers.reverseObjectEnumerator.allObjects) {
        if ([vc isKindOfClass: [JHC2CProductDetailController class]]) {
            backVC = vc;
            break;
        }
        if ([vc isKindOfClass: [JHMarketOrderDetailViewController class]]) {
            backVC = vc;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_AFTER_PAY" object:nil];
            break;
        }
        if ([vc isKindOfClass: [JHMarketOrderListViewController class]]) {
            backVC = vc;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_AFTER_PAY" object:nil];
            break;
        }
    }
    if (backVC) {
        [self.navigationController popToViewController:backVC animated:YES];
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)initScrollview {
    self.contentScroll=[[UIScrollView alloc]init];
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = YES;
    self.contentScroll.backgroundColor = HEXCOLOR(0xf5f6fa);
    self.contentScroll.scrollEnabled=YES;
    self.contentScroll.alwaysBounceVertical=YES;
    [self.view addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhNavView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
    }];
    
    [self initTitleView];
    [self initOrderInfoView];
}
- (void)initTitleView {
    
    _titleView=[[UIView alloc]init];
    _titleView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_titleView];
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        //        make.height.offset(170);
        make.width.offset(ScreenW);
    }];
    
    UIImageView *logo=[[UIImageView alloc]init];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image=[UIImage imageNamed:@"order_pay_new_success_icon"];
    [_titleView addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView).offset(30);
        make.centerX.equalTo(_titleView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines =1;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor=HEXCOLOR(0x333333);;
    label.text = @"支付成功";
    label.font=[UIFont fontWithName:kFontMedium size:18];
    [_titleView addSubview:label];
    
    [ label  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logo.mas_bottom).offset(10);
        make.centerX.equalTo(_titleView);
    }];
    
    UIView  *back=[UIView new];
    [_titleView addSubview:back];
    [ back  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(15);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(_titleView);
        
    }];
    UILabel *cashTitle = [[UILabel alloc] init];
    cashTitle.numberOfLines =1;
    cashTitle.textAlignment = NSTextAlignmentCenter;
    cashTitle.lineBreakMode = NSLineBreakByWordWrapping;
    cashTitle.textColor = HEXCOLOR(0x666666);
    cashTitle.text = @"支付金额:";
    cashTitle.font=[UIFont fontWithName:kFontNormal size:15];
    [back addSubview:cashTitle];
    
    [ cashTitle  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back).offset(5);
        make.top.bottom.equalTo(back);
    }];
    
    [back addSubview:self.cash];
    
    [self.cash  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cashTitle.mas_right).offset(5);
        make.centerY.equalTo(cashTitle);
        make.right.equalTo(back.mas_right);
    }];
    
    lookOrderBtn=[[UIButton alloc]init];
    lookOrderBtn.translatesAutoresizingMaskIntoConstraints=NO;
    [lookOrderBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    lookOrderBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [lookOrderBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    lookOrderBtn.layer.cornerRadius = 19.0;
    [lookOrderBtn setBackgroundColor: HEXCOLOR(0xfee100)];
    
    [lookOrderBtn addTarget:self action:@selector(didClickOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    [_titleView addSubview:lookOrderBtn];
    
    [ lookOrderBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 38));
        make.left.offset(ScreenW/2+10);
    }];
    
    completeBtn=[[UIButton alloc]init];
    completeBtn.translatesAutoresizingMaskIntoConstraints=NO;
    [completeBtn setTitle:@"回到首页" forState:UIControlStateNormal];
    completeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    completeBtn.tag=2;
    [completeBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
    completeBtn.layer.cornerRadius = 19.0;
    [completeBtn setBackgroundColor:[UIColor whiteColor]];
    completeBtn.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
    completeBtn.layer.borderWidth = 0.5f;
    [completeBtn addTarget:self action:@selector(didClickBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [_titleView addSubview:completeBtn];
    
    [ completeBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lookOrderBtn);
        make.size.mas_equalTo(CGSizeMake(120, 38));
        make.right.offset(-(ScreenW/2+10));
    }];
    
    YYLabel *alertLabel = [YYLabel new];
    alertLabel.font = [UIFont fontWithName:kFontNormal size:12];
    alertLabel.textAlignment = NSTextAlignmentNatural;
    alertLabel.textColor = HEXCOLOR(0x666666);
    alertLabel.numberOfLines = 0;
    alertLabel.preferredMaxLayoutWidth = ScreenW - 60;
    [self setupAlertLabel:alertLabel];
    
    [_titleView addSubview:alertLabel];
    
    [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(completeBtn.mas_bottom).offset(30);
        make.bottom.mas_equalTo(-30);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    
}

- (void)setupAlertLabel : (YYLabel *)label {
    
    NSString *str = @"温馨提示：收到货请验收无误再签收，建议录制拆箱视频进行留证，用于交易纠纷举证，查看 具体规则";
    
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:str];
    mutableString.color = HEXCOLOR(0x666666);
    
    @weakify(self)
    [mutableString setTextHighlightRange:NSMakeRange(str.length - 4, 4) color:HEXCOLOR(0x408ffe) backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self)
        NSString *url = H5_BASE_STRING(@"/jianhuo/app/agreement/dealDisputeBuy.html");
        JHWebViewController *vc = [[JHWebViewController alloc] init];
        vc.urlString = url;
        [self.navigationController pushViewController:vc animated:true];
    }];
    label.attributedText = mutableString;
}
-(void)initOrderInfoView{
    
    _orderInfoView=[[UIView alloc]init];
    _orderInfoView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_orderInfoView];
    [_orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
    }];
    
}

-(void)setupOrderInfo:(NSArray*)titles{
    
    UIView * lastView;
    for (int i=0; i<[titles count]; i++) {
        
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [_orderInfoView addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.backgroundColor=[UIColor clearColor];
        [title setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        title.font=[UIFont systemFontOfSize:12];
        title.textColor=HEXCOLOR(0x666666);
        title.numberOfLines = 2;
        title.textAlignment = NSTextAlignmentLeft;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        title.text = titles[i];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.top.bottom.equalTo(view);
            make.right.equalTo(view.mas_right).offset(-10);
        }];
        
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(_orderInfoView);
            if (i==0) {
                make.top.equalTo(_orderInfoView).offset(10);
            }
            else{
                make.top.equalTo(lastView.mas_bottom).offset(10);
            }
            if (i==[titles count]-1) {
                make.bottom.equalTo(_orderInfoView).offset(-10);
            }
            
        }];
        
        lastView= view;
    }
    
}
- (void)setPaymoney:(NSString *)paymoney {
    _paymoney = paymoney;
    self.cash.text = paymoney ?: @"0";
}
-(void)setOrderModel:(OrderMode *)orderModel{
    
    _orderModel = orderModel;
    NSMutableArray * titles=[NSMutableArray array];
    [titles addObject:[@"订单编号: " stringByAppendingString:OBJ_TO_STRING(orderModel.orderCode)]];
    [titles addObject: [@"支付时间: " stringByAppendingString:orderModel.payTime?:@""]];
    if (orderModel.orderCategoryType==JHOrderCategoryRestoreIntention||
        orderModel.orderCategoryType==JHOrderCategoryResaleIntentionOrder){
        lookOrderBtn.hidden=YES;
        [ completeBtn  mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomView).offset(100);
            make.height.equalTo(@47);
            make.left.equalTo(_bottomView).offset(20);
            make.right.equalTo(_bottomView).offset(-20);
        }];
    }
    else{
        [titles addObject:[[@"联系电话: " stringByAppendingString:@""]stringByAppendingString:orderModel.shippingPhone?:@""]];
        [titles addObject:[NSString stringWithFormat:@"收货地址: %@ %@ %@ %@",orderModel.shippingProvince?:@"",orderModel.shippingCity?:@"",orderModel.shippingCounty?:@"",orderModel.shippingDetail?:@""]];
        
    }
    
    NSDecimalNumber *numberPay = [NSDecimalNumber decimalNumberWithString:orderModel.payedMoney];
    NSDecimalNumber *numberAll = [NSDecimalNumber decimalNumberWithString:orderModel.orderPrice];
    
    if ([numberPay compare:numberAll]==NSOrderedAscending)
    {
        [completeBtn setTitle:@"继续支付" forState:UIControlStateNormal];
    }
    else{
        [completeBtn setTitle:@"返回" forState:UIControlStateNormal];
        if ([orderModel.orderCategory isEqualToString:@"limitedTimeOrder"]) {
            [completeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
        }
    }
    [self setupOrderInfo:titles];
    
    
}


-(void)requestInfo{
    
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/detail?orderId=%@&userType=%@"),self.orderId,@"0"];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        OrderMode *orderMode = [OrderMode mj_objectWithKeyValues: respondObject.data];
        self.orderModel = orderMode;
        
        [[JHQYChatManage shareInstance] sendTextWithViewcontroller:self ToShop:orderMode.sellerCustomerId title:orderMode.goodsTitle andOrderId:orderMode.orderId isPayFinish:YES];
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    [SVProgressHUD show];
}
- (UILabel *)cash {
    if (!_cash) {
        _cash = [[UILabel alloc] init];
        _cash.numberOfLines =1;
        _cash.textAlignment = NSTextAlignmentCenter;
        _cash.lineBreakMode = NSLineBreakByWordWrapping;
        _cash.font = [UIFont fontWithName:kFontNormal size:15];
        _cash.textColor= HEXCOLOR(0x666666);;
    }
    return _cash;
}
@end
