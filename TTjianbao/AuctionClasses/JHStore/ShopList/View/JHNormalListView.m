//
//  JHNormalListView.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHNormalListView.h"
#import "JHShoplistTableCell.h"
#import <MJRefresh.h>
#import "JHRefreshGifHeader.h"
#import "YDRefreshFooter.h"
#import "JHShopListMode.h"
#import "JHSellerInfo.h"
#import "JHGoodsInfoMode.h"
#import "UIView+Blank.h"

@interface JHNormalListView () <UITableViewDelegate, UITableViewDataSource, JHShoplistTableCellDelegate>

@property (nonatomic, strong) UITableView *normalTableView;
@property (nonatomic, strong) JHRefreshGifHeader *refreshHeader;
@property (nonatomic, strong) YDRefreshFooter *refreshFooter;
@property (nonatomic, strong) JHShopListMode *listModel;


@end

@implementation JHNormalListView

- (instancetype)init {
    self = [super init];
    if (self) {
        _listModel = [[JHShopListMode alloc] init];
        [self initSubviews];
        [self sendRequest];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _listModel = [[JHShopListMode alloc] init];
        [self initSubviews];
        [self sendRequest];
    }
    return self;
}

- (void)initSubviews {
    _normalTableView = ({
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.backgroundColor = HEXCOLOR(0xF7F7F7);
        table.delegate = self;
        table.dataSource = self;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
        [table registerClass:[JHShoplistTableCell class] forCellReuseIdentifier:@"JHShoplistTableCell"];
        table.mj_header = self.refreshHeader;
        table.mj_footer = self.refreshFooter;
        table.estimatedRowHeight = 0;
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        table;
    });
    
    [self addSubview:_normalTableView];
    
    [_normalTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"JHShoplistTableCell";
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
    [self sendRequest];
}

- (void)refreshMore {
    if (_listModel.isLoading) {
        return;
    }
    _listModel.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest {
    if (_listModel.isFirstReq && _listModel.list.count == 0) {
        [self beginLoading];
    }
    @weakify(self);
    DDLogDebug(@"获取全部话题列表页");
    ///获取店铺列表数据
    [HttpRequestTool getWithURL:[_listModel toUrl] Parameters:nil successBlock:^(RequestModel *respondObject) {
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
            [self.listModel configModel:model];
            [self.normalTableView reloadData];
            if (self.listModel.canLoadMore) {
                [self.refreshFooter endRefreshing];
            } else {
                [self.refreshFooter endRefreshingWithNoMoreData];
            }
            
            [self showBlankView:NO];
        }
        else {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        [self showBlankView:YES];
    }];
}

#pragma mark - 关注按钮的网络请求
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
    [self.normalTableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] withRowAnimation:UITableViewRowAnimationNone];
    
    ///通知全部店铺界面刷新数据
    [JHNotificationCenter postNotificationName:ShopRefreshDataNotication object:info];
}

- (JHRefreshGifHeader *)refreshHeader {
    if (!_refreshHeader) {
        _refreshHeader = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _refreshHeader.automaticallyChangeAlpha = NO;
    }
    return _refreshHeader;
}

- (YDRefreshFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
        _refreshFooter.autoTriggerTimes = YES; //每次拖拽只发送一次请求
    }
    return _refreshFooter;
}

- (void)endRefresh {
    [_normalTableView.mj_header endRefreshing];
    [_normalTableView.mj_footer endRefreshing];
}

- (void)changeSellerInfos:(JHSellerInfo *)sellerInfo {
    [_listModel.list enumerateObjectsUsingBlock:^(JHSellerInfo *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (sellerInfo.seller_id == obj.seller_id) {
            obj.fans_num = sellerInfo.fans_num;
            obj.follow_status = sellerInfo.follow_status;
            [_normalTableView reloadData];
            *stop = YES;
        }
    }];
}

- (void)showBlankView:(BOOL)hasError {
    [self.normalTableView configBlankType:YDBlankTypeNoShopList hasData:_listModel.list.count > 0 hasError:NO offsetY:hasError reloadBlock:^(id sender) {
        NSLog(@"点击刷新按钮");
        //[self refresh];
    }];
}

@end
