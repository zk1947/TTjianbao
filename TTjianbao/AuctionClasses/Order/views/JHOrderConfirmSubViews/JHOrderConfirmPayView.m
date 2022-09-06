//
//  JHOrderConfirmPayView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderConfirmPayView.h"

@interface JHOrderConfirmPayView ()<UITextFieldDelegate>

@property(nonatomic,strong) UIView *balanceView;
@property(nonatomic,strong) UIView *cashView;
@property(nonatomic,strong) UILabel * tip;
@end
@implementation JHOrderConfirmPayView

-(void)initSubViews{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self initPacketView];
    [self initBalanceView];
    [self initCashView];
}

- (void)displayMarket {
    self.tip.text = @"应付金额=宝贝价格-津贴+运费";
}

- (void)auctionDisplayMarket {
    self.tip.text = @"应付金额=宝贝价格-津贴";
}

-(void)initPacketView{
    
    _cashPacketView=[[UIView alloc]init];
    _cashPacketView.backgroundColor=[UIColor whiteColor];
    _cashPacketView.userInteractionEnabled=YES;
    [self addSubview:_cashPacketView];
    
    [_cashPacketView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.offset(50);
    }];
    UILabel *cashPacketTitle=[[UILabel alloc]init];
    cashPacketTitle.text=@"津贴";
    cashPacketTitle.font=[UIFont fontWithName:kFontNormal size:13];
    cashPacketTitle.backgroundColor=[UIColor clearColor];
    cashPacketTitle.textColor=kColor999;
    cashPacketTitle.numberOfLines = 1;
    cashPacketTitle.textAlignment = NSTextAlignmentLeft;
    cashPacketTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [_cashPacketView addSubview:cashPacketTitle];
    
    [cashPacketTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cashPacketView).offset(15);
        make.centerY.equalTo(_cashPacketView);
    }];
    
    _switchView=[JHSwitch new];
    [_switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_cashPacketView addSubview:_switchView];
    
    [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_cashPacketView).offset([self.switchView leftRightOffset:-5]);
        make.centerY.equalTo(_cashPacketView);
    }];
    
    _cashPacket=[[UILabel alloc]init];
    _cashPacket.font=[UIFont systemFontOfSize:13];
    _cashPacket.backgroundColor=[UIColor clearColor];
    _cashPacket.textColor=[CommHelp toUIColorByStr:@"#999999"];
    _cashPacket.numberOfLines = 1;
    _cashPacket.textAlignment = NSTextAlignmentLeft;
    _cashPacket.lineBreakMode = NSLineBreakByWordWrapping;
    [_cashPacketView addSubview:_cashPacket];
    
    [_cashPacket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cashPacketTitle);
        make.right.equalTo(_switchView.mas_left).offset(-10);
    }];
}
-(void)initBalanceView{
    
    _balanceView=[[UIView alloc]init];
    _balanceView.backgroundColor=[UIColor whiteColor];
    _balanceView.userInteractionEnabled=YES;
    _balanceView.layer.masksToBounds =YES;
    [self addSubview:_balanceView];
    
    [_balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.top.equalTo(_cashPacketView.mas_bottom).offset(0);
        make.height.offset(0);
    }];
    
    UILabel * balanceTitle=[[UILabel alloc]init];
    balanceTitle.text=@"使用额度";
    balanceTitle.font=[UIFont fontWithName:kFontNormal size:13];
    balanceTitle.backgroundColor=[UIColor clearColor];
    balanceTitle.textColor=kColor999;
    balanceTitle.numberOfLines = 1;
    balanceTitle.textAlignment = NSTextAlignmentRight;
    balanceTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [_balanceView addSubview:balanceTitle];
    
    
    [balanceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_balanceView).offset(15);
        make.top.equalTo(_balanceView).offset(0);
    }];
    
    UIButton * _alterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_alterBtn setImage:[UIImage imageNamed:@"orderPrice_alter_icon"] forState:UIControlStateNormal];
    [_alterBtn setImage:[UIImage imageNamed:@"orderPrice_alter_icon"] forState:UIControlStateSelected];
    _alterBtn.contentMode=UIViewContentModeScaleAspectFit;
    [_alterBtn addTarget:self action:@selector(orderAlter) forControlEvents:UIControlEventTouchUpInside];
    _alterBtn.userInteractionEnabled=YES;
    [_balanceView addSubview:_alterBtn];
    
    [_alterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_balanceView).offset(-10);
        make.centerY.equalTo(balanceTitle);
        make.size.mas_equalTo(CGSizeMake(13, 12));
    }];
    
    _cash=[[UITextField alloc]init];
    _cash.backgroundColor=[UIColor clearColor];
    _cash.tag=1;
    _cash.tintColor = [UIColor colorWithRed:1.00f green:0.40f blue:0.42f alpha:1.00f];
    _cash.returnKeyType =UIReturnKeyDone;
    _cash.delegate=self;
    _cash.textAlignment = NSTextAlignmentRight;
    _cash.keyboardType = UIKeyboardTypeDecimalPad;
    _cash.placeholder=@"请输入使用津贴金额";
    _cash.font=[UIFont systemFontOfSize:13];
    [_balanceView addSubview:_cash];
    //
    [self.cash mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_alterBtn.mas_left).offset(-10);
        make.width.equalTo(@200);
        make.height.offset(30);
        make.centerY.equalTo(balanceTitle);
    }];
}

-(void)initCashView{
    
    _cashView=[[UIView alloc]init];
    _cashView.backgroundColor=[UIColor whiteColor];
    _cashView.userInteractionEnabled=YES;
    _cashView.layer.masksToBounds =YES;
    [self addSubview:_cashView];
    [_cashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.top.equalTo(_balanceView.mas_bottom).offset(0);
        //  make.height.offset(100);
        make.bottom.equalTo(self);
    }];
    JHCustomLine *topLine = [JHUIFactory createLine];
    [_cashView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cashView).offset(0);
        make.height.equalTo(@1);
        make.left.offset(15);
        make.right.offset(0);
    }];
    
    UILabel * title=[[UILabel alloc]init];
    title.text=@"应付金额";
    title.font=[UIFont boldSystemFontOfSize:13];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=kColor333;
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentLeft;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_cashView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cashView).offset(15);
        make.top.equalTo(_cashView).offset(15);
    }];
    UIImageView *icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"orderconfirm_introduce_icon"]];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [_cashView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.left.equalTo(title.mas_right).offset(5);
    }];
    
    _shoulPayPrice=[[UILabel alloc]init];
    _shoulPayPrice.text=@"";
    _shoulPayPrice.font = [UIFont fontWithName:kFontBoldDIN size:15.f];
    //    _allPrice.backgroundColor=[UIColor yellowColor];
    _shoulPayPrice.textColor=kColorMainRed;
    _shoulPayPrice.numberOfLines = 1;
    [_shoulPayPrice setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    _shoulPayPrice.textAlignment = NSTextAlignmentLeft;
    _shoulPayPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [_cashView addSubview:_shoulPayPrice];
    
    [_shoulPayPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title).offset(2);
        make.right.equalTo(_cashView.mas_right).offset(-10);
    }];
    
//    UIImageView *indicator=[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"orderConfirm_tip_line"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 200, 0,0) resizingMode:UIImageResizingModeStretch]];
//    indicator.contentMode = UIViewContentModeScaleToFill;
//    [_cashView addSubview:indicator];
//    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(title.mas_bottom).offset(10);
//        make.height.equalTo(@6);
//        make.left.offset(15);
//        make.right.offset(0);
//
//    }];
    UIView * indicator=[[UIView alloc]init];
    indicator.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
    [_cashView addSubview:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(15);
        make.height.equalTo(@1);
        make.left.offset(15);
        make.right.offset(0);
    }];
    
    UILabel * tip=[[UILabel alloc]init];
    tip.font=[UIFont systemFontOfSize:13];
    tip.backgroundColor=[UIColor clearColor];
    tip.textColor=kColor999;
    tip.numberOfLines = 0;
    tip.textAlignment = NSTextAlignmentLeft;
    tip.lineBreakMode = NSLineBreakByWordWrapping;
    self.tip = tip;
    [_cashView addSubview:tip];
    
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cashView).offset(15);
        make.right.equalTo(_cashView).offset(-15);
        make.top.equalTo(indicator.mas_bottom).offset(15);
        
    }];
    
    UILabel * tip2=[[UILabel alloc]init];
    tip2.font=[UIFont systemFontOfSize:13];
    tip2.backgroundColor=[UIColor clearColor];
    tip2.textColor=kColor999;
    tip2.numberOfLines = 0;
    tip2.textAlignment = NSTextAlignmentLeft;
    tip2.lineBreakMode = NSLineBreakByWordWrapping;
    [_cashView addSubview:tip2];
    
    [tip2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cashView).offset(15);
        make.right.equalTo(_cashView).offset(-15);
        make.top.equalTo(tip.mas_bottom).offset(0);
        make.bottom.equalTo(_cashView).offset(-15);
    }];
    
    if(self.orderConfirmMode.orderCategoryType==JHOrderCategoryRestoreProcessing||
       self.orderConfirmMode.orderCategoryType==JHOrderCategoryProcessingGoods) {
        tip.text=@"应付金额=宝贝价格优惠后金额+加工费-津贴";
    }
    else  if (self.orderConfirmMode.orderCategoryType==JHOrderCategoryProcessing) {
        tip.text=@"应付金额=宝贝价格优惠后金额+加工费-津贴";
    }
    else  if (self.orderConfirmMode.orderCategoryType==JHOrderCategoryLimitedTime||
              self.orderConfirmMode.orderCategoryType==JHOrderCategoryLimitedShop
              ) {
        tip.text=@"应付金额=宝贝价格-津贴";
    }
    else  if (self.orderConfirmMode.orderCategoryType==JHOrderCategoryMallOrder) {
        tip.text=@"1.应付金额=宝贝价格-红包-代金券-折扣活动-津贴";
    }
    else{
        //套餐
        if (self.orderConfirmMode.customizeType == 2) {
            tip.text=@"1.应付金额=宝贝价格-红包-代金券-折扣活动-津贴";
            tip2.text=@"2.您购买的是定制套餐（原料+定制），需要先支付[原料订单]，再支付[定制订单]。";
            [tip2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tip.mas_bottom).offset(10);
            }];
        }
        else{
            tip.text=@"应付金额=宝贝价格-红包-代金券-折扣活动-津贴";
        }
        
    }
    
    //税费运费
        if(_orderConfirmMode.taxes.doubleValue>0||
           _orderConfirmMode.freight.doubleValue>0){
            tip.text=[NSString stringWithFormat:@"%@%@",tip.text,@"+跨境运费+税费"];
           }
    
}
//-(void)hiddenCoponView{
//
//    [_mallCoponView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(0);
//        make.left.equalTo(self).offset(0);
//        make.right.equalTo(self).offset(0);
//        make.height.offset(0);
//    }];
//    [_coponView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_mallCoponView.mas_bottom).offset(0);
//        make.left.equalTo(self).offset(0);
//        make.right.equalTo(self).offset(0);
//        make.height.offset(0);
//    }];
//
//    [_discountCoponView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_coponView.mas_bottom).offset(0);
//        make.left.equalTo(self).offset(0);
//        make.right.equalTo(self).offset(0);
//        make.height.offset(0);
//    }];
//}
-(void)updateBlanceView:(BOOL)isSwitch{
    if (!isSwitch) {
        self.cash.text=nil;
        [_balanceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cashPacketView.mas_bottom).offset(0);
            make.height.offset(0);
        }];
    }
    else{
        self.cash.text=self.orderConfirmMode.originOrderPrice;
        [_balanceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cashPacketView.mas_bottom).offset(10);
            make.height.offset(40);
        }];
    }
    
}
-(void)setOrderConfirmMode:(JHOrderDetailMode *)orderConfirmMode{
    
    _orderConfirmMode = orderConfirmMode;
}
-(void)tapCopon:(UIGestureRecognizer*)tap{
    
    if (self.coponHandle) {
        self.coponHandle(tap);
    }
}
-(void)tapMallCopon:(UIGestureRecognizer*)tap{
    if (self.mallCoponHandle) {
        self.mallCoponHandle(tap);
    }
}
-(void)tapDiscountCopon:(UIGestureRecognizer*)tap{
    if (self.discountCoponHandle) {
        self.discountCoponHandle(tap);
    }
}
-(void)switchAction:(UISwitch*)aSwitch{
    
    if (self.switchViewHandle) {
        self.switchViewHandle(aSwitch);
    }
}
-(void)orderAlter{
    
    if (self.cash.userInteractionEnabled) {
        [self.cash becomeFirstResponder];
    }
}

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
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.cashEndEditingHandle) {
        self.cashEndEditingHandle(nil);
    }
    // [self setCoponDesc];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField  resignFirstResponder];
    return YES;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
