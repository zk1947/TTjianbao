//
//  JHAuctionOrderConfirmView.m
//  TTjianbao
//
//  Created by zk on 2021/8/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAuctionOrderConfirmView.h"
#import "BYTimer.h"
#import "JHCouponListView.h"
#import "JHMallCoponListView.h"
#import "JHDiscountCoponListView.h"
#import "JHOrderViewModel.h"
#import "TTjianbaoHeader.h"
#import "EnlargedImage.h"
#import "NSString+AttributedString.h"
#import "JHUIFactory.h"
#import "JHItemMode.h"
#import "JHWebViewController.h"
#import "GrowingManager.h"
#import "JHOrderRemainTimeView.h"
#import "JHOrderConfirmAdressView.h"
#import "JHOrderConfirmProductView.h"
#import "JHOrderConfirmShopTrolleyView.h"
#import "JHOrderFeeView.h"
#import "JHOrderConfirmCoponView.h"
#import "JHOrderConfirmProcessPayView.h"
#import "JHOrderGoodsPriceView.h"
#import "JHOrderConfirmPayView.h"
#import "JHOrderConfirmNoteView.h"
#import "JHOrderConfirmOfferView.h"
#import "JHOrderConfirmProtocolView.h"
#import "UIImage+JHColor.h"
#import "JHOrderConfirmHeaderTipView.h"
#import "JHCustomizePayCashView.h"
#import "JHWebViewController.h"
#import "JHCheckBoxProtocolView.h"

@interface JHAuctionOrderConfirmView ()
{
    BYTimer *timer;
    //实付金额
    NSDecimalNumber * numRealPay;
    //津贴抵扣
    NSDecimalNumber *numberCashPacket;
    
    //需要支付的金额
    double needPayMoney;
}
@property(nonatomic,strong) UIScrollView * contentScroll;
//@property(nonatomic,strong) JHOrderRemainTimeView * remainTimeView;
@property(nonatomic,strong) JHOrderConfirmHeaderTipView * tipView;
@property(nonatomic,strong) UILabel *secandLab;
@property(nonatomic,strong) JHOrderConfirmAdressView * addressView;
@property(nonatomic,strong) JHOrderConfirmProductView *productView;
@property(nonatomic,strong) JHOrderConfirmShopTrolleyView *shopTrolleyView;
@property(nonatomic,strong) JHOrderGoodsPriceView *goodsPriceView;
@property(nonatomic,strong) JHOrderConfirmProcessPayView *processPayView;
@property(nonatomic,strong) JHOrderFeeView *feeView;
@property(nonatomic,strong) JHOrderFeeView *taxesFeeView;
@property(nonatomic,strong) JHOrderConfirmCoponView *coponView;
@property(nonatomic,strong) JHOrderConfirmPayView *payView;
@property(nonatomic,strong) JHOrderConfirmOfferView *offerView;
@property(nonatomic,strong) JHCustomizePayCashView *prepayPayCashView;

@property(nonatomic,strong) JHOrderConfirmNoteView *noteView;
@property(nonatomic,strong)     JHOrderConfirmProtocolView *protocolView;

@property (assign, nonatomic)   NSInteger goodsCount;
@property (strong, nonatomic)   UILabel *allPrice;
@property (strong, nonatomic)   UILabel *allCount;
@property (strong, nonatomic)   NSIndexPath * selectIndexPath;
@property (strong, nonatomic)   CoponMode *selectCoponMode;
@property (strong, nonatomic)   NSIndexPath * selectMallCouponIndexPath;
@property (strong, nonatomic)   CoponMode *selectMallCouponMode;
@property (strong, nonatomic)   NSIndexPath * selectDiscountCouponIndexPath;
@property (strong, nonatomic)   CoponMode *selectDiscountCouponMode;
//@property (strong, nonatomic)   UIButton * protocolBtn;
@property (strong, nonatomic)   UIButton * completeBtn;
@property (assign, nonatomic)   BOOL blanceSwitchOn;
@property (strong, nonatomic)  UILabel  *title;
@property (strong, nonatomic) JHCheckBoxProtocolView *checkBoxProtocolView;

@end
@implementation JHAuctionOrderConfirmView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initScrollview];
        [self initBottomView];
        self.selectIndexPath= nil;
        self.selectMallCouponIndexPath= nil;
        self.selectDiscountCouponIndexPath= nil;
        //默认开启余额
        self.blanceSwitchOn=YES;
    }
    return self;
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
        make.bottom.equalTo(self).offset(-50);
        make.left.right.equalTo(self);
    }];
    // [self initTimerView];
    [self initTipView];
    [self initSecandView];
    [self initAddressView];
    [self initProductView];
    [self initShopTrolleyView];
    [self initGoodsPriceView];
    [self initProcessPayView];
    [self initFeeView];
    [self initTaxesFeeView];
    
    [self initPayView];
    [self initOfferView];
    [self initPrepayPayCashView];
    [self initOrderNote];
    [self initProtocolView];
    
    [self dispayMarketView];
    
}

//-(void)initTimerView{
//
//    _remainTimeView=[[JHOrderRemainTimeView alloc]init];
//      [self.contentScroll addSubview:_remainTimeView];
//      [_remainTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
//          make.top.equalTo(self.contentScroll).offset(10);
//          make.left.equalTo(self.contentScroll).offset(10);
//          make.right.equalTo(self.contentScroll).offset(-10);
//          make.height.offset(0);
//          make.width.offset(ScreenW-20);
//      }];
//      _remainTimeView.title=@"剩余支付时间:";
//      _titleView=[[JHOrderTitleView alloc]init];
//
//}

- (void)dispayMarketView {
//    [_tipView displayMarket];
    // 隐藏购买数量
//    _shopTrolleyView.hidden = YES;
    [_goodsPriceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shopTrolleyView.mas_bottom).offset(0);
    }];
    self.coponView.hidden = YES;
    _allCount.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.payView.cashPacketView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.payView).offset(0);
        }];
        [self.payView auctionDisplayMarket];
    });
    self.title.text = @"应付金额：";
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(5);
        make.centerY.equalTo(_completeBtn);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(34);
    }];
    
    [self.allPrice mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(5);
        make.centerY.equalTo(_completeBtn);
        make.left.mas_equalTo(self.title.mas_right).mas_offset(10);
        make.height.mas_equalTo(34);
    }];
    [self.contentScroll addSubview:self.checkBoxProtocolView];
    [self.checkBoxProtocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noteView.mas_bottom).offset(12);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}

- (Boolean)isSelectedProtocol {
    return [self.checkBoxProtocolView getCheckBoxSelectStatus];
}

-(void)initTipView {
    
    _tipView=[[JHOrderConfirmHeaderTipView alloc] init];
    _tipView.leftSpace = 20;
    [_tipView initSubviews];
 
    [self.contentScroll addSubview:_tipView];
    [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.width.offset(ScreenW);
    }];
}

- (void)initSecandView{
    
    UIView *secBackView = [UIView new];
    secBackView.backgroundColor = HEXCOLOR(0xFFEDE7);
    [secBackView jh_cornerRadius:4];
    [self.contentScroll addSubview:secBackView];
    [secBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.mas_equalTo(32);
    }];
    
    _secandLab = [[UILabel alloc]init];
    _secandLab.text = @"您已成功拍得该商品，剩余付款时间：00时00分00秒";
    _secandLab.textColor = HEXCOLOR(0xFC4200);
    _secandLab.font = JHFont(12);
//    _secandLab.textAlignment = NSTextAlignmentCenter;
    [secBackView addSubview:_secandLab];
    [_secandLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.equalTo(secBackView).offset(45);
        make.right.equalTo(secBackView).offset(0);
        make.height.mas_equalTo(32);
    }];
    
    UIImageView *imgv = [[UIImageView alloc]init];
    imgv.image = JHImageNamed(@"order_confirm_time_logo");
    [secBackView addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_secandLab);
        make.left.mas_equalTo(31);
        make.width.mas_equalTo(9);
        make.height.mas_equalTo(10);
    }];
    
//    if (timer) {
//        [timer stopGCDTimer];
//    }
//    timer=[[BYTimer alloc]init];
//    @weakify(self)
//    [timer createTimerWithTimeout:[CommHelp dateRemaining:@"2021-08-03 18:26:22"] handlerBlock:^(int presentTime) {
//        @strongify(self)
//        self.secandLab.text = [NSString stringWithFormat:@"您已成功拍得该商品，剩余付款时间：%@",[CommHelp getHMSWithSecondWord:presentTime]];
//    } finish:^{
//        self.secandLab.text = @"订单已取消";
//    }];
}

-(void)initAddressView{
    _addressView=[[JHOrderConfirmAdressView alloc]init];
    [self.contentScroll addSubview:_addressView];
    [_addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_secandLab.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(80);
    }];
}
-(void)initProductView{
    
    _productView=[[JHOrderConfirmProductView alloc]init];
    [self.contentScroll addSubview:_productView];
    [_productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}
-(void)initShopTrolleyView{
    
    _shopTrolleyView=[[JHOrderConfirmShopTrolleyView alloc]init];
    [self.contentScroll addSubview:_shopTrolleyView];
    [_shopTrolleyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(0);
    }];
    JH_WEAK(self)
    _shopTrolleyView.buttonHandle = ^(id obj) {
        JH_STRONG(self)
        UIButton * button=(UIButton*)obj;
        [self changeGoodsCount:button];
    };
}
-(void)initGoodsPriceView{
    
    _goodsPriceView=[[JHOrderGoodsPriceView alloc]init];
    [self.contentScroll addSubview:_goodsPriceView];
    [_goodsPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shopTrolleyView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(0);
    }];
}
-(void)initProcessPayView{
    
    _processPayView=[[JHOrderConfirmProcessPayView alloc]init];
    [self.contentScroll addSubview:_processPayView];
    [_processPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsPriceView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}

-(void)initFeeView{
    _feeView=[[JHOrderFeeView alloc]init];
    [self.contentScroll addSubview:_feeView];
    [_feeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_processPayView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}
-(void)initTaxesFeeView{
    _taxesFeeView=[[JHOrderFeeView alloc]init];
    [self.contentScroll addSubview:_taxesFeeView];
    [_taxesFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_feeView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    
    //    _taxesFeeView.introducePressBlock = ^(id obj) {
    //
    //        NSInteger index = [(NSNumber*)obj integerValue];
    //        if (index == 1) {
    //             // 税费介绍url
    //            JHWebViewController *vc = [[JHWebViewController alloc] init];
    //            vc.urlString = H5_BASE_STRING(@"/jianhuo/app/overseas/shippingInstructions.html");
    //            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    //        }
    //
    //      else if (index == 2) {
    //
    //            // 运费介绍url
    //            JHWebViewController *vc = [[JHWebViewController alloc] init];
    //            vc.urlString = H5_BASE_STRING(@"/jianhuo/app/overseas/shippingInstructions.html");
    //            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    //
    //        };
    //
    //    };
}

-(void)initPayView{
    _payView=[[JHOrderConfirmPayView alloc]init];
    [self.contentScroll addSubview:_payView];
    [_payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_taxesFeeView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    JH_WEAK(self)
    _payView.switchViewHandle = ^(id obj) {
        JH_STRONG(self)
        UISwitch *aSwitch =(UISwitch*)obj;
        [self switchAction:aSwitch];
    };
    _payView.cashEndEditingHandle = ^(id obj) {
        JH_STRONG(self)
        [self setCoponDesc];
    };
}
-(void)initOfferView{
    
    _offerView=[[JHOrderConfirmOfferView alloc]init];
    [self.contentScroll addSubview:_offerView];
    [_offerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}
-(void)initPrepayPayCashView{
    
    _prepayPayCashView=[[JHCustomizePayCashView alloc]init];
    [self.contentScroll addSubview:_prepayPayCashView];
    
    [_prepayPayCashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_offerView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        // make.height.offset(0);
    }];
}
-(void)initOrderNote{
    
    _noteView=[[JHOrderConfirmNoteView alloc]init];
    [self.contentScroll addSubview:_noteView];
    [_noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_prepayPayCashView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(110);
    }];
}
-(void)initProtocolView{
    
    _protocolView = [JHOrderConfirmProtocolView new];
    [self.contentScroll addSubview:_protocolView];
    [_protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noteView.mas_bottom).offset(20);
        make.height.offset(20.);
        make.centerX.equalTo(self.contentScroll);
        make.bottom.equalTo(self.contentScroll).offset(-20);
    }];
    [_protocolView setHidden:YES];
}
-(void)initBottomView{
    
    UIView * bottom=[[UIView alloc]init];
    bottom.backgroundColor=[CommHelp toUIColorByStr:@"ffffff"];
    [self addSubview:bottom];
    
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).offset(0);
        make.height.offset(50);
        make.bottom.equalTo(self);
    }];
    
    _allCount=[[UILabel alloc]init];
    _allCount.text=@"";
    _allCount.font=[UIFont fontWithName:kFontNormal size:12];
    _allCount.textColor=kColor999;
    _allCount.numberOfLines = 1;
    _allCount.textAlignment = NSTextAlignmentLeft;
    _allCount.lineBreakMode = NSLineBreakByWordWrapping;
    [bottom addSubview:_allCount];
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"应付金额";
    title.font=[UIFont systemFontOfSize:12];
    title.textColor=kColor333;
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentLeft;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    self.title = title;
    [bottom addSubview:title];
    
    _allPrice=[[UILabel alloc]init];
    _allPrice.text=@"";
    _allPrice.font = [UIFont fontWithName:kFontBoldDIN size:18.f];
    _allPrice.textColor=kColorMainRed;
    _allPrice.numberOfLines = 1;
    [_allPrice setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    _allPrice.textAlignment = NSTextAlignmentLeft;
    _allPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [bottom addSubview:_allPrice];
    
    UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(142, 34) radius:17];
    //       UIImage *login_dis_image = [UIImage createImageColor:kColor666 size:CGSizeMake(loginButtonWidth, loginButtonHeight) radius:22];
    
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //_completeBtn.backgroundColor=kColorMain;
    [_completeBtn setBackgroundImage:nor_image forState:UIControlStateNormal];
    // _completeBtn.layer.cornerRadius=17;
    _completeBtn.layer.masksToBounds=YES;
    [_completeBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    _completeBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [_completeBtn  setTitle:@"去支付" forState:UIControlStateNormal];
    _completeBtn.contentMode=UIViewContentModeScaleAspectFit;
    [_completeBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:_completeBtn];
    
    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottom).offset(-10);
        make.centerY.equalTo(bottom);
        make.width.offset(142);
        make.height.offset(34);
    }];
    
    [_allPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        //  make.centerY.equalTo(title).offset(2);
        make.centerY.equalTo(bottom);
        make.right.equalTo(_completeBtn.mas_left).offset(-10);
        make.height.offset(34);
    }];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_allPrice).offset(-2);
        make.centerY.equalTo(bottom);
        make.right.equalTo(_allPrice.mas_left).offset(-10);
        make.height.offset(34);
    }];
    
    [_allCount mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_allPrice).offset(-2);
        make.centerY.equalTo(bottom);
        make.height.offset(34);
        make.right.equalTo(title.mas_left).offset(-10);
    }];
    
    
}

-(void)handleFeeData:(JHOrderDetailMode*)mode{
    NSMutableArray * titles=[self.feeView handleFeeData:mode ];
    if (titles.count>0) {
        [self.feeView initFeeSubViews:titles];
        [self.feeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.processPayView.mas_bottom).offset(10);
        }];
    }
}
-(void)handleCustomizeFeeData:(JHOrderDetailMode*)mode{
    
    NSMutableArray * titles=[self.feeView handleCustomizeFeeData:mode ];
    if (titles.count>0) {
        [self.feeView initFeeSubViews:titles];
        [self.feeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.processPayView.mas_bottom).offset(10);
        }];
    }
}
-(void)handleTaxesData:(JHOrderDetailMode*)mode{
    
    NSMutableArray * titles ;
    if (mode.isC2C) {
        titles=[self.taxesFeeView handleC2CTaxesFeeData:mode];
        [self.taxesFeeView initC2CTaxesFeeSubViews:titles];
    }
    else{
        if(_orderConfirmMode.taxes.doubleValue>0||
           _orderConfirmMode.freight.doubleValue>0){
            titles=[self.taxesFeeView handleTaxesFeeData:mode];
            if (titles.count>0) {
                [self.taxesFeeView initTaxesFeeSubViews:titles];
            }
        }
    }
    
    if (titles.count>0) {
        [self.taxesFeeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.feeView.mas_bottom).offset(10);
        }];
    }
}
-(void)handleOfferData:(JHStoneIntentionInfoModel*)mode{
    NSMutableArray * titles=[self.offerView handleOfferData:mode andConfirmDetailMode:self.orderConfirmMode];
    if (titles.count>0) {
        [self.offerView initOfferSubViews:titles];
        [_offerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_payView.mas_bottom).offset(10);
        }];
    }
}
-(void)handleCustomizeData:(JHOrderDetailMode*)mode{
    NSMutableArray * titles=[self.offerView handleCustomizeOfferData:mode];
    if (titles.count>0) {
        [self.offerView initOfferSubViews:titles];
        [_offerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_payView.mas_bottom).offset(10);
        }];
    }
}

-(void)tapCopon:(UIGestureRecognizer*)tap{
    [self endEditing:YES];
    if (self.orderConfirmMode.myCouponVoList.count<=0) {
        return;
    }
    JHCouponListView *view = [[JHCouponListView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [self.viewController.view addSubview:view];
    [view setDataArr:self.orderConfirmMode.myCouponVoList andDefaultSelecltIndex:self.selectIndexPath];
    [view showAlert];
    JH_WEAK(self)
    view.cellSelect = ^(NSIndexPath *indexPath) {
        JH_STRONG(self)
        if (indexPath==nil) {
            self.selectIndexPath=nil;
            self.selectCoponMode=nil;
        }else{
            self.selectIndexPath=indexPath;
            self.selectCoponMode=self.orderConfirmMode.myCouponVoList[self.selectIndexPath.row];
        }
        [self setCoponDesc];
    };
}
-(void)tapMallCopon:(UIGestureRecognizer*)tap{
    
    [self endEditing:YES];
    if (self.orderConfirmMode.mySellerCouponVoList.count<=0) {
        return;
    }
    JHMallCoponListView *view = [[JHMallCoponListView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [self.viewController.view addSubview:view];
    [view setDataArr:self.orderConfirmMode.mySellerCouponVoList andDefaultSelecltIndex:self.selectMallCouponIndexPath];
    [view showAlert];
    JH_WEAK(self)
    view.cellSelect = ^(NSIndexPath *indexPath) {
        JH_STRONG(self)
        if (indexPath==nil) {
            self.selectMallCouponIndexPath=nil;
            self.selectMallCouponMode=nil;
        }else{
            self.selectMallCouponIndexPath=indexPath;
            self.selectMallCouponMode=self.orderConfirmMode.mySellerCouponVoList[ self.selectMallCouponIndexPath.row];
        }
        [self setCoponDesc];
    };
}
-(void)tapDiscountCopon:(UIGestureRecognizer*)tap{
    
    [self endEditing:YES];
    if (self.orderConfirmMode.discountAllCouponVoList.count<=0) {
        return;
    }
    JHDiscountCoponListView *view = [[JHDiscountCoponListView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [self.viewController.view addSubview:view];
    
    [view setDataArr:self.orderConfirmMode.discountAllCouponVoList andDefaultSelecltIndex:self.selectDiscountCouponIndexPath];
    [view showAlert];
    JH_WEAK(self)
    view.cellSelect = ^(NSIndexPath *indexPath) {
        JH_STRONG(self)
        if (indexPath==nil) {
            self.selectDiscountCouponIndexPath=nil;
            self.selectDiscountCouponMode=nil;
        }else{
            self.selectDiscountCouponIndexPath=indexPath;
            self.selectDiscountCouponMode=self.orderConfirmMode.discountAllCouponVoList[ self.selectDiscountCouponIndexPath.row];
        }
        [self setCoponDesc];
    };
}
-(void)switchAction:(UISwitch*)aSwitch{
    self.blanceSwitchOn=aSwitch.on;
    [self updateBlanceView:aSwitch.on];
    [self setCoponDesc];
}
-(void)setAddressChooseAction:(JHFinishBlock)addressChooseAction{
    
    //    _addressChooseAction = addressChooseAction;
    //    _addressView.addressChooseAction = _addressChooseAction;
}
-(void)setAddressMode:(AdressMode *)addressMode{
    
    _addressMode=addressMode;
    [self.addressView setAddressMode:_addressMode];
    if (_addressMode.receiverName&&_addressMode.phone) {
        [_addressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_secandLab.mas_bottom).offset(10);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
            make.height.offset(80);
        }];
    }
    else{
        [_addressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_secandLab.mas_bottom).offset(10);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
            make.height.offset(174);
        }];
    }
}
-(void)setIntentionMode:(JHStoneIntentionInfoModel *)intentionMode{
    _intentionMode=intentionMode;
    //原石回血单或个人转售订单出价信息
    if (self.orderConfirmMode.orderCategoryType==JHOrderCategoryRestore||
        self.orderConfirmMode.orderCategoryType==JHOrderCategoryResaleOrder) {
        [self handleOfferData:_intentionMode];
    }
}
-(void)configTimeDown:(JHOrderDetailMode*)mode{
//    self.secandLab.text = [CommHelp getHMSWithSecond:[CommHelp dateRemaining:mode.payExpireTime]];
    self.secandLab.text = [NSString stringWithFormat:@"您已成功拍得该商品，剩余付款时间：%@",[CommHelp getHMSWithSecondWord:[CommHelp dateRemaining:mode.payExpireTime]]];
    if (timer) {
        [timer stopGCDTimer];
    }
    timer=[[BYTimer alloc]init];
    @weakify(self)
    [timer createTimerWithTimeout:[CommHelp dateRemaining:mode.payExpireTime] handlerBlock:^(int presentTime) {
        @strongify(self)
//        self.secandLab.text = [CommHelp getHMSWithSecond:presentTime];
        self.secandLab.text = [NSString stringWithFormat:@"您已成功拍得该商品，剩余付款时间：%@",[CommHelp getHMSWithSecondWord:presentTime]];
    } finish:^{
        @strongify(self)
        self.secandLab.text = @"订单已取消";
    }];
}
-(void)setOrderConfirmMode:( JHOrderDetailMode*)orderConfirmMode{
    
    _orderConfirmMode = orderConfirmMode;
    
    [self configTimeDown:_orderConfirmMode];
    
    //    _orderConfirmMode.taxes = @"100";
     //   _orderConfirmMode.freight = @"50";
    //    //主动下单不倒计时
    //    if (self.activeConfirmOrder) {
    //        [self.completeBtn  setTitle:@"提交订单" forState:UIControlStateNormal];
    //        [_remainTimeView mas_updateConstraints:^(MASConstraintMaker *make) {
    //            make.top.equalTo(self.contentScroll).offset(0);
    //            make.height.offset(0);
    //        }];
    //    }
    //    else{
    
    //        [self configTimeDown:_orderConfirmMode];
    //    }
    //    //提示信息
    //    OrderStatusTipModel * tipModel=[UserInfoRequestManager findOrderTip:@"waitpay"];
    //    if (tipModel) {
    //        [self.tipView initContent:tipModel.title andDesc:tipModel.desc];
    //    }
    
    if(orderConfirmMode.isC2C) {
        self.checkBoxProtocolView.hidden = NO;
    }
  
    
    //商品信息 商品标签
    [self.productView setOrderMode:_orderConfirmMode];
    [self.productView ConfigCategoryTagTitle:_orderConfirmMode];
    // 原石回血单,个人转售单 显示回血协议
    if (_orderConfirmMode.orderCategoryType==JHOrderCategoryRestore||
        _orderConfirmMode.orderCategoryType==JHOrderCategoryRestoreProcessing||
        _orderConfirmMode.orderCategoryType==JHOrderCategoryResaleOrder) {
        self.protocolView.hidden=NO;
    }
    //加工服务单或者加工单 显示加工费
    if (_orderConfirmMode.orderCategoryType==JHOrderCategoryProcessing||
        _orderConfirmMode.orderCategoryType==JHOrderCategoryProcessingGoods||
        _orderConfirmMode.orderCategoryType==JHOrderCategoryRestore||
        _orderConfirmMode.orderCategoryType==JHOrderCategoryRestoreProcessing)
    {
        [self handleFeeData:_orderConfirmMode];
    }
    //定制尾款服务单 显示加工费
    else if (_orderConfirmMode.orderCategoryType==JHOrderCategoryCustomizedOrder||
             _orderConfirmMode.orderCategoryType==JHOrderCategoryCustomizedIntentionOrder){
        [self handleCustomizeFeeData:_orderConfirmMode];
    }
    //税费运费
    [self handleTaxesData:_orderConfirmMode];
   
    // 回血普通订单,个人转售订单,定制意向金单,定制服务单,不可以用券和津贴
    if (_orderConfirmMode.orderCategoryType!=JHOrderCategoryRestore&&
        _orderConfirmMode.orderCategoryType!=JHOrderCategoryResaleOrder
        &&
        _orderConfirmMode.orderCategoryType!=JHOrderCategoryCustomizedOrder&&
        _orderConfirmMode.orderCategoryType!=JHOrderCategoryCustomizedIntentionOrder&&
        _orderConfirmMode.orderCategoryType!=JHOrderCategoryPersonalCustomizeOrder
        ){
        [_payView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_taxesFeeView.mas_bottom).offset(10);
        }];
        
        [self.payView setOrderConfirmMode:_orderConfirmMode];
        [self.payView initSubViews];
        
        //加工单 券布局
        if (_orderConfirmMode.orderCategoryType==JHOrderCategoryProcessing||
            _orderConfirmMode.orderCategoryType==JHOrderCategoryProcessingGoods||
            _orderConfirmMode.orderCategoryType==JHOrderCategoryRestoreProcessing){
            
            [self.processPayView addSubview:self.coponView];
            [self.coponView initSubViews];
            [self.coponView setOrderConfirmMode:_orderConfirmMode];
            [self.coponView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.processPayView).offset(0);
                make.left.equalTo(self.processPayView).offset(0);
                make.right.equalTo(self.processPayView).offset(0);
            }];
            
            [self.processPayView initSubViews];
            [self.processPayView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_goodsPriceView.mas_bottom).offset(10);
            }];
            
            [_goodsPriceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_shopTrolleyView.mas_bottom).offset(10);
                make.height.offset(50);
            }];
            [_goodsPriceView setOrderMode:_orderConfirmMode];
            
            [self setDefaultSelectCopon];
        }
        
        //除了特卖单外其他订单
        else if (_orderConfirmMode.orderCategoryType!=JHOrderCategoryLimitedTime&&
                 _orderConfirmMode.orderCategoryType!=JHOrderCategoryLimitedShop){
            [self.payView addSubview:self.coponView];
            [self.coponView initSubViews];
            [self.coponView setOrderConfirmMode:_orderConfirmMode];
            [self.coponView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.payView).offset(0);
                make.left.equalTo(self.payView).offset(0);
                make.right.equalTo(self.payView).offset(0);
            }];
            [self.payView.cashPacketView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.payView).offset(150);
            }];
            
            if (_orderConfirmMode.orderCategoryType==JHOrderCategoryMallOrder){
                [self.coponView.discountCoponView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                }];
                [self.payView.cashPacketView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.payView).offset(100);
                }];
            }
            
            [self setDefaultSelectCopon];
            
        }
        //老商城和新商城显示购物车模快
//        if (_orderConfirmMode.orderCategoryType==JHOrderCategoryMallOrder||
//            _orderConfirmMode.orderCategoryType==JHOrderCategoryLimitedTime||
//            _orderConfirmMode.orderCategoryType==JHOrderCategoryLimitedShop)
//        {
            [_shopTrolleyView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_productView.mas_bottom).offset(10);
                make.left.equalTo(self.contentScroll).offset(10);
                make.right.equalTo(self.contentScroll).offset(-10);
                make.height.offset(48);
            }];
            self.shopTrolleyView.goodCountLabel.text=[NSString stringWithFormat:@"%ld",(long)_orderConfirmMode.goodsCount];
            self.goodsCount=_orderConfirmMode.goodsCount;
            self.allCount.text=[NSString stringWithFormat:@"共%ld件",self.goodsCount];
            
//        }
        
        self.payView.switchView.on=self.blanceSwitchOn;
        // 如果津贴为0，关闭余额开关
        
        double num = [NSDecimalNumber decimalNumberWithString:_orderConfirmMode.usableBountyAmount].doubleValue;
        
        if (orderConfirmMode.isC2C) {
            num = [NSDecimalNumber decimalNumberWithString:_orderConfirmMode.limitBountyAmount].doubleValue;
        }
        
        if ( num <= 0 || isnan(num) ||!_orderConfirmMode.usableBountyAmount) {
            self.payView.switchView.userInteractionEnabled=NO;
            self.payView.switchView.on=NO;
            self.blanceSwitchOn=NO;
            self.payView.cashPacket.text=@"无可用津贴";
        }
        [self updateBlanceView:self.payView.switchView.on];
    }
    
    //显示计算公式
    if (_orderConfirmMode.orderCategoryType == JHOrderCategoryCustomizedOrder||
        _orderConfirmMode.orderCategoryType == JHOrderCategoryCustomizedIntentionOrder
        ){
        [self handleCustomizeData:_orderConfirmMode];
    }
    
    //新定制订单显示应付预付款  隐藏备注栏
    if (_orderConfirmMode.orderCategoryType == JHOrderCategoryPersonalCustomizeOrder
        ){
        [_prepayPayCashView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_offerView.mas_bottom).offset(10);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
        }];
        _noteView.hidden = YES;
        
        //定制订单预付款金额取orderPrice就可以
        [_prepayPayCashView initConfirmOrderShouldPayCashSubViews:_orderConfirmMode];
    }
    //计算bottom金额
    [self setCoponDesc];
    
    [self dispayMarketView];
    
}
-(void)setDefaultSelectCopon{
    
    
    self.selectIndexPath= nil;
    self.selectMallCouponIndexPath= nil;
    self.selectDiscountCouponIndexPath= nil;
    self.selectMallCouponMode = nil;
    self.selectCoponMode = nil;
    self.selectDiscountCouponMode = nil;
    
    if (([_orderConfirmMode.mySellerCouponVoList count]>0&&
         _orderConfirmMode.sellerCouponId)||
        ([_orderConfirmMode.mySellerCouponVoList count]>0&&
         _orderConfirmMode.orderCategoryType ==JHOrderCategoryMallOrder))
    {
        self.selectMallCouponIndexPath= [NSIndexPath indexPathForRow:0 inSection:0];
        self.selectMallCouponMode=self.orderConfirmMode.mySellerCouponVoList[self.selectMallCouponIndexPath.row];
    }
    else{
        self.coponView.mallDesc.text=@"暂无可用";
    }
    if (([_orderConfirmMode.myCouponVoList count]>0&&
         _orderConfirmMode.couponId)||
        ([_orderConfirmMode.myCouponVoList count]>0&&
         _orderConfirmMode.orderCategoryType ==JHOrderCategoryMallOrder)) {
        self.selectIndexPath= [NSIndexPath indexPathForRow:0 inSection:0];
        self.selectCoponMode=self.orderConfirmMode.myCouponVoList[ self.selectIndexPath.row];
    }
    else{
        self.coponView.platformDesc.text=@"暂无可用";
    }
    if ([_orderConfirmMode.discountAllCouponVoList count]>0&&_orderConfirmMode.discountCouponId) {
        self.selectDiscountCouponIndexPath= [NSIndexPath indexPathForRow:0 inSection:0];
        self.selectDiscountCouponMode=self.orderConfirmMode.discountAllCouponVoList[ self.selectDiscountCouponIndexPath.row];
    }
    else{
        self.coponView.discountdDesc.text=@"暂无可用";
    }
    
}
-(void)setCoponDesc{
    
    self.coponView.platformCoponView.userInteractionEnabled=YES;
    self.coponView.mallCoponView.userInteractionEnabled=YES;
    self.coponView.discountCoponView.userInteractionEnabled=YES;
    
    //应付金额开始取原始金额
    numRealPay = [NSDecimalNumber decimalNumberWithString:self.orderConfirmMode.originOrderPrice];
    //加工单 用券规则需要减去 加工费
    if (self.orderConfirmMode.orderCategoryType==JHOrderCategoryProcessing||
        self.orderConfirmMode.orderCategoryType==JHOrderCategoryProcessingGoods||
        self.orderConfirmMode.orderCategoryType==JHOrderCategoryRestoreProcessing)
    {
        
        if (self.orderConfirmMode.manualCost) {
            NSDecimalNumber *manualCost = [NSDecimalNumber decimalNumberWithString:self.orderConfirmMode.manualCost];
            numRealPay = [numRealPay decimalNumberBySubtracting:manualCost];
        }
        if (self.orderConfirmMode.materialCost) {
            NSDecimalNumber *materialCost = [NSDecimalNumber decimalNumberWithString:self.orderConfirmMode.materialCost];
            numRealPay = [numRealPay decimalNumberBySubtracting:materialCost];
        }
        
    }
    
    //代金券
    if (self.selectMallCouponMode) {
        self.coponView.mallDesc.text=[NSString stringWithFormat:@"-¥%@",self.selectMallCouponMode.price];
        self.coponView.mallDesc.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
        NSDecimalNumber *numberPay = [NSDecimalNumber decimalNumberWithString:self.selectMallCouponMode.price];
        //减去 代金券
//        numRealPay = [numRealPay decimalNumberBySubtracting:numberPay];
        if (numRealPay.doubleValue<=0) {
            numRealPay=0;
            if (!self.selectCoponMode) {
                self.coponView.platformCoponView.userInteractionEnabled=NO;
            }
        }
    }
    else{
        self.coponView.mallDesc.textColor=kColor999;
        self.coponView.mallDesc.text=[NSString stringWithFormat:@"%lu 张可用",(unsigned long)[self.orderConfirmMode.mySellerCouponVoList count]];
    }
    //红包
    if (self.selectCoponMode) {
        self.coponView.platformDesc.text=[NSString stringWithFormat:@"-¥%@",self.selectCoponMode.price];
        self.coponView.platformDesc.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
        NSDecimalNumber *numberPay = [NSDecimalNumber decimalNumberWithString:self.selectCoponMode.price];
        // 减去红包
//        numRealPay = [numRealPay decimalNumberBySubtracting:numberPay];
        if (numRealPay.doubleValue<=0) {
            numRealPay=0;
            if (!self.selectMallCouponMode) {
                self.coponView.mallCoponView.userInteractionEnabled=NO;
            }
        }
    }
    else{
        self.coponView.platformDesc.textColor=kColor999;
        self.coponView.platformDesc.text=[NSString stringWithFormat:@"%lu 张可用",(unsigned long)[self.orderConfirmMode.myCouponVoList count]];
    }
    
    //判断折扣券
    NSInteger canUsedCount=0;
    for (CoponMode * mode in self.orderConfirmMode.discountAllCouponVoList) {
        //不满足满减条件
        if ([numRealPay floatValue]<[mode.ruleFrCondition floatValue]) {
            mode.unableUsed=YES;
            if ([self.selectDiscountCouponMode.Id isEqualToString:mode.Id] ) {
                self.selectDiscountCouponIndexPath=nil;
                self.selectDiscountCouponMode=nil;
            }
        }
        //能用
        else{
            mode.unableUsed=NO;
            canUsedCount++;
        }
    }
    if ([numRealPay floatValue]<=0) {
        self.coponView.discountCoponView.userInteractionEnabled=NO;
        self.coponView.discountdDesc.textColor=kColor999;
        self.coponView.discountdDesc.text=@"暂无可用";
        self.selectDiscountCouponIndexPath=nil;
        self.selectDiscountCouponMode=nil;
    }
    else{
        if (self.selectDiscountCouponMode) {
            self.coponView.discountdDesc.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
            if ([self.selectDiscountCouponMode.ruleType isEqualToString:@"FR"]) {
                NSDecimalNumber *numberPay = [NSDecimalNumber decimalNumberWithString:self.selectDiscountCouponMode.price];
                // 减去折扣券
//                numRealPay = [numRealPay decimalNumberBySubtracting:numberPay];
                self.coponView.discountdDesc.text=[NSString stringWithFormat:@"-¥%@",self.selectDiscountCouponMode.price];
            }
            else if ([self.selectDiscountCouponMode.ruleType isEqualToString:@"OD"]) {
                NSString * rate=[NSString stringWithFormat:@"%f",self.selectDiscountCouponMode.price.floatValue*0.1];
                NSDecimalNumber *numberPay = [NSDecimalNumber decimalNumberWithString:rate];
                // 乘折扣券
                NSDecimalNumber *tempNumRealPay = numRealPay;
//                numRealPay = [numRealPay decimalNumberByMultiplyingBy:numberPay];
                NSDecimalNumber *num=[tempNumRealPay decimalNumberBySubtracting:numRealPay];
                self.coponView.discountdDesc.text=[NSString stringWithFormat:@"-¥%.2f",num.floatValue];
            }
            
        }
        else{
            self.coponView.discountdDesc.textColor=kColor999;
            self.coponView.discountdDesc.text=[NSString stringWithFormat:@"%ld 张可用",(long)canUsedCount];
        }
    }
    
    //加工单计算津贴津贴，把加工费补回来
    if (self.orderConfirmMode.orderCategoryType==JHOrderCategoryProcessing||
        self.orderConfirmMode.orderCategoryType==JHOrderCategoryProcessingGoods||
        self.orderConfirmMode.orderCategoryType==JHOrderCategoryRestoreProcessing)
    {
        //赋值优惠后金额
        NSString * goodsString=[@"¥ " stringByAppendingString:[NSString stringWithFormat:@"%.2f",numRealPay.doubleValue]];
        self.processPayView.deductionFinishPrice.text=goodsString;
        
        if (self.orderConfirmMode.manualCost) {
            
            NSDecimalNumber *manualCost = [NSDecimalNumber decimalNumberWithString:self.orderConfirmMode.manualCost];
            numRealPay = [numRealPay decimalNumberByAdding:manualCost];
        }
        if (self.orderConfirmMode.materialCost) {
            NSDecimalNumber *materialCost = [NSDecimalNumber decimalNumberWithString:self.orderConfirmMode.materialCost];
            numRealPay = [numRealPay decimalNumberByAdding:materialCost];
        }
       
        
    }
    //津贴大于0
    if ( [NSDecimalNumber decimalNumberWithString:_orderConfirmMode.usableBountyAmount].doubleValue>0&&_orderConfirmMode.usableBountyAmount) {
        self.payView.switchView.userInteractionEnabled=YES;
        
        if (self.orderConfirmMode.isC2C) {
            if (self.orderConfirmMode.limitBountyAmount.length == 0) {
                self.payView.cashPacketView.hidden = true;
                [self.payView.cashPacketView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
            }else {
                self.payView.cashPacketView.hidden = false;
                [self.payView.cashPacketView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(50);
                }];
                self.payView.cashPacket.text=[@"¥ " stringByAppendingString:[NSString stringWithFormat:@"%@",_orderConfirmMode.usableBountyAmount]];
            }
        }else {
            self.payView.cashPacket.text=[@"¥ " stringByAppendingString:[NSString stringWithFormat:@"%@",_orderConfirmMode.usableBountyAmount]];
        }
        
    }
    //券抵扣完全了 不需要输入津贴
    if ([numRealPay floatValue]<=0) {
        numRealPay=0;
        self.payView.switchView.on=NO;
        [self updateBlanceView:self.payView.switchView.on];
        self.payView.switchView.userInteractionEnabled=NO;
    }
    if (self.payView.switchView.on) {
        
        if ([self.payView.cash.text doubleValue]>0) {
            [self showCanUsedBalance];
            NSDecimalNumber * balanceDecimal = [NSDecimalNumber decimalNumberWithString:self.payView.cash.text];
            numRealPay= [numRealPay decimalNumberBySubtracting:balanceDecimal ];
        }
    }
    
    numberCashPacket= [NSDecimalNumber decimalNumberWithString:self.payView.cash.text];
    
    needPayMoney = numRealPay.doubleValue;
    //税费运费
    if(_orderConfirmMode.taxes.doubleValue>0||
       _orderConfirmMode.freight.doubleValue>0){
        needPayMoney = needPayMoney +  self.orderConfirmMode.taxes.doubleValue +
        self.orderConfirmMode.freight.doubleValue;
    }
    
    NSString * moneyString=[@"¥ " stringByAppendingString:[NSString stringWithFormat:@"%.2f",needPayMoney]];
    
    self.payView.shoulPayPrice.text=moneyString;
    NSRange range = [moneyString rangeOfString:@"¥"];
    self.allPrice.attributedText=[moneyString attributedFont:[UIFont fontWithName:kFontNormal size:11] color:kColorMainRed range:range];
}
-(void)showCanUsedBalance{
    //可用津贴
    NSDecimalNumber *numberUsableBounty = [NSDecimalNumber decimalNumberWithString:_orderConfirmMode.usableBountyAmount];
    //订单限额
    NSDecimalNumber *numberlimitBounty = [NSDecimalNumber decimalNumberWithString:_orderConfirmMode.limitBountyAmount];
    //津贴为0
    if (numberUsableBounty.doubleValue<=0) {
        numberUsableBounty=0;
    }
    //津贴超限额
    if ([numberUsableBounty doubleValue]>[numberlimitBounty doubleValue]) {
        numberUsableBounty=numberlimitBounty;
    }
    //超出实付金额
    if ([ [numRealPay decimalNumberBySubtracting: [NSDecimalNumber decimalNumberWithString:self.payView.cash.text] ] doubleValue]<0) {
        self.payView.cash.text=[NSString stringWithFormat:@"%.2f",numRealPay.doubleValue];
    }
    //超出限额
    if (self.payView.cash.text.doubleValue>numberUsableBounty.doubleValue) {
        self.payView.cash.text=[NSString stringWithFormat:@"%.2f",numberUsableBounty.doubleValue];
    }
}
-(void)onClickBtnAction:(UIButton*)sender{
    if (!self.protocolView.protocolBtn.selected) {
        [self makeToast:@"请阅读并同意原石回血交易协议" duration:1 position:CSToastPositionCenter];
        return;
    }
    JHOrderConfirmReqModel *reqMode=[[JHOrderConfirmReqModel alloc]init];
    reqMode.orderDesc=self.noteView.noteTextview.text;
    reqMode.couponId=self.selectCoponMode.Id;
    reqMode.sellerCouponId=self.selectMallCouponMode.Id;
    reqMode.discountCouponId=self.selectDiscountCouponMode.Id;
    reqMode.goodsCount=self.orderConfirmMode.goodsCount;
    if (numberCashPacket.doubleValue>0) {
        reqMode.bountyAmount=[NSString stringWithFormat:@"%.2f",numberCashPacket.doubleValue];
        reqMode.useMounty=@"1";
    }
    reqMode.discountCouponId = self.selectDiscountCouponMode.Id;
    
    reqMode.needPayMoney = [NSString stringWithFormat:@"%.2f",needPayMoney];//只是埋点用
    
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(Complete:)]){
        [self.delegate Complete:reqMode];
    }
    
   
    
    
}
//埋点：进入店铺 个人中心 进入店铺埋点
- (void)GIOEnterShopPage:(NSString *)sellerId {
    [GrowingManager enterShopHomePage:@{@"shopId":sellerId,
                                        @"from":JHFromUserInfo
    }];
}
-(void)updateBlanceView:(BOOL)isSwitch{
    
    [self.payView updateBlanceView:isSwitch];
}
-(void)changeGoodsCount:(UIButton*)button{
    if (button.tag==1) {
        if (self.goodsCount<=1) {
            //  [self makeToast:@"最少购买一件哦！" duration:1 position:CSToastPositionCenter];
            return;
        }
        self.goodsCount--;
    }
    if (button.tag==2) {
        if (!self.orderConfirmMode.isNewuGoods) {
            if (self.goodsCount+1>self.orderConfirmMode.stock) {
                [self makeToast:@"~超出数量范围~" duration:1 position:CSToastPositionCenter];
                return;
            }
            self.goodsCount++;
        }
        else {
            CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:@"新人专区的商品每位新人限购一件哦" cancleBtnTitle:@"我知道了"];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            return;
        }
    }
    if (self.goodsCountAction) {
        self.goodsCountAction([NSNumber numberWithInteger:self.goodsCount]);
        self.goodsCount=self.orderConfirmMode.goodsCount;
    }
}

#pragma mark - get

-(JHOrderConfirmCoponView*)coponView{
    
    if (!_coponView) {
        _coponView = [[JHOrderConfirmCoponView alloc]init];
        JH_WEAK(self)
        _coponView.coponHandle = ^(id obj) {
            JH_STRONG(self)
            UIGestureRecognizer *tap =(UIGestureRecognizer*)obj;
            [self tapCopon:tap];
        };
        _coponView.mallCoponHandle = ^(id obj) {
            JH_STRONG(self)
            UIGestureRecognizer *tap =(UIGestureRecognizer*)obj;
            [self tapMallCopon:tap];
        };
        _coponView.discountCoponHandle = ^(id obj) {
            JH_STRONG(self)
            UIGestureRecognizer *tap =(UIGestureRecognizer*)obj;
            [self tapDiscountCopon:tap];
        };
    }
    return _coponView;
}

- (JHCheckBoxProtocolView *)checkBoxProtocolView {
    if (!_checkBoxProtocolView) {
        _checkBoxProtocolView = [[JHCheckBoxProtocolView alloc]
                                 initWithSelImageName:@"icon_banck_card_protocol_select" normalImageName:@"recycle_order_cancel_normal" tipStr:@"" protocolStr:@"宝友集市交易协议"];
        _checkBoxProtocolView.isC2cConfirm = true;
//        @weakify(self)
        _checkBoxProtocolView.hidden = YES;
        [_checkBoxProtocolView setCheckBoxProtocolClickBlock:^{
//            @strongify(self)
            NSDictionary *par = @{
                @"page_position":@"checkBindCardInfo"
            };
            
            [JHAllStatistics jh_allStatisticsWithEventId:@"clickAgreeBindCard"
                                                  params:par
                                                    type:JHStatisticsTypeSensors];
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = H5_BASE_STRING(@"/jianhuo/app/agreement/bazaarRule.html");
            [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
        }];
    }
    return _checkBoxProtocolView;
}

- (void)dealloc
{
    [timer stopGCDTimer];
    NSLog(@"dealloc");
}
@end

