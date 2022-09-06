//
//  JHCustomizeOrderDetailController.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeOrderDetailController.h"
#import "JHContactAlertView.h"
#import "JHOrderDetailView.h"
#import "JHCustomizeBuyerOrderView.h"
#import "JHCustomizeSellerOrderView.h"
#import "JHOrderPayViewController.h"
#import "JHQYChatManage.h"
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
#import "JHOrderViewDelegate.h"
#import "JHCustomizeOrderApiManager.h"
#import "JHCustomizeOrdeOperation.h"
static NSString * const reuseHeaderId = @"headerId";
static NSString * const reuseFooterId = @"footerId";
static NSString * const reuseCellId = @"cellId";


@interface JHCustomizeOrderDetailController  ()<JHOrderViewDelegate,JHOrderDetailViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    JHCustomizeBuyerOrderView * orderView;
    JHCustomizeSellerOrderView * sellerOrderView;;
    NSInteger _pageNumber;
    CGFloat headerHeight;
    CGFloat alphaValue;   ///导航栏透明度
    BOOL titleHidden;
    BOOL showGoodsList;
}
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) JCCollectionViewWaterfallLayout *layout;
@property(nonatomic,strong) NSMutableArray<JHShopWindowLayout*>* layouts;
@property(strong,nonatomic) JHCustomizeOrderModel* orderMode;
@end

@implementation JHCustomizeOrderDetailController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestInfo) name:ORDERSTATUSCHANGENotifaction object:nil];
    self.view.backgroundColor=[CommHelp toUIColorByStr:@"#f7f7f7"];
    headerHeight=800;
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:self.jhNavView];
    self.title = @"定制订单详情";
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight-50);
        make.left.right.equalTo(self.view);
    }];
    [self.jhLeftButton setImage:kNavBackWhiteShadowImg forState:UIControlStateNormal];
    [self.jhLeftButton setImage:kNavBackBlackImg forState:UIControlStateHighlighted];
    self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    self.jhTitleLabel.hidden=YES;
    
    
    [self  initContentView];
    __weak typeof(self) weakSelf = self;
    
    self.collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    self.collectionView.mj_footer.hidden=YES;
    [self loadNewData];
    
    if (!self.isSeller) {
     [JHGrowingIO trackEventId:@"dz_order_xq_in"];
    }
}

-(void)loadNewData{
    
    _pageNumber=1;
    [self requestInfo];
    if (!self.isSeller) {
        [self requestFriendAgentPayInfo];
    }
}
-(void)loadGoodList{
    //    if (!self.isSeller) {
    //        showGoodsList = YES;
    //        [self requestProductInfo];
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
       // [SVProgressHUD dismiss];
        
    } failureBlock:^(RequestModel *respondObject) {
      // [SVProgressHUD dismiss];
    }];
   // [SVProgressHUD show];
}
-(void)requestInfo{
    
    [JHCustomizeOrderApiManager requestCustomizeOrderDetail:self.orderId isSeller:self.isSeller Completion:^(NSError * _Nonnull error, JHCustomizeOrderModel * _Nonnull orderModel) {
        
        [SVProgressHUD dismiss];
        if (!error) {
            self.orderMode = orderModel;
            self.orderMode.isSeller=self.isSeller;
            if (self.isSeller) {
                [sellerOrderView setOrderMode:self.orderMode];
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
            }
            
            if (self.orderMode.customizeButtons.count==0) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
                }];
            }
           else {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight-50);
                }];
            }
            [self.collectionView reloadData];
            [self loadGoodList];
        }
        else{
            [self.view makeToast:error.localizedDescription duration:1.0 position:CSToastPositionCenter];
        }
        
    }];
    
    [SVProgressHUD show];
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
        sellerOrderView=[[JHCustomizeSellerOrderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, headerHeight)];
        sellerOrderView.isSeller=self.isSeller;
        sellerOrderView.delegate=self;
        [self.collectionView addSubview:sellerOrderView];
        JH_WEAK(self)
        [sellerOrderView initBottomView];
        sellerOrderView.viewHeightChangeBlock = ^{
            JH_STRONG(self)
        [self->sellerOrderView layoutIfNeeded];
        self-> headerHeight=self->sellerOrderView.contentScroll.frame.size.height;
            self->sellerOrderView.height=self->headerHeight;
            [self.collectionView reloadData];
        };
    }
    else{
        
        orderView=[[JHCustomizeBuyerOrderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, headerHeight)];
        orderView.isSeller=self.isSeller;
        orderView.delegate=self;
        [self.collectionView addSubview:orderView];
        
        [orderView initBottomView];
        
        JH_WEAK(self)
        orderView.shareHandle = ^(id object, id sender) {
            JH_STRONG(self)
            OrderFriendAgentPayMode * mode=(OrderFriendAgentPayMode*)object;
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
            return headerView;
        }
        
    }
    
    if (indexPath.section==1) {
        if([kind isEqual:UICollectionElementKindSectionHeader]){
            JHRecommendHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseHeaderId forIndexPath:indexPath];
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
-(void)buttonPress:(NSInteger)index{
    
    [JHCustomizeOrdeOperation customizeOrderButtonAction:self.orderMode buttonType:index isSeller:self.isSeller isFromOrderDetail:YES];
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
    
    [HttpRequestTool putWithURL:[FILE_BASE_STRING(@" /order/auth/buyer/delete?orderId=") stringByAppendingString:OBJ_TO_STRING(mode.orderId)] Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"%lf",offsetY);
    alphaValue = offsetY / kHeaderH;
    if (alphaValue >= 1) {
        alphaValue = 1;
    }
    titleHidden = (offsetY < kHeaderH/2);
    self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:alphaValue];
    self.jhTitleLabel.hidden=titleHidden;
    UIImage * image= titleHidden ? kNavBackWhiteShadowImg : kNavBackBlackImg;
    //        [self.navbar.comBtn setImage:image forState:UIControlStateNormal];
    //        [self.navbar.comBtn setImage:image forState:UIControlStateSelected];
    [self.jhLeftButton setImage:image forState:UIControlStateNormal];
    [self.jhLeftButton setImage:image forState:UIControlStateSelected];
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)dealloc
{
    NSLog(@"JHCustomizeOrderDetailController dealloc");
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

