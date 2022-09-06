//
//  JHResultGoodsViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/4/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHResultGoodsViewController.h"
#import "JHBuryPointOperator.h"
//#import "JHSearchResultView.h"
# import "JHGrowingIO.h"
#import "JHNewStoreGlobalSearchResultViewController.h"

@interface JHResultGoodsViewController ()

//@property (nonatomic, strong) JHSearchResultView  *resultView;
/// 列表某一次展示ID集合
@property (nonatomic, strong) NSMutableDictionary *idsDic;

@property (nonatomic, strong) JHNewStoreGlobalSearchResultViewController *storeVC;

@end

@implementation JHResultGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self configResultView];
    
    //搜索结果落地页埋点
    if(self.keyword){
        [JHGrowingIO trackEventId:JHSearch_click variables:@{@"type":@"1"}];
    }
}

- (void)reloadData {
    [self.storeVC refreshSearchResult:self.keyword from:ZQSearchFromStore keywordSource:nil];

}

- (void)configResultView {
//    JHSearchResultView *resultView = [[JHSearchResultView alloc] init];
//    resultView.keyword = self.keyword;
//    resultView.keywordSource = self.keywordSource;
//    resultView.showKeyword = @"";
//    resultView.isFromSQ = YES;
//    [self.view addSubview:resultView];
//    _resultView = resultView;
//    [_resultView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.top.equalTo(self.view).offset(1);
//    }];
//    @weakify(self);
//    _resultView.hideKeyBoardBlock = ^{
//        @strongify(self);
//            [self keyboardHide];
//    };
//    _resultView.disPlayDataIdBlock = ^(NSString * _Nonnull Id) {
//        @strongify(self);
//        if(Id)
//        {
//            [self.idsDic setValue:Id forKey:Id];
//        }
//    };
//    [_resultView refresh];
    
    ///商品 -搜索- 用新商场的页面
    self.storeVC.keyword = self.keyword;
    self.storeVC.keywordSource = self.keywordSource;
    [self.view addSubview:self.storeVC.view];
}

- (void)keyboardHide {
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark - JXCategoryListCollectionContentViewDelegate

- (UIView *)listView {
    return self.view;
}

/// 曝光帖子ID集合
- (NSMutableDictionary *)idsDic {
    if(!_idsDic)
    {
        _idsDic = [NSMutableDictionary new];
    }
    return _idsDic;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    NSString *IDS = @"";
    for (NSString *ids in self.idsDic.allKeys) {
        if(IDS.length > 0)
        {
            IDS = [NSString stringWithFormat:@"%@,%@",IDS,ids];
        }
        else
        {
            IDS = ids;
        }
    }
    if(IDS.length > 0)
    {
        [[JHBuryPointOperator shareInstance] buryWithEtype:@"search_shop_exposure" param:@{@"browse_id" : IDS , @"query_word" : self.keyword ? : @""}];
    }
    
    [self.idsDic removeAllObjects];
}

- (JHNewStoreGlobalSearchResultViewController *)storeVC{
    if (!_storeVC) {
        _storeVC = [[JHNewStoreGlobalSearchResultViewController alloc] init];
    }
    return _storeVC;
}

@end
