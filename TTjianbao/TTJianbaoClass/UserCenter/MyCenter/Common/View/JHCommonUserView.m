//
//  JHCommonUserView.m
//  TTjianbao
//
//  Created by lihui on 2020/4/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCommonUserView.h"
#import "JHWebViewController.h"
#import "JHSelectMerchantViewController.h"
#import "JHSignViewController.h"
#import "JHShopHomeController.h"
#import "JHMyShopViewController.h"
#import "JHGoodsDetailViewController.h"
////推荐相关
#import "JCCollectionViewWaterfallLayout.h"
#import "JHShopWindowCollectionCell.h"
#import "JHRecommendHeader.h"
#import "JHShopWindowLayout.h"
#import "JHPersonHeaderCell.h"
#import "JHShopCollectionViewCell.h"
#import "JHCycleCollectionViewCell.h"
#import "JHPersonTableViewCell.h"
#import "JHTitleHeaderCollectionReusableView.h"
#import "CommAlertView.h"
#import "JHZanHUD.h"
#import "JHSQManager.h"
#import "GrowingManager.h"
#import "UIImageView+JHWebImage.h"

#import "JHCommonUserViewModel.h"
#import "JHMySectionModel.h"
#import "JHStoneSignFooter.h"
#import "JHSelectContractViewController.h"
#import "JHUnionSignView.h"
#import "JHStoneResaleLayer.h"
#import "JHPersonWalletCell.h"

#define fiveCellCount 5
#define fourCellCount 4

@interface JHCommonUserView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHCommonUserViewModel *userViewModel; ///数据ViewModel
@property (nonatomic, strong) JHStoneResaleLayer *stoneResaleLayer; /// 原石回血弹层
@end

@implementation JHCommonUserView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"🔥dealloc－－－－%@",self.class);
}

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(self).offset(0);
    }];

    [self refreshPersonCenterData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginRefreshData) name:LOGINSUSSNotifaction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginRefreshData) name:LOGOUTSUSSNotifaction object:nil];
    ///刷新推荐的数据
//    [self refreshRecommendData];
}
- (void)loginRefreshData {
    @weakify(self);
    [self.userViewModel requestBannersWithBlock:^{
        @strongify(self);
        [self.collectionView reloadData];
    }];

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    JHMySectionModel *model = self.userViewModel.sectionArray[section];
    if (model.sectionType == JHMySectionTypeRecommend) {
        return 5;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    JHMySectionModel *model = self.userViewModel.sectionArray[section];
    if (model.sectionType == JHMySectionTypeRecommend) {
        return 5;
    }
    return 0;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.userViewModel.recommendArray.count == 0) {
        return self.userViewModel.sectionArray.count-1;
    }
    return self.userViewModel.sectionArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JHMySectionModel *model = self.userViewModel.sectionArray[section];
    if (model.sectionType == JHMySectionTypeHeader ||
        model.sectionType == JHMySectionTypeShop ||
        model.sectionType == JHMySectionTypeCycle) {
        return 1;
    }
    if (model.sectionType == JHMySectionTypeRecommend) {
        return self.userViewModel.recommendArray.count;
    }
    return self.userViewModel.dataArray[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMySectionModel *model = self.userViewModel.sectionArray[indexPath.section];
    if (model.sectionType == JHMySectionTypeHeader) {
        JHPersonHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHPersonHeaderCell class]) forIndexPath:indexPath];
        ///点击事件方法
        [self respondsPersonheaderViewEvent:cell];
        cell.userModel = [UserInfoRequestManager sharedInstance].user;
        cell.levelModel = [UserInfoRequestManager sharedInstance].levelModel;
        return cell;
    }
    if (model.sectionType == JHMySectionTypeShop) {  ///店铺
        JHShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHShopCollectionViewCell class]) forIndexPath:indexPath];
        @weakify(self);
        cell.myShopBlock = ^{ ///进入我的店铺
            @strongify(self);
            [self enterMyShopPage];
        };
        cell.shopHomeBlock = ^{ ///进入店铺主页
            @strongify(self);
            [self getUserSellerInfo];
        };
        return cell;
    }
    if (model.sectionType == JHMySectionTypeCycle) {  ///轮播图
        JHCycleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCycleCollectionViewCell class]) forIndexPath:indexPath];
        cell.bannerArray = self.userViewModel.bannerModes;
        return cell;
    }
    if (model.sectionType == JHMySectionTypeRecommend) {///推荐的cell
        JHShopWindowCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHShopWindowCollectionCell class]) forIndexPath:indexPath];
        cell.layout = self.userViewModel.recommendArray[indexPath.item];
        return cell;
    }
    //我的钱包
    if (model.sectionType == JHMySectionTypeWallet) {
        JHPersonWalletCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHPersonWalletCell class]) forIndexPath:indexPath];
        cell.model = self.userViewModel.dataArray[indexPath.section][indexPath.row];
        return cell;
    }
    
    JHPersonTableViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHPersonTableViewCell class]) forIndexPath:indexPath];
    cell.model = self.userViewModel.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    JHMySectionModel *model = self.userViewModel.sectionArray[indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (model.sectionType == JHMySectionTypeRecommend) {
            JHRecommendHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"recommendHeader" forIndexPath:indexPath];
            header.title = IS_OPEN_RECOMMEND ? @"为您推荐" : @"推荐";;
            return header;
        }
//        if (model.sectionType == JHMySectionTypeOrder) {
//            JHBlankCornerHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JHBlankCornerHeader" forIndexPath:indexPath];
//            return header;
//        }

        ///标题文字
        JHTitleHeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"titleHeader" forIndexPath:indexPath];
        view.titleLabel.text = model.title;
        return view;
        
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        ///用户信息  轮播图  店铺入口
        if (model.sectionType == JHMySectionTypeHeader ||
            model.sectionType == JHMySectionTypeCycle ||
            model.sectionType == JHMySectionTypeShop ||
            model.sectionType == JHMySectionTypeRecommend) {
            UICollectionReusableView *v = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"commonFooter" forIndexPath:indexPath];
            v.backgroundColor = [UIColor clearColor];
            return v;
        }
        ///原石回血签约入口
        if (model.sectionType == JHMySectionTypeResale && [UserInfoRequestManager sharedInstance].unionSignIsShow) {
            JHStoneSignFooter *stoneFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kStoneSignFooterIdentifer forIndexPath:indexPath];
            return stoneFooter;
        }
        
        JHCollectionFootor *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"JHCollectionFootor" forIndexPath:indexPath];
        view.titleLabel.hidden = YES;
        return view;
    }
        
    return nil;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    JHMySectionModel *model = self.userViewModel.sectionArray[section];
    if (model.sectionType == JHMySectionTypeRecommend) {
        return self.userViewModel.recommendArray.count ? 46 : 0;
    }
    return model.headerHeight;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section{
    JHMySectionModel *model = self.userViewModel.sectionArray[section];
    if (model.sectionType == JHMySectionTypeCycle && self.userViewModel.bannerModes.count == 0) {
        return 0;
    }
    ///原始回血footer高度
    if (model.sectionType == JHMySectionTypeResale && [UserInfoRequestManager sharedInstance].unionSignIsShow) {
        return 76;
    }
    return model.footerHeight;
}

#pragma mark - UICollectionViewLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMySectionModel *model = self.userViewModel.sectionArray[indexPath.section];
    if (model.sectionType == JHMySectionTypeHeader) {
        return CGSizeMake(ScreenW, topHeadHeight);
    }
    if (model.sectionType == JHMySectionTypeRecommend) {
        JHShopWindowLayout *layout = self.userViewModel.recommendArray[indexPath.item];
        return CGSizeMake((ScreenW - 25)/2, layout.cellHeight);
    }
    if (model.sectionType == JHMySectionTypeCycle && self.userViewModel.bannerModes.count == 0) {
        return CGSizeMake(ScreenW, 0);
    }
    return model.cellSize;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section {
    JHMySectionModel *model = self.userViewModel.sectionArray[section];
    return model.columnCount;
}

#pragma mark - UICollectionViewDelegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    JHMySectionModel *model = self.userViewModel.sectionArray[section];
    if (model.sectionType == JHMySectionTypeHeader) {
        return UIEdgeInsetsZero;
    }
    if (model.sectionType == JHMySectionTypeRecommend) {
         return UIEdgeInsetsMake(0,10,10, 10);
    }
    
    return UIEdgeInsetsMake(0,10,0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMySectionModel *mode = self.userViewModel.sectionArray[indexPath.section];
    ///为您推荐
    if (mode.sectionType == JHMySectionTypeRecommend) {
        [self enterGoodetailPage:indexPath.item];
        return;
    }
    JHMyCellModel *model = self.userViewModel.dataArray[indexPath.section][indexPath.row];
    if ([self isNeedlogin:model]) {
        [self enterLoginPage];
        return;
    }
    if ([model.title isEqualToString:@"在线客服"]) {
        ///联系客服
        [self enterChatPage];
        return;
    }
    if ([model.title isEqualToString:@"电话客服"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006230666"]];
        return;
    }
    
    // 显示原石回血弹层
    if ([model.title isEqualToString:JHLocalizedString(@"stoneResale")]) {
        [self.stoneResaleLayer showStoneResaleLayerWithDataSource:[self.userViewModel resaleDataSource] didClickItem:^(JHMyCellModel * _Nonnull myCellModel) {
            if (![JHRootController isLogin]) {
                [self enterLoginPage];
                return;
            }
            if (myCellModel.vcName) {
                [JHRootController toNativeVC:myCellModel.vcName withParam:myCellModel.params from:@""];
            }
        }];
        return;
    }
    
    if ([self isNeedUnionSign:model]) {
        if ([UserInfoRequestManager sharedInstance].unionSignStatus == JHUnionSignStatusSigning) {
            ///首先判断当前是否是签约中 如果是签约中 直接跳转到签约界面
            [self enterUnionSignPage];
        }
        else {
            ///提示用户签约
            [self showUnionSignAlert];
        }
        return;
    }
    if (model.vcName) {
        [JHRootController toNativeVC:model.vcName withParam:model.params from:@""];
        
        // 埋点逻辑
        if (model.growingClickString.length>0) {
            [JHGrowingIO trackEventId:model.growingClickString];
        }
        
        if([model.vcName isEqualToString:@"JHDraftBoxController"]) {
            [JHAllStatistics jh_allStatisticsWithEventId:@"personal_draft_click" type:(JHStatisticsTypeGrowing | JHStatisticsTypeSensors)];
        }
        else if([model.vcName isEqualToString:@"JHUserInfoViewController"]) {
            int t = 1;
            if(IS_DICTIONARY(model.params) && [model.params valueForKey:@"index"]) {
                NSString *index = [model.params valueForKey:@"index"];
                t = index.intValue;
            }
            NSString *eventId = @"personal_comment_click";
            if(t == 2) {
                eventId = @"personal_write_click";
            }
            else if(t == 3) {
                eventId = @"personal_like_click";
            }
            [JHAllStatistics jh_allStatisticsWithEventId:eventId type:(JHStatisticsTypeGrowing | JHStatisticsTypeSensors)];
        }
    }
}

///进入商品详情页
- (void)enterGoodetailPage:(NSInteger)index {
    JHGoodsInfoMode *data = [self.userViewModel.recommendArray[index] goodsInfo];
    JHGoodsDetailViewController *vc = [[JHGoodsDetailViewController alloc] init];
    vc.goods_id = data.goods_id;
    vc.entry_type = JHFromStoreFollowPersonalRecommend; ///个人中心推荐
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}

- (void)enterChatPage {
    [[JHQYChatManage shareInstance] showChatWithViewcontroller:[JHRootController currentViewController]];
}

- (void)showUnionSignAlert {
    JHUnionSignStatus status = [UserInfoRequestManager sharedInstance].unionSignStatus;
    [JHUnionSignAlertView creatUnionSignAlertViewWithStatus:status];
}

///进入银联签约h5页面
- (void)enterUnionSignPage {
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.titleString = JHLocalizedString(@"signContractTitle");
    vc.urlString = [UserInfoRequestManager sharedInstance].unionSignRequestInfoUrl;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)enterLoginPage {
    [JHRootController presentLoginVC];
}

- (BOOL)isNeedlogin:(JHMyCellModel *)model {
    if (![JHRootController isLogin] &&
        ![model.title isEqualToString:JHLocalizedString(@"helpCenter")] &&
        ![model.title isEqualToString:JHLocalizedString(@"stoneResale")]) {
        return YES;
    }
    return NO;
}

///头部个人信息部分点击事件
- (void)respondsPersonheaderViewEvent:(JHPersonHeaderCell *)sender {
    @weakify(self);
    sender.signActionBlock = ^(id sender) {
        [self enterSignInPage];
    };
    
    sender.taskBlock = ^(id sender) {
        @strongify(self);
        [self enterTaskCenterVC];
    };
    sender.scoreBlock = ^(id sender) {
        @strongify(self);
        [self enterIntegralVC];
    };
    sender.personHomeBlock = ^(id sender) {
        @strongify(self);
        [self enterUserInfoVC];
    };
    
    sender.headerActionBlock = ^(id object, UIControl *sender) {
        NSLog(@"点击 %zd",sender.tag);
        @strongify(self);
        switch (sender.tag) {
            case JHPersonCenterActionFollow: {
                [self enterFriendVCWithCurIndex:1];
                break;
            }
            case JHPersonCenterActionFans: {
                [self enterFriendVCWithCurIndex:2];
                break;
            }
            case JHPersonCenterActionGetLikes: {
                [JHZanHUD showText:[NSString stringWithFormat:@"\"%@\"共获得%ld个赞",
                                    [UserInfoRequestManager sharedInstance].user.name,
                                    (long)[UserInfoRequestManager sharedInstance].levelModel.like_num]];
                break;
            }
            case JHPersonCenterActionExperienceValue: {
                [self enterIntegralVC];
                break;
            }
            default:
                break;
        }
    };
}

#pragma mark -
#pragma mark - 网络请求判断用户是否为特卖商家
- (void)getUserSellerInfo {
    @weakify(self);
    [self.userViewModel requestUserSellerInfo:^(id  _Nullable respObj, BOOL hasError) {
        RequestModel *data = (RequestModel *)respObj;
        if (!hasError) {
            @strongify(self);
            NSNumber *sellerId = data.data[@"seller_id"];
            [self enterShopHomePage:[sellerId integerValue]];
            //埋点：进入店铺页
            [self GIOEnterShopPageWithSellerId:sellerId];
        }
        else {
            NSLog(@"不是特卖商家 or 网络请求失败");
            if (data.code == JHDataCodeIsSpecialSale) {
                [self showAlertView:data];
            }
        }
    }];
}

//埋点：进入店铺页
- (void)GIOEnterShopPageWithSellerId:(NSNumber *)sellerId {
    NSDictionary *params = @{@"shopId" : sellerId,
                             @"from" : @"JHFromPersonalCenter"
    };
    [GrowingManager enterShopHomePage:params];
}

///提示弹框
- (void)showAlertView:(RequestModel *)respondObject {
    ///不是特卖是商家 弹出弹框 提示用户不是特卖商家
    CommAlertView *alertView = [[CommAlertView alloc] initWithTitle:@"温馨提示" andDesc:respondObject.message cancleBtnTitle:JHLocalizedString(@"iKnow")];
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    __block typeof(alertView)blockAlertView = alertView;
    alertView.cancleHandle = ^{
        if (blockAlertView) {
            [blockAlertView removeFromSuperview];
        }
    };
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.scrollBlock) {
        self.scrollBlock(offsetY);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == false) {
        [self scrollViewDidEndScroll:scrollView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (dragToDragStop) {
        [self scrollViewDidEndScroll:scrollView];
    }
}
- (void)scrollViewDidEndScroll : (UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.scrollEndBlock) {
        self.scrollEndBlock(offsetY);
    }
}
#pragma mark -
#pragma mark - 页面跳转  action event
///进入店铺主页
- (void)enterShopHomePage:(NSInteger)sellerId {
    ///进入店铺埋点
    [self GIOEnterShopPage:@(sellerId)];
    
    JHShopHomeController *vc = [[JHShopHomeController alloc] init];
    vc.sellerId = sellerId;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}

//埋点：进入店铺 个人中心 进入店铺埋点
- (void)GIOEnterShopPage:(NSNumber *)sellerId {
    [GrowingManager enterShopHomePage:@{@"shopId":sellerId,
                                        @"from":@"JHFromPersonalCenter"
    }];
}

///签到有礼页面
- (void)enterSignInPage {
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.titleString = @"签到有礼";
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/newSigned/newSigned.html");
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    //埋点
    NSDictionary *param = @{
        @"model_name":@"签到",
        @"page_position":@"个人中心首页"
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickModel" params:param type:JHStatisticsTypeSensors];
}

- (void)enterMyShopPage {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    JHMyShopViewController *vc = [[JHMyShopViewController alloc] init];
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}

//进入个人主页
- (void)enterUserInfoVC {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    NSString *userId = [UserInfoRequestManager sharedInstance].user.customerId;
    [JHRootController enterUserInfoPage:userId from:@""];
}

//进入关注/粉丝页
- (void)enterFriendVCWithCurIndex:(NSInteger)curIndex {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    User *user = [UserInfoRequestManager sharedInstance].user;
    [JHRouterManager pushUserFriendWithController:[JHRootController currentViewController] type:curIndex userId:user.customerId.integerValue name:user.name];
}

//进入任务中心
- (void)enterTaskCenterVC {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.titleString = @"任务中心";
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/myTitle.html");
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}

//进入我的积分
- (void)enterIntegralVC {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.titleString = @"我的积分";
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/myIntegral.html");
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}


#pragma mark - 银联签约相关
///判断是否需要银联签约
- (BOOL)isNeedUnionSign:(JHMyCellModel *)model {
    if ([model.title isEqualToString:JHLocalizedString(@"buyInStone")]) {
        JHUnionSignStatus status = [UserInfoRequestManager sharedInstance].unionSignStatus;
        if (status != JHUnionSignStatusComplete &&
            status != JHUnionSignStatusReviewing) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark - data

- (void)refreshPersonCenterData {
    @weakify(self);
    [self.userViewModel loadPersonCenterDataWithBlock:^{
        @strongify(self);
        [self.collectionView reloadData];
    }];
}

#pragma mark -
#pragma mark - 推荐数据相关

- (void)refreshRecommendData {
    [self loadData:YES];
}

- (void)loadMoreRecommendData {
    [self loadData:NO];
}

- (void)loadData:(BOOL)isRefresh {
    @weakify(self);
    [self.userViewModel loadRecommendData:isRefresh completeBlock:^(BOOL hasData, BOOL hasError) {
        @strongify(self);
        [self endRefresh];
        self.collectionView.mj_footer.hidden = !hasData;
        [self.collectionView reloadData];
    }];
}

- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark - Setters / Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        JCCollectionViewWaterfallLayout *flowLayout = [[JCCollectionViewWaterfallLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.bounces = true;
        _collectionView.backgroundColor = kColorF5F6FA;
    
//        JHRefreshNormalFooter *footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self  refreshingAction:@selector(loadMoreRecommendData)];
//        _collectionView.mj_footer = footer;
        
        ///cell
        [_collectionView registerClass:[JHPersonHeaderCell class] forCellWithReuseIdentifier:NSStringFromClass([JHPersonHeaderCell class])];
        ///店铺
        [_collectionView registerClass:[JHShopCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHShopCollectionViewCell class])];
        ///轮播图
        [_collectionView registerClass:[JHCycleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCycleCollectionViewCell class])];
        ///中间的内容cell
        [_collectionView registerClass:[JHPersonTableViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHPersonTableViewCell class])];
        
        [_collectionView registerClass:[JHPersonWalletCell class] forCellWithReuseIdentifier:NSStringFromClass([JHPersonWalletCell class])];
        ///推荐的商品cell
        [_collectionView registerClass:[JHShopWindowCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHShopWindowCollectionCell class])];
        ///header
        ///为您推荐的header
        [_collectionView registerClass:[JHRecommendHeader class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"recommendHeader"];
        ///带有标题的header
        [_collectionView registerClass:[JHTitleHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"titleHeader"];
        [_collectionView registerClass:[JHBlankCornerHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JHBlankCornerHeader"];
        
        ///背景色为灰色 带白色下左右圆角的footer
        [_collectionView registerClass:[JHCollectionFootor class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"JHCollectionFootor"];
        
        ///原石回血底部签约入口
        [_collectionView registerClass:[JHStoneSignFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kStoneSignFooterIdentifer];

        ///普通的footer
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"commonFooter"];
    }
    return _collectionView;
}

- (JHCommonUserViewModel *)userViewModel {
    if (!_userViewModel) {
        _userViewModel = [[JHCommonUserViewModel alloc] init];
    }
    return _userViewModel;
}

- (JHStoneResaleLayer *)stoneResaleLayer {
    if(!_stoneResaleLayer){
        _stoneResaleLayer = [[JHStoneResaleLayer alloc] init];
    }
    return _stoneResaleLayer;
}

#pragma mark -
#pragma mark - others

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.view == self.collectionView) {
        return NO;
    }
    return YES;
}

@end
