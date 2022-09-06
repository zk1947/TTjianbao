//
//  JHOrderListView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/24.
//  Copyright © 2019年 Netease. All rights reserved.
//
#import "UIView+NTES.h"
#import "JHOrderListView.h"
#import "JHOrderListAlertCell.h"
#import "TTjianbaoHeader.h"

#import "CustomToolsBar.h"

@interface JHOrderListView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CustomToolsBar *navbar;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;


@end

@implementation JHOrderListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}



- (void)makeUI {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    [self addSubview:self.backView];
    
    self.navbar = [[CustomToolsBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50-1)];
    [self.backView addSubview:_navbar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.navbar.bounds];
    label.text = @"订单列表";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = HEXCOLOR(0x222222);
    label.font = [UIFont systemFontOfSize:16];
    [self.navbar addSubview:label];
    
    [self.backView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backView).insets(UIEdgeInsetsMake(CGRectGetMaxY(self.navbar.frame)+1, 0, UI.bottomSafeAreaHeight, 0));
        
    }];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"icon_alert_close"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navbar addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navbar);
        make.trailing.equalTo(self.navbar);
        make.width.height.equalTo(@50);
    }];
    
    
}




#pragma mark - GET

- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.frame = CGRectMake(0, ScreenH-290./375.*ScreenW, ScreenW, 290./375.*ScreenW);
    }
    
    return _backView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHOrderListAlertCell class]) bundle:nil] forCellReuseIdentifier:@"JHOrderListAlertCell"];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 45;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadOneData)];
        _tableView.mj_header = header;
        
        JHRefreshNormalFooter *footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.mj_footer = footer;
        
    }
    return _tableView;
}


- (void)backAction{
    [self hiddenAlert];
}
#pragma mark - UITableViewDelegate UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    JHOrderListAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHOrderListAlertCell"];
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}



- (void)btnAction:(UIButton *)btn {
    
}




- (UIImageView *)creatLine {
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_cell_separator"]];
    img.mj_x = 15;
    img.mj_y = 45 - img.mj_h;
    img.mj_w = ScreenW - 15;
    return img;
}

#pragma mark -

#pragma mark - 请求数据
- (void)loadOneData {
    _pageNo = 0;
    _pageSize = 10;
    [self requestList];
}

- (void)loadMoreData {
    _pageNo ++;
    _pageSize = 10;
    [self requestList];
}



- (void)requestList {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"searchStatus"] = @"all";
    dic[@"pageNo"] = @(self.pageNo);
    dic[@"pageSize"] = @(self.pageSize);
    NSString *url = @"";
    if(self.roleType == 0)
    {
        url = @"/order/auth/waitAppraiseNew";
    }
    else
    {
        if (_isAndience) {
            url = @"/order/auth/buyerOrderList";
            dic[@"isAssistant"] = @(self.isAssistant);

        }else {
            url = @"/order/auth/sellerOrderList";
            dic[@"isLive"] = @(1);
            dic[@"isAssistant"] = @(self.isAssistant);
        }
    }

    [HttpRequestTool getWithURL:FILE_BASE_STRING(url) Parameters:dic successBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        NSArray *array = [OrderMode mj_objectArrayWithKeyValuesArray:respondObject.data];
        [self dealDataWithDic:array];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        [self makeToast:respondObject.message];
    }];
}


- (void)endRefresh {
    if (self.pageNo<=0) {
        [_tableView.mj_header endRefreshing];
        
    }else {
        [_tableView.mj_footer endRefreshing];
        
    }
}
- (void)dealDataWithDic:(NSArray *)arr {
    if (arr.count) {
        if (self.pageNo == 0) {
            self.dataArray = [NSMutableArray arrayWithArray:arr];
        }else {
            [self.dataArray addObjectsFromArray:arr];
        }
        
    }else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView reloadData];
}
#pragma mark -

- (void)showAlert {
    CGRect rect = self.backView.frame;
    self.backView.mj_y = ScreenH;
    
    rect.origin.y = ScreenH - rect.size.height;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.frame = rect;
    }];
    [self loadOneData];
}



- (void)hiddenAlert {
    CGRect rect = self.backView.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.frame = rect;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)hiddenAlertCompletion:(void (^)(BOOL))completion {
    CGRect rect = self.backView.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        completion(finished);
    }];
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hiddenAlert];
}


@end
