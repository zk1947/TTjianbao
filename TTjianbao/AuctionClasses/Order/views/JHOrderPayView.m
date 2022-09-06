//
//  JHOrderPayView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrderPayView.h"
#import "JHOrdePayGradationViewController.h"
#import "JHBubbleView.h"
#import "PayMode.h"
#import "TTjianbaoHeader.h"
#import "BYTimer.h"
#import "JHQYChatManage.h"
#import "JHOrderConfirmHeaderTipView.h"
#import "UIImage+JHColor.h"
#import "JHBusinessModelTitleConfig.h"

@interface JHOrderPayView ()<UITextViewDelegate,UITextFieldDelegate>
{
    UIView *adressInfoView;
    UIView *adressAddView;
    UITextView *noteTextview;
    UILabel * titleTip;
    UIView* progressLabelBack ;
    UILabel  *tip;
    BYTimer *timer ;
}

@property(nonatomic,strong) JHOrderHeaderTitleView * headerTitleView;
@property(nonatomic,strong) JHOrderConfirmHeaderTipView * headerTipView;
//@property(nonatomic,strong) UIView * remainTimeView;
@property(nonatomic,strong) UIView *allPriceView;
@property(nonatomic,strong) UIView *productView;
@property(nonatomic,strong) UIView *payWayView;
//@property(nonatomic,strong) UIView *gradationView;
@property(nonatomic,strong) UILabel * remainTime;
@property (strong, nonatomic)  UILabel* userName;
@property (strong, nonatomic)  UILabel *address;
@property (strong, nonatomic)  UILabel *userPhoneNum;

@property (strong, nonatomic)  UILabel *sallerName;
@property (strong, nonatomic)  UILabel *productPrice;
@property (strong, nonatomic)  UITextField *leavePayPriceField;
@property (strong, nonatomic)  UILabel *productTitle;
@property (strong, nonatomic)  UIImageView *productImage;
@property (strong, nonatomic)  UIImageView *sallerHeadImage;
@property (strong, nonatomic)  UILabel *allPrice;
@property (strong, nonatomic)  UIButton *alterBtn;
@property (strong, nonatomic)  PayWayMode *payWayMode;
@property (assign, nonatomic) Boolean isMarket;
@property (strong, nonatomic) UILabel * moneyLogo;

@end
@implementation JHOrderPayView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initScrollview];
        
        [self  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)]];
    }
    
    return self;
}

-(void)dismissKeyboard{
    
    [self endEditing:YES];
    
}
-(void)initScrollview{
    
    self.contentScroll=[[UIScrollView alloc]init];
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = YES;
    self.contentScroll.backgroundColor =[CommHelp toUIColorByStr:@"#f7f7f7"];
    self.contentScroll.scrollEnabled=YES;
    self.contentScroll.alwaysBounceVertical=YES;
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self);
    }];
    
    [self initTitleView];
    [self initTipView];
    [self initOrderAllPriceView];
    [self initProductView];
    [self initPayWayView];
    //  [self initGardationView];
    [self initBottomView];
    
}
- (void)displayMarket {
    _headerTipView.hidden = YES;
    [_allPriceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerTitleView.mas_bottom).offset(10);
    }];
    self.isMarket = YES;
}

- (void)dealAuctionUI{
    _alterBtn.hidden = YES;
    _leavePayPriceField.userInteractionEnabled = NO;
    [_leavePayPriceField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_productView);
        make.right.mas_equalTo(-10);
        make.width.greaterThanOrEqualTo(@5);
    }];
    
    [_moneyLogo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_leavePayPriceField.mas_left).offset(-5);
    }];
    
//    _productView.hidden = YES;
//    [_payWayView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.allPriceView.mas_bottom).offset(10);
//    }];
}

- (void)dealEarnestMoneyUI{
    
    
    
}

-(void)initTitleView {
    
    _headerTitleView=[[JHOrderHeaderTitleView alloc]init];
     [self.contentScroll addSubview:_headerTitleView];
     [_headerTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.contentScroll).offset(0);
         make.left.equalTo(self.contentScroll).offset(0);
         make.right.equalTo(self.contentScroll).offset(0);
         make.width.offset(ScreenW);
     }];

}
-(void)initTipView{
    
     _headerTipView=[[JHOrderConfirmHeaderTipView alloc]init];
    _headerTipView.leftSpace = 20;
    [_headerTipView initSubviews];
      [self.contentScroll addSubview:_headerTipView];
     [_headerTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerTitleView.mas_bottom).offset(0);
         make.left.equalTo(self.contentScroll).offset(0);
         make.right.equalTo(self.contentScroll).offset(0);
         make.width.offset(ScreenW);
     }];
}
-(void)initOrderAllPriceView{
    
    _allPriceView=[[UIView alloc]init];
    _allPriceView.backgroundColor=[UIColor whiteColor];
    _allPriceView.layer.cornerRadius = 8;
    _allPriceView.layer.masksToBounds = YES;

    [self.contentScroll addSubview:_allPriceView];
    
    [_allPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerTipView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(50);
    }];
    
    //    UIView * back=[[UIView alloc]init];
    //    [_allPriceView addSubview:back];
    //    [back mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.centerX.equalTo(_allPriceView);
    //    }];
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"订单总额:";
    title.font=[UIFont systemFontOfSize:14];
    //    title.backgroundColor=[UIColor greenColor];
    title.textColor=[CommHelp toUIColorByStr:@"#666666"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_allPriceView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_allPriceView);
        make.left.equalTo(_allPriceView).offset(10);
    }];
    
    _allPrice=[[UILabel alloc]init];
    _allPrice.text=@"¥";
    _allPrice.font = [UIFont fontWithName:kFontBoldDIN size:22.f];
    //    _allPrice.backgroundColor=[UIColor yellowColor];
    _allPrice.textColor=kColor222;
    _allPrice.numberOfLines = 1;
    [_allPrice setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    _allPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _allPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [_allPriceView addSubview:_allPrice];
    
    [_allPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.left.equalTo(title.mas_right).offset(5);
        make.right.equalTo(_allPriceView.mas_right).offset(-10);
    }];
}
-(void)initProductView{
    
    _productView=[[UIView alloc]init];
    _productView.backgroundColor=[UIColor whiteColor];
    _productView.layer.cornerRadius = 8;
       _productView.layer.masksToBounds = YES;
    [self.contentScroll addSubview:_productView];
    
    [_productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allPriceView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(50);
    }];
    
    //    UIView * back=[[UIView alloc]init];
    //    [_productView addSubview:back];
    //    [back mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.centerX.equalTo(_productView);
    //    }];
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"未支付金额:";
    title.font=[UIFont systemFontOfSize:14];
    //    title.backgroundColor=[UIColor greenColor];
    title.textColor=[CommHelp toUIColorByStr:@"#666666"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_productView);
        make.left.equalTo(_productView).offset(10);
    }];
    
    _alterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_alterBtn setImage:[UIImage imageNamed:@"orderPrice_alter_icon"] forState:UIControlStateNormal];
    [_alterBtn setImage:[UIImage imageNamed:@"orderPrice_alter_icon"] forState:UIControlStateSelected];
    _alterBtn.contentMode=UIViewContentModeScaleAspectFit;
    [_alterBtn addTarget:self action:@selector(orderAlter) forControlEvents:UIControlEventTouchUpInside];
    _alterBtn.userInteractionEnabled=YES;
    [_productView addSubview:_alterBtn];
    
    [_alterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_productView).offset(-10);
        make.centerY.equalTo(_productView);
    }];
    
    _leavePayPriceField = [[UITextField alloc] init];
    _leavePayPriceField.delegate = self;
    _leavePayPriceField.text = @"";
    _leavePayPriceField.textColor = kColorMainRed;
    _leavePayPriceField.font = [UIFont fontWithName:kFontBoldDIN size:22.0];
    _leavePayPriceField.backgroundColor = [UIColor clearColor];
    _leavePayPriceField.returnKeyType = UIReturnKeyDone;
    _leavePayPriceField.keyboardType = UIKeyboardTypeDecimalPad;
    _leavePayPriceField.textAlignment = NSTextAlignmentRight;
    _leavePayPriceField.userInteractionEnabled=YES;
    [_leavePayPriceField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_productView addSubview:_leavePayPriceField];
    [_leavePayPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.right.equalTo(_alterBtn.mas_left).offset(-10);
        make.width.greaterThanOrEqualTo(@5);
    }];
    
    _moneyLogo=[[UILabel alloc]init];
    _moneyLogo.text=@"¥";
    _moneyLogo.font = [UIFont fontWithName:kFontBoldDIN size:22.f];
    //    _allPrice.backgroundColor=[UIColor yellowColor];
    _moneyLogo.textColor=kColorMainRed;
    _moneyLogo.numberOfLines = 1;
    [_moneyLogo setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    _moneyLogo.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _moneyLogo.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:_moneyLogo];
    
    [_moneyLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_productView);
        make.right.equalTo(_leavePayPriceField.mas_left).offset(-2);
    }];
    
}
-(void)initPayWayView{
    
    _payWayView=[[UIView alloc]init];
    _payWayView.backgroundColor=[UIColor whiteColor];
     _payWayView.layer.cornerRadius = 8;
    _payWayView.layer.masksToBounds = YES;
    [self.contentScroll addSubview:_payWayView];
    
    [_payWayView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.productView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    
}
//-(void)initGardationView{
//
//    _gradationView=[[UIView alloc]init];
//    _gradationView.backgroundColor=[UIColor whiteColor];
//    _gradationView.userInteractionEnabled=YES;
//    [_gradationView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapGardation:)]];
//    [self.contentScroll addSubview:_gradationView];
//
//    [_gradationView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_payWayView.mas_bottom).offset(10);
//        make.left.equalTo(self.contentScroll).offset(0);
//        make.right.equalTo(self.contentScroll).offset(0);
//        make.height.offset(50);
//    }];
//
//    UIImageView *indicator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_right_jiantou"]];
//    indicator.backgroundColor=[UIColor clearColor];
//    [indicator setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    [indicator setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    indicator.contentMode = UIViewContentModeScaleAspectFit;
//    [_gradationView addSubview:indicator];
//
//    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_gradationView).offset(-15);
//        make.centerY.equalTo(_gradationView);
//
//    }];
//
//    UIImageView * logo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_gardationLogo"]];
//    logo.contentMode = UIViewContentModeScaleAspectFit;
//    [logo setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    [logo setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    [_gradationView addSubview:logo];
//    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(_gradationView).offset(10);
//        make.centerY.equalTo(_gradationView);
//    }];
//
//    UILabel  *title=[[UILabel alloc]init];
//    title.text=@"分次支付";
//    title.font=[UIFont systemFontOfSize:15];
//    title.backgroundColor=[UIColor clearColor];
//    title.textColor=[CommHelp toUIColorByStr:@"#222222"];
//    title.numberOfLines = 1;
//    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
//    title.lineBreakMode = NSLineBreakByWordWrapping;
//    [_gradationView addSubview:title];
//
//
//    [title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(logo.mas_right).offset(5);
//        make.top.equalTo(_gradationView).offset(10);
//    }];
//
//    tip=[[UILabel alloc]init];
//    tip.text=@"";
//    tip.font=[UIFont systemFontOfSize:11];
//    tip.backgroundColor=[UIColor clearColor];
//    tip.textColor=[CommHelp toUIColorByStr:@"#999999"];
//    tip.numberOfLines = 1;
//    tip.textAlignment = UIControlContentHorizontalAlignmentCenter;
//    tip.lineBreakMode = NSLineBreakByWordWrapping;
//    [_gradationView addSubview:tip];
//
//    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(title.mas_bottom).offset(5);
//        make.left.equalTo(title);
//    }];
//
//}
-(void)initPayWaySubviews:(NSArray*)arr{
    
    [_payWayView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel  *viewTitle=[[UILabel alloc]init];
    viewTitle.text=@"付款方式";
    viewTitle.font=[UIFont systemFontOfSize:13];
    viewTitle.backgroundColor=[UIColor clearColor];
    viewTitle.textColor=[CommHelp toUIColorByStr:@"#999999"];
    viewTitle.numberOfLines = 1;
    viewTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    viewTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [_payWayView addSubview:viewTitle];
    
    [viewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payWayView).offset(0);
        make.left.equalTo(_payWayView).offset(10);
        make.right.equalTo(_payWayView).offset(0);
        make.height.offset(30);
    }];

    
    UIView * lastView;
    for (int i=0; i<[arr count]; i++) {
        
        PayWayMode * payMode =arr[i];
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(payWayViewTap:)]];
        [_payWayView addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.text=payMode.name;
        title.font=[UIFont systemFontOfSize:15];
        title.backgroundColor=[UIColor clearColor];
        title.textColor=[CommHelp toUIColorByStr:@"#222222"];
        title.numberOfLines = 1;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UIImageView * logo=[[UIImageView alloc]init];
        [logo jhSetImageWithURL:[NSURL URLWithString:payMode.icon]];
        logo.contentMode = UIViewContentModeScaleAspectFit;
        [logo setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [logo setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [view addSubview:logo];
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(view).offset(10);
            make.centerY.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(25,40));
        }];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(logo.mas_right).offset(5);
            make.centerY.equalTo(view);
        }];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"order_payway_choose_nomal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"order_payway_choose_select"] forState:UIControlStateSelected];
        button.contentMode=UIViewContentModeScaleAspectFit;
        button.userInteractionEnabled=NO;
        [view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-20);
            make.centerY.equalTo(view);
        }];
        button.selected=NO;
        if (payMode.isDefault) {
            button.selected=YES;
            self.payWayMode=payMode;
        }
        
        UILabel  *tip=[[UILabel alloc]init];
        tip.text=payMode.remarks;
        tip.font=[UIFont systemFontOfSize:12];
        tip.backgroundColor=[UIColor clearColor];
        tip.textColor=kColor999;
        tip.numberOfLines = 1;
        tip.textAlignment = UIControlContentHorizontalAlignmentCenter;
        tip.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(button.mas_left).offset(-5);
            make.centerY.equalTo(view);
        }];
        
//        UIView * line=[[UIView alloc]init];
//        line.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
//        [view addSubview:line];
//
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.equalTo(view).offset(15);
//            make.bottom.equalTo(view).offset(0);
//            make.right.equalTo(view).offset(-15);
//            make.height.offset(1);
//        }];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50);
            make.left.right.equalTo(_payWayView);
            if (i==0) {
                make.top.equalTo(viewTitle.mas_bottom);
            }
            else{
                make.top.equalTo(lastView.mas_bottom);
            }
            if (i==[arr count]-1) {
                
                make.bottom.equalTo(_payWayView);
            }
            
        }];
        
        lastView= view;
    }
    
}

-(void)initBottomView{
    
    UIView * bottom=[[UIView alloc]init];
    [self.contentScroll addSubview:bottom];
    
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_payWayView.mas_bottom).offset(50);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.bottom.equalTo(self.contentScroll).offset(-10);
    }];
    
    UIView * backView=[[UIView alloc]init];
    [bottom addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottom).offset(10);
        make.centerX.equalTo(bottom);
        make.height.equalTo(@30);
    }];
    
    UILabel  *serveTitle=[[UILabel alloc]init];
    serveTitle.text=@"支付遇到问题？请联系";
    serveTitle.font=[UIFont systemFontOfSize:13];
    serveTitle.backgroundColor=[UIColor clearColor];
    serveTitle.textColor=[CommHelp toUIColorByStr:@"#999999"];
    serveTitle.numberOfLines = 1;
    serveTitle.textAlignment = UIControlContentHorizontalAlignmentLeft;
    serveTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [backView addSubview:serveTitle];
    
    [serveTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView);
        make.left.equalTo(backView).offset(10);
    }];
    
    UIButton  *serverBtn=[[UIButton alloc]init];
    [serverBtn setTitle:@"官方客服" forState:UIControlStateNormal];
    serverBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [serverBtn setTitleColor:[UIColor colorWithRed:0.22f green:0.60f blue:0.85f alpha:1.00f] forState:UIControlStateNormal];
    serverBtn.backgroundColor=[UIColor clearColor];
    [serverBtn addTarget:self action:@selector(Contact) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:serverBtn];
    
    [serverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView);
        make.right.equalTo(backView).offset(-5);
        make.left.equalTo(serveTitle.mas_right).offset(0);
    }];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确认支付" forState:UIControlStateNormal];
    [button setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
     UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(279, 44) radius:22];
    [button setBackgroundImage:nor_image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.left.equalTo(bottom).offset(10);
        make.centerX.equalTo(bottom);
        make.top.equalTo(backView.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(279, 44));
        make.bottom.equalTo(bottom);
    }];
}
-(void)tapGardation:(UITapGestureRecognizer*)tap{
    
    NSDecimalNumber *numberAll = [NSDecimalNumber decimalNumberWithString:self.orderMode.orderPrice];
    NSDecimalNumber *numberPay = [NSDecimalNumber decimalNumberWithString:self.orderMode.payedMoney];
    NSDecimalNumber *numResult = [numberAll decimalNumberBySubtracting:numberPay];
    NSLog(@"ddd==%ld",(long)[numResult compare:[NSDecimalNumber decimalNumberWithString:self.orderMode.payBatchLimit] ]);
    if ([numResult compare:[NSDecimalNumber decimalNumberWithString:self.orderMode.payBatchLimit] ]==NSOrderedAscending) {
        [self makeToast: [NSString stringWithFormat:@"分次金额不得少于%@",self.orderMode.payBatchLimit] duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (self.orderMode.orderId) {
        JHOrdePayGradationViewController * vc=[[JHOrdePayGradationViewController alloc]init];
        vc.orderId=self.orderMode.orderId;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}
-(void)Contact{
    
    [[JHQYChatManage shareInstance] showChatWithViewcontroller:self.viewController];
    
}
-(void)payWayViewTap:(UITapGestureRecognizer*)tap{
    
    [self cancleButtonSelect:self.payWayView];
    
    UITapGestureRecognizer *tapView=(UITapGestureRecognizer*)tap;
    for (UIView * view in tapView.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn=(UIButton*)view;
            btn.selected=YES;
        }
    }
    self.payWayMode=self.payWayArray[tap.view.tag];
    
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
-(void)setOrderMode:(JHOrderDetailMode *)orderMode{
    
    _orderMode = orderMode;
    _allPrice.text=[NSString stringWithFormat:@"¥ %.2f",[_orderMode.orderPrice doubleValue]];
    _leavePayPriceField.text=[NSString stringWithFormat:@"%.2f",[_orderMode.orderPrice doubleValue]-[_orderMode.payedMoney doubleValue]];
    tip.text=[NSString stringWithFormat:@"订单≥%@可用",_orderMode.payBatchLimit];
    //头信息
    _headerTitleView.isAuction = self.isAuction;
    [self.headerTitleView setOrderMode:_orderMode];
//    //提示
    [self.headerTipView setSubmitOrdersMode:orderMode];
    
//        OrderStatusTipModel * tipModel=[UserInfoRequestManager findOrderTip:_orderMode.orderStatus];
//         if (tipModel) {
//             [self.headerTipView initContent:tipModel.title andDesc:tipModel.desc];
//
//             [_headerTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                 make.top.equalTo(_headerTitleView.mas_bottom).offset(-15);
//                 make.left.equalTo(self.contentScroll).offset(10);
//                 make.right.equalTo(self.contentScroll).offset(-10);
//                 make.width.offset(ScreenW-20);
//             }];
//         }
          
    
    NSDecimalNumber *numberAll = [NSDecimalNumber decimalNumberWithString:self.orderMode.orderPrice];
    NSDecimalNumber *numberPay = [NSDecimalNumber decimalNumberWithString:self.orderMode.payedMoney];
    NSDecimalNumber *numResult = [numberAll decimalNumberBySubtracting:numberPay];
    NSLog(@"ddd==%ld",(long)[numResult compare:[NSDecimalNumber decimalNumberWithString:self.orderMode.payBatchLimit] ]);
    if ([numResult compare:[NSDecimalNumber decimalNumberWithString:self.orderMode.payBatchLimit] ]==NSOrderedAscending) {
        self.leavePayPriceField.userInteractionEnabled=NO;
        [_alterBtn setHidden:YES];
        [_alterBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_productView).offset(0);
            make.width.equalTo(@0);
        }];
        
    }
    else{
        if (!self.isAuction) {
            
            UIImageView * bubble = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_agent_pay_paopao"]];
            bubble.contentMode=UIViewContentModeScaleAspectFit;
            [self addSubview:bubble];
            [bubble mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_alterBtn.mas_bottom).offset(5);
                make.right.equalTo(_alterBtn.mas_right).offset(0);
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [bubble removeFromSuperview];
            });
            
        }

    }
    if (_orderMode.orderCategoryType==JHOrderCategoryRestoreIntention||
        _orderMode.orderCategoryType==JHOrderCategoryResaleOrder||
        _orderMode.orderCategoryType==JHOrderCategoryResaleIntentionOrder) {
           _leavePayPriceField.userInteractionEnabled=NO;
            [_alterBtn setHidden:YES];
          [_alterBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_productView).offset(0);
              make.width.equalTo(@0);
          }];
       }
    
//    if (self.directDelivery) {
//        _headerTipView.desc = [[JHBusinessModelTitleConfig businessModelTitleConfig] objectForKey:@"JHStraightHairConfigKey"];
//    }
}
-(void)setPayWayArray:(NSArray *)payWayArray{
    
    _payWayArray=payWayArray;
    [self initPayWaySubviews: _payWayArray];
    
}

-(void)onClickBtnAction:(UIButton*)sender{
    
    if (![self isNeedPay]) {
        [self makeToast:@"订单金额已全部支付" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    //    if (self.delegate&&[self.delegate respondsToSelector:@selector(Complete:)]) {
    //
    //        [self.delegate Complete:self.payWayMode];
    //    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(Complete:andPayMoney:)]) {
        [self.delegate Complete:self.payWayMode andPayMoney:[_leavePayPriceField.text doubleValue]];
    }
}
-(void)orderAlter{
    
    if (self.leavePayPriceField.userInteractionEnabled) {
        [self.leavePayPriceField becomeFirstResponder];
    }
}
-(BOOL)isNeedPay{
    
    NSDecimalNumber *numberAll = [NSDecimalNumber decimalNumberWithString:self.orderMode.orderPrice];
    NSDecimalNumber *numberPay = [NSDecimalNumber decimalNumberWithString:self.orderMode.payedMoney];
    
    if ([numberAll compare:numberPay]==NSOrderedSame) {
        return  NO;
    }
    return YES;
}
#pragma mark =============== delegate ===============
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *futureString = [NSMutableString stringWithString:textField.text];
    [futureString insertString:string atIndex:range.location];
    NSInteger flag = 0;
    // 这个可以自定义,保留到小数点后两位,后几位都可以
    const NSInteger limited = 2;
    
    for (NSInteger i = futureString.length - 1; i >= 0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            // 如果大于了限制的就提示
            if (flag > limited) {
                return NO;
            }
            break;
        }
        
        flag++;
    }
    
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField.text length]>0) {
        NSDecimalNumber *leave = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[_orderMode.orderPrice doubleValue]-[_orderMode.payedMoney doubleValue]]];
        //超出实付金额
        if ([ [leave decimalNumberBySubtracting: [NSDecimalNumber decimalNumberWithString:self.leavePayPriceField.text] ] doubleValue]<0) {
            self.leavePayPriceField.text=[NSString stringWithFormat:@"%.2f",leave.doubleValue];
        }
        //少于最低分期金额
        if ([_leavePayPriceField.text doubleValue]<[self.orderMode.payBatchMin doubleValue]) {
            self.leavePayPriceField.text=[NSString stringWithFormat:@"%.2f",[_orderMode.orderPrice doubleValue]-[_orderMode.payedMoney doubleValue]];
            [self makeToast: [NSString stringWithFormat:@"分次金额不得少于%@",self.orderMode.payBatchMin] duration:1.0 position:CSToastPositionCenter];
            return;
        }
    }
    else{
        self.leavePayPriceField.text=[NSString stringWithFormat:@"%.2f",[_orderMode.orderPrice doubleValue]-[_orderMode.payedMoney doubleValue]];
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField  resignFirstResponder];
    return YES;
}

- (void)dealloc
{
    [timer stopGCDTimer];
    NSLog(@"dealloc");
}
@end

