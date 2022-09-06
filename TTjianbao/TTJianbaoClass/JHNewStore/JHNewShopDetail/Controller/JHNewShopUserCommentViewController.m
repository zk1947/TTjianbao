//
//  JHNewShopUserCommentViewController.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopUserCommentViewController.h"
#import "YYControl.h"
#import "JHNewUserCommentTableViewCell.h"
#import "JHNewShopUserCommentModel.h"
#import "JHNewShopUserCommentViewModel.h"
#import <MJRefresh.h>
#import "YDRefreshFooter.h"
#import "JHNewShopCommentTitleTagsView.h"


@interface JHNewShopUserCommentViewController ()<UITableViewDelegate,UITableViewDataSource,JHNewUserCommentTableViewCellDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) JHNewShopUserCommentViewModel *commentViewModel;
@property (nonatomic, strong) JHNewShopCommentTitleTagsView *tagTitleView;
@property (nonatomic, strong) NSMutableArray *dataListArray;
@property (nonatomic, copy) NSString *tagCodeString;//all("全部"), hasImg("有图")

@end

@implementation JHNewShopUserCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tagCodeString = @"all";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self updateLoadData:YES selectedTag:NO];
    [self configData];

}

#pragma mark - UI
- (void)setupHeaderView{
    [self.tagTitleView removeFromSuperview];
    [self.view addSubview:self.tagTitleView];
    [self.tagTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(35);
    }];

}
#pragma mark - LoadData
//刷新数据
- (void)updateLoadData:(BOOL)isRefresh selectedTag:(BOOL)isSelectedTag{
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"sellerId"] = @([self.shopInfoModel.customerId longValue]);
    dicData[@"tagCode"] = self.tagCodeString;
    dicData[@"isRefresh"] = @(isRefresh);
    dicData[@"isSelectedTag"] = @(isSelectedTag);
    [self.commentViewModel.shopUserCommentCommand execute:dicData];
}

//加载更多数据
- (void)loadMoreData{
    [self updateLoadData:NO selectedTag:NO];
}

- (void)configData{
    @weakify(self)
    //刷新数据
    [self.commentViewModel.updateShopSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x boolValue]) {//YES 为刷新
            if ([self.commentViewModel.userCommentModel.commentCount integerValue] > 0) {
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(35, 0, 0, 0));
                }];
                if ([self.commentViewModel.userCommentModel.countCommentsWithImg integerValue] > 0) {
                    self.tagTitleView.tagArray = @[[NSString stringWithFormat:@"全部 (%@)",[self.commentViewModel.userCommentModel.commentCount integerValue] > 999?@"999+" : self.commentViewModel.userCommentModel.commentCount], [NSString stringWithFormat:@"有图 (%@)",[self.commentViewModel.userCommentModel.countCommentsWithImg integerValue] > 999?@"999+" : self.commentViewModel.userCommentModel.countCommentsWithImg]];
                }else{
                    self.tagTitleView.tagArray = @[[NSString stringWithFormat:@"全部 (%@)",[self.commentViewModel.userCommentModel.commentCount integerValue] > 999?@"999+" : self.commentViewModel.userCommentModel.commentCount]];
                }
                [self setupHeaderView];

            }else{
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
                }];
            }
        }
        [self.tableView.mj_footer endRefreshing];

        //刷新数据，判断空页面
        [self.tableView jh_reloadDataWithEmputyView];
        if (self.commentViewModel.commentDataArray.count > 6) {
            ((YDRefreshFooter *)_tableView.mj_footer).showNoMoreString = YES;
        }
    }];
    //加载更多数据
    [self.commentViewModel.moreShopSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];

    }];
    //没有更多数据
    [self.commentViewModel.noMoreDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    //请求出错
    [self.commentViewModel.errorRefreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - Action


#pragma mark - Delegate
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentViewModel.commentDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JHNewUserCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHNewUserCommentTableViewCell class])];
    if (!cell) {
        cell = [[JHNewUserCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHNewUserCommentTableViewCell class])];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (self.commentViewModel.commentDataArray) {
        cell.commentListModel = self.commentViewModel.commentDataArray[indexPath.row];
    }

    return cell;
}

#pragma mark - JHNewUserCommentTableViewCellDelegate
- (void)clickUnfoldButtonAction:(JHNewUserCommentTableViewCell *)commentCell{
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:commentCell];
    
    JHNewShopUserCommentListModel *newModel = self.commentViewModel.commentDataArray[indexPath.row];
    newModel.isShowMore = !newModel.isShowMore;

    [UIView setAnimationsEnabled:NO];
    [self.tableView beginUpdates];
    
    //更新cell，更新model里isShowMore的改变
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
    
}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

#pragma mark - Lazy
- (JHNewShopUserCommentViewModel *)commentViewModel{
    if (!_commentViewModel) {
        _commentViewModel = [[JHNewShopUserCommentViewModel alloc] init];
    }
    return _commentViewModel;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXCOLOR(0xF8F8F8);
        [_tableView registerClass:[JHNewUserCommentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHNewUserCommentTableViewCell class])];
        _tableView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
            _tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
            _tableView.scrollIndicatorInsets =_tableView.contentInset;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }

    }
    return  _tableView;
}
- (JHNewShopCommentTitleTagsView *)tagTitleView{
    if (!_tagTitleView) {
        _tagTitleView = [[JHNewShopCommentTitleTagsView alloc] init];
        @weakify(self)
        _tagTitleView.tagSelectedBlock = ^(id obj) {
            @strongify(self)
            NSNumber *tagIndex = (NSNumber*)obj;
            if ([tagIndex intValue] == 0) {
                self.tagCodeString = @"all";
            }else{
                self.tagCodeString = @"hasImg";
            }
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];

            //更新数据
            [self updateLoadData:YES selectedTag:YES];
        };
    }
    return _tagTitleView;
}

- (NSMutableArray *)dataListArray{
    if (!_dataListArray) {
        _dataListArray = [NSMutableArray array];
    }
    return _dataListArray;
}
@end
