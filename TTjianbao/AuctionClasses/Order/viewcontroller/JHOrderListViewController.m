//
//
//  Created by jiangchao on 2017/5/23.
//  Copyright © 2017年 jiangchao. All rights reserved.
//
#import "JHPickerView.h"

#import "JHOrderListViewController.h"
#import "JHOrderListTableViewCell.h"
#import "JHSellerOrderListTableViewCell.h"
#import "JHOrderDetailViewController.h"
#import "JHOrderPayViewController.h"
#import "JHOrderConfirmViewController.h"
#import "JHExpressViewController.h"
#import "JHQYChatManage.h"
#import "JHSendOutViewController.h"
#define pagesize 10
#define cellRate (float)  201/345
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
#import "JHBuyerOrderCollectionViewCell.h"
#import "JHSellerOrderCollectionViewCell.h"
#import "JHShopWindowLayout.h"
#import "JHShopWindowCollectionCell.h"
#import "JHGoodsDetailViewController.h"
#import "JHRecommendHeader.h"
#import "JHStoreApiManager.h"
#import "JHUnionSignSalePopView.h"
#import "JHUnionSignView.h"
#import "JHCustomizeOrderDetailController.h"
#import "JHDefaultCollectionViewCell.h"
#import "JHOrderListZhiFaHeaderView.h"
#import "UIView+JHGradient.h"
#import "JHRecycleLogisticsViewController.h"
#import "JHRefunfOrderModel.h"
typedef enum : NSUInteger {
    JHSellOrderStatusNoZhifa = 0,
    JHSellOrderStatusZhifa = 1,
    JHSellOrderStatusAll,
} JHSellOrderStatus;


static NSString * const reuseHeaderId = @"headerId";
static NSString * const reuseFooterId = @"footerId";
static NSString * const reuseCellId = @"cellId";
@interface JHOrderListViewController ()<UITableViewDelegate,UITableViewDataSource,JHOrderSegmentViewViewDelegate,JHOrderListTableViewCellDelegate,JHSellerOrderListTableViewCellDelegate,UIDocumentInteractionControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,STPickerSingleDelegate>
{
    NSInteger PageNum;
    NSInteger _pageNumber;
    NSArray* rootArr;
    JHOrderListSegmentView *  headerView;
    JHLiveRoomMode * selectLiveRoom;
    BYTimer *timer;
    float titleViewHeight;
    BOOL isSection0End;
    BOOL showDefaultImage;
    
}
//@property(nonatomic,strong) UITableView* homeTable;
@property (nonatomic, strong) NSMutableArray <OrderMode*>* orderModes;
@property (nonatomic, strong) NSMutableArray                  *bannerModes;
@property (nonatomic, strong) NSString                        *searchStatus;
@property (nonatomic, strong) UIDocumentInteractionController *document;
@property (nonatomic, strong) UIButton                        *scanBtn;
@property (nonatomic, strong) UIButton                        *orderOutBtn;
@property (nonatomic, strong) OrderMode                       *selectMode;
@property (nonatomic, strong) UICollectionView                *collectionView;
@property (nonatomic, strong) JCCollectionViewWaterfallLayout *layout;
@property (nonatomic, strong) NSMutableArray<JHShopWindowLayout*>* layouts;
@property (nonatomic, strong) NSArray<JHOrderCateMode*>* orderCateArray;
@property (nonatomic, strong) JHOrderListZhiFaHeaderView *zfHeaderView;
@property (nonatomic, assign) JHSellOrderStatus           requestStatus;
@property (nonatomic,strong) JHPickerView   *picker;

@end

@implementation JHOrderListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentIndex=0;
        self.requestStatus = JHSellOrderStatusAll;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self  initToolsBar];
    if (self.isSeller) {
        self.title = @"我卖出的";
        [self initRightButtonWithImageName:@"navi_icon_search" action:@selector(orderSearch:)];
        [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(44);
            make.right.equalTo(self.jhNavView).offset(-10);
        }];
        titleViewHeight=0;
        //创建打印单例 搜索附近打印机
        [JHPrinterManager sharedInstance];
        self.orderCateArray = [JHOrderCateMode getSellerOrderListCateArry];
    }
    else{
        self.title = @"我买到的";
        titleViewHeight=30;
        [self initTitleView];
        self.orderCateArray = [JHOrderCateMode getBuyerOrderListCateArry];
    }
    
    self.searchStatus=self.orderCateArray[_currentIndex].status;
    
    self.bannerModes=[NSMutableArray arrayWithCapacity:10];
    [self setHeaderView];
    [self.view addSubview:self.collectionView];
    
    [self showScanBtn];
    __weak typeof(self) weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:ORDERSTATUSCHANGENotifaction object:nil];
    self.collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    self.collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    self.collectionView.mj_footer.hidden=YES;
    [self.collectionView.mj_header beginRefreshing];
    
    
    [self updateCellTimeStatus];
    [self getData];

}
-(void)initTitleView{
    
    UIView * titleView=[[UIView alloc]init];
    titleView.backgroundColor=[CommHelp  toUIColorByStr:@"#fffbdc"];
    [self.view addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.offset(titleViewHeight);
        make.width.offset(ScreenW);
    }];
    
    UIImageView *logo=[[UIImageView alloc]init];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image=[UIImage imageNamed:@"order_gift_tip_logo"];
    [titleView addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).offset(20);
        make.centerY.equalTo(titleView);
        make.size.mas_equalTo(CGSizeMake(14, 13));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines =1;
    label.textAlignment = UIControlContentHorizontalAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
    label.text = @"评价分享拿好礼，快来评价互动吧。";
    label.font=[UIFont systemFontOfSize:13];
    [titleView addSubview:label];
    
    [ label  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logo.mas_right).offset(5);
        make.centerY.equalTo(logo);
    }];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_zfHeaderView) {
        [_zfHeaderView putAwayListView];
    }
}


//埋点：扩展创建页面（进入页面的参数）
- (NSMutableDictionary*)growingGetCreatePageParamDict
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:[super growingGetCreatePageParamDict]];
    [dic setValue:self.fromSource ? : @" " forKey:@"from"];
    return dic;
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
-(void)showScanBtn{
    
    [self.view addSubview:self.scanBtn];
    [self.view addSubview:self.orderOutBtn];
    if ([self.searchStatus isEqualToString:@"waitsellersend"]&&self.isSeller) {
        self.collectionView.height=ScreenH-UI.statusAndNavBarHeight-50-titleViewHeight-50;
        self.scanBtn.hidden=NO;
        self.orderOutBtn.hidden=NO;
    }
    else{
        self.collectionView.height=ScreenH-UI.statusAndNavBarHeight-50-titleViewHeight;
        self.scanBtn.hidden=YES;
        self.orderOutBtn.hidden=YES;
    }
}
- (void)setHeaderView {
    headerView = [[JHOrderListSegmentView alloc]initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight+titleViewHeight, ScreenW - 64.f , 50)];
    
    NSMutableArray *titles = [NSMutableArray array];
    for (int i=0; i<self.orderCateArray.count;i++) {
        [titles addObject:self.orderCateArray[i].title];
    }
    [headerView setTitles:titles];
    
    @weakify(self);
    headerView.selectedItemHelper = ^(NSInteger index) {
        @strongify(self);
        self -> isSection0End=NO;
        self.searchStatus=self.orderCateArray[index].status;
        self.orderModes=[NSMutableArray array];
        self.layouts=[NSMutableArray array];
        [self.collectionView reloadData];
        [self.collectionView.mj_header beginRefreshing];
        if ([self.searchStatus isEqualToString:@"waitsellersend"]&&self.isSeller) {
            self.collectionView.height=ScreenH-UI.statusAndNavBarHeight-50-(self -> titleViewHeight)-50;
              self.scanBtn.hidden=NO;
              self.orderOutBtn.hidden=NO;
        }
        else {
            self.collectionView.height=ScreenH-UI.statusAndNavBarHeight-50-(self -> titleViewHeight);
            self.scanBtn.hidden=YES;
            self.orderOutBtn.hidden=YES;
        }
    };
    
    [self.view addSubview:headerView];
    
    [headerView changeItemToTargetIndex:self.currentIndex];
    
    
    _zfHeaderView = [[JHOrderListZhiFaHeaderView alloc] initWithFrame:CGRectMake(ScreenW - 101, 0, 101, 50)];
    [_zfHeaderView jh_setGradientBackgroundWithColors:@[HEXCOLORA(0xF7F7F7,0.11), HEXCOLORA(0xF7F7F7,1), HEXCOLORA(0xF7F7F7,1)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [self.view addSubview:_zfHeaderView];
    [_zfHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(headerView);
        make.right.equalTo(self.view.mas_right);
        make.width.mas_equalTo(101.f);
    }];
    _zfHeaderView.didSelectedCallback = ^(NSInteger index, NSString * _Nonnull content) {
        @strongify(self);
        if ([content isEqualToString:@"全部"]) {
            self.requestStatus = JHSellOrderStatusAll;
        }
        if ([content isEqualToString:@"直发"]) {
            self.requestStatus = JHSellOrderStatusZhifa;
        }
        if ([content isEqualToString:@"非直发"]) {
            self.requestStatus = JHSellOrderStatusNoZhifa;
        }
//        [self loadNewData];
        [self.collectionView.mj_header beginRefreshing];
    };
}


- (void)setCurrentIndex:(int)currentIndex {
    _currentIndex = currentIndex;
}

#pragma mark ===============JHOrderListHeaderViewDelegate===============
- (void)segMentButtonPress:(UIButton *)button
{
    self.searchStatus=self.orderCateArray[button.tag].status;
    if ([self.searchStatus isEqualToString:@"waitsellersend"]&&self.isSeller) {
        self.collectionView.height=ScreenH-UI.statusAndNavBarHeight-50-titleViewHeight-50;
        self.scanBtn.hidden=NO;
    }
    else{
        self.collectionView.height=ScreenH-UI.statusAndNavBarHeight-50-titleViewHeight;
        self.scanBtn.hidden=YES;
    }
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)requestInfo {
    NSString *url;
    if (self.isSeller) {
        User *user = [UserInfoRequestManager sharedInstance].user;
        BOOL isAssistant = NO;
        if (user.isAssistant||
            user.blRole_customizeAssistant) {
            isAssistant = YES;
        }
        if (self.requestStatus == JHSellOrderStatusAll) {
            url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/sellerOrderList?searchStatus=%@&pageNo=%ld&pageSize=%ld&isAssistant=%ld&bussId=%ld"),self.searchStatus,PageNum,pagesize,isAssistant, (long)self.bussId];
        } else {
            url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/sellerOrderList?searchStatus=%@&pageNo=%ld&pageSize=%ld&isAssistant=%ld&bussId=%ld&isDirectDelivery=%ld"),self.searchStatus,PageNum,pagesize,isAssistant, (long)self.bussId, self.requestStatus];
        }
    }
    else{
        url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/buyerOrderList?searchStatus=%@&pageNo=%ld&pageSize=%ld"),self.searchStatus,PageNum,pagesize];
    }
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
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
    NSArray *arr = [OrderMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        [self.orderModes removeAllObjects];
        self.collectionView.contentOffset = CGPointMake(0, 0);
        self.orderModes = [NSMutableArray arrayWithCapacity:10];
    }
    //    else {
    //        [self.orderModes addObjectsFromArray:arr];
    //    }
    for (OrderMode *mode in arr) {
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
        if (self.isSeller) {
            self.collectionView.mj_footer.hidden=YES;
        }
        else{
            isSection0End=YES;
            _pageNumber=1;
            [self requestProductInfo];
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


- (JHPickerView *)picker {
    if (!_picker) {
        _picker = [[JHPickerView alloc] init];
        _picker.widthPickerComponent = 300;
        _picker.heightPicker = 240 + UI.bottomSafeAreaHeight;
        [_picker setDelegate:self];
    }
    return _picker;
}


- (void)getData {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/express/bathcomlist") Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSMutableArray *muArray = [NSMutableArray array];
        NSArray *arr = respondObject.data;
        for (NSDictionary *dic in arr) {
            [muArray addObject:dic[@"name"]];
        }
        self.picker.arrayData = muArray;

    } failureBlock:^(RequestModel * _Nullable respondObject) {
            
    }];
}

-(UIButton*)scanBtn{
    if (!_scanBtn) {
        _scanBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _scanBtn.frame=CGRectMake(0, ScreenH-50,ScreenW, 50);
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight+50+titleViewHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight-50-titleViewHeight)  collectionViewLayout:self.layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [CommHelp toUIColorByStr:@"f7f7f7"];
        [_collectionView registerClass:[JHBuyerOrderCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHBuyerOrderCollectionViewCell class])];
        [_collectionView registerClass:[JHSellerOrderCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHSellerOrderCollectionViewCell class])];
        
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
        if (self.isSeller) {
            JHSellerOrderCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHSellerOrderCollectionViewCell class]) forIndexPath:indexPath];
            cell.delegate=self;
            [cell setOrderMode:self.orderModes[indexPath.row]];
            
            return cell;
        }
        JHBuyerOrderCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHBuyerOrderCollectionViewCell class]) forIndexPath:indexPath];
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
        return CGSizeMake(ScreenW-10, self.orderModes[indexPath.row].height);
    }
    JHShopWindowLayout *layout = self.layouts[indexPath.item];
    return CGSizeMake((ScreenW-20)/2, layout.cellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0   ;
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
    return UIEdgeInsetsMake(0,5,0, 5);
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
        if ([[self.orderModes[indexPath.item]orderStatus]isEqualToString:@"waitack"]
            &&!self.isSeller) {
        
            JHOrderConfirmViewController * order=[[JHOrderConfirmViewController alloc]init];
            order.orderId=[self.orderModes[indexPath.item]orderId];
            [self.navigationController pushViewController:order animated:YES];
        }
        else{
            
            JHOrderDetailViewController * detail=[[JHOrderDetailViewController alloc]init];
            detail.orderId=[self.orderModes[indexPath.item]orderId];
            detail.isSeller=self.isSeller;
            detail.orderCategoryType=[self.orderModes[indexPath.item]orderCategoryType];
            [self.navigationController pushViewController:detail animated:YES];
            
        }
    }
    else{
        JHShopWindowLayout *layout = self.layouts[indexPath.item];
        JHGoodsInfoMode *goods = layout.goodsInfo;
        
        JHGoodsDetailViewController *detailVC = [[JHGoodsDetailViewController alloc] init];
        detailVC.goods_id = goods.goods_id;
        detailVC.entry_type = JHFromStoreFollowOrderListRecommend; ///订单列表推荐
        detailVC.entry_id = @"0"; //入口id传橱窗id
        detailVC.isFromShopWindow = NO;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

-(void)updateCellTimeStatus
{
    JH_WEAK(self)
    if (!timer) {
        timer=[[BYTimer alloc]init];
    }
    [timer startGCDTimerOnMainQueueWithInterval:1 Blcok:^{
        JH_STRONG(self)
        [self updateTime];
    }];
    
}
-(void)updateTime
{
    NSArray* cellArr = [self.collectionView visibleCells];
    for(id obj in cellArr)
    {
        if([obj isKindOfClass:[JHBuyerOrderCollectionViewCell class]])
        {
            JHBuyerOrderCollectionViewCell *cell=(JHBuyerOrderCollectionViewCell *)obj;
            if ([cell.orderMode.orderStatus isEqualToString:@"waitpay"]||[cell.orderMode.orderStatus isEqualToString:@"waitack"]){
                NSString * status=[cell.orderMode.orderStatus isEqualToString:@"waitpay"]?@"待付款 ":@"待付款 ";
                if ([CommHelp dateRemaining:cell.orderMode.payExpireTime]>0) {
                    cell.orderRemainTime=[status stringByAppendingString:OBJ_TO_STRING([CommHelp getHMSWithSecond:[CommHelp dateRemaining:cell.orderMode.payExpireTime]])];
                }
                else{
                    cell.orderRemainTime=@"订单已取消";
                }
            }
            else  if ([cell.orderMode.orderStatus isEqualToString:@"refunding"]&&cell.orderMode.refundButtonShow){
                NSString * status=cell.orderMode.workorderDesc ;
                if ([CommHelp dateRemaining:cell.orderMode.refundExpireTime]>0) {
                    cell.orderRemainTime=[NSString stringWithFormat:@"%@:%@",status,[CommHelp getHMSWithSecond:[CommHelp dateRemaining:cell.orderMode.refundExpireTime]]];
                }
                else{
                    cell.orderRemainTime=cell.orderMode.workorderDesc;
                }
            }
        }
        
        else if([obj isKindOfClass:[JHSellerOrderCollectionViewCell class]])
        {
//            JHSellerOrderCollectionViewCell *cell=(JHSellerOrderCollectionViewCell *)obj;
//            if ([cell.orderMode.orderStatus isEqualToString:@"waitpay"]||[cell.orderMode.orderStatus isEqualToString:@"waitack"]){
//                NSString * status=[cell.orderMode.orderStatus isEqualToString:@"waitpay"]?@"待付款 ":@"待付款 ";
//                if ([CommHelp dateRemaining:cell.orderMode.payExpireTime]>0) {
//                    cell.orderRemainTime=[status stringByAppendingString:OBJ_TO_STRING([CommHelp getHMSWithSecond:[CommHelp dateRemaining:cell.orderMode.payExpireTime]])];
//                }
//                else{
//                    cell.orderRemainTime=@"订单已取消";
//                }
//            }
        }
    }
}
-(void)buttonPress:(UIButton*)button withOrder:(OrderMode*)mode{
    
    self.selectMode=mode;
    switch (button.tag) {
        case JHOrderButtonTypeCommit:
        {
            JHOrderConfirmViewController * order=[[JHOrderConfirmViewController alloc]init];
            order.orderId=mode.orderId;
            [self.navigationController pushViewController:order animated:YES];
        }
            break;
        case JHOrderButtonTypePay:{
            JH_WEAK(self)
            [JHOrderViewModel  OrderPayCheckTest2WithOrderId:mode.orderId completion:^(RequestModel * _Nonnull respondObject, NSError * _Nonnull error) {
                JH_STRONG(self)
                [SVProgressHUD dismiss];
                if (!error ) {
                    JHOrderPayViewController * order =[[JHOrderPayViewController alloc]init];
                    order.orderId=mode.orderId;
                    order.directDelivery = order.directDelivery;
                    [self.navigationController pushViewController:order animated:YES];
                }
                else{
                    if (respondObject.code == 40005) {
                        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:error.localizedDescription cancleBtnTitle:@"我知道了"];
                        [[UIApplication sharedApplication].keyWindow addSubview:alert];
                    }
                    else {
                        [self.view makeToast:respondObject.message duration:1.0f position:CSToastPositionCenter];
                    }
                    
                    
                    //                    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:error.localizedDescription cancleBtnTitle:@"我知道了"];
                    //                    [[UIApplication sharedApplication].keyWindow addSubview:alert];
                }
            }];
            [SVProgressHUD show];
        }
            break;
        case JHOrderButtonTypeCancle:
            
            [self cancleOrder:mode];
            break;
        case JHOrderButtonTypeContact:
            if (self.isSeller) {
                [[JHQYChatManage shareInstance] showChatWithViewcontroller:self];
                
            }else {
                [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:self orderModel:mode];
            }
            
            break;
        case JHOrderButtonTypeLogistics: {
            if (mode.directDelivery) {
                JHRecycleLogisticsViewController *vc = [[JHRecycleLogisticsViewController alloc]init];
                vc.orderId = mode.orderId;
                if ([mode.orderStatus isEqualToString:@"refunding"]) { /// 退货
                    vc.type = 7;
                } else {
                    vc.type = 6;
                }
                vc.isBusinessZhiSend = YES;
                vc.isZhifaSeller     = self.isSeller;
                if ([mode.orderStatus isEqualToString:@"portalsent"] || [mode.orderStatus isEqualToString:@"待收货"]) {
                    vc.isZhifaOrderComplete = NO;
                } else {
                    vc.isZhifaOrderComplete = YES;
                }
                [self.navigationController pushViewController:vc animated:true];
            } else {
                JHExpressViewController * express=[[JHExpressViewController alloc]init];
                express.orderId = mode.orderId;
                [self.navigationController pushViewController:express animated:YES];
            }
        }
            
            break;
        case JHOrderButtonTypeReceive:
            
            [self sureOrder:mode];
            break;
            
        case JHOrderButtonTypeDetail:
        {
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/report.html?orderId=%@"), mode.orderId];
            [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
        }
            break;
        case JHOrderButtonTypeSend:
        {
            JHSendOutViewController *sendOut = [[JHSendOutViewController alloc]init];
            sendOut.orderId                     = mode.orderId;
            sendOut.directDelivery              = mode.directDelivery;
            
            JHOrderDetailMode *orderShowModel   = [[JHOrderDetailMode alloc] init];
            orderShowModel.shippingProvince     = mode.shippingProvince;
            orderShowModel.shippingCity         = mode.shippingCity;
            orderShowModel.shippingCounty       = mode.shippingCounty;
            orderShowModel.shippingDetail       = mode.shippingDetail;
            orderShowModel.shippingPhone        = mode.shippingPhone;
            orderShowModel.shippingReceiverName = mode.shippingReceiverName;
            orderShowModel.directDelivery       = mode.directDelivery;
            sendOut.orderShowModel              = orderShowModel;
            [self.navigationController pushViewController:sendOut animated:YES];
        }
            break;
            //评价
        case JHOrderButtonTypeComment:{
            JHSendCommentViewController *vc = [[JHSendCommentViewController alloc] init];
            MJWeakSelf
            vc.commentComplete = ^{
                mode.commentStatus = 1;
                [weakSelf.collectionView reloadData];
            };
            vc.imageUrl = mode.goodsUrl;
            vc.orderId = mode.orderId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            //已评价
        case JHOrderButtonTypeLookComment: {
            JHSendCommentViewController *vc = [[JHSendCommentViewController alloc] init];
            vc.orderId = mode.orderId;
            vc.imageUrl = mode.goodsImg;
            vc.isShow = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
            //绑卡
        case JHOrderButtonTypeBindCard: {
            [self toScanVcType:1 model:mode];
            
        }
            break;
            //退货
        case JHOrderButtonTypeReturnGood: {
            JHOrderReturnViewController *vc =[[JHOrderReturnViewController alloc]init];
            vc.refundExpireTime=self.selectMode.refundExpireTime;
            vc.orderId = self.selectMode.orderId;
            vc.directDelivery = self.selectMode.directDelivery;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHOrderButtonTypeAlterAddress: {
            
            AdressManagerViewController *vc = [[AdressManagerViewController alloc] init];
            vc.orderId=self.selectMode.orderId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHOrderButtonTypeReturnDetail: {
            
            JHWebViewController *webVC = [JHWebViewController new];
            webVC.urlString =ReturnDetailURL(mode.orderId, self.isSeller?1:0);
            [self.navigationController pushViewController:webVC animated:YES];
            
        }
            break;
        case JHOrderButtonTypeAppraiseIssue: {
            
            JHWebViewController *webVC = [JHWebViewController new];
            webVC.urlString =AppraiseIssueDetailURL(mode.orderId);
            [self.navigationController pushViewController:webVC animated:YES];
            
            
        }
            break;
        case JHOrderButtonTypeAddNote: {
            
            JHOrderNoteView * note=[[JHOrderNoteView alloc]init];
            note.orderMode=mode;
            [self.view addSubview:note];
            
        }
            break;
        case JHOrderButtonTypeApplyReturn: {
            
            [SVProgressHUD show];
            NSDictionary * dic = @{@"orderId":mode.orderId};
            @weakify(self);
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/getPartialWorkOrder") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
                [SVProgressHUD dismiss];
                @strongify(self);
                JHRefunfOrderModel *model = [JHRefunfOrderModel mj_objectWithKeyValues:respondObject.data];
                if (model.flag) {
                    JHTOAST(model.refundTag);
                }else{
                    JHOrderApplyReturnViewController * vc=[[JHOrderApplyReturnViewController alloc]init];
                    vc.orderMode=mode;
                    vc.orderId=mode.orderId;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } failureBlock:^(RequestModel *respondObject) {
                @strongify(self);
                [SVProgressHUD dismiss];
                JHOrderApplyReturnViewController * vc=[[JHOrderApplyReturnViewController alloc]init];
                vc.orderMode=mode;
                vc.orderId=mode.orderId;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            
        }
            break;
            
        case JHOrderButtonTypePrintCard: {
            [[JHPrinterManager sharedInstance] printOrderBarCode:mode.orderId andResult:^(BOOL success, NSString *desc) {
                NSLog(@"打印订单结果===%@",desc);
            }];
        }
            break;
            
        case JHOrderButtonTypeCompleteInfo: {
            JHWebViewController *webVC = [JHWebViewController new];
            webVC.urlString =CompleteOrderDetailURL(mode.orderId);
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
            
            //提醒发货
        case JHOrderButtonTyperRemindSend: {
            //           JHOrderReturnViewController *vc =[[JHOrderReturnViewController alloc]init];
            //                      vc.orderMode=self.selectMode;
            //                      vc.orderId = self.selectMode.orderId;
            //                      [self.navigationController pushViewController:vc animated:YES];
            [self remindOrderSend:mode];
        }
            break;
            //转售
        case JHOrderButtonTyperStoneResell: {
            JHUnionSignStatus status = [UserInfoRequestManager sharedInstance].unionSignStatus;
            if (status==JHUnionSignStatusComplete || status==JHUnionSignStatusReviewing) {
                [JHRouterManager pushPersonReSellPublishWithSourceOrderId:mode.orderId sourceOrderCode:mode.orderCode flag:1 editSuccessBlock:^{}];
            }
            else
            {
                [JHUnionSignSalePopView showResellSignView].activeBlock = ^(id obj) {
                    [JHUnionSignView signMethod];
                };
            }
        }
            break;
            
        case JHOrderButtonTyperDelete:{
            
            CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"删除后此订单将不再展示，请确认操作？" cancleBtnTitle:@"取消" sureBtnTitle:@"删除"];
            [self.view addSubview:alert];
            @weakify(self);
            alert.handle = ^{
                @strongify(self);
                [self deleteOrder:self.selectMode];
            };
        }
            break;
            
        case JHOrderButtonTyperApplyCustomize:{
            [JHRootController EnterLiveRoom:self.selectMode.channelLocalId fromString:@"" isStoneDetail:NO isApplyConnectMic:YES];
        }
            break;
            
          
        default:
            break;
    }
}
-(void)showAlert{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"退货方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"已拒收快递" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JH_WEAK(self)
        CommAlertView*  returnAlert=[[CommAlertView alloc]initWithTitle:@"是否确认您已拒收快递?" andDesc:@"" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
        [self.view addSubview:returnAlert];
        returnAlert.handle = ^{
            JH_STRONG(self)
            [self refuse:self.selectMode];
        };
    }] ];
    [alert addAction:[UIAlertAction actionWithTitle:@"已收货，发快递退回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JHOrderReturnViewController *vc =[[JHOrderReturnViewController alloc]init];
        vc.refundExpireTime=self.selectMode.refundExpireTime;
        vc.orderId = self.selectMode.orderId;
        vc.directDelivery = self.selectMode.directDelivery;
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
        [self loadNewData];
        
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
        [self loadNewData];
        
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
        [self loadNewData];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    [SVProgressHUD show];
}
-(void)deleteOrder:(OrderMode*)mode{

    [HttpRequestTool putWithURL:[FILE_BASE_STRING(@"/order/auth/buyer/delete/") stringByAppendingString:OBJ_TO_STRING(mode.orderId)] Parameters:@{@"orderId":mode.orderId} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self loadNewData];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
}
-(void)orderOut:(UIButton*)button{
    JH_WEAK(self)
    OrderDateChooseView *view=[[OrderDateChooseView alloc]initWithFrame:self.view.frame];
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


- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    if (![pickerSingle isKindOfClass:[JHPickerView class]]) {
        return;
    }
    JH_WEAK(self)
    JHQRViewController *vc = [[JHQRViewController alloc] init];
    vc.titleString = @"扫描运单号";
    vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController *obj) {
        JH_STRONG(self)
        [obj.navigationController popViewControllerAnimated:YES];
        
        JHSellerSendOrderViewController *vc = [JHSellerSendOrderViewController new];
        vc.expressNumber = scanString;
        vc.expressName = selectedTitle;
        [self.navigationController pushViewController:vc animated:NO];
    };
    [self.navigationController pushViewController:vc animated:YES];

}


/**
 @param type  0 扫码发货 1 绑定宝卡
 */
- (void)toScanVcType:(NSInteger)type model:(OrderMode *)model {
    JHQRViewController *vc = [[JHQRViewController alloc] init];
    JH_WEAK(self)
    if (type == 0) {
        [self.picker show];
        return;
    }else if (type == 1) {
        vc.titleString = @"扫描宝卡";
        
        vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController *obj) {
            JH_STRONG(self)
            [self relBarCode:scanString obj:obj model:model];
        };
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)relBarCode:(NSString *)cardId obj:(JHQRViewController *)vc model:(OrderMode *)model{
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
-(void)remindOrderSend:(OrderMode*)mode{
    
    [JHOrderViewModel remindOrderSend:mode.orderId completion:^(RequestModel *respondObject, NSError *error) {
        if ((!error)) {
            [self.view makeToast:@"已提醒卖家发货" duration:1 position:CSToastPositionCenter];
        }
        else{
            [self.view makeToast:respondObject.message duration:1 position:CSToastPositionCenter];
        }
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [timer stopGCDTimer];
    NSLog(@"%@*************被释放",[self class])
}
@end



