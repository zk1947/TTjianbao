//
//  JHGraphicOrderDetailViewController.m
//  TTjianbao
//
//  Created by 张坤 on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGraphicOrderDetailViewController.h"
#import "JHOrderDetailView.h"
#import "JHGraphicBuyerOrderView.h"
#import "JHSellerOrderView.h"
#import "JHQYChatManage.h"
#import "CommAlertView.h"
#import "JHWebViewController.h"
#import "JHPrinterManager.h"
#import "JHOrderViewModel.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "JHShopWindowLayout.h"
#import "JHShopWindowCollectionCell.h"
#import "JHGoodsDetailViewController.h"
#import "JHRecommendHeader.h"
#import "JHRecycleOrderCancelViewController.h"
#import "JHAppraisePayView.h"
#import "JHGraphicaldentificationBusiness.h"
#import "JHGraphiclOrderDelegate.h"

static NSString * const reuseHeaderId = @"headerId";
static NSString * const reuseFooterId = @"footerId";
static NSString * const reuseCellId = @"cellId";


@interface JHGraphicOrderDetailViewController  ()<
JHGraphiclOrderDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
{
    JHGraphicBuyerOrderView * orderView;
    JHSellerOrderView * sellerOrderView;
    CGFloat headerHeight;
    CGFloat alphaValue;   ///导航栏透明度
    BOOL titleHidden;
    BOOL showGoodsList;
}

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *orderCode;
@property (nonatomic, weak) id<JHGraphicalSubListVCDelegate> delegate;

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) JCCollectionViewWaterfallLayout *layout;
@property (nonatomic, strong) NSMutableArray<JHShopWindowLayout*>* layouts;
@property (nonatomic, strong) JHOrderDetailMode* orderMode;

@end

@implementation JHGraphicOrderDetailViewController

- (instancetype)initWithOrderInfoId:(NSString *)aOrderId
                          orderCode:(NSString *)aOrderCode
                           delegate:(id<JHGraphicalSubListVCDelegate>) aDelegate {
    
    if (self = [super init]) {
        _orderId = aOrderId;
        _orderCode = aOrderCode;
        _delegate = aDelegate;
        
    }
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reportPageView];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"订单详情";
    self.view.backgroundColor=[CommHelp toUIColorByStr:@"#f7f7f7"];
    headerHeight=800;
    
    [self.jhLeftButton setImage:kNavBackWhiteShadowImg forState:UIControlStateNormal];
    [self.jhLeftButton setImage:kNavBackBlackImg forState:UIControlStateSelected];
    self.jhTitleLabel.hidden = YES;
    self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    
    [self  initContentView];
   
     self.collectionView.mj_footer.hidden=YES;
    [self.view bringSubviewToFront:self.jhNavView];
    
    [self requestInfo];
}


-(void)backActionButton:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initContentView{
    
    orderView=[[JHGraphicBuyerOrderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, headerHeight)];
    orderView.isSeller=NO;
    orderView.delegate=self;
    [self.collectionView addSubview:orderView];
    [orderView initBottomView];
    JH_WEAK(self)
    orderView.viewHeightChangeBlock = ^{
        JH_STRONG(self)
        [self->orderView layoutIfNeeded];
        self-> headerHeight=self->orderView.contentScroll.frame.size.height;
        self->orderView.height=self->headerHeight;
        [self.collectionView reloadData];
    };
}
#pragma mark - 网络请求

-(void)requestInfo {
    
    [SVProgressHUD show];
    NSDictionary *dict = @{@"orderId":self.orderId};
    [JHGraphicaldentificationBusiness requestGraphicOrderDetailWithParams:dict completion:^(RequestModel * _Nonnull respondObject) {
        [SVProgressHUD dismiss];
        self.orderMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
        [orderView setOrderMode:self.orderMode];
        [orderView layoutIfNeeded];
        headerHeight=orderView.contentScroll.frame.size.height;
        orderView.height=headerHeight;
        NSLog(@"mmmheaderHeight444==%lf",headerHeight);
        [self loadChatType];
        
        if (self.orderMode.buttons.count==0) {
          [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
           }];
        }
         [self.collectionView reloadData];
        
    } fail:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"请求失败" duration:1.0 position:CSToastPositionCenter];
    }];
    
}

-(void)loadChatType{
    [JHQYChatManage checkChatTypeWithCustomerId:self.orderMode.sellerCustomerId  saleType:JHChatSaleTypeAfter completeResult:^(BOOL isShop, JHQYStaffInfo * _Nonnull staffInfo) {
        NSString * title=@"联系客服";
        [orderView.chatBtn setTitle:title forState:UIControlStateNormal];
    }];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
         UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
          return cell;
    }
        JHShopWindowCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHShopWindowCollectionCell class]) forIndexPath:indexPath];
        cell.layout = _layouts[indexPath.item];
        
        return cell;
    
}

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
    
    return 0;
    
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


#pragma mark - JHGraphiclOrderDelegate

- (void)countdownOver {
    // 刷新数据
    [self requestInfo];
    if ([self.delegate respondsToSelector:@selector(toRefreshGraphicalSubListPage)]) {
        [self.delegate toRefreshGraphicalSubListPage];
    }
}

- (void)cancelAppraisalWith:(JHGraphicalSubModel *)graphicalModel {
    
    JHRecycleOrderCancelViewController *vc = [[JHRecycleOrderCancelViewController alloc] init];
    vc.jhNavView.hidden = YES;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.requestType = 3;
    vc.isShowCancel = 1;
    @weakify(self);
    vc.selectCompleteBlock = ^(NSString * _Nonnull message, NSString *code) {
        @strongify(self);
        
        NSDictionary *dict = @{@"orderId":self.orderId,@"cancelReason":message};
        [JHGraphicaldentificationBusiness requestCancelIdentificationWithParams:dict
                                                                     completion:^(RequestModel * _Nonnull respondObject) {
            // 刷新数据
            [self requestInfo];
            if ([self.delegate respondsToSelector:@selector(toRefreshGraphicalSubListPage)]) {
                [self.delegate toRefreshGraphicalSubListPage];
            }
            
            
        } fail:^(NSError * _Nonnull error) {
            
        }];
       
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)toPayWith:(JHGraphicalSubModel *)graphicalModel {
    JHAppraisePayView * payView = [[JHAppraisePayView alloc]init];
    payView.orderId = self.orderId;
    [JHKeyWindow addSubview:payView];
    [payView showAlert];
    @weakify(self);
    payView.paySuccessBlock = ^{
        @strongify(self);
        // 刷新数据
        [self requestInfo];
        if ([self.delegate respondsToSelector:@selector(toRefreshGraphicalSubListPage)]) {
            [self.delegate toRefreshGraphicalSubListPage];
        }
    };
}

- (void)checkTheReportWith:(JHGraphicalSubModel *)graphicalModel {
    
    JHWebViewController *webVC = [JHWebViewController new];
    NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
    NSString *url = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/reportGraphic.html?customerId=%@&orderCode=%@"),customerId, self.orderCode];
    
    webVC.urlString = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)toDeleteWith:(JHGraphicalSubModel *)graphicalModel {
    
    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"您确定删除？" cancleBtnTitle:@"取消" sureBtnTitle:@"删除"];
    [JHKeyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        [SVProgressHUD show];
        [JHGraphicaldentificationBusiness requestDeleteGraphicalWithParams:@{@"orderId":self.orderId} completion:^(RequestModel * _Nonnull respondObject) {
            [SVProgressHUD dismiss];
            if ([self.delegate respondsToSelector:@selector(toRefreshGraphicalSubListPage)]) {
                [self.delegate toRefreshGraphicalSubListPage];
            }
            JHTOAST(@"删除订单成功");
            [self.navigationController popViewControllerAnimated:YES];
            
        } fail:^(NSError * _Nonnull error) {
            
            [SVProgressHUD dismiss];
            
        }];
        
    };
}

///联系客服
- (void)contactCustomerService {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"在线客服" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[JHQYChatManage shareInstance] showChatWithViewcontroller:[JHRootController currentViewController]];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"电话客服" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006230666"]];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
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

#pragma mark - 埋点
- (void)reportPageView {
    NSDictionary *par = @{
        @"page_name" : @"鉴定订单详情页",
        @"order_id" : self.orderId,
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
- (void)reportPayEvent {
    NSMutableDictionary *par = [NSMutableDictionary new];
    [par setValue: @"鉴定订单详情页" forKey:@"page_position"];
    [par setValue: self.orderMode.goodsId forKey:@"commodity_id"];
    [par setValue: self.orderMode.orderPrice forKey:@"order_actual_amount"];
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickSubmitOrder"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}


#pragma mark - set/get

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
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
            make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight-50);
            make.left.right.equalTo(self.view);
        }];
    }
    return _collectionView;
}

@end

