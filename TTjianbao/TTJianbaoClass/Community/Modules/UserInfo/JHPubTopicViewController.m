//
//  JHUserInfoPostController.m
//  TTjianbao
//
//  Created by lihui on 2020/7/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUserInfoPostController.h"
#import "JHCommentListTableViewCell.h"
#import "JHBlankPostTableViewCell.h"
#import "JHSQPostNormalCell.h"
#import "JHSQPostDynamicCell.h"
#import "JHSQPostVideoCell.h"
#import "JHSQHelper.h"
#import "JHSQModel.h"
#import "JHSQManager.h"
#import "JHSQApiManager.h"
#import "UIView+Blank.h"
#import "CommAlertView.h"
#import "JHCollectionView.h"
#import "JHCollectionItemModel.h"
#import "JHPubTopicViewController.h"
#import "NTESGrowingInternalTextView.h"
#import "JHEasyInputTextView.h"

@interface JHPubTopicViewController () <UITableViewDelegate, UITableViewDataSource, JHDetailCollectionDelegate>

@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) NSMutableArray<JHPostData *> *postArray;
@property (nonatomic, strong) NSMutableArray<NSURL *> *videoUrlArray; //所有视频url
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger lastId;
///是否是第一次请求
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSIndexPath *toCommentIndexPath; //将要对这条帖子进行评论
@end

@implementation JHPubTopicViewController

- (NSMutableArray<JHPostData *> *)postArray {
    if (!_postArray) {
        _postArray = [NSMutableArray new];
    }
    return _postArray;
}

- (NSMutableArray<NSURL *> *)videoUrlArray {
    if (!_videoUrlArray) {
        _videoUrlArray = [NSMutableArray new];
    }
    return _videoUrlArray;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isLoading = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNaviBar];
    self.naviBar.backgroundColor = [UIColor whiteColor];
    self.naviBar.title = [NSString stringWithFormat:@"#%@", _titleString];
    self.naviBar.bottomLine.hidden = NO;
    
    self.view.backgroundColor = kColorF5F6FA;
    _lastId = 0;
    [self createTableView];
    [self refreshData];
    [self registerPlayer];
    [self addObserver];
}

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
    [self initPlayerWithListView:self.contentTableView controlView:[JHBaseControlView new]];
    self.section = 0;
    self.singleTapBack = ^(NSIndexPath * _Nonnull indexPath) {
        //单击进详情
        @strongify(self);
        JHPostData *data = self.postArray[indexPath.row];
        NSDictionary *params = @{@"plate_id":data.plate_info.ID,
                                 @"page_from":JHFromUserInfo
        };
        [JHGrowingIO trackEventId:JHTrackSQPlateVideoEnter variables:params];
        
        [JHRouterManager pushPostDetailWithItemType:data.item_type itemId:data.item_id pageFrom:JHFromUserInfo scrollComment:0];
    };
    
    self.getCoverImage = ^UIImage * _Nonnull(NSIndexPath * _Nonnull indexPath) {
        //获取封面图
        @strongify(self)
        return self.postArray[indexPath.row].video_info.coverImage;
    };
}

- (void)createTableView {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, kScreenWidth, kScreenHeight - UI.statusAndNavBarHeight) style:UITableViewStylePlain];
    table.backgroundColor = kColorF5F6FA;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.tableFooterView = [UIView new];
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentTableView = table;
    
    NSArray *cellNames = @[NSStringFromClass([JHSQPostNormalCell class]),
                           NSStringFromClass([JHSQPostDynamicCell class]),
                           NSStringFromClass([JHSQPostVideoCell class]),
                           NSStringFromClass([YDBaseTableViewCell class]),
                           NSStringFromClass([JHBlankPostTableViewCell class])];
    [JHSQHelper configTableView:_contentTableView cells:cellNames];
    table.backgroundColor = kColorF5F6FA;

    @weakify(self);
    table.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshData];
    }];
    table.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];
}
#pragma mark -
#pragma mark - UITableViewDelegate / UITableViewSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postArray.count;
}

- (void)deleteArticle:(NSInteger)index {
    JHPostData *data = self.postArray[index];
    [JHSQApiManager deleteRequestAsAuthor:data reasonId:nil block:^(id  _Nullable respObj, BOOL hasError) {
        [UITipView showTipStr:@"帖子删除成功"];
    }];
}

- (void)cancelLike:(NSInteger)index {
    JHPostData *data = self.postArray[index];
    [JHSQApiManager sendUnLikeRequest:data block:^(RequestModel *respObj, BOOL hasError) {
        if (!hasError) {
            [UITipView showTipStr:@"删除成功"];
            [self.postArray removeObject:data];
            [self.contentTableView reloadData];
            [JHNotificationCenter postNotificationName:kUpdateUserCenterInfoNotification object:@{@"likeNum":@(-1)}];
        }
        else {
            [UITipView showTipStr:respObj.message?:@"删除失败"];
        }
    }];
}

- (void)toDeletePost:(NSInteger)index {
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"确认要删除吗？" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
            [self deleteArticle:index];
    };
    
    alert.cancleHandle = ^{

    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHPostData *data = self.postArray[indexPath.row];
    if (data.show_status == JHPostDataShowStatusDelete) {
        JHBlankPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHBlankPostTableViewCell class]) forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.postData = data;
        @weakify(self);
        cell.deleteBlock = ^(NSInteger index) {
            @strongify(self);
            [self toDeletePost:index];
        };
        return cell;
    }
    
    switch (data.item_type) {
        case JHPostItemTypePost: {
            JHSQPostNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostNormalCell class]) forIndexPath:indexPath];
            cell.pageType = JHPageTypeUserInfoPublishTab;
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
            cell.pageType = JHPageTypeUserInfoPublishTab;
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
        case JHPostItemTypeVideo:
        {
            JHSQPostVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostVideoCell class]) forIndexPath:indexPath];
            cell.pageType = JHPageTypeUserInfoPublishTab;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHPostData *data = self.postArray[indexPath.row];
    if (data.show_status == JHPostDataShowStatusDelete) {
        CGFloat height = data.is_self ?  137.f : 104.f;
        return height;
    }
    
    Class curClass = [JHSQHelper cellClassWithItemType:data.item_type];
    if (curClass) {
        return [self.contentTableView cellHeightForIndexPath:indexPath
                                                model:data
                                              keyPath:@"postData"
                                            cellClass:curClass
                                     contentViewWidth:kScreenWidth];
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark -
#pragma mark - Data

- (void)refreshData {
    _isLoading = YES;
    self.page = 1;
    [self loadData:YES];
}

- (void)loadMoreData {
    self.page ++;
    [self loadData:NO];
}

- (void)loadData:(BOOL)isRefresh {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"topic_id"] = @(self.itemId.integerValue);
    params[@"user_id"] = @(self.userId.integerValue);
    params[@"q"] = @"";  //q直接给空
    params[@"page"] = @(self.page);
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/v1/bbs/search")  Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray<JHPostData *> *list = [NSArray modelArrayWithClass:[JHPostData class] json:respondObject.data[@"post_list"]];
        self.isLoading = NO;
        self.lastId = [respondObject.data[@"last_id"] integerValue];

        if (self.page == 1) {
            self.postArray = [NSMutableArray arrayWithArray:list];
        }else{
            [self.postArray addObjectsFromArray:list];
        }
        
        if (list > 0) {
            self.page += 1;
            [self.contentTableView.mj_footer endRefreshing];
        }else{
            [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.contentTableView.mj_header endRefreshing];
        [self.contentTableView reloadData];
        
        ///展示暂无数据的page
        [self showBlankView:self.postArray.count];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self.contentTableView.mj_header endRefreshing];
        [self.contentTableView.mj_footer endRefreshing];
        [self showBlankView:self.postArray.count];
    }];
}

- (void)configDataList:(NSArray<JHPostData *> *)dataList {
    if (dataList.count <= 0) {
        return;
    }
    NSMutableArray<JHPostData *> *postList = [NSMutableArray new];
    NSMutableArray<NSURL *> *urlList = [NSMutableArray new];
    
    for (JHPostData *data in dataList) {
        //配置帖子内容
        BOOL isNormal = data.item_type == JHPostItemTypePost;
        //动态&短视频内容为空时，赋默认值
        if (data.item_type == JHPostItemTypeDynamic ||
            data.item_type == JHPostItemTypeVideo ||
            data.item_type == JHPostItemTypeAppraisalVideo) {
            if (![data.content isNotBlank]) {
                data.content = @"分享内容";
            }
        }
        [data configPostContent:data.content isNormal:isNormal];
        
        [postList addObject:data];
        
        //配置视频url
        if (data.item_type == JHPostItemTypeVideo || data.item_type == JHPostItemTypeAppraisalVideo) {
            [urlList addObject:[NSURL URLWithString:data.video_info.url]];
        } else {
            [urlList addObject:[NSURL URLWithString:@""]];
        }
    }
    
    [self.postArray addObjectsFromArray:postList];
    [self.videoUrlArray addObjectsFromArray:urlList];
    self.playVideoUrls = self.videoUrlArray;
}

- (void)showBlankView:(NSInteger)count {
    if (count == 0) {
        [self showDefaultImageWithView:self.view];
    }
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
        [self.postArray removeObject:data];
        [self.contentTableView reloadData];
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
    JHPostData *data = self.postArray[_toCommentIndexPath.row];
    @weakify(self);
    [JHSQApiManager sendComment:commentInfos postData:data block:^(JHCommentData * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (respObj) {
            data.comment_num++;
            [self.contentTableView reloadData];
        }
    }];
}

///有时候传进来的不是字符串 导致 isEqualToString  crash
- (void)setUserId:(NSString *)userId
{
    if(!IS_STRING(userId))
    {
        userId = [NSString stringWithFormat:@"%@",userId];
    }
    _userId = userId;
}
@end
