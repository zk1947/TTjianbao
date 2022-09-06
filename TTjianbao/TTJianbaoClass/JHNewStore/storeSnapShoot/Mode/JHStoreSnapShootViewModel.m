//
//  JHStoreSnapShootViewModel.m
//  TTjianbao
//
//  Created by jiangchao on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreSnapShootViewModel.h"
@interface JHStoreSnapShootViewModel()

@property (nonatomic, strong) JHStoreSnapShootDetailModel *dataModel;

@property (nonatomic, assign) NSUInteger focusStatus;

@end

@implementation JHStoreSnapShootViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init {
    self = [super init];
    if (self) {
//        [self.refreshTableView sendNext:nil];
        // 底部工具条
        [self bindFunction];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}

#pragma mark - 事件
/// 专场跳转
- (void)pushSpecialShow {
    NSLog(@"专场");
    NSDictionary *par = @{};
    NSDictionary *dic = @{@"type" : @"SpecialShow",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
/// 确认订单跳转
- (void)pushOrder {
    NSLog(@"确认订单");
    
    if (self.functionViewModel.purchaseStatus == PurchaseStateCantBuy) { return; }
    
    if (self.dataModel.sellStock <= 0) {
        self.toastMsg = @"来晚了哦~";
        self.functionViewModel.purchaseStatus = PurchaseStateSoldout;
        return;
    }
    if (self.productId == nil) { return; }
    NSDictionary *par = @{@"productId" : self.productId};
    NSDictionary *dic = @{@"type" : @"Order",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
/// 支付跳转
- (void)pushPayment {
    NSLog(@"支付订单");
    NSDictionary *par = @{};
    NSDictionary *dic = @{@"type" : @"Payment",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
/// 店铺跳转
- (void)pushShop {
    NSLog(@"店铺");
    NSString *shopId = self.dataModel.shopInfo.shopId;
    if (shopId == nil || shopId.length <= 0) { return; }
    
    NSDictionary *par = @{@"shopId" : shopId};
    NSDictionary *dic = @{@"type" : @"Shop",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
/// 客服跳转
- (void)pushSerice {
    NSLog(@"客服");
    if (self.dataModel.existShow == true) { // 专场客服
        
    }else { // 普通客服
        
    }
    
    NSDictionary *par = @{};
    NSDictionary *dic = @{@"type" : @"Serice",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
/// 用户教育跳转
- (void)pushEducation {
    NSLog(@"用户教育");
    NSString *url = self.dataModel.userEducationUrl;
    if (url == nil) { return; }
    NSDictionary *par = @{@"url" : url};
    NSDictionary *dic = @{@"type" : @"Education",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
/// 优惠券
- (void)pushCoupon {
    NSLog(@"优惠券");
    NSString *sellerId = self.dataModel.shopInfo.sellerId;
    if (sellerId == nil) { return; }
    NSDictionary *par = @{@"shopId" : sellerId};
    NSDictionary *dic = @{@"type" : @"Coupon",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
/// 跳转收藏
- (void)pushCollectList {
    NSLog(@"收藏");
    NSDictionary *par = @{};
    NSDictionary *dic = @{@"type" : @"Collect",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
/// 新人福利
- (void)pushNewUserActivities {
    NSLog(@"新人福利");
    NSString *url = self.dataModel.specialShowInfo.showUrl;
    if (url == nil) { return; }
    NSDictionary *par = @{@"url" : url};
    NSDictionary *dic = @{@"type" : @"NewUserActivities",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
/// 登录
- (void)pushLogin {
    NSLog(@"新人福利");
    NSDictionary *par = @{};
    NSDictionary *dic = @{@"type" : @"Login",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
/// 设置开售提醒
- (void)setSalesRemind {
    @weakify(self)
    NSString *productId = self.productId;
    if (productId == nil) { return; }
    [JHStoreDetailBusiness salesRemindWithProductId:productId successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        self.functionViewModel.purchaseStatus = PurchaseStateSalesReminded;
        self.toastMsg = @"开售提醒设置成功";
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}
- (BOOL)isLogin {
    if (![JHRootController isLogin]) {
        [self pushLogin];
        return false;
    }
    return true;
}
/// 点击购买按钮
- (void)didClickBuy {
    
    switch (self.functionViewModel.purchaseStatus) {
        case PurchaseStateBuy: //购买
            [self pushOrder];
            break;
        case PurchaseStateSalesRemind:
            [self setSalesRemind];
            break;
        case PurchaseStateSalesReminded:
            break;
        case PurchaseStateOff:
            break;
        case PurchaseStateSoldout:
            break;
        default:
            break;
    }
}
/// 点击收藏
- (void)didClickCollect {
    NSLog(@"收藏");
    if (!self.isLogin) { return; }
    @weakify(self)
    if (self.functionViewModel.collectState == 0) {
        [JHStoreDetailBusiness followProduct:self.productId successBlock:^(RequestModel * _Nullable respondObject) {
            @strongify(self)
            self.toastMsg = @"收藏成功~";
            self.functionViewModel.collectState = 1;
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            
        }];
    }else{
        [JHStoreDetailBusiness followCancelProduct:self.productId successBlock:^(RequestModel * _Nullable respondObject) {
            @strongify(self)
            self.toastMsg = @"取消收藏成功~";
            self.functionViewModel.collectState = 0;
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            
        }];
    }
}
/// 点击关注
- (void)didClickShopFocus {
    NSLog(@"关注");
    if (!self.isLogin) { return; }
    NSString *shopId = self.dataModel.shopInfo.shopId;
    if (shopId == nil) { return; }
    @weakify(self)
    if (self.focusStatus == 0) {
        [JHStoreDetailBusiness shopFollowWithShopId:shopId type:@"1" successBlock:^(RequestModel * _Nullable respondObject) {
            @strongify(self)
            self.focusStatus = 1;
            self.toastMsg = @"关注成功~";
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            
        }];
    }else {
        [JHStoreDetailBusiness shopFollowWithShopId:shopId type:@"0" successBlock:^(RequestModel * _Nullable respondObject) {
            @strongify(self)
            self.focusStatus = 0;
            self.toastMsg = @"取消关注成功~";
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            
        }];
    }
}

#pragma mark - 数据
// 获取商品详情数据
- (void)getDetailInfo {
    if (self.productId == nil) { return; }
    
    [JHStoreDetailBusiness getStoreSnapShootWithOrderId:self.productId successBlock:^(JHStoreSnapShootDetailModel * _Nullable respondObject) {
        [self.endRefreshing sendNext:nil];
        self.dataModel = respondObject;
        [self setupData];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self.endRefreshing sendNext:nil];
    }];
}

- (void)setupData {
    if (self.dataModel == nil) { return; }
    [self.cellViewModelList removeAllObjects];
    // 标题、价格、标签区
    JHStoreDetailSectionCellViewModel *section0 = [[JHStoreDetailSectionCellViewModel alloc] init];
    // 优惠券 区
    JHStoreDetailSectionCellViewModel *section1 = [[JHStoreDetailSectionCellViewModel alloc] init];
//    // 用户教育 区
//    JHStoreDetailSectionCellViewModel *section2 = [[JHStoreDetailSectionCellViewModel alloc] init];
    // 店铺 区
    JHStoreDetailSectionCellViewModel *section3 = [[JHStoreDetailSectionCellViewModel alloc] init];
    // 规格参数、 商品介绍、商品大图、区
    JHStoreDetailSectionCellViewModel *section4 = [[JHStoreDetailSectionCellViewModel alloc] init];
    //
    JHStoreDetailSectionCellViewModel *section5 = [[JHStoreDetailSectionCellViewModel alloc] init];
    //
    JHStoreDetailSectionCellViewModel *section6 = [[JHStoreDetailSectionCellViewModel alloc] init];
    
    // 分享信息
    [self setupShare];
    
    // 表头、视频+图片
    [self setupHeaderData];
    
    // 商品售卖状态描述
    [self setupSellStatusDesc];
    
    // 商品售卖状态
    [self setupSellStatus];
    
    // 收藏状态
    [self setupCollectStatus];
    
    // 价格
    [self setupPriceWithSection:section0];
    // 标题
    [self setupTitleWithSection:section0];
    // 标签
    [self setupTagWithSection:section0];
    // 专场
    [self setupSpecialWithSection:section0];
    
    // 优惠券
    BOOL hasCoupon = [self setupCouponWithSection:section1];
    // 用户教育
  //  BOOL hasEducation = [self setupEducationWithSection:section2];
    // 店铺title
    BOOL hasShopTitle = [self setupShopTitleWithSection:section5];
    // 店铺
    BOOL hasShop = [self setupShopWithSection:section5];
    // 规格
    BOOL hasSpec = [self setupSpecWithSection:section4];
    // 商品描述
    BOOL hasGoodDes = [self setupGoodsDesWithSection:section4];
    // 商品大图
    BOOL hasGoodImage = [self setupGoodsImageWithSection:section4];
    // 保障
   // BOOL hasSecurity = [self setupSecurityWithSection:section4];

    self.specSectionIndex = 0;
    // 添加分区
    [self.cellViewModelList appendObject:section0];
    if (hasCoupon) {
        [self.cellViewModelList appendObject:section1];
        self.specSectionIndex += 1;
    }
//    if (hasEducation) {
//        [self.cellViewModelList appendObject:section2];
//    self.specSectionIndex += 1;
//    }
    if (hasShop || hasShopTitle) {
        [self.cellViewModelList appendObject:section5];
//        self.specSectionIndex += 1;
    }
    if (hasSpec || hasGoodDes || hasGoodImage ) {
        [self.cellViewModelList appendObject:section4];
        self.specSectionIndex += 1;
    }

    // 刷新列表
    [self.refreshTableView sendNext:nil];
}
#pragma mark - 默认站位数据
- (void)setupPlaceholderData {
    self.dataModel = [[JHStoreSnapShootDetailModel alloc]init];
    [self.cellViewModelList removeAllObjects];
    
    self.dataModel.mainImageUrl = @[@""];
    
    [self setupData];
}
#pragma mark - 表头、视频+图片
- (void)setupHeaderData {
    self.videoUrl = self.dataModel.videoUrl;
    
    [self.headerViewModel setupDataWithVideoUrl:self.dataModel.videoCoverUrl
                                      imageList:self.dataModel.mainImageMiddleUrl
                                     mediumUrls:self.dataModel.mainImageUrl];
    
}
#pragma mark - 价格区
- (void)setupPriceWithSection : (JHStoreDetailSectionCellViewModel*)section {
    
    JHStoreSnapShootPriceViewModel *priceModel = [[JHStoreSnapShootPriceViewModel alloc] init];
    priceModel.cellType = PriceCell;
    priceModel.height = 50;
    [priceModel setupDataWithSalePrice:self.dataModel.price price:nil isAuction:NO discount:nil];
    [section.cellViewModelList appendObject:priceModel];
    
}
#pragma mark - 标题区
- (void)setupTitleWithSection : (JHStoreDetailSectionCellViewModel*)section {
    NSString *title = self.dataModel.productName;
    
    BOOL isOrphan = [self.dataModel.uniqueStatus isEqualToString:@"1"];
    
    JHStoreDetailTitleViewModel *titleModel = [[JHStoreDetailTitleViewModel alloc]
                                          initWithText:title isOrphan:isOrphan];
    [section.cellViewModelList appendObject:titleModel];
}
#pragma mark - 标签区
- (void)setupTagWithSection : (JHStoreDetailSectionCellViewModel*)section {
    JHStoreDetailTagViewModel *tagModel = [[JHStoreDetailTagViewModel alloc] init];
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    if (self.dataModel.productTagList == nil || self.dataModel.productTagList.count <= 0) { return; }
    for (NSString *tag in self.dataModel.productTagList) {
        JHStoreDetailTagItemViewModel *tagItem = [[JHStoreDetailTagItemViewModel alloc] init];
        tagItem.titleText = tag;
        [list appendObject:tagItem];
    }
    tagModel.itemList = list;
    
    [section.cellViewModelList appendObject:tagModel];
}
#pragma mark - 专场区
- (void)setupSpecialWithSection : (JHStoreDetailSectionCellViewModel*)section {
    if (self.dataModel.existShow == false) { return; }
    if (self.dataModel.specialShowInfo.showName == nil) { return; }
    JHStoreDetailSpecialViewModel *special = [[JHStoreDetailSpecialViewModel alloc] init];
    special.titleText = self.dataModel.specialShowInfo.showName;
    
    [section.cellViewModelList appendObject:special];
    
    @weakify(self)
    [special.pushvc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushSpecialShow];
    }];
}
#pragma mark - 优惠券区
- (BOOL)setupCouponWithSection : (JHStoreDetailSectionCellViewModel*)section {
    if (self.dataModel.couponList == nil || self.dataModel.couponList.count <= 0 ) { return false; }
    JHStoreDetailCouponViewModel *coupon = [[JHStoreDetailCouponViewModel alloc] init];
    for (NSString *str in self.dataModel.couponList) {
        JHStoreDetailCouponItemViewModel *item = [[JHStoreDetailCouponItemViewModel alloc] init];
        item.titleText = str;
        [coupon.itemList appendObject:item];
    }
    @weakify(self)
    [coupon.pushvc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushCoupon];
    }];
    
    [section.cellViewModelList appendObject:coupon];
    
    return true;
}
#pragma mark - 用户教育区
- (BOOL)setupEducationWithSection : (JHStoreDetailSectionCellViewModel*)section {
    JHStoreDetailEducationViewModel *education = [[JHStoreDetailEducationViewModel alloc] init];
    [section.cellViewModelList appendObject:education];
    
    @weakify(self)
    [education.pushvc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushEducation];
    }];
    
    return true;
}
#pragma mark - 店铺title区
- (BOOL)setupShopTitleWithSection : (JHStoreDetailSectionCellViewModel*)section {
    if (self.dataModel.shopInfo == nil) { return false; }
    ProductShopInfo *shopInfo = self.dataModel.shopInfo;
    JHStoreDetailShopTitleViewModel *shopTitle = [[JHStoreDetailShopTitleViewModel alloc] init];
    
    shopTitle.iconUrl    = shopInfo.shopLogoImg;
    shopTitle.titleText  = shopInfo.shopName;
    shopTitle.praiseText = shopInfo.orderGrades;
    shopTitle.sellerType = shopInfo.sellerType;
    
    self.focusStatus = shopInfo.followStatus;
    RAC(shopTitle, focusStatus) = RACObserve(self, focusStatus);
    
    [section.cellViewModelList appendObject:shopTitle];
    
    @weakify(self)
    RAC(shopTitle, fansText) = RACObserve(shopInfo, followNum);
    [shopTitle.pushvc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushShop];
    }];
    [shopTitle.focusAction subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self didClickShopFocus];
    }];
    
    return true;
}
#pragma mark - 店铺区
- (BOOL)setupShopWithSection : (JHStoreDetailSectionCellViewModel*)section {
    if (self.dataModel.shopInfo == nil) { return false; }
    ProductShopInfo *shopInfo = self.dataModel.shopInfo;
    if (shopInfo.shopProductList == nil || shopInfo.shopProductList.count <= 0) { return false; }
    
    JHStoreDetailShopViewModel *shop = [[JHStoreDetailShopViewModel alloc] init];
    
    for (ShopProductInfo *info in shopInfo.shopProductList) {
        JHStoreDetailShopItemViewModel *shopItem = [[JHStoreDetailShopItemViewModel alloc] init];
        shopItem.iconUrl = info.coverImage.url;
        shopItem.titleText = info.productName;
        if (info.showPrice != nil && info.showPrice.length > 0) {
            [shopItem setupPrice:info.showPrice];
        }else {
            [shopItem setupPrice:info.price];
        }
        [shop.itemList appendObject:shopItem];
    }
    [section.cellViewModelList appendObject:shop];
    
    @weakify(self)
    [shop.pushvc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushShop];
    }];
    
    return true;
}
#pragma mark - 规格区
- (BOOL)setupSpecWithSection : (JHStoreDetailSectionCellViewModel*)section {
    
    if (self.dataModel.productAttrList == nil || self.dataModel.productAttrList.count <= 0) { return false; }
    
    JHStoreDetailSectionTitleViewModel *specTitle = [[JHStoreDetailSectionTitleViewModel alloc] init];
    specTitle.titleText = @"规格参数";
    [section.cellViewModelList appendObject:specTitle];
    
    for (ProductSpecInfo *spec in self.dataModel.productAttrList) {
        JHStoreDetailSpecViewModel *specModel = [[JHStoreDetailSpecViewModel alloc] init];
        specModel.titleText = spec.attrName;
        specModel.detailText = spec.attrValue;
        [section.cellViewModelList appendObject:specModel];
    }
    return true;
}
#pragma mark - 商品介绍区
- (BOOL)setupGoodsDesWithSection : (JHStoreDetailSectionCellViewModel*)section {
    
    if (self.dataModel.productDesc == nil || self.dataModel.productDesc.length <= 0) { return false; }
    
    JHStoreDetailSectionTitleViewModel *goodsTitle = [[JHStoreDetailSectionTitleViewModel alloc] init];
    goodsTitle.titleText = @"商品特征";
    
    JHStoreDetailGoodsDesViewModel *goodsDes = [[JHStoreDetailGoodsDesViewModel alloc] init];
    goodsDes.titleText = self.dataModel.productDesc;
    
    [section.cellViewModelList appendObject:goodsTitle];
    [section.cellViewModelList appendObject:goodsDes];
    
    return true;
}
#pragma mark - 商品图片区
- (BOOL)setupGoodsImageWithSection : (JHStoreDetailSectionCellViewModel*)section {
    
    if (self.dataModel.detailImages == nil || self.dataModel.detailImages.count <= 0) { return false; }
    
    JHStoreDetailSectionTitleViewModel *imageTitle = [[JHStoreDetailSectionTitleViewModel alloc] init];
    imageTitle.titleText = @"商品详情";
    
    [section.cellViewModelList appendObject:imageTitle];
    
    NSArray *imageInfos = self.dataModel.detailImages;
    
    NSMutableArray *imageUrls = [NSMutableArray new];
    NSMutableArray *mediumImageUrls = [NSMutableArray new];
    for (ProductImageInfo *imageInfo in imageInfos) {
        [imageUrls appendObject:imageInfo.middleUrl];
        [mediumImageUrls appendObject:imageInfo.url];
    }
    
    self.goodsThumbsUrls = imageUrls;

    self.goodsMediumUrls = mediumImageUrls;
    self.goodsLargeUrls = mediumImageUrls;
    
    NSInteger index = 0;
    for (ProductImageInfo *imageInfo in self.dataModel.detailImages) {
        JHStoreDetailImageViewModel *image = [[JHStoreDetailImageViewModel alloc] init];
        image.imageUrl = imageInfo.middleUrl;
        image.index = index;
        
        @weakify(self)
        [image.reloadCellSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            if (image.sectionIndex != 0) {
                NSString *section = [NSString stringWithFormat:@"%ld", image.sectionIndex];
                NSString *row = [NSString stringWithFormat:@"%ld", image.rowIndex];
                [self.refreshCell sendNext:RACTuplePack(section, row)];
            }
        }];
        
        [section.cellViewModelList appendObject:image];
        index += 1;
    }
    
    return true;
}
#pragma mark - 保障区
- (BOOL)setupSecurityWithSection : (JHStoreDetailSectionCellViewModel*)section {
    
    JHStoreDetailSecurityViewModel *security = [[JHStoreDetailSecurityViewModel alloc] init];
    [section.cellViewModelList appendObject:security];
    [security.pushvc subscribeNext:^(id  _Nullable x) {
        [self pushEducation];
    }];
    return true;
}
#pragma mark - 分享信息
- (void)setupShare {
    if (self.dataModel.shareInfo == nil) { return; }
    self.shareInfo = [JHShareInfo new];
    self.shareInfo.title = self.dataModel.shareInfo.title;
    self.shareInfo.desc = self.dataModel.shareInfo.desc;
    self.shareInfo.url = self.dataModel.shareInfo.url;
    self.shareInfo.img = self.dataModel.shareInfo.img;
    self.shareInfo.shareType = ShareObjectTypeStoreGoodsDetail;
}
#pragma mark - 商品售卖状态描述
- (void)setupSellStatusDesc {
    if (self.dataModel.productSellStatusDesc == nil || self.dataModel.productSellStatusDesc.length <= 0) { return; }
    self.productSellStatusDesc = self.dataModel.productSellStatusDesc;

}
#pragma mark - 商品售卖状态
- (void)setupSellStatus {
    NSInteger status = [self.dataModel.productSellStatus integerValue];
    PurchaseState purchaseState = PurchaseStateBuy;
    switch (status) {
        case 0:
            // 可售库存为0且存在待支付订单 不可购买
            if (self.dataModel.productSellStatusDesc != nil &&
                self.dataModel.sellStock <= 0) {
                purchaseState = PurchaseStateCantBuy;
            }else{
                purchaseState = PurchaseStateBuy;
            }
            break;
        case 1:
            purchaseState = PurchaseStateOff;
            break;
        case 2:
            purchaseState = PurchaseStateSoldout;
            break;
        case 3:
            purchaseState = PurchaseStateSalesRemind;
            break;
        case 4:
            purchaseState = PurchaseStateSalesReminded;
            break;
        default:
            break;
    }
    self.functionViewModel.purchaseStatus = purchaseState;
}
#pragma mark - 收藏状态
- (void)setupCollectStatus {
    self.functionViewModel.collectState = self.dataModel.followStatus ? 1 : 0;
}
#pragma mark - 工具条
- (void)bindFunction {
    @weakify(self)
    [self.functionViewModel.buyAction subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self didClickBuy];
    }];
    [self.functionViewModel.shopAction subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushShop];
    }];
    [self.functionViewModel.serviceAction subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushSerice];
    }];
    [self.functionViewModel.collectAction subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self didClickCollect];
    }];
}

#pragma mark - Lazy
- (void)setProductId:(NSString *)productId {
    _productId = productId;
    [self setupPlaceholderData];
   // [self setupData1];
}
- (NSMutableArray<JHStoreDetailSectionCellViewModel *> *)cellViewModelList {
    if (!_cellViewModelList) {
        _cellViewModelList = [NSMutableArray array];
    }
    return _cellViewModelList;
}
- (JHStoreDetailHeaderViewModel *)headerViewModel {
    if (!_headerViewModel) {
        _headerViewModel = [[JHStoreDetailHeaderViewModel alloc] init];
    }
    return _headerViewModel;
}
- (JHStoreDetailFunctionViewModel *)functionViewModel {
    if (!_functionViewModel) {
        _functionViewModel = [[JHStoreDetailFunctionViewModel alloc] init];
    }
    return _functionViewModel;
}
- (RACReplaySubject *)refreshTableView {
    if (!_refreshTableView) {
        _refreshTableView = [RACReplaySubject subject];
    }
    return _refreshTableView;
}
- (RACReplaySubject<RACTuple *> *)refreshCell {
    if (!_refreshCell) {
        _refreshCell = [RACReplaySubject subject];
    }
    return _refreshCell;
}
- (RACSubject<NSDictionary *> *)pushvc {
    if (!_pushvc) {
        _pushvc = [RACSubject subject];
    }
    return _pushvc;
}
- (RACSubject *)endRefreshing {
    if (!_endRefreshing) {
        _endRefreshing = [RACSubject subject];
    }
    return _endRefreshing;
}
@end
