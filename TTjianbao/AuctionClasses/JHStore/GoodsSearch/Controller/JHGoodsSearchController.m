//
//  JHGoodsSearchController.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/19.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  搜索页面 & 搜索结果页面
//

#import "JHGoodsSearchController.h"
#import "JHGoodsSearchView.h"
#import "JHHotWordModel.h"
#import "JHStoreApiManager.h"
#import "TTjianbaoMarco.h"
#import "JHWebViewController.h"
#import "JHSearchResultView.h"
#import "GrowingManager.h"
#import "JHSearchTextfield.h"

#define itemWidth 44.f
#define itemHeight 30.f
#define searchBarH 28.f
#define searchBarW (ScreenWidth - itemWidth - 30)
#define cancelWidth 18.0f
#define naviHeight (IS_PhoneXAll ? 84.f : 64.f)


@interface JHGoodsSearchController () <JHSearchTextfieldDelegate>

@property (nonatomic, strong) CSearchKeyModel *keyModel;
@property (nonatomic, strong) UIButton *backButton; ///返回按钮
@property (nonatomic, strong) UIButton *cancelButton; ///取消按钮
@property (nonatomic, strong) JHSearchTextfield *searchBar;
///默认默认view
@property (nonatomic, strong) JHGoodsSearchView *keyListView;
///搜索结果view
@property (nonatomic, strong) JHSearchResultView *searchResultView;

@property (nonatomic, assign) BOOL isShowKeyList;  ///标记默认页是否显示过

@property (nonatomic, assign) BOOL isEdited;  ///标记搜索框是否编辑过 默认没有编辑过
//进入界面时间戳
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, copy) NSString *fromSource; ///from
@end

@implementation JHGoodsSearchController

- (instancetype)init {
    self = [super init];
    if (self) {
        _isSort = NO;
        _isEdited = NO;
        _isShowKeyList = NO;
        _keyModel = [[CSearchKeyModel alloc] init];
        self.fromSource = nil; //初始化为空
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF7F7F7);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [self configNaviBar];
    [self loadHotList];
    [self showView];
}

-(void)noteEventType:(id)status
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:status forKey:JHUPBrowseKey];
    [param setValue:self.category1_id forKey:@"category1_id"];
    [param setValue:self.category2_id forKey:@"category2_id"];
    
    [JHUserStatistics noteEventType:kUPEventTypeMallCategoryTabBrowse params:param];
}

#pragma mark -
#pragma mark - UI
- (void)configNaviBar {
    [self showNaviBar];
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, UI.statusAndNavBarHeight)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, navView.bounds.size.height - 0.5, ScreenW, 0.5f)];
    bottomLine.backgroundColor = kColorCellLine;
    [navView addSubview:bottomLine];
    [navView addSubview:self.searchBar];
    [navView addSubview:self.backButton];
    [navView addSubview:self.cancelButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    ///分类进入的需要添加停留时长埋点 - 开始
    if (self.isSort) {
        [self noteEventType:JHUPBrowseBegin];
    }
    
    if (!self.isSort && !self.keyListView.hidden) {
        [self.searchBar.searchTextField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///用户画像埋点：- 结束
    if (self.isSort) {
        [self noteEventType:JHUPBrowseEnd];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    //有点特别:1,输入框2,搜索历史,两页并没有跳转页面,因此统计起来有点。。
    if(_searchResultView.keyword && self.fromSource)
    {
        [self growingSetParamDict:@{@"key":_searchResultView.keyword, @"from": self.fromSource}];
    }
    else
    {
        [self growingSetParamDict:nil];
    }
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark - JHSearchTextfieldDelegate

- (BOOL)searchTextfieldShouldReturn:(JHSearchTextfield *)searchTextfield {
    ///点击回车 相当于点击了搜索按钮 搜索数据
    [self searchData];
    return YES;
}

- (void)searchTextfieldTextDidChange:(JHSearchTextfield *)searchTextfield searchFieldText:(NSString *)searchTextfieldText {
    if (searchTextfieldText.length == 0) {
        ///当搜索框内文字为空时 显示默认搜索页 隐藏 结果页
        [self showKeylistView];
        return;
    }
}

- (BOOL)searchTextfieldShouldChangeCharactersInRange:(NSRange)range searchTextField:(JHSearchTextfield *)searchTextfield {
    _isEdited = YES;
    return YES;
}

- (BOOL)searchTextfieldTextDidClear:(JHSearchTextfield *)searchTextfield {
    return YES;
}

#pragma mark - 搜索执行的方法

- (void)searchData {
    [self keyboardHide];
    if (![self.searchBar.searchTextField.text isNotBlank]) {
        ///为空 需要定位当前轮询的热搜词
        JHHotWordModel *model = self.keyModel.hotList[self.searchBar.currentIndex-1];
        if (model && model.target && model.target.componentName) {
            ///搜索按钮点击埋点 热搜词
            [self trackSearchBtnClick:model.title type:@"hotKey"];
            
            if ([model.target.componentName isEqualToString:NSStringFromClass([self class])]) {
                ///跳转到结果界面
                _searchResultView.keyword = model.target.params[@"keyword"];
                [self showSearchResultiew:nil];
            }
            else {
                [JHRootController toNativeVC:model.target.componentName withParam:model.target.params from:@""];
            }
        }
    }
    else {
        ///搜索按钮点击埋点
        if (self.isSort && !self.isEdited) {
            ///如果是分类 并且 没有编辑行为 点击按钮不执行下面的操作
            [self trackSearchBtnClick:self.searchBar.searchTextField.text type:@"cateKey"];
            return;
        }
        ///发生了编辑行为 不管当前文字和分类是否一样 全部按照搜索处理
        //保存搜索历史
        CSearchKeyData *data = [CSearchKeyData new];
        data.keyword = self.searchBar.searchTextField.text;
        [CSearchKeyModel saveHistoryData:data];
        
        _searchResultView.keyword = data.keyword;
        _searchResultView.showKeyword = @"";
        [self showSearchResultiew:JHTrackMarketSaleSearchFromInputBox];
        [JHGrowingIO trackEventId:JHTrackMarketSaleSearchListIn from:JHTrackMarketSaleSearchFromInputBox];
        ///分类 && 编辑 || 非分类 && 搜索框不为空
        [self trackSearchBtnClick:data.keyword type:@"inputKey"];
    }
}

- (void)cancelSearch {
    [self.navigationController popViewControllerAnimated:NO];
}

///显示默认搜索框页面
- (void)showKeylistView {
    ///隐藏页面时上报
    self.searchResultView.hidden = YES;
    self.keyListView.hidden = NO;
    ///如果是分类的话 这块显示Keylist
    self.isShowKeyList = YES;
    [self hideBackAnimation];
    
    [self.keyListView updateHistoryList];
}

- (void)showView {
    /// 如果是从分类进入 展示结果界面
    if (self.isSort && [self.keyword isNotBlank]) {
        self.searchResultView.keyword = self.keyword;
        self.searchResultView.showKeyword = self.showKeyword;
        self.searchBar.searchTextField.text = self.searchResultView.keyword;
        [self.searchBar hidePlaceholder];
        [self.searchResultView refresh];
        [self showSearchResultiew:JHTrackMarketSaleSearchFromCategory];
        [JHGrowingIO trackEventId:JHTrackMarketSaleSearchListIn from:JHTrackMarketSaleSearchFromCategory];
    }
    else {
        ///展示默认页
        [self showKeylistView];
    }
}

///显示结果页面
- (void)showSearchResultiew:(NSString*)from {
    [_searchResultView refresh];
    self.searchResultView.hidden = NO;
    self.keyListView.hidden = YES;
    [self showBackAnimation];
    self.fromSource = from;
    ///进入界面的时间
    self.startTime = [YDHelper get13TimeStamp].longLongValue;
}

- (void)leftBtnClicked {
    ///如果不是分类 并且当前默认页为隐藏状态
    ///如果是分类 并且搜索页显示过 且当前默认页为隐藏状态
    if ((!self.isSort && self.keyListView.hidden) || (self.isSort && self.isShowKeyList && self.keyListView.hidden)) {
        ///如果keyListView是隐藏的 表示当前展示的是结果页 点击返回按钮应该显示搜索页面
        [self showKeylistView];
        self.searchBar.searchTextField.text = @"";
        [self.searchBar hidePlaceholder];
        [self searchGrowingEvent]; //两种搜索（无独立页面）埋点
        return;
    }
    ///如果不是分类 并且当前默认页是显示的状态： 返回到首页
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchGrowingEvent
{
    [self growingSetParamDict:@{@"key":_searchResultView.keyword, @"from": self.fromSource}];
    [self growingArticleBrowseWithStartTime:self.startTime];
    self.fromSource = nil;
}

#pragma mark -
#pragma mark - UI lazy loading
- (JHGoodsSearchView *)keyListView {
    if (!_keyListView) {
        ///默认搜索框页面
        JHGoodsSearchView *keyListView = [[JHGoodsSearchView alloc] init];
        keyListView.curModel = _keyModel;
        [self.view addSubview:keyListView];
        _keyListView = keyListView;
        [_keyListView mas_makeConstraints:^(MASConstraintMaker *make) {     make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, UI.bottomSafeAreaHeight, 0));
        }];
        
        @weakify(self);
        _keyListView.didSelectKeywordBlock = ^(NSString * _Nonnull vcName, NSDictionary * _Nonnull params, NSString * _Nonnull searchFrom) {
            @strongify(self);
            [self keyboardHide];
            if ([vcName isEqualToString:NSStringFromClass([self class])]) {
                self.searchResultView.keyword = params[@"keyword"];
                self.searchResultView.showKeyword = @"";
                self.searchBar.searchTextField.text = params[@"keyword"];
                ///必须在赋值的后面
                [self.searchBar hidePlaceholder];
                [JHGrowingIO trackEventId:JHTrackMarketSaleSearchListIn from:searchFrom];
                ///展示结果页面
                [self showSearchResultiew:searchFrom];
                [self.keyListView updateHistoryList];
            }
            else {
                ///如果不是跳结果页的话 就是其他页面
                [JHRootController toNativeVC:vcName withParam:params from:@""];
            }
        };
    }
    return _keyListView;
}

- (JHSearchResultView *)searchResultView {
    if (!_searchResultView) {
        ///搜索结果页面
        JHSearchResultView *resultView = [[JHSearchResultView alloc] init];
        resultView.keyword = self.searchBar.searchTextField.text;
        resultView.showKeyword = @"";
        [self.view addSubview:resultView];
        _searchResultView = resultView;
        [_searchResultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.keyListView);
        }];
        ///默认是隐藏
        _searchResultView.hidden = YES;
        
        @weakify(self);
        _searchResultView.hideKeyBoardBlock = ^{
            @strongify(self);
            [self keyboardHide];
        };
    }
    return _searchResultView;
}

#pragma mark -
#pragma mark - data
- (void)loadHotList {
    @weakify(self);
    [JHStoreApiManager getHotKeywords:^(NSArray *respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            self.keyModel.hotList = [NSMutableArray arrayWithArray:respObj];
            self.keyListView.curModel = self.keyModel;
            
            NSMutableArray *tempArray = [NSMutableArray array];
            for (JHHotWordModel *model in self.keyModel.hotList) {
                [tempArray addObject:model.title];
            }
            ///请求到数据后给搜索框的占位符赋值
            self.searchBar.placeholders = tempArray.copy;
        }
    }];
}

- (void)keyboardHide {
    [self.view endEditing:YES];
}

///搜索按钮点击事件 埋点
- (void)trackSearchBtnClick:(NSString *)key type:(NSString *)type {
    NSDictionary * params = @{@"key":key,@"type":type};
    [GrowingManager clickSearchButton:params];
}

#pragma mark -
#pragma mark - lazy loading

- (JHSearchTextfield *)searchBar {
    if (!_searchBar) {
        _searchBar = [[JHSearchTextfield alloc] initWithFrame:CGRectMake(15, UI.statusBarHeight+(44-searchBarH)/2, searchBarW, searchBarH)];
        _searchBar.backgroundColor = kColorF5F6FA;
        _searchBar.layer.cornerRadius = _searchBar.height/2;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.placeholder = @"";
        _searchBar.textColor = [UIColor blackColor];
        _searchBar.font = [UIFont fontWithName:kFontNormal size:13];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(ScreenW - itemWidth - 10, 0, itemWidth, cancelWidth);
        _cancelButton.centerY = self.searchBar.centerY;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(-itemWidth, 0, itemWidth, itemHeight);
        _backButton.centerY = self.searchBar.centerY;
        [_backButton setImage:kNavBackBlackImg forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

///导航栏动画相关
- (void)showBackAnimation {
    self.backButton.hidden = NO;
    [UIView animateWithDuration:0.25f animations:^{
        CGRect cannelF = self.cancelButton.frame;
        CGRect searchF = self.searchBar.frame;
        CGRect backF = self.backButton.frame;

        backF.origin.x = 0;
        searchF.origin.x = 35;
        cannelF.origin.x = ScreenW;
        
        self.backButton.frame = backF;
        self.searchBar.frame = searchF;
        self.cancelButton.frame = cannelF;
        
    } completion:^(BOOL finished) {
    }];
}

- (void)hideBackAnimation {
    self.backButton.hidden = YES;
    [UIView animateWithDuration:0.25f animations:^{
        CGRect cannelF = self.cancelButton.frame;
        CGRect searchF = self.searchBar.frame;
        CGRect backF = self.backButton.frame;

        backF.origin.x = -itemWidth;
        searchF.origin.x = 15;
        cannelF.origin.x = ScreenWidth - itemWidth - 5;
        
        self.backButton.frame = backF;
        self.searchBar.frame = searchF;
        self.cancelButton.frame = cannelF;
        
    } completion:^(BOOL finished) {

    }];
}



@end
