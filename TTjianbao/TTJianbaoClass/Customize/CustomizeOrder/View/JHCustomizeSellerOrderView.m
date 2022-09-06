//
//  JHCustomizeSellerOrderView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeSellerOrderView.h"
#import "BYTimer.h"
#import "JHCouponListView.h"
#import "JHMallCoponListView.h"
#import "JHOrderViewModel.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoUtil.h"
#import "JHUIFactory.h"
#import "JHItemMode.h"
#import "JHWebViewController.h"
#import "JHGoodsDetailViewController.h"
#import "JHOrderRemainTimeView.h"
#import "JHOrderAdressView.h"
#import "JHCustomizeOrderProductView.h"
#import "JHCustomizePayCashView.h"
#import "JHCustomizeProgramView.h"
#import "JHCustomizeDetailInfoView.h"
#import "JHCustomizePayInfoView.h"

#import "JHOrderFeeView.h"
#import "JHOrderDeductionView.h"
#import "JHOrderProcessDescView.h"
#import "JHOrderBuyerNoteView.h"
#import "JHOrderSellerNoteView.h"
#import "JHOrderPayListView.h"
#import "JHOrderStoneOriginalProductView.h"
#import "JHCustomizeOrderInfoView.h"
#import "JHCustomizeOrderButtonsView.h"
#import "JHOrderHeaderTipView.h"
#import "JHCustomizeCompleteInfoView.h"
#import "JHChatBusiness.h"
@interface JHCustomizeSellerOrderView ()
{
    BYTimer *timer;
}
@property(nonatomic,strong) JHOrderHeaderTitleView * headerTitleView;
@property(nonatomic,strong) JHOrderHeaderTipView * headerTipView;
@property(nonatomic,strong) JHOrderAdressView * addressView;
@property(nonatomic,strong) JHCustomizeOrderProductView *productView;
@property(nonatomic,strong) JHCustomizePayCashView *payCashView;
@property(nonatomic,strong) JHCustomizeCompleteInfoView *customizeCompleteInfoView;
@property(nonatomic,strong) JHCustomizeProgramView *customizeProgramView;
@property(nonatomic,strong) JHCustomizeDetailInfoView *customizeDetailInfoView;
@property(nonatomic,strong) JHCustomizePayInfoView *customizePayInfoView;
@property(nonatomic,strong) JHCustomizeOrderInfoView *orderInfoView;
@property(nonatomic,strong) JHOrderPayListView *payListView;
@property(nonatomic,strong) JHOrderBuyerNoteView *buyerNoteView;
@property(nonatomic,strong) JHOrderSellerNoteView *sellerNoteView;

@property(nonatomic,strong) JHCustomizeOrderButtonsView *buttonBackView;
@property(nonatomic,strong) UIView *serviceView;
@property(nonatomic,strong) UIImageView *tipImgeView;
@end
@implementation JHCustomizeSellerOrderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initScrollview];
    }
    return self;
}
-(void)initScrollview{
    
    self.contentScroll=[[UIView alloc]init];
    self.contentScroll.backgroundColor =[CommHelp toUIColorByStr:@"#f7f7f7"];
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.right.equalTo(self);
    }];
    
    [self initTitleView];
    [self initTipView];
    [self initAddressView];
    [self initProductView];
    [self initPayCashView];
    [self initCompleteInfoView];
    [self initProgramView];
    [self initDetailInfoView];
    [self initCustomizePayInfoView];
    [self initCustomizePayListView];
    [self initOrderInfoView];
    [self initBuyerNoteView];
    [self initSellerNoteView];
    
}
-(void)initTitleView{
    
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
    
     _headerTipView=[[JHOrderHeaderTipView alloc]init];
      [self.contentScroll addSubview:_headerTipView];
     [_headerTipView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(_headerTitleView.mas_bottom).offset(0);
         make.left.equalTo(self.contentScroll).offset(10);
         make.right.equalTo(self.contentScroll).offset(-10);
         make.width.offset(ScreenW-20);
     }];
}
-(void)initAddressView{
    
    _addressView=[[JHOrderAdressView alloc]init];
    [self.contentScroll addSubview:_addressView];
    [_addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerTipView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(0);
    }];
}
-(void)initProductView{
    
    _productView=[[JHCustomizeOrderProductView alloc]init];
    [self.contentScroll addSubview:_productView];
    [_productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        //        make.height.offset(120);
    }];
}
-(void)initPayCashView{
    
       _payCashView=[[JHCustomizePayCashView alloc]init];
       [self.contentScroll addSubview:_payCashView];
       
        [_payCashView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(_productView.mas_bottom).offset(0);
           make.left.equalTo(self.contentScroll).offset(10);
           make.right.equalTo(self.contentScroll).offset(-10);
           make.height.offset(0);
       }];
}

-(void)initCompleteInfoView{
    
    _customizeCompleteInfoView=[[JHCustomizeCompleteInfoView alloc]init];
    [self.contentScroll addSubview:_customizeCompleteInfoView];
    
    [_customizeCompleteInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payCashView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(0);
    }];
    
}
-(void)initProgramView{
    
    _customizeProgramView=[[JHCustomizeProgramView alloc]init];
    _customizeProgramView.isSeller = YES;
    [self.contentScroll addSubview:_customizeProgramView];
    
    [_customizeProgramView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_customizeCompleteInfoView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}


-(void)initDetailInfoView{
    
    _customizeDetailInfoView =[[JHCustomizeDetailInfoView alloc]init];
    [self.contentScroll addSubview:_customizeDetailInfoView];
    
    [_customizeDetailInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_customizeProgramView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}


-(void)initCustomizePayInfoView{
    
    _customizePayInfoView=[[JHCustomizePayInfoView  alloc]init];
    [self.contentScroll addSubview:_customizePayInfoView];
    
    [_customizePayInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_customizeDetailInfoView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}
-(void)initCustomizePayListView{
    
    _payListView=[[JHOrderPayListView alloc]init];
    [self.contentScroll addSubview:_payListView];
    [_payListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customizePayInfoView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    JH_WEAK(self)
    _payListView.buttonHandle = ^(id obj) {
        JH_STRONG(self)
        UIButton *button=(UIButton*)obj;
        OrderFriendAgentPayMode * mode=self.friendAgentpayArr[button.tag];
        if (self.shareHandle) {
            self.shareHandle(mode, nil);
        }
    };
    
}
-(void)initOrderInfoView{
    
    _orderInfoView=[[JHCustomizeOrderInfoView alloc]init];
    [self.contentScroll addSubview:_orderInfoView];
    
    [_orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payListView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    
}
-(void)initBuyerNoteView{
    _buyerNoteView=[[JHOrderBuyerNoteView alloc]init];
    [self.contentScroll addSubview:_buyerNoteView];
    [_buyerNoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderInfoView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}
-(void)initSellerNoteView{
    _sellerNoteView=[[JHOrderSellerNoteView alloc]init];
    [self.contentScroll addSubview:_sellerNoteView];
    [_sellerNoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buyerNoteView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.bottom.equalTo(self.contentScroll).offset(-10);
    }];
}

-(void)setViewHeightChangeBlock:(JHFinishBlock)viewHeightChangeBlock{
    
    _viewHeightChangeBlock = viewHeightChangeBlock;
    _orderInfoView.viewHeightChangeBlock = _viewHeightChangeBlock;
    _customizeProgramView.viewHeightChangeBlock = _viewHeightChangeBlock;
}
-(void)initBottomView{
    
    _buttonBackView=[[JHCustomizeOrderButtonsView alloc]init];
    _buttonBackView.backgroundColor=[CommHelp toUIColorByStr:@"#ffffff"];
    [self.viewController.view addSubview:_buttonBackView];
    [_buttonBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.viewController.view).offset(0);
        make.height.offset(50);
        make.bottom.equalTo(self.viewController.view).offset(-UI.bottomSafeAreaHeight);
    }];
    JH_WEAK(self)
    _buttonBackView.buttonHandle = ^(id obj) {
        JH_STRONG(self)
        if (self.delegate) {
            [self.delegate buttonPress:[obj integerValue]];
        }
    };
}
-(void)initPayCashSubViews{
    
    //待付款状态||有差额
    if ([_orderMode.shouldPayAdvanceValue floatValue]>0||
        [_orderMode.shouldPayValue floatValue]>0){
        
        [_payCashView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_productView.mas_bottom).offset(10);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
        }];
        [self.payCashView initShouldPayCashSubViews:self.orderMode];
    }
    else{
        [_payCashView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_productView.mas_bottom).offset(0);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
        }];
    }

}
-(void)initCustomizeCompleteInfoSubViews{
    
    if (self.orderMode.completions.count) {
        [_customizeCompleteInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.payCashView.mas_bottom).offset(10);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
        }];
        [self.customizeCompleteInfoView setOrderMode:self.orderMode];
        [self.customizeCompleteInfoView initCustomizeCompleteInfoViews];
    }
    else{
        [_customizeCompleteInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.payCashView.mas_bottom).offset(0);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
        }];
    }
}
-(void)initCustomizeProgramSubViews{
    
    if (self.orderMode.plans.count){
       [_customizeProgramView mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.customizeCompleteInfoView.mas_bottom).offset(10);
           make.left.equalTo(self.contentScroll).offset(10);
           make.right.equalTo(self.contentScroll).offset(-10);
       }];
        [self.customizeProgramView setOrderMode:self.orderMode];
        [self.customizeProgramView initCustomizeProgramViews];
   }
    
   else if (
        (self.orderMode.customizeOrderStatusType==
         JHCustomizeOrderStatusWaitCustomerAckPlan||
        self.orderMode.customizeOrderStatusType ==
         JHCustomizeOrderStatusCustomizing||
        self.orderMode.customizeOrderStatusType==
         JHCustomizeOrderStatusCustomizerPlanning)&&self.orderMode.customizeType!=1)
    {
       [_customizeProgramView mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.customizeCompleteInfoView.mas_bottom).offset(10);
           make.left.equalTo(self.contentScroll).offset(10);
           make.right.equalTo(self.contentScroll).offset(-10);
       }];
        [self.customizeProgramView setOrderMode:self.orderMode];
       [self.customizeProgramView initCustomizeProgramViews];
   }
   else{
       [_customizeProgramView mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.customizeCompleteInfoView.mas_bottom).offset(0);
           make.left.equalTo(self.contentScroll).offset(10);
           make.right.equalTo(self.contentScroll).offset(-10);
       }];
   }
 
  

}
-(void)initCustomizeDetailInfoSubViews{
    
     if (self.orderMode.picInfoVo){
        [_customizeDetailInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.customizeProgramView.mas_bottom).offset(10);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
        }];
         [self.customizeDetailInfoView setOrderMode:self.orderMode];
         [self.customizeDetailInfoView initCustomizeDetailViews];
    }
    else{
        [_customizeDetailInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.customizeProgramView.mas_bottom).offset(0);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
        }];
    }
   

}
-(void)initPayInfoSubViews{
    
    if (self.orderMode.payRecordVos.count){
        [_customizePayInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_customizeDetailInfoView.mas_bottom).offset(10);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
        }];
     [self.customizePayInfoView initCustomizePayListSubviews:self.orderMode.payRecordVos];
    }
    else{
        [_customizePayInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_customizeDetailInfoView.mas_bottom).offset(0);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
        }];
   }
}
-(void)initBuyerNoteSubViews{
    
    [_buyerNoteView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderInfoView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    [self.buyerNoteView initCustomizeBuyerNoteSubViews:self.orderMode];
}
-(void)initSellerNoteSubViews{
    
    [_sellerNoteView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buyerNoteView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.bottom.equalTo(self.contentScroll).offset(-10);
    }];
    [self.sellerNoteView setCustomizeOrderMode:self.orderMode];
    [self.sellerNoteView initCustomizeSellerNoteSubViews];
}

-(void)initOrderInfoSubviews{
    
    self.orderInfoView.orderMode=self.orderMode;
   [self.orderInfoView setupOrderInfo];
    
}
-(void)handleOrderButtons:(JHCustomizeOrderModel*)mode{
    
    if (self.orderMode.customizeButtons.count==0) {
        [self.buttonBackView setHidden:YES];
    }
    else{
        [self.buttonBackView setHidden:NO];
        
        [JHChatBusiness getServeceWithUserId:self.orderMode.sellerCustomerId successBlock:^(RequestModel * _Nullable respondObject) {
            NSUInteger code = [respondObject.data integerValue];
            if (code == 1) {
                for ( JHCustomizeOrderButtonModel *mode in self.orderMode.customizeButtons) {
                    if (mode.buttonType == JHCustomizeOrderButtonContactService) {
                        mode.title = @"联系商家";
                        break;
                    }
                }
            }else {
                [JHQYChatManage checkChatTypeWithCustomerId:self.orderMode.sellerCustomerId  saleType:JHChatSaleTypeAfter completeResult:^(BOOL isShop, JHQYStaffInfo * _Nonnull staffInfo) {
                    NSString * title=isShop?@"联系商家":@"联系客服";
                    for ( JHCustomizeOrderButtonModel *mode in self.orderMode.customizeButtons) {
                        if (mode.buttonType == JHCustomizeOrderButtonContactService) {
                            mode.title = title;
                            break;
                        }
                    }
                    [self.buttonBackView setupBuyerButtons:self.orderMode.customizeButtons];
                }];
            }
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            
        }];
    }
    
}
-(void)setFriendAgentpayArr:(NSArray *)friendAgentpayArr{
    
    _friendAgentpayArr=friendAgentpayArr;
    if (_friendAgentpayArr.count>0) {
        [_payListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.customizePayInfoView.mas_bottom).offset(10);
        }];
    }
    [self.payListView initBuyerPayListSubviews:_friendAgentpayArr];
    
}
-(void)setOrderMode:(JHCustomizeOrderModel *)orderMode{
    
    _orderMode=orderMode;
    [self.productView setOrderMode:_orderMode];
    //头信息
    [self.headerTitleView setCustomizeOrderMode:_orderMode];
    //提示信息
    [self showTipView];
    
   //地址
    if (_orderMode.shippingReceiverName) {
        [_addressView setCustomizeOrderMode:_orderMode];
        [_addressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerTipView.mas_bottom).offset(10);
        make.height.offset(90);
        }];
    }
     [self initPayCashSubViews];
    
    //制作完成信息
     [self initCustomizeCompleteInfoSubViews];
    //定制方案信息
    [self initCustomizeProgramSubViews];
    //定制详情信息  放到商品栏了
   // [self initCustomizeDetailInfoSubViews];
    
    //支付信息
    [self initPayInfoSubViews];
    
    //订单支付时间信息
      [self initOrderInfoSubviews];
    
    //买家留言
     if([self.orderMode.userRemark length]>0 ){
        [self initBuyerNoteSubViews];
    }
    //卖家留言
    if([self.orderMode.customizeRemark length]>0){
        [self initSellerNoteSubViews];
    }
    //底部按钮
    [self handleOrderButtons:_orderMode];
    
}
-(void)showTipView{
    
    if ([_orderMode.orderStatus isEqualToString:@"waitack"]||
        [_orderMode.orderStatus isEqualToString:@"waitpay"]) {
        //提示
        OrderStatusTipModel * tipModel=[UserInfoRequestManager findOrderTip:_orderMode.orderStatus];
        if (tipModel) {
            [_headerTipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_headerTitleView.mas_bottom).offset(-15);
                make.left.equalTo(self.contentScroll).offset(10);
                make.right.equalTo(self.contentScroll).offset(-10);
                make.width.offset(ScreenW-20);
            }];
            [self.headerTipView initContent:tipModel.title andDesc:tipModel.desc];
        }
    }
    else{
        [_headerTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerTitleView.mas_bottom).offset(0);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
            make.width.offset(ScreenW-20);
        }];
        
    }
}
- (void)ClickService:(UIButton*)button{
    
    if (self.delegate) {
        [self.delegate buttonPress:button.tag];
    }

}
-(void)productViewTap:(UIGestureRecognizer*)gestureRecognizer{
    
    if (self.orderMode.orderType == 4) {
        JHGoodsDetailViewController *vc = [[JHGoodsDetailViewController alloc] init];
        vc.goods_id = self.orderMode.onlyGoodsId;
        vc.isFromShopWindow = NO;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    
}
-(UIImageView*)tipImgeView{
    
    if (!_tipImgeView) {
        _tipImgeView=[[UIImageView alloc]init];
        _tipImgeView.contentMode = UIViewContentModeScaleAspectFit;
        _tipImgeView.image=[UIImage imageNamed:@"order_show_report_img"];
    }
  return _tipImgeView;
    
}
- (void)dealloc
{
    [timer stopGCDTimer];
    NSLog(@"dealloc");
}
@end



