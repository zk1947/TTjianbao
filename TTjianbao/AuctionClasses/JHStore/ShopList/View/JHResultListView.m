//
//  JHResultListView.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHResultListView.h"
#import "JHShoplistTableCell.h"
#import <MJRefresh.h>
#import "JHRefreshGifHeader.h"
#import "YDRefreshFooter.h"
#import "JHShopListMode.h"
#import "JHSellerInfo.h"
#import "UIView+Blank.h"

@interface JHResultListView ()<UITableViewDelegate, UITableViewDataSource, JHShoplistTableCellDelegate>

@property (nonatomic, strong) UITableView *resultTableView;
@property (nonatomic, strong) YDRefreshFooter *refreshFooter;
@property (nonatomic, strong) JHShopListMode *listModel;

@property (nonatomic, assign) NSInteger page;

@end

@implementation JHResultListView

- (instancetype)init {
    self = [super init];
    if (self) {
        _listModel = [[JHShopListMode alloc] init];
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _listModel = [[JHShopListMode alloc] init];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    _resultTableView = ({
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.backgroundColor = HEXCOLOR(0xF7F7F7);
        table.delegate = self;
        table.dataSource = self;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
        [table registerClass:[JHShoplistTableCell class] forCellReuseIdentifier:@"JHShoplistTableCellResultIdentifer"];
        table.mj_footer = self.refreshFooter;
        table.estimatedRowHeight = 0;
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        table;
    });
    
    [self addSubview:_resultTableView];
    
    [_resultTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"JHShoplistTableCellResultIdentifer";
    JHShoplistTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.sellerInfo = _listModel.list[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listModel.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHSellerInfo *model = _listModel.list[indexPath.row];
    if (model.goodsArray.count > 0) {
        return model.cellheight;
    }
    return 55+10;
}

#pragma mark - JHShoplistTableCellDelegate
- (void)focusShop:(JHSellerInfo *)model {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    ///发送关注请求
    [self focusRequest:model];
}

#pragma mark -
#pragma mark - 网络请求

- (void)refresh {
    if (_listModel.isLoading) {
        return;
    }
    _listModel.willLoadMore = NO;
    _page = 1;
    [self sendSearchRequest];
}

- (void)refreshMore {
    if (_listModel.isLoading) {
        return;
    }
    _listModel.willLoadMore = YES;
    _page ++;
    [self sendSearchRequest];
}

- (void)sendSearchRequest {
    if (_listModel.isFirstReq && _listModel.list.count == 0) {
        [self beginLoading];
    }
    @weakify(self);
    DDLogDebug(@"获取全部话题列表页");
    ///获取店铺列表数据
    [HttpRequestTool getWithURL:[_listModel toSearchUrlWithKey:_keyword] Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self);
        [self endLoading];
        [self endRefresh];
        if (respondObject.data) {
            ///店铺的数据 生成模型
            NSArray *dataList = [JHSellerInfo mj_objectArrayWithKeyValuesArray:respondObject.data];
            if (!dataList) {
                dataList = [NSArray array];
            }
            JHShopListMode *model = [[JHShopListMode alloc] init];
            model.list = dataList.mutableCopy;
            [self configModel:dataList];
            [self.resultTableView reloadData];

            if (self.listModel.canLoadMore) {
                [self.refreshFooter endRefreshing];
            } else {
                [self.refreshFooter endRefreshingWithNoMoreData];
            }
        }
        else {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }
        [self showBlankView:NO];
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        [self showBlankView:YES];
    }];
}

///关注按钮的网络请求
- (void)focusRequest:(JHSellerInfo *)sellerInfo {
    NSString *urlStr = [sellerInfo.follow_status integerValue] ? @"unfollow_bus" : @"follow_bus";
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v1/shop/%@"), urlStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sellerInfo.seller_id forKey:@"seller_id"];
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self praseData:sellerInfo];
        [UITipView showTipStr:respondObject.message];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [UITipView showTipStr:respondObject.message];
    }];
}

///处理关注后的数据
- (void)praseData:(JHSellerInfo *)info {
    if ([info.fans_num isPureInt]) {
        if ([info.follow_status integerValue]) {
            ///需要取消关注
            info.fans_num = @([info.fans_num integerValue] - 1).stringValue;
            info.fans_num_int = info.fans_num_int - 1;
        }
        else {
            info.fans_num = @([info.fans_num integerValue] + 1).stringValue;
            info.fans_num_int = info.fans_num_int + 1;
        }
    }
    info.follow_status = @(![info.follow_status integerValue]);
    ///刷新cell
    NSInteger index = [self.listModel.list indexOfObject:info];
    [self.resultTableView reloadRow:index inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    ///通知全部店铺界面刷新数据
    [JHNotificationCenter postNotificationName:ShopRefreshDataNotication object:info];
}

- (void)configModel:(NSArray *)array {
    if (_listModel.willLoadMore) {
        [_listModel.list addObjectsFromArray:array];
    } else {
        _listModel.list = [NSMutableArray arrayWithArray:array];
    }
    _listModel.canLoadMore = array.count > 0;
}

- (YDRefreshFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
        _refreshFooter.autoTriggerTimes = YES; //每次拖拽只发送一次请求
    }
    return _refreshFooter;
}

- (void)endRefresh {
    [_resultTableView.mj_header endRefreshing];
    [_resultTableView.mj_footer endRefreshing];
}

- (void)setKeyword:(NSString *)keyword {
    _keyword = keyword;
    if (!keyword) {
        return;
    }
    _listModel.willLoadMore = NO;

    if (![keyword isNotBlank]) {
        [_listModel.list removeAllObjects];
        [_resultTableView reloadData];
        return;
    }
    [self sendSearchRequest];
}

- (void)changeSellerInfos:(JHSellerInfo *)sellerInfo {
    [_listModel.list enumerateObjectsUsingBlock:^(JHSellerInfo *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (sellerInfo.seller_id == obj.seller_id) {
            obj.fans_num = sellerInfo.fans_num;
            obj.follow_status = sellerInfo.follow_status;
            [_resultTableView reloadData];
            *stop = YES;
        }
    }];
}

- (void)showBlankView:(BOOL)hasError {
    @weakify(self);
    [self.resultTableView configBlankType:YDBlankTypeNoShopList hasData:_listModel.list.count > 0 hasError:NO offsetY:hasError reloadBlock:^(id sender) {
        NSLog(@"点击刷新按钮");
        @strongify(self);
        [self refresh];
    }];
}


@end
