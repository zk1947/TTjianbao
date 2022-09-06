//
//  JHSQSearchViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2020/7/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQSearchViewController.h"
#import "JHSQHelper.h"
#import "JHSQApiManager.h"
#import "JHSQPostNormalCell.h"
#import "JHSQPostDynamicCell.h"
#import "JHSQPostVideoCell.h"
#import "JHSearchTextfield.h"
#import "JHSearchRespModel.h"
#import "UIView+Blank.h"
#import "JHEasyInputTextView.h"

#define kLeftSpace 40
#define kRightSpace 15
#define kSearchBarWidth  (ScreenW - kLeftSpace - kRightSpace)
#define itemWidth 44.f
#define itemHeight 30.f
#define searchBarH 28.f
#define searchBarW (ScreenWidth - itemWidth - 50-10)
#define cancelWidth 18.0f
@interface JHSQSearchViewController () <JHSearchTextfieldDelegate>

//feed流<帖子>数据模型
@property (nonatomic, strong) JHSQModel *curModel;

@property (nonatomic, strong) JHSearchRespModel *respModel;

//版块数据
@property (nonatomic, strong) NSMutableArray<JHPlateListData *> *plateList;
//帖子上传
@property (nonatomic, strong) JHSQUploadView *uploadView;

@property (nonatomic, strong) UIButton *backButton; ///返回按钮
@property (nonatomic, strong) UIButton *searchButton; ///
@property (nonatomic, strong) JHSearchTextfield *searchBar;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) NSIndexPath *toCommentIndexPath; //将要对这条帖子进行评论
@end

@implementation JHSQSearchViewController

#pragma mark -
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    
    _curModel = [[JHSQModel alloc] init];
    _plateList = [[NSMutableArray alloc] init];
    
    self.respModel = [[JHSearchRespModel alloc]init];
    self.respModel.section_id = self.section_id;
    self.respModel.user_id = self.user_id;
    self.respModel.topic_id = self.topic_id;
    
    [self configNaviBar];
    [self configTableView];
    [self registerPlayer];
    [self addObserver];
   // [self refresh];
}

#pragma mark -
#pragma mark - UI
- (void)configNaviBar {
//    [self initToolsBar];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//      [self.navbar.comBtn addTarget :self action:@selector(backAction)  forControlEvents:UIControlEventTouchUpInside];
    [self showNavView];
    [self.jhNavView addSubview:self.searchBar];
    [self.jhNavView addSubview:self.searchButton];
}
- (JHSearchTextfield *)searchBar {
    if (!_searchBar) {
        _searchBar = [[JHSearchTextfield alloc] initWithFrame:CGRectMake(50, UI.statusBarHeight+(44-searchBarH)/2, searchBarW, searchBarH)];
        _searchBar.backgroundColor = kColorF5F6FA;
        _searchBar.layer.cornerRadius = _searchBar.height/2;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.placeholder = self.placeholder ? : @"";
        _searchBar.textColor = [UIColor blackColor];
        _searchBar.font = [UIFont fontWithName:kFontNormal size:13];
        _searchBar.delegate = self;
        [_searchBar.searchTextField becomeFirstResponder];
    }
    return _searchBar;
}
- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(ScreenW - itemWidth - 10, 0, itemWidth, cancelWidth);
        _searchButton.centerY = self.searchBar.centerY;
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_searchButton addTarget:self action:@selector(searchData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}
-(UIView*)getHeaderView{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    self.headerView.backgroundColor=[UIColor whiteColor];
    self.countLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, ScreenW-15, 30)];
    self.countLabel.text=@"";
    self.countLabel.backgroundColor=[UIColor whiteColor];
    self.countLabel.font=[UIFont fontWithName:kFontMedium size:15];
    self.countLabel.textColor=kColor333;
    self.countLabel.numberOfLines = 1;
    self.countLabel.textAlignment = NSTextAlignmentLeft;
    self.countLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [ self.headerView addSubview: self.countLabel];
    
    return self.headerView;
}
#pragma mark -
#pragma mark - Observer
- (void)addObserver {
    @weakify(self);
    
    //静音开关通知
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kMuteStateChangedNotication object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self setIsVideoMute:[JHSQManager isMute]];
    }];
}

#pragma mark - player
- (void)registerPlayer {
    
    @weakify(self);
    [self initPlayerWithListView:self.tableView controlView:[JHBaseControlView new]];
    self.section = 1;
    
    self.singleTapBack = ^(NSIndexPath * _Nonnull indexPath) {
        //单击进详情
        @strongify(self);
        JHPostData *data = self.curModel.list[indexPath.row];
        NSDictionary *params = @{@"plate_id":data.plate_info.ID,
                                 @"page_from":JHFromSQSearchResult
        };
        [JHGrowingIO trackEventId:JHTrackSQPlateVideoEnter variables:params];
        [JHRouterManager pushPostDetailWithItemType:data.item_type itemId:data.item_id pageFrom:JHFromSQSearchBar scrollComment:0];
    };
    
    self.getCoverImage = ^UIImage * _Nonnull(NSIndexPath * _Nonnull indexPath) {
        //获取封面图
        @strongify(self)
        return self.curModel.list[indexPath.row].video_info.coverImage;
    };
}

#pragma mark
#pragma mark - UI Methods

- (void)configTableView {
    NSArray *cellNames = @[NSStringFromClass([JHSQPostNormalCell class]),
                           NSStringFromClass([JHSQPostDynamicCell class]),
                           NSStringFromClass([JHSQPostVideoCell class]),
                           NSStringFromClass([YDBaseTableViewCell class])];
    [JHSQHelper configTableView:self.tableView cells:cellNames];
    
    self.tableView.tableHeaderView = [self getHeaderView];
    self.tableView.backgroundColor=[UIColor whiteColor];
    //self.refreshFooter.showNoMoreString = YES;
    self.tableView.mj_header = self.refreshHeader;
    self.tableView.mj_footer = self.refreshFooter;
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
    
}

#pragma mark -
#pragma mark - 网络请求

- (void)refresh {
    _curModel.willLoadMore = NO;
    self.respModel.page = 1;
    [self getPostList];
}
- (void)refreshMore {
    
    _curModel.willLoadMore = YES;
    self.respModel.page ++;
    [self getPostList];
}
//获取主列表数据
- (void)getPostList {
    @weakify(self);
    [JHSQApiManager getSearchPostList:self.respModel block:^(JHSQModel * _Nullable respObj, BOOL hasError)
     {
        @strongify(self);
        [self.view endLoading];
        [self endRefresh];
        
        if (respObj) {
            [self.curModel configModel:respObj];
            self.playVideoUrls = self.curModel.videoUrls;
            [self.tableView reloadData];
            self.countLabel.text = [NSString stringWithFormat:@"共%ld条结果", (long)respObj.total_num];
            
            if (self.curModel.canLoadMore) {
                [self.refreshFooter endRefreshing];
            } else {
                [self.refreshFooter endRefreshingWithNoMoreData];
            }
            
        } else {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }
        BOOL hasData = self.curModel.list.count == 0 ? NO :YES;
        [self.view configBlankType:0 hasData:hasData hasError:NO reloadBlock:nil];
        
    }];
}

#pragma mark -
#pragma mark - <UITableViewDelegate & UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _curModel.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHPostData *data = _curModel.list[indexPath.row];
    Class curClass = Nil;
    
    if (data.item_type == JHPostItemTypePost) {
        curClass = [JHSQPostNormalCell class];
    } else if (data.item_type == JHPostItemTypeDynamic) {
        curClass = [JHSQPostDynamicCell class];
    } else if (data.item_type == JHPostItemTypeVideo || data.item_type == JHPostItemTypeAppraisalVideo) {
        curClass = [JHSQPostVideoCell class];
    }
    
    if (curClass) {
        return [self.tableView cellHeightForIndexPath:indexPath
                                                model:_curModel.list[indexPath.row]
                                              keyPath:@"postData"
                                            cellClass:curClass
                                     contentViewWidth:kScreenWidth];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHPostData *data = _curModel.list[indexPath.row];
    
    switch (data.item_type) {
        case JHPostItemTypePost: {
            JHSQPostNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostNormalCell class]) forIndexPath:indexPath];
            cell.pageType = JHPageTypePostSearch;
            cell.postData = data;
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            @weakify(self);
            cell.operationAction = ^(NSNumber *obj, JHPostData *data) {
                @strongify(self);
                JHOperationType operationType = [obj intValue];
                [self operationComplete:operationType withData:data];
                
            };
            return cell;
        }
        case JHPostItemTypeDynamic: {
            JHSQPostDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostDynamicCell class]) forIndexPath:indexPath];
            cell.pageType = JHPageTypePostSearch;
            cell.indexPath = indexPath;
            cell.postData = data;
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            
            @weakify(self);
            cell.operationAction = ^(NSNumber *obj, JHPostData *data) {
                @strongify(self);
                JHOperationType operationType = [obj intValue];
                [self operationComplete:operationType withData:data];
            };
            
            cell.inputBarClickedBlock = ^(NSIndexPath * _Nonnull indexPath, JHPostData * _Nonnull data) {
                @strongify(self);
                self.toCommentIndexPath = indexPath;
                [self showInputTextView];
            };
            return cell;
        }
        case JHPostItemTypeAppraisalVideo:
        case JHPostItemTypeVideo: {
            JHSQPostVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostVideoCell class]) forIndexPath:indexPath];
            cell.pageType = JHPageTypePostSearch;
            cell.indexPath = indexPath;
            cell.postData = data;
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            @weakify(self);
            cell.operationAction = ^(NSNumber *obj, JHPostData *data) {
                @strongify(self);
                JHOperationType operationType = [obj intValue];
                [self operationComplete:operationType withData:data];
            };
            return cell;
        }
        default: {
            YDBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YDBaseTableViewCell class]) forIndexPath:indexPath];
            return cell;
        }
    }
}


#pragma mark -
#pragma mark - JHSearchTextfieldDelegate

- (BOOL)searchTextfieldShouldReturn:(JHSearchTextfield *)searchTextfield {
    ///点击回车 相当于点击了搜索按钮 搜索数据
    [self searchData];
    return YES;
}
- (void)searchTextFieldDidBegin:(JHSearchTextfield *_Nonnull)searchTextField{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.searchBar.width=searchBarW;
    } completion:^(BOOL finished) {
        [self.searchButton setHidden:NO];
    }];
}
-(void)searchData{
    [self.searchButton setHidden:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.searchBar.width=(ScreenWidth - 50-10);
    }];
    
    self.respModel.q=self.searchBar.searchTextField.text;
    _curModel = [[JHSQModel alloc] init];
    _plateList = [[NSMutableArray alloc] init];
    [self.view endEditing:YES];
    [self refresh];
}
#pragma mark -
#pragma mark - 操作交互弹框后 刷新cell数据
-(void)operationComplete:(JHOperationType)operationType withData:(JHPostData*)data{
    
    if (operationType==JHOperationTypeColloct||
        operationType==JHOperationTypeCancleColloct) {
        data.is_collect=!data.is_collect;
    }
    if (operationType==JHOperationTypeSetGood||
        operationType==JHOperationTypeCancleSetGood) {
        data.content_level=data.content_level==1?0:1;
    }
    if (operationType==JHOperationTypeSetTop||
        operationType==JHOperationTypeCancleSetTop) {
        data.content_style=data.content_style==2?0:2;
    }
    if (operationType==JHOperationTypeNoice||
        operationType==JHOperationTypeCancleNotice) {
        data.content_style=data.content_style==3?0:3;
    }
    if (operationType==JHOperationTypeDelete) {
        [self.curModel.list removeObject:data];
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark - 评论输入框相关
- (void)showInputTextView {
    JHEasyInputTextView *easyView = [[JHEasyInputTextView alloc] initInputTextViewWithFontSize:[UIFont fontWithName:kFontNormal size:13.f] limitNum:10000 inputBackgroundColor:kColorF5F6FA maxNumbersOfLine:3 currentViewController:NSStringFromClass([JHRootController.currentViewController class])];
    easyView.showLimitNum = YES;
    [JHKeyWindow addSubview:easyView];
    [easyView show];
    @weakify(easyView);
    [easyView toPublish:^(NSDictionary * _Nonnull inputInfos) {
        @strongify(easyView);
        [easyView endEditing:YES];
        [self didSendText:inputInfos];
    }];
}

- (void)didSendText:(NSDictionary *)commentInfos {
    if ([JHSQManager needLogin]) {
        return;
    }
    
    JHPostData *data = _curModel.list[_toCommentIndexPath.row];
    @weakify(self);
    [JHSQApiManager sendComment:commentInfos postData:data block:^(JHCommentData * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (respObj) {
            self.curModel.list[_toCommentIndexPath.row].comment_num++;
            [self.tableView reloadData];
        }
    }];
}

-(void)dealloc
{
    NSLog(@"%@*************被释放",[self class])
}

@end
