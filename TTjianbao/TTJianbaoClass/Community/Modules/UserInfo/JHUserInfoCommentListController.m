//
//  JHUserInfoCommentListController.m
//  TTjianbao
//
//  Created by lihui on 2020/6/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUserInfoCommentListController.h"
#import "JHCommentListTableViewCell.h"
#import "JHUserInfoApiManager.h"
#import "JHUserInfoCommentModel.h"
#import "JHWebViewController.h"

#import "UIView+Blank.h"
#import "JHSQManager.h"
#import "JHSQApiManager.h"

@interface JHUserInfoCommentListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, assign) NSInteger page;
///是否是第一次请求
@property (nonatomic, assign) BOOL isFirstRequst, isLoading;

@end

@implementation JHUserInfoCommentListController

- (NSMutableArray *)commentArray {
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isFirstRequst = YES;
        _isLoading = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    [self createTableView];
    [self refreshData];
}

- (void)createTableView {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.backgroundColor = kColorF5F6FA;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.tableFooterView = [UIView new];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    _contentTableView = table;
    
    [table registerClass:[JHCommentListTableViewCell class] forCellReuseIdentifier:kCommentListIdentifer];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    @weakify(self);
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
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHCommentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentListIdentifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellType = indexPath.row ? JHCommentListCellTypeAsCritic : JHCommentListCellTypeAsAuthor;
    cell.commentModel = self.commentArray[indexPath.row];
    cell.indexPath = indexPath;
    @weakify(self);
    cell.deleteBlock = ^(NSInteger index) {
        @strongify(self);
        [self deletePost:index];
    };
    return cell;
}

- (void)deleteComment:(NSInteger)index {
    JHUserInfoCommentModel *model = self.commentArray[index];
    [JHSQApiManager deletePostDetailCommentWithCommentId:model.mainInfo.comment_id reasonId:@"" completeBlock:^(RequestModel *respObj, BOOL hasError) {
        if (!hasError) {
            [UITipView showTipStr:@"删除成功"];
            [self.commentArray removeObject:model];
            [self.contentTableView reloadData];
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        }
        else {
            [UITipView showTipStr:respObj.message?:@"删除评论失败"];
        }
    }];
}

- (void)deletePost:(NSInteger)index {
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"确认要删除吗？" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        [self deleteComment:index];
    };
    alert.cancleHandle = ^{

    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHUserInfoCommentModel *model = self.commentArray[indexPath.row];
    if ([model.postData.item_id isNotBlank] &&
        model.postData.show_status == JHPostDataShowStatusNormal) {
        
        [JHRouterManager pushPostDetailWithItemType:model.postData.item_type itemId:model.postData.item_id pageFrom:JHFromUserInfo scrollComment:1];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark -
#pragma mark - Data

- (void)refreshData {
    if (!_isFirstRequst) {
        return;
    }
    _isFirstRequst = NO;
    _isLoading = YES;
    self.page = 1;
    [self loadData:YES];
}

- (void)loadMoreData {
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    self.page ++;
    [self loadData:NO];
}

- (void)loadData:(BOOL)isRefresh {

    NSString *lastId = @"0";
    if (self.commentArray.count > 0) {
        JHUserInfoCommentModel *model = [self.commentArray lastObject];
        lastId = model.mainInfo.comment_id;
    }
    @weakify(self);
    [JHUserInfoApiManager getUserHistory:JHPersonalInfoTypeComment UserId:self.userId Page:self.page LastId:lastId CompleteBlock:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                RequestModel *respondObject = respObj;
                NSArray<JHUserInfoCommentModel *> *list = [NSArray modelArrayWithClass:[JHUserInfoCommentModel class] json:respondObject.data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isLoading = NO;
                    if (list.count > 0) {
                        [self.contentTableView.mj_footer endRefreshing];
                        [self.commentArray addObjectsFromArray:list];
                        [self.contentTableView reloadData];
                    }
                    else {
                        [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    
                    [self showBlankView:self.commentArray.count];
                });
            });
        }
        else {
            ///展示暂无数据的page
            [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
            [self showBlankView:self.commentArray.count];
        }
    }];
}

- (void)showBlankView:(NSInteger)count {
    if (count == 0) {
        [self showDefaultImageWithView:self.view];
    }
}

#pragma mark -
#pragma mark - 分页逻辑

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.contentTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}
- (void)dealloc {
    NSLog(@"%@*************被释放",[self class])
}


@end
