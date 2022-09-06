//
//  JHNewStoreSearchResultSubViewController.m
//  TTjianbao
//
//  Created by hao on 2021/8/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreSearchResultSubViewController.h"
@interface JHNewStoreSearchResultSubViewController ()

@end

@implementation JHNewStoreSearchResultSubViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //页面曝光埋点
    NSMutableDictionary *sensorsDic = [NSMutableDictionary dictionary];
    if (self.fromSource == JHSearchFromStore) {
        sensorsDic[@"page_name"] = @"商城搜索结果页";
    } else if (self.fromSource == JHSearchFromLive) {
        sensorsDic[@"page_name"] = @"直播搜索结果页";
    }
    sensorsDic[@"key_word"] = self.cateId > 0 ? @"" : self.keyword;
    sensorsDic[@"search_type"] = self.keywordSource;
    sensorsDic[@"tab_name"] = self.titleArray[self.titleTagIndex];
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:sensorsDic type:JHStatisticsTypeSensors];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserveValue];
}

#pragma mark - UI

#pragma mark - LoadData

#pragma mark  - Action

- (void)addObserveValue{
    //搜索框中的搜索条件
    @weakify(self)
    [[RACObserve(self.searchTextfield, recommendTagsArray) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //搜索条件变化重新请求数据
        if (self.searchTextfield.tagsDataArray.count > 0) {
            self.cateId = 0;
            [self reloadSubViewData];
        }
    }];
    
    RAC(self, keyword) = RACObserve(self.searchTextfield, searchWord);

}
- (void)reloadSubViewData{
    //重新加载子类数据
}

#pragma mark - Delegate
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}


#pragma mark - Lazy
- (UILabel *)nullDataLabel{
    if (!_nullDataLabel) {
        _nullDataLabel = [UILabel new];
        _nullDataLabel.font = JHFont(13);
        _nullDataLabel.textColor = HEXCOLOR(0x666666);
        _nullDataLabel.text = @"   抱歉，没有找到您检索的信息，为您推荐以下结果";
        _nullDataLabel.backgroundColor = HEXCOLOR(0xF8F8F8);
    }
    return _nullDataLabel;
}
@end
