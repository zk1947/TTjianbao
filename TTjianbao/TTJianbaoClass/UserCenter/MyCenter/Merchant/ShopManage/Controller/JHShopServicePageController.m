//
//  JHShopServicePageController.m
//  TTjianbao
//
//  Created by lihui on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHShopServicePageController.h"
#import "JHShopServiceCell.h"
#import "JHRefreshGifHeader.h"
#import "JHShopServiceInfo.h"
#import "UIView+Blank.h"

@interface JHShopServicePageController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <JHShopServiceInfo *>*listArray;
@end

@implementation JHShopServicePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务剩余时间";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavView.mas_bottom);
        make.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    
    [self refreshData];
}

- (void)refreshData {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/app/personal/businessLineTimes") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        [self.tableView.mj_header endRefreshing];
        NSArray *list = [JHShopServiceInfo mj_objectArrayWithKeyValuesArray:respondObject.data];
        self.listArray = [NSMutableArray arrayWithArray:list];
        [self.tableView reloadData];
        [self.tableView configBlankType:YDBlankTypeNone hasData:self.listArray.count hasError:NO reloadBlock:nil];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [UITipView showTipStr:respondObject.message];
        [self.tableView configBlankType:YDBlankTypeNone hasData:NO hasError:YES reloadBlock:nil];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHShopServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHShopServiceCell"];
    cell.serviceModel = self.listArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf8f8f8);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[JHShopServiceCell class] forCellReuseIdentifier:@"JHShopServiceCell"];
        @weakify(self);
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self refreshData];
        }];
    }
    return _tableView;
}
@end
