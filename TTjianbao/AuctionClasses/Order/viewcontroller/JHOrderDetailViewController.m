//
//  JHOrderDetailViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/22.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "JHContactAlertView.h"
#import "JHOrderDetailViewController.h"
#import "JHOrderDetailView.h"
#import "JHBuyerOrderView.h"
#import "JHSellerOrderView.h"
#import "JHOrderPayViewController.h"
#import "JHOrderConfirmViewController.h"
#import "JHExpressViewController.h"
#import "JHQYChatManage.h"
#import "JHSendOutViewController.h"
#import "JHOrderListViewController.h"
#import "NTESAudienceLiveViewController.h"
#import "JHSendCommentViewController.h"
#import "JHMessageSubListController.h"
#import "CommAlertView.h"
#import "JHOrderReturnViewController.h"
#import "JHWebViewController.h"
#import "AdressManagerViewController.h"
#import "JHOrderApplyReturnViewController.h"
#import "JHBaseOperationView.h"
#import "JHPrinterManager.h"
#import "JHOfferPriceViewController.h"
#import "JHOrderNoteView.h"
#import "JHOrderViewModel.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "JHShopWindowLayout.h"
#import "JHShopWindowCollectionCell.h"
#import "JHGoodsDetailViewController.h"
#import "JHRecommendHeader.h"
#import "JHStoreApiManager.h"

#import "JHIMEntranceManager.h"

#import "JHRecycleLogisticsViewController.h"
#import "JHChatBusiness.h"
#import "JHRefunfOrderModel.h"

static NSString * const reuseHeaderId = @"headerId";
static NSString * const reuseFooterId = @"footerId";
static NSString * const reuseCellId = @"cellId";


@interface JHOrderDetailViewController  ()<JHBuyerOrderViewDelegate,JHOrderDetailViewDelegate,JHSellerOrderViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    JHBuyerOrderView * orderView;
    JHSellerOrderView * sellerOrderView;;
    NSInteger _pageNumber;
    CGFloat headerHeight;
    CGFloat alphaValue;   ///导航栏透明度
    BOOL titleHidden;
    BOOL showGoodsList;
}
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) JCCollectionViewWaterfallLayout *layout;
@property(nonatomic,strong) NSMutableArray<JHShopWindowLayout*>* layouts;
//@property(strong,nonatomic) JHOrderDetailMode *orderDetailMode;
@end

@implementation JHOrderDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestInfo) name:ORDERSTATUSCHANGENotifaction object:nil];
     self.view.backgroundColor=[CommHelp toUIColorByStr:@"#f7f7f7"];
     headerHeight=800;
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:self.jhNavView];
     self.title = @"订单详情";
    if (!self.isSeller) {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
            make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight-50);
            make.left.right.equalTo(self.view);
        }];
        [self.jhLeftButton setImage:kNavBackWhiteShadowImg forState:UIControlStateNormal];
        [self.jhLeftButton setImage:kNavBackBlackImg forState:UIControlStateSelected];
        self.jhTitleLabel.hidden = YES;
        self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    else{
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
            make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight-50);
            make.left.right.equalTo(self.view);
            
        }];
//        [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
        
    }
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self  initContentView];
    __weak typeof(self) weakSelf = self;

    self.collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
     self.collectionView.mj_footer.hidden=YES;
    [self loadNewData];
}

-(void)loadNewData{
    
    _pageNumber=1;
    [self requestInfo];
    if (!self.isSeller) {
        [self requestFriendAgentPayInfo];
    }
}
-(void)loadGoodList{
    //买家&&不是待付款状态显示推荐商品列表
    //新商城改 订单详情暂时不要推荐商品列表
//    if (!self.isSeller) {
//        if (![self.orderMode.orderStatus isEqualToString:@"waitack"]&&
//            ![self.orderMode.orderStatus isEqualToString:@"waitpay"]){
//            showGoodsList = YES;
//            [self requestProductInfo];
//          }
//      }
}
-(void)loadMoreData{
    
    _pageNumber++;
    [self requestProductInfo];
   
}
-(void)requestFriendAgentPayInfo{
    
    [HttpRequestTool getWithURL:[NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/getFriendsPay?orderId=%@"),self.orderId] Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSArray *arr = [OrderFriendAgentPayMode mj_objectArrayWithKeyValuesArray:respondObject.data];
        [orderView setFriendAgentpayArr:arr];
        [orderView layoutIfNeeded];
        headerHeight=orderView.contentScroll.frame.size.height;
        orderView.height=headerHeight;
        NSLog(@"mmmheaderHeight22==%lf",headerHeight);
        
        [self.collectionView reloadData];
        [SVProgressHUD dismiss];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
    }];
    [SVProgressHUD show];
}
-(void)requestInfo{
    if (self.orderCategoryType==JHOrderCategoryRestore||
        self.orderCategoryType==JHOrderCategoryRestoreProcessing) {
        [JHOrderViewModel requestStoneOrderDetail:self.orderId  isSeller:self.isSeller stoneId:self.stoneId completion:^(RequestModel *respondObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                    self.orderMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
                   self.orderMode.isSeller=self.isSeller;
                    if (self.isSeller) {
                        [sellerOrderView setOrderMode:self.orderMode];
                        sellerOrderView.isProblem=self.isProblem;
                        [sellerOrderView layoutIfNeeded];
                        headerHeight=sellerOrderView.contentScroll.frame.size.height;
                        sellerOrderView.height=headerHeight;
                        NSLog(@"mmmheaderHeight111==%lf",headerHeight);
                    }
                    else{
                         [orderView setOrderMode:self.orderMode];
                         [orderView layoutIfNeeded];
                         headerHeight=orderView.contentScroll.frame.size.height;
                          orderView.height=headerHeight;
                         [self loadChatType];
                       
                        NSLog(@"mmmheaderHeight222==%lf",headerHeight);
                    }
                
               
                if (self.orderMode.buttons.count==0) {
                    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
                    }];
                    
                }
                
                [self.collectionView reloadData];
                [self loadGoodList];
            }
            else{
                 [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
            }
        }];
        [SVProgressHUD show];
    }
    else{
        [JHOrderViewModel requestOrderDetail:self.orderId isSeller:self.isSeller completion:^(RequestModel *respondObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                self.orderMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
                self.orderMode.isSeller=self.isSeller;
                if (self.isSeller) {
                      [sellerOrderView setOrderMode:self.orderMode];
                      sellerOrderView.isProblem=self.isProblem;
                    [sellerOrderView layoutIfNeeded];
                    headerHeight=sellerOrderView.contentScroll.frame.size.height;
                    
                    sellerOrderView.height=headerHeight;
                    NSLog(@"mmmheaderHeight333==%lf",headerHeight);
                }
                else{
                    [orderView setOrderMode:self.orderMode];
                    [orderView layoutIfNeeded];
                    headerHeight=orderView.contentScroll.frame.size.height;
                    orderView.height=headerHeight;
                    NSLog(@"mmmheaderHeight444==%lf",headerHeight);
                    [self loadChatType];
                }
                
                if (self.orderMode.buttons.count==0) {
                  [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                       make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
                   }];
                }
                 [self.collectionView reloadData];
                [self loadGoodList];
            }
            else{
                 [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
            }
        }];
        [SVProgressHUD show];
    }
}
-(void)backActionButton:(UIButton *)sender{
    
    BOOL backLastLevel=YES;
    for (UIViewController* vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass: [JHOrderListViewController  class]]) {
            backLastLevel=NO;
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        else  if ([vc isKindOfClass: [NTESAudienceLiveViewController  class]]) {
            backLastLevel=NO;
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        else  if ([vc isKindOfClass: [JHMessageSubListController  class]]) {
            backLastLevel=NO;
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        else  if ([vc isKindOfClass: [QYSessionViewController  class]]) {
            backLastLevel=NO;
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    if (backLastLevel) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)initContentView{
    
    if (self.isSeller) {
        sellerOrderView=[[JHSellerOrderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, headerHeight)];
        sellerOrderView.isSeller=self.isSeller;
        sellerOrderView.delegate=self;
        [self.collectionView addSubview:sellerOrderView];
        
         [sellerOrderView initBottomView];
//        [sellerOrderView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.collectionView).offset(0);
//         //   make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
//            make.left.right.equalTo(self.collectionView).offset(0);
//
//        }];
        JH_WEAK(self)
        sellerOrderView.viewHeightChangeBlock = ^{
            JH_STRONG(self)
        [self->sellerOrderView layoutIfNeeded];
        self-> headerHeight=self->sellerOrderView.contentScroll.frame.size.height;
            self->sellerOrderView.height=self->headerHeight;
            [self.collectionView reloadData];
        };
        
    }
    else{
        
        
        orderView=[[JHBuyerOrderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, headerHeight)];
        orderView.isSeller=self.isSeller;
        orderView.delegate=self;
        orderView.orderCategory = self.orderCategory;
        [self.collectionView addSubview:orderView];
        
        [orderView initBottomView];
//        [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.collectionView).offset(0);
//           // make.bottom.equalTo(self.collectionView).offset(-UI.bottomSafeAreaHeight);
//            make.left.right.equalTo(self.collectionView);
//            make.height.offset(700);
//        }];
        
        JH_WEAK(self)
        orderView.shareHandle = ^(id object, id sender) {
            JH_STRONG(self)
            OrderFriendAgentPayMode * mode=(OrderFriendAgentPayMode*)object;
//            [[UMengManager shareInstance] shareWebPageToPlatformType:UMSocialPlatformType_WechatSession title:mode.title text:mode.summary thumbUrl:mode.pic webURL:mode.targetUrl type:ShareObjectTypeAgentPay pageFrom:JHPageFromTypeUnKnown object:self.orderMode.orderCode];
            JHShareInfo* info = [JHShareInfo new];
            info.title = mode.title;
            info.desc = mode.summary;
            info.img = mode.pic;
            info.shareType = ShareObjectTypeAgentPay;
            info.pageFrom = JHPageFromTypeUnKnown;
            info.url = mode.targetUrl;
            [JHBaseOperationAction toShare:JHOperationTypeWechatSession operationShareInfo:info object_flag:self.orderMode.orderCode];//TODO:Umeng share
            
            [JHGrowingIO trackOrderEventId:JHTrackorder_detail_user_replacePayClick orderCode:self.orderMode.orderCode payWay:@"replacePay" suc:@""];
        };
        
        orderView.viewHeightChangeBlock = ^{
            JH_STRONG(self)
            [self->orderView layoutIfNeeded];
            self-> headerHeight=self->orderView.contentScroll.frame.size.height;
            self->orderView.height=self->headerHeight;
            [self.collectionView reloadData];
        };
    }
}
    
- (void)requestProductInfo{
    ///1订单列表 2订单详情 3个人中心 4商品详情
    @weakify(self);
    NSDictionary *dic = @{@"page" : @(_pageNumber),
                          @"from" : @2
    };
    [JHStoreApiManager getRecommendListWithParams:dic block:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self endRefresh];
        if (!hasError) {
            RequestModel *respondObject = (RequestModel *)respObj;
            [self handleProudctWithArr:respondObject.data];
        }
    }];
}
- (void)handleProudctWithArr:(NSArray *)array {
    NSArray *arr = [JHGoodsInfoMode mj_objectArrayWithKeyValuesArray:array];
    
    if (_pageNumber == 1) {
        self.layouts = [NSMutableArray arrayWithCapacity:10];
    }
    [arr enumerateObjectsUsingBlock:^(JHGoodsInfoMode * _Nonnull goodsInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        JHShopWindowLayout *layout = [[JHShopWindowLayout alloc] initWithModel:goodsInfo];
        [self.layouts addObject:layout];
    }];
    if ([arr count]==0) {
        self.collectionView.mj_footer.hidden=YES;
    }
    else{
        self.collectionView.mj_footer.hidden=NO;
    }
    [_collectionView reloadData];
}
- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}
#pragma mark - Getters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.layout = [[JCCollectionViewWaterfallLayout alloc] init];
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight-UI.bottomSafeAreaHeight)  collectionViewLayout:self.layout];
          _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero  collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        //解决categoryView在吸顶状态下，且collectionView的显示内容不满屏时，出现竖直方向滑动失效的问题
        _collectionView.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [CommHelp toUIColorByStr:@"f7f7f7"];
        
      
        [_collectionView registerClass:[JHShopWindowCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHShopWindowCollectionCell class])];
        
        [_collectionView registerClass:[JHRecommendHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderId];
        
         [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    
         [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    return _collectionView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
         UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
          return cell;
    }
        JHShopWindowCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHShopWindowCollectionCell class]) forIndexPath:indexPath];
        cell.layout = _layouts[indexPath.item];
        
        return cell;
    
}
#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (showGoodsList&&[self.layouts count]>0) {
          return 2;
    }
     return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return self.layouts.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
   return 2;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CGSizeMake(ScreenW, 0);
    }
    JHShopWindowLayout *layout = self.layouts[indexPath.item];
    return CGSizeMake((ScreenW-20)/2, layout.cellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return headerHeight;
    }
    return 46;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section{
    
    return 0 ;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if([kind isEqual:UICollectionElementKindSectionHeader]){
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
        //    headerView.backgroundColor=[UIColor redColor];
            
            return headerView;
        }
        
    }
    
    if (indexPath.section==1) {
        if([kind isEqual:UICollectionElementKindSectionHeader]){
            JHRecommendHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseHeaderId forIndexPath:indexPath];
          //  headerView.backgroundColor=[UIColor redColor];
            return headerView;
        }
    }
    return nil;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
      return UIEdgeInsetsMake(0,5,0, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    return 5.f;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 20.f;
//}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

        JHShopWindowLayout *layout = self.layouts[indexPath.item];
        JHGoodsInfoMode *goods = layout.goodsInfo;

        JHGoodsDetailViewController *vc = [[JHGoodsDetailViewController alloc] init];
        vc.goods_id = goods.goods_id;
        vc.entry_id = @"0"; //入口id传橱窗id
        vc.entry_type = JHFromStoreFollowOrderDetailRecommend; ///订单详情推荐
        vc.isFromShopWindow = NO;
        [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 点击事件
-(void)buttonPress:(UIButton*)button{
    
    switch (button.tag) {
        case JHOrderButtonTypeCommit:
        {
            JHOrderConfirmViewController * order=[[JHOrderConfirmViewController alloc]init];
            order.orderId=self.orderMode.orderId;
            [self.navigationController pushViewController:order animated:YES];
        }
            
            break;
        case JHOrderButtonTypePay:{
        JH_WEAK(self)
        [JHOrderViewModel  OrderPayCheckTest2WithOrderId:self.orderMode.orderId completion:^(RequestModel * _Nonnull respondObject, NSError * _Nonnull error) {
            JH_STRONG(self)
                [SVProgressHUD dismiss];
                if (!error ) {
                    JHOrderPayViewController * order =[[JHOrderPayViewController alloc]init];
                    order.orderId=self.orderMode.orderId;
                    order.directDelivery = self.orderMode.directDelivery;
                    [self.navigationController pushViewController:order animated:YES];
                }
                else{
                    if (respondObject.code == 40005) {
                        CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"温馨提示" andDesc:error.localizedDescription cancleBtnTitle:@"我知道了"];
                        [[UIApplication sharedApplication].keyWindow addSubview:alert];
                    }
                    else {
                        [self.view makeToast:respondObject.message duration:1.0f position:CSToastPositionCenter];
                    }
                }
            }];
            [SVProgressHUD show];
        }
            break;  
        case JHOrderButtonTypeCancle:
            [self cancleOrder:self.orderMode];
            break;
        case JHOrderButtonTypeContact:
        {
            if (self.isSeller) {
                [[JHQYChatManage shareInstance] showChatWithViewcontroller:self];
//                
//                [JHIMEntranceManager pushSessionWithUserId:self.orderMode.sellerCustomerId orderInfo:model isBusiness:true];
            }else {
                [JHQYChatManage checkChatTypeWithCustomerId:self.orderMode.sellerCustomerId  saleType:JHChatSaleTypeAfter completeResult:^(BOOL isShop, JHQYStaffInfo * _Nonnull staffInfo) {
                    if(isShop)
                    {
                        [JHIMEntranceManager pushSessionOrderWithUserId:self.orderMode.sellerCustomerId orderInfo:self.orderMode ];
//                        [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:self orderModel:self.orderMode];
                    }
                    else
                    {
                        @weakify(self);
                        JHContactAlertView *alertView = [[JHContactAlertView alloc] initWithFrame:self.view.bounds];
                        [self.view addSubview:alertView];
                        alertView.clickBlock = ^{
                            @strongify(self);
                            [JHIMEntranceManager pushSessionOrderWithUserId:self.orderMode.sellerCustomerId orderInfo:self.orderMode ];
//                            [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:self orderModel:self.orderMode];
                        };
                    }
                }];
            }
        }

            break;
            
        case JHOrderButtonTypeLogistics: {
            
            if (self.orderMode.directDelivery) {
                JHRecycleLogisticsViewController *vc = [[JHRecycleLogisticsViewController alloc]init];
                vc.orderId = self.orderId;
                if ([self.orderMode.orderStatus isEqualToString:@"refunding"]) { /// 退货
                    vc.type = 7;
                } else {
                    vc.type = 6;
                }
                vc.isBusinessZhiSend = YES;
                vc.isZhifaSeller     = self.isSeller;
                if ([self.orderMode.orderStatus isEqualToString:@"portalsent"] || [self.orderMode.orderStatus isEqualToString:@"待收货"]) {
                    vc.isZhifaOrderComplete = NO;
                } else {
                    vc.isZhifaOrderComplete = YES;
                }
                [self.navigationController pushViewController:vc animated:true];
            } else {
                JHExpressViewController *express=[[JHExpressViewController alloc]init];
                express.orderId = self.orderId;
                [self.navigationController pushViewController:express animated:YES];
            }
            NSString *from = @"直播订单";
            if (self.orderMode.orderCategoryType == JHOrderCategoryMallOrder) {
                from = @"商城订单";
            }
            [JHAllStatistics jh_allStatisticsWithEventId:@"wlClick" params:@{@"order_id":self.orderMode.orderId,@"order_amount":self.orderMode.orderPrice,@"store_from":from} type:JHStatisticsTypeSensors];
        }
            
            break;
        case JHOrderButtonTypeReceive:
            [self sureOrder:self.orderMode];
            break;
        case JHOrderButtonTypeDetail: {
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/report.html?orderId=%@"), self.orderMode.orderId];
            [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
        }
            break;
        case JHOrderButtonTypeSend:
        {
            JHSendOutViewController *sendOut = [[JHSendOutViewController alloc]init];
            sendOut.orderId                  = self.orderMode.orderId;
            sendOut.directDelivery           = self.orderMode.directDelivery;
            sendOut.orderShowModel           = self.orderMode;
            [self.navigationController pushViewController:sendOut animated:YES];
        }
            break;
            
            //评价
        case JHOrderButtonTypeComment:{
            JHSendCommentViewController *vc = [[JHSendCommentViewController alloc] init];
            vc.orderId = self.orderMode.orderId;
            vc.imageUrl = self.orderMode.goodsUrl;
            
            MJWeakSelf
            vc.commentComplete = ^{
                __strong typeof(weakSelf) sself = weakSelf;
                weakSelf.orderMode.commentStatus = YES;
                if (weakSelf.isSeller) {
                    [sself -> sellerOrderView setOrderMode:weakSelf.orderMode];
                }
                else{
                    [sself -> orderView setOrderMode:weakSelf.orderMode];
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            //已评价
        case JHOrderButtonTypeLookComment: {
            JHSendCommentViewController *vc = [[JHSendCommentViewController alloc] init];
            vc.orderId = self.orderMode.orderId;
            vc.imageUrl = self.orderMode.goodsImg;
            
            vc.isShow = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            //退货
        case JHOrderButtonTypeReturnGood: {
            JHOrderReturnViewController *vc =[[JHOrderReturnViewController alloc]init];
            vc.refundExpireTime=self.orderMode.refundExpireTime;
            vc.orderId = self.orderMode.orderId;
            vc.directDelivery = self.orderMode.directDelivery;
            [self.navigationController pushViewController:vc animated:YES];
            //  [self showAlert];
        }
            break;
        case JHOrderButtonTypeQuestionDetail: {
            JHWebViewController *webVC = [JHWebViewController new];
            webVC.urlString = [H5_BASE_STRING(@"/jianhuo/app/problemDetails.html?orderId=") stringByAppendingString:OBJ_TO_STRING(self.orderMode.orderId)];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case JHOrderButtonTypeAlterAddress: {
            AdressManagerViewController *vc = [[AdressManagerViewController alloc] init];
            vc.orderId=self.orderMode.orderId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHOrderButtonTypeReturnDetail: {
            
            JHWebViewController *webVC = [JHWebViewController new];
            webVC.urlString =ReturnDetailURL(self.orderMode.orderId, self.isSeller?1:0);
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case JHOrderButtonTypeAppraiseIssue: {
            JHWebViewController *webVC = [JHWebViewController new];
            webVC.urlString =AppraiseIssueDetailURL(self.orderMode.orderId);
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case JHOrderButtonTypeApplyReturn: {
            
            [SVProgressHUD show];
            NSDictionary * dic = @{@"orderId":self.orderMode.orderId};
            @weakify(self);
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/getPartialWorkOrder") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
                @strongify(self);
                [SVProgressHUD dismiss];
                JHRefunfOrderModel *model = [JHRefunfOrderModel mj_objectWithKeyValues:respondObject.data];
                if (model.flag) {
                    JHTOAST(model.refundTag);
                }else{
                    JHOrderApplyReturnViewController * vc=[[JHOrderApplyReturnViewController alloc]init];
                    vc.orderMode=self.orderMode;
                    vc.orderId=self.orderMode.orderId;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } failureBlock:^(RequestModel *respondObject) {
                @strongify(self);
                [SVProgressHUD dismiss];
                JHOrderApplyReturnViewController * vc=[[JHOrderApplyReturnViewController alloc]init];
                vc.orderMode=self.orderMode;
                vc.orderId=self.orderMode.orderId;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            
        }
            break;
        case JHOrderButtonTypeAddNote: {
            
            JHOrderNoteView * note=[[JHOrderNoteView alloc]init];
            note.orderMode=self.orderMode;
            [self.view addSubview:note];
            
        }
            break;
            case JHOrderButtonTypePrintCard: {
            [[JHPrinterManager sharedInstance] printOrderBarCode:self.orderMode.orderId andResult:nil];
            }
            break;
        case JHOrderButtonTypeCompleteInfo: {
            JHWebViewController *webVC = [JHWebViewController new];
            webVC.urlString =CompleteOrderDetailURL(self.orderMode.orderId);
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
            //结算详情
        case JHOrderButtonTypeAccountDetail:{
            NSString *url = [NSString stringWithFormat:@"/jianhuo/app/settlement/settlement.html?orderId=%@",self.orderId];
            
            JHWebViewController *webVC = [JHWebViewController new];
            webVC.urlString  = H5_BASE_STRING(url);
            webVC.titleString = @"结算详情";
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case JHOrderButtonTyperDelete:{
           
            CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"删除后此订单将不再展示，请确认操作？" cancleBtnTitle:@"取消" sureBtnTitle:@"删除"];
            [self.view addSubview:alert];
            @weakify(self);
            alert.handle = ^{
                @strongify(self);
                [self deleteOrder:self.orderMode];
            };
        }
            break;
            
        case JHOrderButtonTyperApplyCustomize:{
            
            [JHRootController EnterLiveRoom:self.orderMode.channelLocalId fromString:@"" isStoneDetail:NO isApplyConnectMic:YES];
        }
            break;
        default:
            break;
            
    }
}
-(void)showAlert{
    JH_WEAK(self)
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"退货方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"已拒收快递" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CommAlertView*  returnAlert=[[CommAlertView alloc]initWithTitle:@"是否确认您已拒收快递?" andDesc:@"" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
        [self.view addSubview:returnAlert];
        returnAlert.handle = ^{
            JH_STRONG(self)
            [self refuse:self.orderMode];
        };
    }] ];
    [alert addAction:[UIAlertAction actionWithTitle:@"已收货，发快递退回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JH_STRONG(self)
        JHOrderReturnViewController *vc =[[JHOrderReturnViewController alloc]init];
        vc.refundExpireTime=self.orderMode.refundExpireTime;
        vc.orderId = self.orderMode.orderId;
        vc.directDelivery = self.orderMode.directDelivery;
        [self.navigationController pushViewController:vc animated:YES];
        
    }] ];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }] ];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)refuse:(OrderMode*)mode{
    [HttpRequestTool postWithURL:[FILE_BASE_STRING(@"/orderRefund/auth/express/reject?orderId=") stringByAppendingString:OBJ_TO_STRING(mode.orderId)] Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"已拒收" duration:1.0 position:CSToastPositionCenter];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
}
-(void)sureOrder:(OrderMode*)mode{
    
    [HttpRequestTool postWithURL:[FILE_BASE_STRING(@"/order/auth/receipt?orderId=") stringByAppendingString:OBJ_TO_STRING(mode.orderId)] Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"收货完成" duration:1.0 position:CSToastPositionCenter];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
    
    [SVProgressHUD show];
}
-(void)cancleOrder:(OrderMode*)mode{
    
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSString * type;
    if (self.isSeller) {
        type=user.isAssistant?@"2":@"1";
    }
    else{
        type=@"0";
    }
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/cancel?orderId=%@&cancelReason=%@&userType=%@"),mode.orderId,@"",type];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"取消成功" duration:1.0 position:CSToastPositionCenter];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
        
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    [SVProgressHUD show];
}
-(void)deleteOrder:(OrderMode*)mode{
    
    [HttpRequestTool putWithURL:[FILE_BASE_STRING(@"/order/auth/buyer/delete/") stringByAppendingString:OBJ_TO_STRING(mode.orderId)] Parameters:@{@"orderId":mode.orderId} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
}
-(void)loadChatType{
    [JHChatBusiness getServeceWithUserId:self.orderMode.sellerCustomerId successBlock:^(RequestModel * _Nullable respondObject) {
        NSUInteger code = [respondObject.data integerValue];
        if (code == 1) {
            [orderView.chatBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        }else {
            [JHQYChatManage checkChatTypeWithCustomerId:self.orderMode.sellerCustomerId  saleType:JHChatSaleTypeAfter completeResult:^(BOOL isShop, JHQYStaffInfo * _Nonnull staffInfo) {
                NSString * title=isShop?@"联系商家":@"联系客服";
                [orderView.chatBtn setTitle:title forState:UIControlStateNormal];
            }];
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.isSeller) {
        CGFloat offsetY = scrollView.contentOffset.y;
        NSLog(@"%lf",offsetY);
        alphaValue = offsetY / kHeaderH;
        if (alphaValue >= 1) {
            alphaValue = 1;
        }
        titleHidden = (offsetY < kHeaderH/2);
//        self.navbar.ImageView.backgroundColor = [UIColor colorWithWhite:1 alpha:alphaValue];
//        self.navbar.titleLbl.hidden=titleHidden;
        self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:alphaValue];
        self.jhTitleLabel.hidden=titleHidden;
        UIImage * image= titleHidden ? kNavBackWhiteShadowImg : kNavBackBlackImg;
        [self.jhLeftButton setImage:image forState:UIControlStateNormal];
        [self.jhLeftButton setImage:image forState:UIControlStateSelected];
//        [self.navbar.comBtn setImage:image forState:UIControlStateNormal];
//        [self.navbar.comBtn setImage:image forState:UIControlStateSelected];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

