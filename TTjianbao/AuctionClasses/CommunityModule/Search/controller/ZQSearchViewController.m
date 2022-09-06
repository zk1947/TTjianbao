//
//  ZQSearchViewController.m
//  ZQSearchController
//
//  Created by zzq on 2018/9/20.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQSearchViewController.h"
#import "ZQSearchNormalViewController.h"
#import "JHDiscoverSearchViewModel.h"
#import "JHDiscoverSearchModel.h"
#import <IQKeyboardManager.h>

#import "UITextField+PlaceHolderColor.h"
#import "JHHotWordModel.h"
#import "CSearchKeyModel.h"
#import "JHSearchTextfield.h"
#import "JHGoodsSearchController.h"
#import "NSString+Common.h"

#define padding 15.f
#define bottomPadding 13.f
#define naviPadding 50.f
//#define itemWidth 50.f
#define itemWidth 44.f
#define itemHeight 30.f
#define searchBarH 30.f
#define searchBarW (ScreenWidth - itemWidth - 30)
#define cancelWidth 30.0f



@interface ZQSearchViewController ()<UITextFieldDelegate, JHSearchTextfieldDelegate, ZQSearchChildViewDelegate>
//ZQSearchChildViewDelegate

@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) UIView *baseView;

//@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) JHSearchTextfield *searchBar;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, assign) ZQSearchState sState;
@property (nonatomic, assign) ZQSearchBarStyle sStyle;

//子控制器
@property (nonatomic, strong) UIViewController *resultVC;//结果界面
@property (nonatomic, strong) ZQSearchNormalViewController *searchNormalVC;//默认界面
@property (nonatomic, strong) NSMutableArray *hotList;//默认界面

//
@property (nonatomic, assign) NSInteger inputCount;

@property (nonatomic, weak) UIView *gapV;
@property (nonatomic, assign)ZQSearchFrom from;
@end

@implementation ZQSearchViewController

- (void)dealloc {
    NSLog(@"ZQSearchViewController dealloc");
}

- (instancetype)initSearchViewWithFrom:(ZQSearchFrom)from resultController:(UIViewController *)resultController {
    if (self = [super init]) {
        resultController.view.frame = self.baseView.bounds;
        self.resultVC = resultController;
        self.from = from;
        [self configBaseUI];
        [self updateChildViewState:ZQSearchStateNormal];
        if(from == ZQSearchFromCommunity){ //社区
            //加载热门话题
            [self requestCommunityHotSearch:0];
            //加载热搜词
            [self getCommunityHotKeyWordsData];
        }
        else if(from == ZQSearchFromLive){ //直播和天天定制
            //加载热搜词
            [self getLiveHotKeyWordsData];
        }
        else if(from == ZQSearchFromStore){ //特卖商城
            //曝光埋点
            [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
                @"page_name":@"商城搜索中间页"
            } type:JHStatisticsTypeSensors];
            //加载热搜词
            [self getStoreHotKeyWordsData];
        }else if(from == ZQSearchFromC2C){ //C2C
            //曝光埋点
            [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
                @"page_name":@"集市搜索中间页"
            } type:JHStatisticsTypeSensors];
            //加载热搜词
            [self getC2CHotKeyWordsData];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveResignFirstResponse) name:kHideKeyBoardNoticename object:nil];
    }
    return self;
}

- (void)receiveResignFirstResponse {
    [self.searchBar.searchTextField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showSearchViewAnimation];
    
    if (self.sState == ZQSearchStateResult) {
        [self.searchBar.searchTextField resignFirstResponder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark - config UI
/*
 * 顶部导航栏view
 * 子控制器view
 */
- (void)configBaseUI {
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.baseView];
    [self.view addSubview:self.naviView];
    
    [self.naviView addSubview:self.searchBar];
    [self.naviView addSubview:self.backBtn];
    [self.naviView addSubview:self.cancelBtn];
    
    self.backBtn.hidden = YES;
    
    UIView *gapV = [UIView new];
    gapV.backgroundColor = [UIColor colorWithHexStr:@"f5f5f5"];
    gapV.frame = CGRectMake(0, UI.statusAndNavBarHeight - 0.5, ScreenW, 0.5);
    [self.naviView addSubview:gapV];
    self.gapV = gapV;
    
    [self.baseView addSubview:self.resultVC.view];
    [self.baseView addSubview:self.searchNormalVC.view];
    
    [self addChildViewController:self.resultVC];
    [self addChildViewController:self.searchNormalVC];
    
    [self.searchBar.searchTextField becomeFirstResponder];
}

///获取社区热搜话题的数据
- (void)requestCommunityHotSearch:(NSInteger)channelId {
    [JHDiscoverSearchViewModel getSearchKeyWordWithChannel_id:channelId success:^(RequestModel * _Nonnull request) {
        NSArray *topics = request.data[@"topics"];
        NSArray *topicList = [NSArray modelArrayWithClass:[CTopicData class] json:topics];
        [self.searchNormalVC setTopicList:topicList];
    } failure:^(RequestModel * _Nonnull request) {
        [UITipView showTipStr:request.message];
    }];
}

///获取社区热搜词
- (void)getCommunityHotKeyWordsData {
    [JHDiscoverSearchViewModel getHotKeyHordData:^(id  _Nullable respObj, BOOL hasError) {
        if (!hasError) {
            RequestModel * respondObject = (RequestModel *)respObj;
            NSArray *hotKeys = [JHHotWordModel mj_objectArrayWithKeyValuesArray:respondObject.data].copy;
            self.hotList = [NSMutableArray arrayWithArray:hotKeys];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (JHHotWordModel *model in hotKeys) {
                [tempArray addObject:model.title];
            }
            ///请求到数据后给搜索框的占位符赋值
            self.searchBar.placeholders = tempArray.copy;
            [self.searchNormalVC setHotList:self.hotList.copy];
        }
    }];
}

//获取直播热搜词
-(void)getLiveHotKeyWordsData {
    [JHDiscoverSearchViewModel getLiveHotKeyHordData:^(id  _Nullable respObj, BOOL hasError) {
        if (!hasError) {
            RequestModel * respondObject = (RequestModel *)respObj;
            NSMutableArray *hotKeys = [NSMutableArray array];
            
            NSArray *array = respondObject.data;
            for (NSDictionary *dic in array) {
                NSString* word = dic[@"word"];
                JHHotWordModel *model = [[JHHotWordModel alloc]init];
                model.title = word;
                JHHotWordTarget *target = [[JHHotWordTarget alloc]init];
                target.componentName = @"ZQSearchViewController";
                NSDictionary  *params = @{
                    @"keyword": word
                };
                target.params = params;
                model.target = target;
                [hotKeys addObject:model];
            }

            self.hotList = hotKeys;
            NSMutableArray *tempArray = [NSMutableArray array];
            for (JHHotWordModel *model in hotKeys) {
                [tempArray addObject:model.title];
            }
            ///请求到数据后给搜索框的占位符赋值
            self.searchBar.placeholders = tempArray.copy;
            [self.searchNormalVC setHotList:self.hotList.copy];
        }
    }];
}

///获取特卖商城热搜词
- (void)getStoreHotKeyWordsData {
    [JHDiscoverSearchViewModel getStoreHotKeyHordData:^(id  _Nullable respObj, BOOL hasError) {
        if (!hasError) {
            RequestModel * respondObject = (RequestModel *)respObj;
            NSArray *hotKeys = [JHHotWordModel mj_objectArrayWithKeyValuesArray:respondObject.data].copy;
            self.hotList = [NSMutableArray arrayWithArray:hotKeys];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (JHHotWordModel *model in hotKeys) {
                [tempArray addObject:model.title];
            }
            ///请求到数据后给搜索框的占位符赋值
            self.searchBar.placeholders = tempArray.copy;
            [self.searchNormalVC setHotList:self.hotList.copy];
        }
    }];
}

///获取C2C热搜词
- (void)getC2CHotKeyWordsData {
    [JHDiscoverSearchViewModel getC2CHotKeyHordData:^(id  _Nullable respObj, BOOL hasError) {
        if (!hasError) {
            RequestModel * respondObject = (RequestModel *)respObj;
            NSArray *hotKeys = [JHHotWordModel mj_objectArrayWithKeyValuesArray:respondObject.data].copy;
            self.hotList = [NSMutableArray arrayWithArray:hotKeys];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (JHHotWordModel *model in hotKeys) {
                [tempArray addObject:model.title];
            }
            ///请求到数据后给搜索框的占位符赋值
            self.searchBar.placeholders = tempArray.copy;
            [self.searchNormalVC setHotList:self.hotList.copy];
        }
    }];
}

- (void)updateChildViewState:(ZQSearchState)state {
    self.sState = state;
    
    switch (self.sState) {
        case ZQSearchStateNormal:
            [self.baseView sendSubviewToBack:self.resultVC.view];
            self.gapV.backgroundColor = HEXCOLOR(0xf8f8f8);
            self.backBtn.hidden = YES;
            break;
        case ZQSearchStateResult:
            [self.baseView sendSubviewToBack:self.searchNormalVC.view];
            self.gapV.backgroundColor = [UIColor whiteColor];
            self.backBtn.hidden = NO;
            break;
        default:
            break;
    }
}

#pragma mark - animation
- (void)showSearchViewAnimation {
    if (self.sStyle != ZQSearchBarStyleNone) {
        return;
    }
    self.sStyle = ZQSearchBarStyleCannel;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.searchBar.frame = CGRectMake(15, UI.statusBarHeight+(44-searchBarH)/2, searchBarW, searchBarH);
    } completion:nil];
}

- (void)showBackAnimation {
    if (self.sStyle == ZQSearchBarStyleBack) {
        return;
    }
    [UIView animateWithDuration:0.25f animations:^{
        CGRect cannelF = self.cancelBtn.frame;
        CGRect searchF = self.searchBar.frame;
        CGRect backF = self.backBtn.frame;

        backF.origin.x = 0;
        searchF.origin.x = 35;
        cannelF.origin.x = ScreenW;
        
        self.backBtn.frame = backF;
        self.searchBar.frame = searchF;
        self.cancelBtn.frame = cannelF;
        
    } completion:^(BOOL finished) {
        self.backBtn.hidden = NO;
        self.sStyle = ZQSearchBarStyleBack;
    }];
}

- (void)hideBackAnimation {
    [UIView animateWithDuration:0.25f animations:^{
        CGRect cannelF = self.cancelBtn.frame;
        CGRect searchF = self.searchBar.frame;
        CGRect backF = self.backBtn.frame;

        backF.origin.x = -itemWidth;
        searchF.origin.x = 15;
        cannelF.origin.x = ScreenWidth - itemWidth - 5;
        
        self.backBtn.frame = backF;
        self.searchBar.frame = searchF;
        self.cancelBtn.frame = cannelF;
        
    } completion:^(BOOL finished) {
        self.backBtn.hidden = YES;
        self.sStyle = ZQSearchBarStyleCannel;
    }];
}

#pragma mark - actions
- (void)cancelBtnClicked:(UIButton *)sender {
    if (self.searchBar.searchTextField.text.length) {
        [self showBackAnimation];
        [self.searchBar.searchTextField resignFirstResponder];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)backBtnClicked:(UIButton *)sender {
     [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UITextFieldActions
- (void)textFieldDidBegin:(UITextField *)field {
    self.inputCount = 0;
    if (self.sStyle == ZQSearchBarStyleCannel) {
        return;
    }
    self.sStyle = ZQSearchBarStyleCannel;
}

#pragma mark - ZQSearchChildViewDelegate
- (void)searchChildViewDidScroll {
    if (self.searchBar.searchTextField.isFirstResponder) {
        [self.searchBar.searchTextField resignFirstResponder];
    }
}

- (void)searchChildViewDidSelectItem:(id)value {
    if (!value) {
        return;
    }
    if (self.searchBar.searchTextField.isFirstResponder) {
        [self.searchBar.searchTextField resignFirstResponder];
    }
    //C2C搜索埋点
    if (self.from == ZQSearchFromC2C) {
        [JHAllStatistics jh_allStatisticsWithEventId:@"searchButtonClick" params:@{
            @"page_position":@"集市搜索中间页"
        } type:JHStatisticsTypeSensors];
    }
    if ([value isKindOfClass:[JHHotWordModel class]]) {
        ///热搜
        JHHotWordModel *model = (JHHotWordModel *)value;
        if (model.title.length <= 0) {
            return;
        }
        //MARK: 新商城版->为了兼容商城热搜都跳结果页（暂时这样处理）
        if (self.from == ZQSearchFromStore) {
            //跳转到搜索结果页
            [self beginToSearch:model.title keywordSource:@"热门搜索"];
        }else{
            if ([model.target.componentName isEqualToString:NSStringFromClass([self class])] || [model.target.componentName isEqualToString:NSStringFromClass([JHGoodsSearchController class])] || [NSString isEmpty:model.target.componentName]) {
                //跳转到搜索结果页
                if (self.from == ZQSearchFromC2C) {
                    [self beginToSearch:model.title keywordSource:@"热词搜索"];
                }else{
                    [self beginToSearch:model.title keywordSource:@"热门搜索"];
                }
            }
            else {
                [JHRootController toNativeVC:model.target.vc withParam:model.target.params from:@""];
            }
        }
        
    }
    else if ([value isKindOfClass:[CSearchKeyData class]]) {
        //保存历史  历史只有历史记录才会保存历史  热搜词不保存历史记录
        CSearchKeyData *data = (CSearchKeyData *)value;
        [CSearchKeyModel saveHistoryData:data];
        //跳转到搜索结果页
        [self beginToSearch:data.keyword keywordSource:@"历史搜索"];
    }
}

- (void)beginToSearch:(NSString *)keyword keywordSource:(NSString *)keywordSource {
    self.searchBar.searchTextField.text = keyword;
    [self.searchBar hidePlaceholder];
    [self updateChildViewState:ZQSearchStateResult];
    [self showBackAnimation];
    //刷新结果界面
    id<ZQSearchData>value = (id<ZQSearchData>)keywordSource;

    if (self.delegate && [self.delegate respondsToSelector:@selector(searchFuzzyResultWithKeyString:Data:resultController: From:)]) {
        [self.delegate searchFuzzyResultWithKeyString:keyword Data:value resultController:self.resultVC From:self.from];
    }
}

#pragma mark - getter & setter

- (JHSearchTextfield *)searchBar {
    if (!_searchBar) {
        _searchBar = [[JHSearchTextfield alloc] initWithFrame:CGRectMake(15, UI.statusBarHeight+(44-searchBarH)/2, searchBarW, searchBarH)];
        _searchBar.backgroundColor = kColorF5F6FA;
        _searchBar.layer.cornerRadius = searchBarH/2;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.placeholder = @"";
        _searchBar.textColor = HEXCOLOR(0x333333);
        _searchBar.font = [UIFont fontWithName:kFontNormal size:13];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

#pragma mark -
#pragma mark - JHSearchTextfieldDelegate

- (void)searchTextFieldDidBegin:(JHSearchTextfield *)searchTextField {
    self.inputCount = 0;
    if (self.sStyle == ZQSearchBarStyleCannel) {
        return;
    }
    self.sStyle = ZQSearchBarStyleCannel;
}

- (BOOL)searchTextfieldShouldReturn:(JHSearchTextfield *)searchTextfield {
    if (self.searchBar.searchTextField.isFirstResponder) {
        [self.searchBar.searchTextField resignFirstResponder];
    }
    //C2C搜索埋点
    if (self.from == ZQSearchFromC2C) {
        [JHAllStatistics jh_allStatisticsWithEventId:@"searchButtonClick" params:@{
            @"page_position":@"集市搜索中间页"
        } type:JHStatisticsTypeSensors];
    }
    ///点击回车 相当于点击了搜索按钮 搜索数据
    if ([searchTextfield.searchTextField.text isNotBlank]) {
        ///输入框有数据
        [self searchData];
        //输入搜索埋点
        [JHGrowingIO trackEventId:JHLive_search_in variables:@{@"dz_search":searchTextfield.searchTextField.text,@"dz_search_type":@"inputSearch"}];
    }
    else {
        JHHotWordModel *model = self.hotList[self.searchBar.currentIndex-1];
        if (model.title.length <= 0) {
            return NO;
        }
        [self beginToSearch:model.title keywordSource:@"默认搜索"];

//        //MARK: 新商城版->为了兼容商城热搜都跳结果页（暂时这样处理）
//        if (self.from == ZQSearchFromStore) {
//            //跳转到搜索结果页
//        }else{
//            if (model && model.target && model.target.componentName) {
//                if ([model.target.componentName isEqualToString:NSStringFromClass([self class])] || [model.target.componentName isEqualToString:NSStringFromClass([JHGoodsSearchController class])] || [NSString isEmpty:model.target.componentName]) {
//                    //跳转到搜索结果页
//                    [self beginToSearch:model.title keywordSource:@"默认搜索"];
//                }
//                else {
//                    [JHRootController toNativeVC:model.target.vc withParam:model.target.params from:@""];
//                }
//            }
//        }
//
        //关键词埋点
        [JHGrowingIO trackEventId:JHLive_search_in variables:@{@"dz_search":model.title,@"dz_search_type":@"hotSearch"}];
    }
    return YES;
}

- (void)searchTextfieldTextDidChange:(JHSearchTextfield *)searchTextfield searchFieldText:(NSString *)searchTextfieldText {
    ///当搜索框内文字为空时 显示默认搜索页 隐藏 结果页
    NSString *text = searchTextfield.searchTextField.text;
    if (text.length == 0) {
        ///当输入文字为空时 并且搜索过之后需要刷新section
        [self.searchNormalVC updateHistoryList];
        [self updateChildViewState:ZQSearchStateNormal];
        [self hideBackAnimation];
    } else {
        [self.searchBar hidePlaceholder];
        [self updateChildViewState:ZQSearchStateEditing];
        self.inputCount++;
    }
}

#pragma mark - 搜索执行的方法
- (void)searchData {
    if (self.searchBar.searchTextField.isFirstResponder) {
        [self.searchBar.searchTextField resignFirstResponder];
    }
    
    //历史记录
    CSearchKeyData *data = [[CSearchKeyData alloc] init];
    data.keyword = self.searchBar.searchTextField.text;
    [CSearchKeyModel saveHistoryData:data];
    [self updateChildViewState:ZQSearchStateResult];
    [self showBackAnimation];
    
    //跳转到搜索结果页
    NSString *keywordSource = @"手动搜索";
    id<ZQSearchData>value = (id<ZQSearchData>)keywordSource;
    //刷新结果界面
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchFuzzyResultWithKeyString:Data:resultController: From:)]) {
        [self.delegate searchFuzzyResultWithKeyString:data.keyword Data:value resultController:self.resultVC From:self.from];
    }
    NSLog(@"edit exit");
}

- (UIView *)naviView {
    if (!_naviView) {
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZQSearchWidth, UI.statusAndNavBarHeight)];
        _naviView.backgroundColor = [UIColor whiteColor];
    }
    return _naviView;
}

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ZQSearchWidth, ZQSearchHeight - UI.statusAndNavBarHeight)];
        _baseView.backgroundColor = [UIColor whiteColor];
    }
    return _baseView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(ScreenWidth - itemWidth - 5, 0, itemWidth, cancelWidth);
        _cancelBtn.centerY = self.searchBar.centerY;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(-itemWidth, 0, itemWidth, itemHeight);
        _backBtn.centerY = self.searchBar.centerY;
        [_backBtn setImage:kNavBackBlackImg forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIViewController *)resultVC {
    if (!_resultVC) {
        _resultVC = [[UIViewController alloc] init];
        _resultVC.view.frame = self.baseView.bounds;
    }
    return _resultVC;
}

- (ZQSearchNormalViewController *)searchNormalVC {
    if (!_searchNormalVC) {
        _searchNormalVC = [[ZQSearchNormalViewController alloc] init];
        _searchNormalVC.view.frame = self.baseView.bounds;
        _searchNormalVC.delegate = self;
    }
    return _searchNormalVC;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder.copy;
    self.searchBar.placeholder = _placeholder;
}

@end
