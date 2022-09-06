//
//  JHRecycleUploadTypeSeleteViewController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleUploadTypeSeleteViewController.h"
#import "JHRecycleUploadProductViewController.h"
#import "JHRecycleUploadTypeTableViewCell.h"
#import "JHSQBannerView.h"
#import "JHRecycleUploadProductBusiness.h"

#import "JHRecycleUploadArbitrationViewController.h"
#import "JHRecycleUploadFinishViewController.h"
#import "JHRecycleSquareHomeViewController.h"
#import "JHRecycleMeAttentionViewController.h"
#import "JHPhotoExampleViewController.h"
#import "BannerMode.h"
#import <SDWebImage.h>
#import "SVProgressHUD.h"
#import "CommAlertView.h"

@interface JHRecycleUploadTypeSeleteViewController ()<UITableViewDelegate, UITableViewDataSource>

/// 轮播图
@property(nonatomic, strong) JHSQBannerView * bannerView;

@property(nonatomic, strong) UITableView * tableView;

/// 类型种类数组
@property (nonatomic, strong) NSArray<JHRecycleUploadSeleteTypeListModel*> *listModelArr;
/// banner数组
@property (nonatomic, strong) NSArray<JHRecycleUploadSeleteTypeBannerModel*> *bannerModelArr;

@end

@implementation JHRecycleUploadTypeSeleteViewController

- (void)viewWillAppear:(BOOL)animated{
    [JHTracking trackEvent:@"appPageView" property:@{@"page_name":@"回收选择售卖分类页"}];
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择售卖分类";
    [self setItems];
    [self layoutItems];
    [SVProgressHUD show];
    @weakify(self);
    [JHRecycleUploadProductBusiness requestRecycleProductSeleteTypeCompletion:^(NSError * _Nullable error, JHRecycleUploadSeleteTypeModel * _Nullable model) {
        [SVProgressHUD dismiss];
        @strongify(self);
        self.bannerModelArr = model.bannerImgUrls;
        self.listModelArr = model.categoryVOs;
        [self.tableView jh_reloadDataWithEmputyView];
        [self refershBanner];
    }];
    
}

- (void)setItems{
    [self.view addSubview:self.tableView];
}

- (void)layoutItems{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(self.jhNavView.mas_bottom);
    }];
}

#pragma mark -- <Action>
- (void)bannerClickWithModel:(BannerCustomerModel*)model{
    NSDictionary * targetLanding = model.title.mj_JSONObject;

//    [JHRootController toNativeVC:targetLanding[@"componentName"] withParam:targetLanding[@"params"] from:JHFromSQHomeFeedList];
    
    if ([targetLanding isKindOfClass:[NSDictionary class]]) {
        [self addStatisticWithBanner:targetLanding];
        JHRouterModel* router = [JHRouterModel mj_objectWithKeyValues:targetLanding];
        [JHRouterManager deepLinkRouter:router];
    }
}

- (void)refershBanner{
    NSMutableArray<BannerCustomerModel*> *arr = [self.bannerModelArr jh_map:^id _Nonnull(JHRecycleUploadSeleteTypeBannerModel * _Nonnull obj, NSUInteger idx) {
        BannerCustomerModel* model = [[BannerCustomerModel alloc] init];
        model.image = obj.imageUrl;
        model.title = obj.landingTarget;
        return model;
    }];
    self.bannerView.bannerList = arr;


}



#pragma mark -- <UITableViewDelegate and UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JHRecycleUploadTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JHRecycleUploadTypeTableViewCell.class) forIndexPath:indexPath];
    JHRecycleUploadSeleteTypeListModel *model = self.listModelArr[indexPath.row];
    cell.nameLbl.text = model.categoryName;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.categoryImgUrl.small] placeholderImage:[UIImage imageNamed:@"recycle_buyCategory_placeholderImage"]];
    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listModelArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHRecycleUploadSeleteTypeListModel *model = self.listModelArr[indexPath.row];
    if (isEmpty(model.type)) {
        JHRecycleUploadProductViewController *vc = [[JHRecycleUploadProductViewController alloc] init];
        vc.typeName = model.categoryName;
        vc.typeImageName =  model.categoryImgUrl.small;
        vc.categoryId = model.categoryId;
        vc.businessId = self.businessId;
        [self.navigationController pushViewController:vc animated:YES];
        [self addStatisticWithCategryId:model.categoryId];
    } else {
        /// 大宗钱币
        CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"卖大宗钱币" andDesc:@"联系平台客服，为您提供大宗钱币（20个钱币以上）回收专属服务。" cancleBtnTitle:@"联系客服"];
        [alert addCloseBtn];
        [alert addBackGroundTap];
        [alert setDescTextAlignment:NSTextAlignmentCenter];
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        alert.cancleHandle = ^{
            [[JHQYChatManage shareInstance] showChatWithViewcontroller:[JHRootController currentViewController]];
        };
    }
}

#pragma mark -- <set and get>

- (JHSQBannerView *)bannerView {
    if (!_bannerView) {
        @weakify(self);
        _bannerView = [[JHSQBannerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100) andEdge:UIEdgeInsetsMake(10, 12, 12, 12) andClickBlock:^(BannerCustomerModel * _Nonnull bannerData, NSInteger selectIndex) {
            @strongify(self);
            [self bannerClickWithModel:bannerData];
        }];
        _bannerView.backgroundColor = kColorF5F6FA;
        _bannerView.type = JHBannerAdTypeRecycle;
    }
    return _bannerView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] init];
        view.delegate = self;
        view.dataSource = self;
        view.rowHeight = 89;
        view.tableHeaderView = self.bannerView;
        view.tableFooterView = [UIView new];
        view.backgroundColor = HEXCOLOR(0xF5F5F5);
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.estimatedRowHeight = 0;
        [view registerClass:JHRecycleUploadTypeTableViewCell.class forCellReuseIdentifier:NSStringFromClass(JHRecycleUploadTypeTableViewCell.class)];
        _tableView = view;
    }
    return _tableView;
}


#pragma mark -- <打点统计>
//打点统计
- (void)addStatisticWithCategryId:(NSString*)categryId{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"page_position"] = @"recycleUploadedGoods";
    parDic[@"class_id"] = NONNULL_STR(categryId);
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickClassify" params:parDic type:JHStatisticsTypeSensors];
}

- (void)addStatisticWithBanner:(NSDictionary*)dic{
    //            landingTarget = "{\"componentName\":\"com.yiding.jianhuo.web.WebActivity\",\"componentType\":-999,\"params\":{\"urlString\":\"https://h5.ttjianbao.com/html/coins.html#/\",\"url\":\"https://h5.ttjianbao.com/html/coins.html#/\"},\"type\":\"1\",\"vc\":\"JHWebViewController\"}";
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"page_position"] = @"recycleUploadedGoods";
    parDic[@"spm_type"] = @"banner";
    parDic[@"activity_id"] = NONNULL_STR(dic[@"type"]);
    parDic[@"content_url"] = NONNULL_STR(dic[@"params"][@"urlString"]);
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickClassify" params:parDic type:JHStatisticsTypeSensors];

}

@end
