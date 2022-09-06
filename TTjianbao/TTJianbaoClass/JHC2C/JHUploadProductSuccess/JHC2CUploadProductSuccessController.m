//
//  JHC2CUploadProductSuccessController.m
//  TTjianbao
//
//  Created by jiangchao on 2021/6/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CUploadProductSuccessController.h"
#import "JHContactAlertView.h"
#import "JHUploadSuccessHeaderView.h"
#import "JHQYChatManage.h"
#import "JHBaseOperationView.h"
#import "JHOrderViewModel.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "JHShopWindowLayout.h"
#import "JHShopWindowCollectionCell.h"
#import "JHGoodsDetailViewController.h"
#import "JHRecommendHeader.h"
#import "JHStoreApiManager.h"
#import "JHC2CUploadSuccessBusiness.h"
#import "JHC2CGoodsListModel.h"
#import "JHC2CGoodsCollectionViewCell.h"
#import "JHC2CProductDetailController.h"
#import "JHAuthorize.h"
static NSString * const reuseHeaderId = @"headerId";
static NSString * const reuseFooterId = @"footerId";
static NSString * const reuseCellId = @"cellId";


@interface JHC2CUploadProductSuccessController  ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    JHUploadSuccessHeaderView * orderView;
    NSInteger _pageNumber;
    CGFloat headerHeight;
}
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) JCCollectionViewWaterfallLayout *layout;
@property(nonatomic,strong) NSMutableArray<JHC2CProductBeanListModel*>* layouts;
@end

@implementation JHC2CUploadProductSuccessController

- (void)viewDidLoad {
    
    [super viewDidLoad];
     self.view.backgroundColor=[CommHelp toUIColorByStr:@"#f7f7f7"];
     headerHeight = 250;
    
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:self.jhNavView];
    // self.title = @"宝贝发布成功啦!";
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
            make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
            make.left.right.equalTo(self.view);
            
        }];
    [self  initContentView];
    __weak typeof(self) weakSelf = self;

    self.collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
     self.collectionView.mj_footer.hidden=YES;
    [self loadNewData];
    [JHTracking trackEvent:@"appPageView" property:@{@"page_name":@"集市发布完成页"}];
    
    [self addTitleView];
    
    [JHAuthorize clickTriggerPushAuthorizetion:JHAuthorizeClickTypeGoodsUpdateSuccess];
}
-(void)addTitleView{
    
    UIView *view = [UIView new];
    [self.jhNavView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.jhLeftButton);
        make.centerX.equalTo(self.jhNavView);
    }];
    
    UIImageView *icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c2c_publish_success_icon"]];
    icon.backgroundColor=[UIColor clearColor];
    [view addSubview:icon];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(0);
        make.centerY.equalTo(view);
        
    }];
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"宝贝发布成功啦!";
    title.font=[UIFont fontWithName:kFontMedium size:20];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=kColor333;
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentLeft;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [view addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(5);
        make.right.equalTo(view).offset(0);
        make.centerY.equalTo(view);
    }];
    
    
}
-(void)loadNewData{
    
    _pageNumber=1;
    [self requestProductInfo];
}
-(void)loadMoreData{
    
    _pageNumber++;
    [self requestProductInfo];
   
}
-(void)backActionButton:(UIButton *)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)initContentView{
    
    orderView=[[JHUploadSuccessHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, headerHeight)];
    [self.collectionView addSubview:orderView];
    orderView.canAuth = self.canAuth;
        JH_WEAK(self)
        orderView.shareHandle = ^(id object, id sender) {
            JH_STRONG(self)
            JHC2CPublishSuccessShareInfo * mode=(JHC2CPublishSuccessShareInfo*)object;
            JHShareInfo* info = [JHShareInfo new];
            info.title = mode.title;
            info.desc = mode.desc;
            info.img = mode.img;
           // info.shareType = ShareObjectTypeAgentPay;
           // info.pageFrom = JHPageFromTypeUnKnown;
            info.url = mode.url;
//            [JHBaseOperationAction toShare:JHOperationTypeWechatSession operationShareInfo:info object_flag:nil];//TODO:Umeng share
            
            [JHBaseOperationView creatShareOperationView:info object_flag:nil];
            
        };
        
        orderView.viewHeightChangeBlock = ^{
            JH_STRONG(self)
            [self->orderView layoutIfNeeded];
            self-> headerHeight=self->orderView.contentScroll.frame.size.height;
            self->orderView.height=self->headerHeight;
            [self.collectionView reloadData];
        };
    
    [orderView setModel:self.model];
}
    
- (void)requestProductInfo{
    @weakify(self);
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSDictionary *dic = @{@"pageNo" : @(_pageNumber),
                          @"pageSize" : @10,
                          @"imageType" : @"s,m,b,o",
                          @"productType" : self.productType?:@"0",
                          @"customerId" : user.customerId ?: @""   //4.0.2 新增
    };
    [JHC2CUploadSuccessBusiness getProdutListRecommend:dic completion:^(RequestModel *respondObject, NSError *error) {
        @strongify(self);
        [self endRefresh];
        if (!error) {
            [self handleProudctWithArr:respondObject.data[@"productList"]];
        }
    }];
}
- (void)handleProudctWithArr:(NSArray *)array {
    
    NSArray *arr = [JHC2CProductBeanListModel mj_objectArrayWithKeyValuesArray:array];
    if (_pageNumber == 1) {
        self.layouts = [NSMutableArray arrayWithCapacity:10];
    }
    [arr enumerateObjectsUsingBlock:^(JHC2CProductBeanListModel * _Nonnull goodsInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.layouts addObject:goodsInfo];
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
        [_collectionView registerClass:[JHC2CGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHC2CGoodsCollectionViewCell class])];
        
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
    JHC2CGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHC2CGoodsCollectionViewCell class]) forIndexPath:indexPath];
    JHC2CProductBeanListModel *dataModel = self.layouts[indexPath.row];
    [cell bindViewModel:dataModel params:nil];
        return cell;
    
}
#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([self.layouts count]>0) {
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
    JHC2CProductBeanListModel *layout = self.layouts[indexPath.item];
    return CGSizeMake((ScreenW-20)/2, layout.itemHeight);
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

    JHC2CProductBeanListModel *layout = self.layouts[indexPath.item];
    JHC2CProductDetailController *vc = [JHC2CProductDetailController new];
    vc.productId = layout.productId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end

