//
//  JHNewOrderSubListViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2021/1/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
#import "JHNewOrderSubListViewController.h"
#import "JHOrderListTableViewCell.h"
#import "JHSellerOrderListTableViewCell.h"
#import "JHOrderDetailViewController.h"
#import "JHOrderPayViewController.h"
#import "JHOrderConfirmViewController.h"
#import "JHQYChatManage.h"
#import "JHOrderSegmentView.h"
#import "JHSendCommentViewController.h"
#import "OrderDateChooseView.h"
#import "JHOrderExportSuccessView.h"
#import "NaiveShareManager.h"
#import "JHSellerSendOrderViewController.h"
#import "JHOrderListSegmentView.h"
#import "CommAlertView.h"
#import "JHOrderReturnViewController.h"
#import "JHQRViewController.h"
#import "AdressManagerViewController.h"
#import "JHWebViewController.h"
#import "JHOrderNoteView.h"
#import "JHOrderApplyReturnViewController.h"
#import "JHAppraiseOrderViewController.h"
#import "JHOrderSearchView.h"
#import "JHOrderSearchResultViewController.h"
#import "ExportOrderMode.h"
#import "JHOrderViewModel.h"
#import "JHLiveRoomMode.h"
#import "HttpDownLoadFileTool.h"
#import "BYTimer.h"
#import "JHPrinterManager.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "JHStoneResaleSmallCollectionViewCell.h"
#import "JHNewOrderListCell.h"
#import "JHShopWindowLayout.h"
#import "JHShopWindowCollectionCell.h"
#import "JHGoodsDetailViewController.h"
#import "JHRecommendHeader.h"
#import "JHStoreApiManager.h"
#import "JHUnionSignSalePopView.h"
#import "JHUnionSignView.h"
#import "JHCustomizeOrderDetailController.h"
#import "JHCustomizeOrderModel.h"
#import "JHCustomizeOrdeOperation.h"
#import "JHDefaultCollectionViewCell.h"
#import "JHOrderOperation.h"
#import "JHAuctionOrderDetailViewController.h"

#define pagesize 20
static NSString * const reuseHeaderId = @"headerId";
static NSString * const reuseFooterId = @"footerId";
static NSString * const reuseCellId = @"cellId";
@interface JHNewOrderSubListViewController ()<UITableViewDelegate,UITableViewDataSource,JHOrderSegmentViewViewDelegate,JHOrderViewDelegate,UIDocumentInteractionControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSInteger PageNum;
    NSInteger _pageNumber;
    BYTimer *timer;
    BOOL isSection0End;
    BOOL showDefaultImage;
    BOOL needRecommend; //是否需要列表展示推荐数据
}
@property(nonatomic,strong) NSMutableArray <JHCustomizeOrderModel*>* orderModes;
@property (nonatomic,strong)UIDocumentInteractionController * document;
@property (nonatomic,strong)UIButton * scanBtn;
@property (nonatomic,strong)UIButton * orderOutBtn;
@property (nonatomic,strong)   JHCustomizeOrderModel * selectMode;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) JCCollectionViewWaterfallLayout *layout;
@property(nonatomic,strong) NSMutableArray<JHShopWindowLayout*>* layouts;
@end

@implementation JHNewOrderSubListViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (self.isSeller) {
        [JHPrinterManager sharedInstance];
    }
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    __weak typeof(self) weakSelf = self;
    
    needRecommend = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:ORDERSTATUSCHANGENotifaction object:nil];
    self.collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    self.collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.collectionView.mj_footer.hidden=YES;
    [self.collectionView.mj_header beginRefreshing];
    
    [self showScanBtn];
}
-(void)loadNewData{
    
    isSection0End=NO;
    PageNum=0;
    [self requestInfo];
}
-(void)loadMoreData{
    
    if (isSection0End) {
        _pageNumber++;
        [self requestProductInfo];
    }
    else{
        PageNum++;
        [self requestInfo];
    }
}
-(void)requestInfo{
    
    NSString *url;
    if (self.isSeller) {
        User *user = [UserInfoRequestManager sharedInstance].user;
        BOOL isAssistant = NO;
        if (user.isAssistant||
            user.blRole_customizeAssistant) {
            isAssistant = YES;
        }
        url = FILE_BASE_STRING(@"");
    }
    else{
        url = FILE_BASE_STRING(@"/order/auth/orderList");
    }
    
    [HttpRequestTool getWithURL:url Parameters:@{@"searchStatus":self.status,@"pageNo":[NSString stringWithFormat:@"%ld",(long)PageNum],@"pageSize":[NSString stringWithFormat:@"%d",pagesize]}  successBlock:^(RequestModel *respondObject) {
        [self handleDataWithArr:respondObject.data];
        [self endRefresh];
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        
        [self endRefresh];
    }];
}
- (void)requestProductInfo{
    ///1订单列表 2订单详情 3个人中心 4商品详情
    @weakify(self);
    NSDictionary *dic = @{@"page" : @(_pageNumber),
                          @"from" : @1
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
- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr = [JHCustomizeOrderModel mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.orderModes = [NSMutableArray arrayWithCapacity:10];
    }
    //    else {
    //        [self.orderModes addObjectsFromArray:arr];
    //    }
    for (JHCustomizeOrderModel *mode in arr) {
        mode.isSeller=self.isSeller;
        [self.orderModes addObject:mode];
        
    }
    self.collectionView.mj_footer.hidden=NO;
    
    if (self.orderModes.count==0) {
        showDefaultImage=YES;
    }
    else{
        showDefaultImage=NO;
    }
    if (arr.count<pagesize) {
        
        if (needRecommend) {
            isSection0End=YES;
            _pageNumber=1;
            [self requestProductInfo];
        }
        else{
            self.collectionView.mj_footer.hidden=YES;
        }
    }
    [self.collectionView reloadData];
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

-(UIButton*)scanBtn{
    if (!_scanBtn) {
        _scanBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _scanBtn.titleLabel.font= [UIFont systemFontOfSize:18];
        [_scanBtn setTitle:@"扫码发货" forState:UIControlStateNormal];
        _scanBtn.backgroundColor=[CommHelp toUIColorByStr:@"#fee100"];
        [_scanBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
        [_scanBtn addTarget:self action:@selector(Scan:) forControlEvents:UIControlEventTouchUpInside];
        _scanBtn.contentMode=UIViewContentModeScaleAspectFit;
        
    }
    return _scanBtn;
}
-(UIButton*)orderOutBtn{
    if (!_orderOutBtn) {
        _orderOutBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _orderOutBtn.frame=CGRectMake(ScreenW-60, ScreenH/2+50, 50, 50);
        _orderOutBtn.titleLabel.font= [UIFont systemFontOfSize:13];
        [_orderOutBtn setTitle:@"订单\n导出" forState:UIControlStateNormal];
        _orderOutBtn.layer.cornerRadius = 25;
        _orderOutBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _orderOutBtn.backgroundColor=[CommHelp toUIColorByStr:@"#feda00"];
        [_orderOutBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
        [_orderOutBtn addTarget:self action:@selector(orderOut:) forControlEvents:UIControlEventTouchUpInside];
        _orderOutBtn.contentMode=UIViewContentModeScaleAspectFit;
        
    }
    return _orderOutBtn;
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
        _collectionView.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [CommHelp toUIColorByStr:@"f7f7f7"];
        [_collectionView registerClass:[JHNewOrderListCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewOrderListCell class])];
        [_collectionView registerClass:[JHShopWindowCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHShopWindowCollectionCell class])];
        [_collectionView registerClass:[JHDefaultCollectionViewCell class] forCellWithReuseIdentifier:@"defaultcell"];
        [_collectionView registerClass:[JHRecommendHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderId];
    }
    return _collectionView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0 ) {
        if (showDefaultImage) {
            JHDefaultCollectionViewCell *defaultcell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"defaultcell" forIndexPath:indexPath];
            [defaultcell.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(defaultcell.mas_centerY).offset(-15);
                make.centerX.equalTo(defaultcell.mas_centerX);
            }];
            defaultcell.label.text=@"您还没有相关订单";
            defaultcell.label.font = [UIFont systemFontOfSize:12];
            defaultcell.label.textColor = kColor999;
            return defaultcell;
        }
        JHNewOrderListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewOrderListCell class]) forIndexPath:indexPath];
        cell.delegate=self;
        [cell setOrderMode:self.orderModes[indexPath.row]];
        
        return cell;
    }else {
        JHShopWindowCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHShopWindowCollectionCell class]) forIndexPath:indexPath];
        cell.layout = _layouts[indexPath.item];
        
        return cell;
        
    }
    return nil;
}
#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (isSection0End&&[self.layouts count]>0) {
        return 2;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0) {
        if (self.orderModes.count>0) {
            return self.orderModes.count;
        }
        if (showDefaultImage) {
            return  1;
        }
    }
    return self.layouts.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else {
        return 2;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (showDefaultImage) {
            return CGSizeMake(ScreenW-10, 250);
        }
        return CGSizeMake(ScreenW-20, self.orderModes[indexPath.row].cellHeight);
    }
    JHShopWindowLayout *layout = self.layouts[indexPath.item];
    return CGSizeMake((ScreenW-20)/2, layout.cellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0 ;
    }
    return 46;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section{
    return 0 ;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        if([kind isEqual:UICollectionElementKindSectionHeader]){
            JHRecommendHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseHeaderId forIndexPath:indexPath];
            headerView.backgroundColor=[UIColor redColor];
            return headerView;
        }
        else {
            UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseFooterId forIndexPath:indexPath];
            return footerView;
        }
    }
    
    return nil;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section==1) {
        return UIEdgeInsetsMake(0,10,0, 10);
    }
        return UIEdgeInsetsMake(10,10,0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    return 5.f;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 20.f;
//}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        if (showDefaultImage) {
            return;
        }
        
    if (self.orderModes[indexPath.item].orderCategoryType == JHOrderCategoryPersonalCustomizeOrder) {
        if ([self.orderModes[indexPath.item]customizeOrderStatusType] == JHCustomizeOrderStatusWaitOrder
              &&!self.isSeller) {
          JHOrderConfirmViewController * order=[[JHOrderConfirmViewController alloc]init];
              order.orderId=[self.orderModes[indexPath.item]orderId];
              [self.navigationController pushViewController:order animated:YES];
          }
          else{
          JHCustomizeOrderDetailController * detail=[[JHCustomizeOrderDetailController alloc]init];
          detail.orderId=[self.orderModes[indexPath.item]orderId];
          detail.isSeller=self.isSeller;
          [self.navigationController pushViewController:detail animated:YES];
         }
        
           
    }
    else{
        
        if ([[self.orderModes[indexPath.item]orderStatus]isEqualToString:@"waitack"]
            &&!self.isSeller) {
            if (![self.orderModes[indexPath.item].orderCategory isEqualToString:@"marketAuctionOrder"]) {
                JHOrderConfirmViewController * order=[[JHOrderConfirmViewController alloc]init];
                order.orderId = [self.orderModes[indexPath.item]orderId];
                order.orderCategory = self.orderModes[indexPath.item].orderCategory;
                [self.navigationController pushViewController:order animated:YES];
            } else {
                JHAuctionOrderDetailViewController * order=[[JHAuctionOrderDetailViewController alloc]init];
                order.orderId= [self.orderModes[indexPath.item]orderId];
                order.orderCategory = @"marketAuctionOrder";
                [self.navigationController pushViewController:order animated:YES];
            }
        }
        else{
            
            JHOrderDetailViewController * detail=[[JHOrderDetailViewController alloc]init];
            detail.orderId=[self.orderModes[indexPath.item]orderId];
            detail.isSeller=self.isSeller;
            detail.orderCategoryType=[self.orderModes[indexPath.item]orderCategoryType];
            detail.orderCategory = [self.orderModes[indexPath.item]orderCategory];
            [self.navigationController pushViewController:detail animated:YES];
            if ([((JHCustomizeOrderModel*)self.orderModes[indexPath.item]).orderStatus isEqualToString:@"waitpay"]) {
                [self sa_track_goodClick:((JHCustomizeOrderModel*)self.orderModes[indexPath.item]).onlyGoodsId andGoodName:((JHCustomizeOrderModel*)self.orderModes[indexPath.item]).goodsTitle];
            }
            
        }
        
    }
        
  }
}
-(void)buttonPress:(NSInteger)buttonIndex withOrder:(JHCustomizeOrderModel*)mode{
    
    
    if (mode.orderCategoryType == JHOrderCategoryPersonalCustomizeOrder) {
        [JHCustomizeOrdeOperation customizeOrderButtonAction:mode buttonType:buttonIndex isSeller:self.isSeller isFromOrderDetail:NO];
    }
    else{
        [JHOrderOperation customizeOrderButtonAction:mode buttonType:buttonIndex isSeller:self.isSeller isFromOrderDetail:NO];
    }
}
-(void)orderOut:(UIButton*)button{
    JH_WEAK(self)
    OrderDateChooseView *view=[[OrderDateChooseView alloc]initWithFrame:JHKeyWindow.frame];
    [view show];
    view.handle = ^(NSString * _Nonnull begin, NSString * _Nonnull end) {
        JH_STRONG(self)
        [self exportOrder:begin andEndTime:end];
    };
}
-(void)exportOrder:(NSString*)beginTime andEndTime:(NSString*)endTime{
    [JHOrderViewModel getOrderExportInfoByStartTime:beginTime endTime:endTime completion:^(RequestModel *respondObject, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            ExportOrderMode * mode = [ExportOrderMode  mj_objectWithKeyValues: respondObject.data];
            NSString *fullPath =  [NSString stringWithFormat:@"%@/%@%@",[HttpDownLoadFileTool shareInstance ].orderDirectory,mode.orderTime,@".pdf"];
            [[HttpDownLoadFileTool shareInstance ]downLoadFileByURL:mode.docUrl andFilePath:fullPath progress:^(NSProgress * _Nonnull downloadProgress) {
                [SVProgressHUD showProgress:1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount status:@"正在导出中" maskType:SVProgressHUDMaskTypeGradient];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                if (!error) {
                    JHOrderExportSuccessView * success=[[JHOrderExportSuccessView alloc]init];
                    success.handle = ^{
                        [[NaiveShareManager shareInstance] nativeShare:filePath.path];
                    };
                }
                else{
                    [[UIApplication sharedApplication].keyWindow makeToast:@"导出失败,请重试" duration:1.0 position:CSToastPositionCenter];
                }
            }];
            [SVProgressHUD show];
        }
        else{
            [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }
    }];
    [SVProgressHUD show];
}
-(void)Scan:(UIButton*)button{
    [self toScanVcType:0 model:nil];
    
}
-(void)orderSearch:(UIButton*)button{
    JH_WEAK(self)
    JHOrderSearchView * view=[[JHOrderSearchView alloc]init];
    view.handle = ^(id object, id sender) {
        JH_STRONG(self)
        OrderSearchParamMode * mode=(OrderSearchParamMode*)object;
        NSDictionary * dic=[mode mj_keyValues];
        JHOrderSearchResultViewController * vc=[[JHOrderSearchResultViewController alloc ]init];
        vc.params=dic;
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    [self.view addSubview:view];
    [view show];
    
}
/**
 @param type  0 扫码发货 1 绑定宝卡
 */
- (void)toScanVcType:(NSInteger)type model:(JHCustomizeOrderModel *)model {
    
    JHQRViewController *vc = [[JHQRViewController alloc] init];
    JH_WEAK(self)
    if (type == 0) {
        vc.titleString = @"扫描运单号";
        vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController *obj) {
            JH_STRONG(self)
            [obj.navigationController popViewControllerAnimated:YES];
            
            JHSellerSendOrderViewController *vc = [JHSellerSendOrderViewController new];
            vc.expressNumber = scanString;
            
            [self.navigationController pushViewController:vc animated:NO];
            
        };
    }else if (type == 1) {
        vc.titleString = @"扫描宝卡";
        
        vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController *obj) {
            JH_STRONG(self)
            [self relBarCode:scanString obj:obj model:model];
        };
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)relBarCode:(NSString *)cardId obj:(JHQRViewController *)vc model:(JHCustomizeOrderModel *)model{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"isAssistant"] = @([UserInfoRequestManager sharedInstance].user.isAssistant?1:0);
    dic[@"barCode"] = cardId;
    dic[@"orderId"] = model.orderId;
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/order/auth/relBarCode") Parameters:dic requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        model.barCode = cardId;
        [self.collectionView reloadData];
        [vc.navigationController popViewControllerAnimated:YES];
        [self.view makeToast:@"绑定成功" duration:1 position:CSToastPositionCenter];
        
        
    } failureBlock:^(RequestModel *respondObject) {
        [vc.view makeToast:respondObject.message duration:1 position:CSToastPositionCenter];
        [vc performSelector:@selector(reStartDevice) withObject:nil afterDelay:2];
    }];
}
-(void)remindOrderSend:(JHCustomizeOrderModel*)mode{
    
    [JHOrderViewModel remindOrderSend:mode.orderId completion:^(RequestModel *respondObject, NSError *error) {
        if ((!error)) {
            [self.view makeToast:@"已提醒卖家发货" duration:1 position:CSToastPositionCenter];
        }
        else{
            [self.view makeToast:respondObject.message duration:1 position:CSToastPositionCenter];
        }
        
    }];
}
-(void)showScanBtn{
    
    if (self.isSeller&&[self.status isEqualToString:@"waitCustomizerSend"]) {
        [self.view addSubview:self.scanBtn];
        [_scanBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(@50);
            
        }];
        
        [self.view addSubview:self.orderOutBtn];
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-50);
            
        }];
    }
}
#pragma mark -
#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"customizeOrderListdealloc");
    [timer stopGCDTimer];
}

- (void)sa_track_goodClick:(NSString *)goodId andGoodName:(NSString *)goodname{
    if ([self.status isEqualToString:@"all"]) {
        [JHTracking trackEvent:@"commodityClick" property:@{@"commodity_id":NONNULL_STR(goodId),@"commodity_name":NONNULL_STR(goodname),@"model_type":@"待付款",@"tab_name":@"全部",@"page_position":@"待付款页"}];
    }else if([self.status isEqualToString:@"waitpay"]){
        [JHTracking trackEvent:@"commodityClick" property:@{@"commodity_id":NONNULL_STR(goodId),@"commodity_name":NONNULL_STR(goodname),@"model_type":@"待付款",@"tab_name":@"待付款",@"page_position":@"待付款页"}];
    }
    
}
@end
