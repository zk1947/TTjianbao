//
//  JHSearchViewController_NEW.m
//  TTjianbao
//
//  Created by liuhai on 2021/10/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSearchViewController_NEW.h"
#import <IQKeyboardManager.h>
#import "UITextField+PlaceHolderColor.h"
#import "CSearchKeyModel.h"
#import "JHSearchTextfield.h"
#import "CommAlertView.h"
#import "NSString+Common.h"
#import "JHSearchHeaderView.h"
#import "JHHotSearchCell.h"
#import "JHSearchAssociateView.h"
#import "JHSearchRecommendListCell.h"
#import "JHSearchRecommendModel.h"
#import "JHNewStoreSearchResultViewController.h"

#define itemWidth 44.f
#define searchBarH 30.f
#define cancelWidth 30.0f
#define searchBarW (ScreenWidth - itemWidth - cancelWidth - 30)

@interface JHSearchViewController_NEW ()<JHSearchTextfieldDelegate, UITableViewDelegate, UITableViewDataSource, JHHotSearchCellDelegate>
@property (nonatomic, strong) JHSearchTextfield *searchBar;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) JHSearchAssociateView *associateView;//搜索联想页
@property (strong, nonatomic) UITableView *tableViewSearch;
@property (strong, nonatomic) NSMutableArray *histroyArr;//热门搜索历史数组
@property (nonatomic, strong) NSMutableArray *hotList;// 搜索框滚动词
@property (nonatomic, strong) JHSearchRecommendModel * serchRecommendModel; //热门词 列表
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isExpand;//历史搜索是否展开

@end

@implementation JHSearchViewController_NEW

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchBar.searchTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.fromSource == JHSearchFromStore) {
        [JHTracking trackEvent:@"appPageView" property:@{@"page_name":@"商城搜索中间页"}];
    }else if(self.fromSource == JHSearchFromLive){
        [JHTracking trackEvent:@"appPageView" property:@{@"page_name":@"直播搜索中间页"}];
    }
    
    self.isExpand = NO;
    [self configBaseUI];
    //加载热搜词
    [self getInitData];
    //占位词等数据
    [self initializeData];
    
}

#pragma mark - config UI
///顶部导航栏view 子控制器view
- (void)configBaseUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.jhNavView addSubview:self.searchBar];
    [self.jhNavView addSubview:self.cancelBtn];
    [self creatttTabl];
    //搜索联想页
    [self addSearchAssociateView];
}

- (void)creatttTabl{
    self.tableViewSearch = [[UITableView alloc]initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, kScreenWidth, kScreenHeight - UI.statusAndNavBarHeight - UI.bottomSafeAreaHeight) style:UITableViewStyleGrouped];
    self.tableViewSearch.delegate = self;
    self.tableViewSearch.dataSource = self;
    self.tableViewSearch.backgroundColor = UIColor.whiteColor;
    self.tableViewSearch.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableViewSearch];
    self.tableViewSearch.tableFooterView = [[UIView alloc] init];
}
- (void)addSearchAssociateView {
    if (!self.associateView) {
        self.associateView = [[JHSearchAssociateView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, kScreenWidth, kScreenHeight-self.searchBar.bottom)];
        self.associateView.supVC = self;
        self.associateView.hidden = YES;
        @weakify(self);
        self.associateView.pushToResultVC = ^(NSString * _Nonnull keyword) {
            @strongify(self);
            [self beginToSearch:keyword keywordSource:@"联想搜索"];
        };
        [self.view addSubview:self.associateView];
    }
}

- (void)initializeData{
    //占位词
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:NONNULL_STR(self.placeholder) attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x888888),NSFontAttributeName:JHFont(13)}];
    self.searchBar.searchTextField.attributedPlaceholder = attrString;
    
    //当有搜索词时显示联想页面
    if (self.searchWord.length > 0) {
        self.searchBar.searchTextField.text = self.searchWord;
        [self.searchBar hidePlaceholder];
        [self.associateView showAssociateViewWithKeyword:self.searchWord currentPageIndex:0];
    }
}

- (void)getInitData{
    @weakify(self);
    NSString *url= FILE_BASE_STRING(@"/mall/search/search/queryHotRecommend");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self);
        self.serchRecommendModel = [JHSearchRecommendModel mj_objectWithKeyValues:respondObject.data];
        [self.tableViewSearch reloadData];
        NSLog(@"---");
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSLog(@"===");
    }];
}


#pragma mark - getter & setter
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder.copy;
}
- (void)setFromSource:(JHSearchFromSource)fromSource{
    _fromSource = fromSource;
}

- (void)setSearchWord:(NSString *)searchWord{
    _searchWord = searchWord;
    
}

#pragma mark - actions
///重写返回按钮方法
- (void)backActionButton:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

///顶部搜索按钮点击事件
- (void)searchBtnClicked:(UIButton *)sender {
    if (self.searchBar.searchTextField.text.length > 0) {
        [self beginToSearch:self.searchBar.searchTextField.text keywordSource:@"手动搜索"];
    }else if(self.placeholder.length > 0){
        [self beginToSearch:self.placeholder keywordSource:@"默认搜索"];
    }
    [self sa_tracking_SearchBtnAction];
}

///删除历史记录点击事件
- (void)clickRemoveHistory:(UIButton *)sender{
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"确认删除全部历史记录？" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        [CSearchKeyModel removeAllHistory];
        self.histroyArr = [NSMutableArray arrayWithArray:[CSearchKeyModel loadHistoryList]];
        [self.tableViewSearch reloadData];
    };
}

#pragma mark - 搜索执行的方法
- (void)beginToSearch:(NSString *)keyword keywordSource:(NSString *)keywordSource{
    self.associateView.hidden = YES;
    if (self.searchBar.searchTextField.isFirstResponder) {
        [self.searchBar.searchTextField resignFirstResponder];
    }
    if (self.searchBar.searchTextField.text.length > 0) {
        self.searchBar.searchTextField.text = @"";
    }
    //历史记录
    CSearchKeyData *data = [[CSearchKeyData alloc] init];
    data.keyword = keyword;
    [CSearchKeyModel saveHistoryData:data];
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        @strongify(self);
        self.histroyArr = [NSMutableArray arrayWithArray:[CSearchKeyModel loadHistoryList]];
        [self.tableViewSearch reloadData];
    });
    
    [self pushSearchResultView:keyword searchSource:keywordSource];
}
///搜索结果页
- (void)pushSearchResultView:(NSString *)searchWord searchSource:(NSString *)searchSource{
    JHNewStoreSearchResultViewController *resultVC = [[JHNewStoreSearchResultViewController alloc] init];
    resultVC.searchWord = searchWord;
    resultVC.searchSource = searchSource;
    resultVC.fromSource = self.fromSource;
    resultVC.searchPlaceholder = self.placeholder;
    [self.navigationController pushViewController:resultVC animated:NO];
    
    
    
    //    //跳转到搜索结果页
    //    NSString *keywordSource = fromStr;
    //    id<ZQSearchData>value = (id<ZQSearchData>)keywordSource;
    //    //刷新结果界面
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(searchFuzzyResultWithKeyString:Data:resultController: From:)]) {
    //        [self.delegate searchFuzzyResultWithKeyString:keyWord Data:value resultController:self.resultVC From:self.from];
    //    }
    //    if (self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(pushSearchResultView:searchController:Data:From:)]) {
    //        [self.searchDelegate pushSearchResultView:keyWord searchController:self Data:value From:self.from];
    //    }
}


#pragma mark - Delegate
#pragma mark - JHSearchTextfieldDelegate
- (BOOL)searchTextfieldShouldReturn:(JHSearchTextfield *)searchTextfield {
    if (self.searchBar.searchTextField.isFirstResponder) {
        [self.searchBar.searchTextField resignFirstResponder];
    }
    ///点击回车 相当于点击了搜索按钮 搜索数据
    if ([searchTextfield.searchTextField.text isNotBlank]) {
        ///输入框有数据
        [self beginToSearch:searchTextfield.searchTextField.text keywordSource:@"手动搜索"];
        
    } else {//默认收拾
        NSString *placeStr = self.placeholder;
        if (placeStr.length <= 0) {
            return NO;
        }
        [self beginToSearch:placeStr keywordSource:@"默认搜索"];
    }
    [self sa_tracking_SearchBtnAction];
    return YES;
}

- (void)searchTextfieldTextDidChange:(JHSearchTextfield *)searchTextfield searchFieldText:(NSString *)searchTextfieldText {
    if (searchTextfieldText.length>0) {
        [self.associateView showAssociateViewWithKeyword:searchTextfieldText currentPageIndex:0];
    }else{
        self.associateView.hidden = YES;
    }
    
    ///当搜索框内文字为空时 显示默认搜索页 隐藏 结果页
    NSString *text = searchTextfield.searchTextField.text;
    if (text.length > 0) {
        [self.searchBar hidePlaceholder];
    }
}

#pragma mark - JHHotSearchCellDelegate
///历史记录 和 热门记录 点击
- (void)clickHotLabelChangeValue:(NSString*)hotTitle searchWordsType:(SearchWordsType)searchWordsType andindex:(NSInteger)index{
    if (searchWordsType == SearchWordsTypeHistory) {
        [self beginToSearch:hotTitle keywordSource:@"历史搜索"];
    }else{
        JHSearchRecommendKeyWordModel * model = self.serchRecommendModel.operationSubjectResponses[index];
        if (model.target) {
            JHRouterModel* router = [JHRouterModel mj_objectWithKeyValues:model.target];
            [JHRouterManager deepLinkRouter:router];
        }else{
            [self beginToSearch:model.name keywordSource:@"热门搜索"];
        }
        
    }
}
///历史记录展开更多点击
- (void)expandBtnAction{
    self.isExpand = YES;
    [self.tableViewSearch reloadData];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        JHHotSearchCell * cell = [[JHHotSearchCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"JHHotSearchCell" withArr:self.histroyArr withHotTagArr:NULL andSearchType:SearchWordsTypeHistory andisexpandL:self.isExpand];
        [cell.line setHidden:YES];
        CGSize size = [cell fittedSize];
        
        cell.indexpath = indexPath;
        _cellHeight = size.height;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1){
        JHHotSearchCell * cell = [[JHHotSearchCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"JHHotSearchCell1" withArr:NULL withHotTagArr:[NSMutableArray arrayWithArray:self.serchRecommendModel.operationSubjectResponses] andSearchType:SearchWordsTypeHot andisexpandL:YES];
        CGSize size = [cell fittedSize];
        
        cell.indexpath = indexPath;
        _cellHeight = size.height;
        cell.delegate = self;
        return cell;
    }else if(indexPath.section == 2){
        JHSearchRecommendListCell * cell = [[JHSearchRecommendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHSearchRecommendListCell" withModel:self.serchRecommendModel];
        cell.fromStr = [self fromPageString];
        return cell;
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if (self.histroyArr.count == 0){
            return 0;
        }
        return _cellHeight;
    }else if(indexPath.section == 1){
        return _cellHeight;
    }else if(indexPath.section == 2){
        if (self.serchRecommendModel.hotLiveResponses.count==0 && self.serchRecommendModel.hotShopResponses.count==0) {
            return 0;
        }
        return 751;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        if (self.histroyArr.count == 0){
            return 0;
        }
        return 47;
    }else if(section == 1){
        if (self.serchRecommendModel.operationSubjectResponses.count>0) {
            return 47;
        }else{
            return 0;
        }
    }
    return 15;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==0){
        JHSearchHeaderView * HotSearchView = [[JHSearchHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 47) withTitleName:@"历史记录"];
        HotSearchView.userInteractionEnabled = YES;
        UIButton *btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW - 40, 5, 30, 37)];
        [btnCancel setImage:[UIImage imageNamed:@"dis_searchDelete"] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(clickRemoveHistory:) forControlEvents:UIControlEventTouchUpInside];
        [HotSearchView addSubview:btnCancel];
        return HotSearchView;
    }else if(section==1){
        //searchHistory_refresh   searchHistory_more
        JHSearchHeaderView * historySearchView = [[JHSearchHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 47) withTitleName:@"热门搜索"];
        return historySearchView;
    }
    return [UIView new];
}


#pragma mark - Lazy
- (JHSearchTextfield *)searchBar {
    if (!_searchBar) {
        _searchBar = [[JHSearchTextfield alloc] initWithFrame:CGRectMake(itemWidth, UI.statusBarHeight+(44-searchBarH)/2, searchBarW, searchBarH)];
        _searchBar.backgroundColor = UIColor.whiteColor;
        _searchBar.layer.borderWidth = 1.5;
        _searchBar.layer.borderColor = HEXCOLOR(0xFFD70F).CGColor;
        _searchBar.layer.cornerRadius = searchBarH/2;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.textColor = HEXCOLOR(0x333333);
        _searchBar.font = [UIFont fontWithName:kFontNormal size:13];
        _searchBar.delegate = self;
    }
    return _searchBar;
}


- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(ScreenWidth - itemWidth - 6, 0, itemWidth, cancelWidth);
        _cancelBtn.centerY = self.searchBar.centerY;
        [_cancelBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"222222"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


- (NSMutableArray *)histroyArr {
    if (!_histroyArr) {
        _histroyArr = [NSMutableArray arrayWithArray:[CSearchKeyModel loadHistoryList]];
    }
    return _histroyArr;
}


///埋点
- (void)sa_tracking_SearchBtnAction{
    [JHTracking trackEvent:@"searchBarClick" property:@{@"model_name":@"搜索按钮",@"page_position":[self fromPageString]}];
}
- (NSString *)fromPageString{
    if (self.fromSource == JHSearchFromStore) {
        return @"商城搜索中间页";;
    }else if(self.fromSource == JHSearchFromLive){
        return @"直播搜索中间页";;
    }
    return @"";
}
@end
