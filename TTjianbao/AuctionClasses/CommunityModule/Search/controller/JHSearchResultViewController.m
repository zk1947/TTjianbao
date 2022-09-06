//
//  JHSearchResultViewController.m
//  TTjianbao
//
//  Created by mac on 2019/6/18.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHSearchResultViewController.h"
#import "TopicApiManager.h"
#import "JHTopicDetailController.h"

#import "TTjianbaoBussiness.h"
#import "JHResultGoodsViewController.h"
#import "CTopicModel.h"
#import "JHPostResultListController.h"
#import "JHLiveSearchResultVC.h"


@interface JHSearchResultViewController ()

@property (nonatomic,   copy) NSString *keywordStr;
@property (nonatomic, assign) NSInteger channelId;
///关键词来源
@property (nonatomic, copy) NSString *keywordSource;
@property (nonatomic, assign) BOOL hasTopic;
@property (nonatomic, strong) JHLiveSearchResultVC *liveSearchVC;
@property (nonatomic, strong) JHResultGoodsViewController *goodsVC;
@property (nonatomic, strong) JHPostResultListController *postVC;


@end

@implementation JHSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitleCategoryView];
    
    //【埋点】进入搜索结果页
    [JHGrowingIO trackEventId:JHTrackSQIntoSearchResult from:JHFromSQSearchBar];
    ///用户画像埋点：搜索结果页面停留时长：开始
    [JHUserStatistics noteEventType:kUPEventTypeCommunitySearchResultBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///用户画像埋点：搜索结果页面停留时长：结束
    [JHUserStatistics noteEventType:kUPEventTypeCommunitySearchResultBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd}];
}

///带关键词来源的方法
- (void)refreshSearchResult:(NSString *)keyword from:(ZQSearchFrom)from keywordSource:(id<ZQSearchData>)keywordSource {
    self.keywordStr = keyword;
    self.keywordSource = (NSString *)keywordSource;
    NSInteger index = 0;
    if(from == ZQSearchFromLive){
        index = 0;
    }else if(from == ZQSearchFromStore){
        index = 1;
    }else{
        index = 2;
    }
    //重载之后默认回到0，你也可以指定一个index
    self.titleCategoryView.defaultSelectedIndex = index;
    self.titleCategoryView.titles = self.titles;
    [self.titleCategoryView reloadData];
    
    self.listContainerView.defaultSelectedIndex = index;
    [self.listContainerView reloadData];
}

#pragma mark -
#pragma mark - JXCategoryView Methods

- (void)setupTitleCategoryView {
    self.titles = @[@"直播", @"商品",@"帖子"];
    self.titleCategoryView.titles = self.titles;
    self.titleCategoryView.cellSpacing = 20;
    self.titleCategoryView.titleColorGradientEnabled = YES;
    
    JXCategoryIndicatorLineView *indicatorView = self.indicatorView;
    self.titleCategoryView.indicators = @[indicatorView];
    
    self.titleCategoryView.sd_layout.topSpaceToView(self.view, 0);
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

#pragma mark -
#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    if(index == 0){
        self.liveSearchVC.keyword = self.keywordStr;
        self.liveSearchVC.keywordSource = self.keywordSource;
        [self.liveSearchVC reloadData];
        return self.liveSearchVC;
    }
    else if(index == 1){
        self.goodsVC.keyword = self.keywordStr;
        self.goodsVC.keywordSource = self.keywordSource;
        [self.goodsVC reloadData];
        return self.goodsVC;
    }
    else{
        self.postVC.q = self.keywordStr;
        self.postVC.type = [NSString stringWithFormat:@"%ld", (long)index];
        self.postVC.hasTopic = self.hasTopic;
        self.postVC.keywordSource = self.keywordSource;
        [self.postVC reloadData];
        return self.postVC;
    }
}

- (JHLiveSearchResultVC *)liveSearchVC {
    if (!_liveSearchVC) {
        JHLiveSearchResultVC *vc = [[JHLiveSearchResultVC alloc] init];
        _liveSearchVC = vc;
    }
    return _liveSearchVC;
}

- (JHResultGoodsViewController *)goodsVC {
    if (!_goodsVC) {
        _goodsVC = [[JHResultGoodsViewController alloc] init];
    }
    return _goodsVC;
}

- (JHPostResultListController *)postVC {
    if (!_postVC) {
        _postVC = [[JHPostResultListController alloc] init];
    }
    return _postVC;
}

- (void)dealloc {
    NSLog(@"%@*********被释放",[self class]);
}

@end
