//
//  JHGraphicBuyerOrderView.m
//  TTjianbao
//
//  Created by 张坤 on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGraphicBuyerOrderView.h"
#import "JHOrderViewModel.h"
#import "JHStoreDetailViewController.h"
#import "JHOrderAdressView.h"
#import "JHOrderProductView.h"
#import "JHOrderPayListView.h"
#import "JHGraphic0rderInforView.h"
#import "UIView+AddSubviews.h"
#import "NSString+NTES.h"
#import "UIImage+JHColor.h"
#import "UIImageView+WebCache.h"
#import "JHPhotoBrowserManager.h"
#import "JHGraphic0rderHeaderView.h"
#import "JHGraphic0rderBottomView.h"
#import "JHGraphicalBottomModel.h"

@interface JHGraphicBuyerOrderView () <
UIGestureRecognizerDelegate>

@property(nonatomic,strong) JHGraphic0rderHeaderView * headerTitleView;
@property(nonatomic,strong) JHGraphic0rderInforView *orderInfoView;
@property(nonatomic,strong) JHOrderPayListView *payListView;
@property(nonatomic,strong) JHGraphic0rderBottomView *buttonBackView;
@property(nonatomic,strong) UIView *serviceView;
@property(nonatomic,strong) UIImageView *tipImgeView;
@property (nonatomic, strong) UIScrollView *imageScrollerView;
@property (nonatomic, strong)  UIView *imageContainView;
@property (nonatomic, strong) UILabel *titleValue;
@property (nonatomic, strong) UILabel *priceValue;
@property (nonatomic, strong) UILabel *redBagValue;
@property (nonatomic, strong) UILabel *allMoneyValue;
@property (nonatomic, strong) UILabel *numValue;
@property (nonatomic, strong) NSMutableArray *goodImages;
@property (nonatomic, strong) UIView *imagesView;
@property (nonatomic, strong) UIView *tipView;
@end
@implementation JHGraphicBuyerOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initScrollview];
    }
    return self;
}

-(void)initScrollview {
    
    self.contentScroll=[[UIView alloc]init];
    self.contentScroll.backgroundColor =[CommHelp toUIColorByStr:@"#f7f7f7"];
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.right.equalTo(self);
    }];
    
    [self initTitleView];
    [self setupImageContainerUI];
    [self initPayListView];
    [self initOrderInfoView];
    [self initServeView];
    
}
-(void)initTitleView{
    
    _headerTitleView = [[JHGraphic0rderHeaderView alloc]init];
    @weakify(self);
    _headerTitleView.countDownFinshBlock = ^{
        @strongify(self);
        [self performSelector:@selector(p_refreshThePage) withObject:nil afterDelay:1.0f];
    };
    [self.contentScroll addSubview:_headerTitleView];
    [_headerTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.width.offset(ScreenW);
    }];
    
}

- (void)setupImageContainerUI {
    
    UIView *imageView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.contentScroll];
    imageView.layer.cornerRadius = 8.5;
    imageView.clipsToBounds = YES;
    self.imageContainView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headerTitleView.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(255);
    }];
    
    UILabel *titleValue = [UILabel jh_labelWithFont:12 textColor:HEXCOLOR(0xFF333333) addToSuperView:imageView];
    titleValue.text = @"鉴定类目：木雕盘玩";
    [titleValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(18);
    }];
    self.titleValue = titleValue;
    
    UIView *line = [UIView jh_viewWithColor:HEXCOLOR(0xFFF5F6FA) addToSuperview:imageView];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleValue.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(titleValue);
        make.height.mas_equalTo(1);
    }];
    
    UIScrollView *imageScrollerView = [UIScrollView jh_viewWithColor:UIColor.clearColor addToSuperview:self.contentScroll];
    imageScrollerView.userInteractionEnabled = YES;
    imageScrollerView.showsHorizontalScrollIndicator = NO;

    self.imageScrollerView = imageScrollerView;
    
    UIView *imagesView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.imageScrollerView];
    self.imagesView  = imagesView;
    [self.imageScrollerView setNeedsLayout];
    [self.imageScrollerView layoutIfNeeded];
    
    CGFloat imageWH = (kScreenWidth - 30*2) / 3;
    self.goodImages = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        UIImageView *imageView =[[UIImageView alloc]init];
        [self.goodImages addObject:imageView];
        imageView.tag = 100+i;
        imageView.layer.cornerRadius = 8;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"common_photo_placeholder"];
        [imagesView addSubview:imageView];
        imageView.frame = CGRectMake(i*(imageWH+10),10, imageWH, imageWH);
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusGesture:)];
        tapGestureRecognizer.delegate = self;
        [imageView addGestureRecognizer:tapGestureRecognizer];
    }
    
    [imageScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).mas_offset(0);
        make.left.right.mas_equalTo(titleValue);
        make.height.mas_equalTo(imageWH+20);
    }];

    [imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(imageWH+20);
        make.width.mas_equalTo(10*imageWH+10*10);
    }];
    
    UIView *tipView = [UIView jh_viewWithColor:HEXCOLORA(0XFF000000, 0.5) addToSuperview:self.contentScroll];
    tipView.layer.cornerRadius = 8.5;
    tipView.clipsToBounds = YES;
    self.tipView = tipView;
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 17));
        make.right.mas_equalTo(self.imageScrollerView.mas_right).mas_offset(-6);
        make.bottom.mas_equalTo(self.imageScrollerView.mas_bottom).mas_offset(-10);
    }];

    UILabel *numValue = [UILabel jh_labelWithFont:12 textColor:HEXCOLOR(0xFFFFFFFF) addToSuperView:tipView];
    numValue.text = @"10";
    self.numValue = numValue;
    
    UIImageView *numIcon = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"icon_image_tip_JHGraphicBuyerOrderView"] addToSuperview:tipView];
    [numIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tipView);
        make.left.mas_equalTo(5);
//        make.size.mas_equalTo(CGSizeMake(7.5, 6.5));
    }];
    
    [numValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(numIcon.mas_right).mas_offset(3);
        make.centerY.mas_equalTo(tipView);
    }];
    
    UIView *bottomLine = [UIView jh_viewWithColor:HEXCOLOR(0xFFF5F6FA) addToSuperview:imageView];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageScrollerView.mas_bottom).mas_offset(2);
        make.left.right.mas_equalTo(titleValue);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *priceTip = [UILabel jh_labelWithFont:12 textColor:HEXCOLOR(0xFF999999) addToSuperView:imageView];
    priceTip.text = @"鉴定费：";
    
    [priceTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomLine.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(titleValue);
    }];
    
    UILabel *priceValue = [UILabel jh_labelWithFont:12 textColor:HEXCOLOR(0x33333333) addToSuperView:imageView];
    priceValue.text = @"￥10.00";
    self.priceValue = priceValue;
    [priceValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(priceTip.mas_centerY);
        make.right.mas_equalTo(titleValue);
    }];
    
    UILabel *redBagTip = [UILabel jh_labelWithFont:12 textColor:HEXCOLOR(0xFF999999) addToSuperView:imageView];
    redBagTip.text = @"红包：";
    
    [redBagTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceTip.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(titleValue);
    }];
    
    UILabel *redBagValue = [UILabel jh_labelWithFont:12 textColor:HEXCOLOR(0x33333333) addToSuperView:imageView];
    redBagValue.text = @"￥10.00";
    self.redBagValue = redBagValue;
    [redBagValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(redBagTip.mas_centerY);
        make.right.mas_equalTo(titleValue);
    }];
    
    UILabel *allMoneyTip = [UILabel jh_labelWithFont:12 textColor:HEXCOLOR(0xFF999999) addToSuperView:imageView];
    allMoneyTip.text = @"实付款：";
    
    [allMoneyTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(redBagTip.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(titleValue);
    }];
    
    UILabel *allMoneyValue = [UILabel jh_labelWithFont:12 textColor:HEXCOLOR(0xFFF73128) addToSuperView:imageView];
    allMoneyValue.font = JHMediumFont(12);
    allMoneyValue.text = @"￥10.00";
    self.allMoneyValue = allMoneyValue;
    [allMoneyValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(allMoneyTip.mas_centerY);
        make.right.mas_equalTo(titleValue);
    }];
}

- (void)focusGesture:(UIGestureRecognizer*)sender {
    NSInteger index = sender.view.tag-100;
    NSLog(@"index=%ld",index);
    [JHPhotoBrowserManager showPhotoBrowserThumbImages:[self.orderMode.goodsImgs valueForKey:@"small"] mediumImages: [self.orderMode.goodsImgs valueForKey:@"medium"] origImages: [self.orderMode.goodsImgs valueForKey:@"origin"] sources:self.goodImages currentIndex:index canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleZoom];
}

-(void)initPayListView{

    _payListView=[[JHOrderPayListView alloc]init];
    [self.contentScroll addSubview:_payListView];
    [_payListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageContainView.mas_bottom).offset(10);
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
    
    _orderInfoView = [[JHGraphic0rderInforView alloc]init];
    _orderInfoView.backgroundColor = [UIColor whiteColor];
    [self.contentScroll addSubview:_orderInfoView];
    @weakify(self);
    _orderInfoView.copyOrderNumberBlock = ^{
        @strongify(self);
        [UITipView showTipStr:@"复制成功"];
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        pab.string = self.orderMode.orderCode;
    };
    
    [_orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payListView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.mas_equalTo(91);
    }];
    
}
-(void)initServeView{
    
    _serviceView=[[UIView alloc]init];
    _serviceView.backgroundColor=[UIColor whiteColor];
    _serviceView.layer.cornerRadius = 8;
    _serviceView.layer.masksToBounds = YES;
    [self.contentScroll addSubview:_serviceView];
    
    [_serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderInfoView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(40);
        make.bottom.equalTo(self.contentScroll).offset(-10);
        
    }];
    
    _chatBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_chatBtn setImage:[UIImage imageNamed:@"order_contactService_icon"] forState:UIControlStateNormal];//
    [_chatBtn setTitle:@"" forState:UIControlStateNormal];
    [_chatBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
    _chatBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    _chatBtn.tag=JHOrderButtonTypeContact;
    [_chatBtn addTarget:self action:@selector(ClickService:) forControlEvents:UIControlEventTouchUpInside];
    [_serviceView addSubview:_chatBtn];
    [_chatBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                              imageTitleSpace:5];
    [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_serviceView);
    }];
    
}

-(void)initBottomView{
    
    _buttonBackView = [[JHGraphic0rderBottomView alloc]init];
    _buttonBackView.backgroundColor=[CommHelp toUIColorByStr:@"#ffffff"];
    [self.viewController.view addSubview:_buttonBackView];
    [_buttonBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.viewController.view).offset(0);
        make.height.offset(50);
        make.bottom.equalTo(self.viewController.view).offset(-UI.bottomSafeAreaHeight);
    }];
    @weakify(self);
    _buttonBackView.buttonBlock = ^(JHGraphicalBottomModel * _Nullable model) {
        @strongify(self);
        SEL Seletor = NSSelectorFromString(model.selName);
        if ([self.delegate respondsToSelector:Seletor]) {
            Class Cls = [self.delegate class];
            NSMethodSignature *sig= [Cls instanceMethodSignatureForSelector:Seletor];
            NSInvocation *invocation=[NSInvocation invocationWithMethodSignature:sig];
            [invocation setTarget:self.delegate];
            [invocation setSelector:Seletor];
//            [invocation setArgument:&bottommodel atIndex:2];
            [invocation invoke];
           
        }

    };
    
}

 
-(void)initOrderInfoSubviews{
    NSArray <NSString *> *titleList = [self getGraphic0rderInfor:self.orderMode];
    CGFloat orderInfoHeight =(titleList.count + 1) * 10 + 18 * titleList.count + 28;
    [self.orderInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(orderInfoHeight);
    }];
    [self.orderInfoView updateGraphic0rderInforView:titleList];

}

- (NSArray <NSString *> *)getGraphic0rderInfor:(JHOrderDetailMode *)mode {
    
    NSMutableArray * titles=[NSMutableArray array];
    if (mode.orderCode ) {
        [titles addObject: [@"订单号:  " stringByAppendingString:OBJ_TO_STRING(mode.orderCode)]];
        
    }
    if (mode.createTime) {
        [titles addObject: [@"下单时间:  " stringByAppendingString:OBJ_TO_STRING(mode.createTime)]];
        
    }
    if (mode.payTime) {
        [titles addObject: [@"支付时间:  " stringByAppendingString:OBJ_TO_STRING(mode.payTime)]];
        
    }
    if (mode.sellerSentTime) {
        [titles addObject: [@"卖家发货:  " stringByAppendingString:OBJ_TO_STRING(mode.sellerSentTime)]];
        
    }
    if (mode.portalReceivedTime) {
        [titles addObject: [@"平台收货时间:  " stringByAppendingString:OBJ_TO_STRING(mode.portalReceivedTime)]];
        
    }
    if (mode.portalSentTime) {
        [titles addObject: [@"平台发货:  " stringByAppendingString:OBJ_TO_STRING(mode.portalSentTime)]];
        
    }
    return titles.copy;
        
}


-(void)setFriendAgentpayArr:(NSArray *)friendAgentpayArr{
    
    _friendAgentpayArr=friendAgentpayArr;
//    if (_friendAgentpayArr.count>0) {
//        [_payListView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.sellerNoteView.mas_bottom).offset(10);
//        }];
//    }
    [self.payListView initBuyerPayListSubviews:_friendAgentpayArr];
    
}

-(void)setOrderMode:(JHOrderDetailMode *)orderMode{
    
    _orderMode=orderMode;
//    [self.productView setOrderMode:_orderMode];
//    [self.productView ConfigCategoryTagTitle:_orderMode];
    
    //头信息
    [self.headerTitleView updateGraphic0rderHeaderView:_orderMode];
    
    self.titleValue.text = [NSString stringWithFormat:@"鉴定类目：%@",_orderMode.appraisalCateName];
    self.priceValue.text = [NSString stringWithFormat:@"￥%@",_orderMode.appraisalFee];
    
    self.redBagValue.text = [NSString stringWithFormat:@"￥%@",_orderMode.discountAmount];
    self.allMoneyValue.text = [NSString stringWithFormat:@"￥%@",_orderMode.orderPrice];
    self.numValue.text = [NSString stringWithFormat:@"%ld",_orderMode.goodsImgs.count];
    
    for (UIImageView *iv in  self.goodImages) {
        iv.hidden = YES;
    }
    
    [self.tipView removeFromSuperview];
    
    for (int i=0; i<_orderMode.goodsImgs.count; i++) {
        UIImageView *iv = self.goodImages[i];
        iv.hidden = NO;
        JHGroDetailImageUrlModel *model = _orderMode.goodsImgs[i];
        [iv sd_setImageWithURL:[NSURL URLWithString:model.small] placeholderImage:[UIImage imageNamed:@"common_photo_placeholder"]];
        
        if(i == (_orderMode.goodsImgs.count-1)){
            [iv addSubview:self.tipView];
            [self.tipView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 17));
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
        }
        
    }
    CGFloat imageWH = (kScreenWidth - 30*2) / 3;
    [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_orderMode.goodsImgs.count*imageWH+10*_orderMode.goodsImgs.count);
    }];
    
    //订单支付时间信息
    [self initOrderInfoSubviews];
    //底部按钮
    _buttonBackView.hidden = orderMode.bottomButtons.count == 0 ? YES : NO;
    [self.buttonBackView updateGraphicBottom:orderMode.bottomButtons];
    [self showReportTipImage];
    
}

-(void)showReportTipImage{
    
    [_tipImgeView removeFromSuperview];
    _tipImgeView=nil;
    
    if (!self.orderMode.reportReadFlag) {
        for (id obj in self.buttonBackView.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton * button =(UIButton*)obj;
                //JHOrderButtonTypeDetail
                if (button.tag == JHOrderButtonTypeDetail) {
                    [self.viewController.view addSubview:self.tipImgeView];
                    [self.tipImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(button.mas_left).offset(30);
                        make.bottom.equalTo(button.mas_top).offset(7);
                        make.size.mas_equalTo(CGSizeMake(40, 19));
                    }];
                }
            }
            break;
        }
    }
}
-(void)setViewHeightChangeBlock:(JHFinishBlock)viewHeightChangeBlock{
    
    _viewHeightChangeBlock = viewHeightChangeBlock;
//    _feeView.viewHeightChangeBlock = _viewHeightChangeBlock;
}
- (void)ClickService:(UIButton*)button{
    
    if ([self.delegate respondsToSelector:@selector(contactCustomerService)]) {
        [self.delegate contactCustomerService];
    }
    
}

-(void)productViewTap:(UIGestureRecognizer*)gestureRecognizer{
    
    if (self.orderMode.orderCategoryType == JHOrderCategoryMallOrder) {
        JHStoreDetailViewController *detailVC = [[JHStoreDetailViewController alloc] init];
        detailVC.productId = self.orderMode.onlyGoodsId;
        detailVC.fromPage = @"";
        [self.viewController.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (void)p_refreshThePage {
    if ([self.delegate respondsToSelector:@selector(countdownOver)]) {
        [self.delegate countdownOver];
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

@end


