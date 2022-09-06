//
//  JHLivingCustomOrderView.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLivingCustomOrderView.h"
#import "JHLivingCustomOrderCell.h"
#import "JHCustomizeOrderModel.h"
#import "JHCustomizeOrderDetailController.h"


@interface JHLivingCustomOrderView()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger pageNum;
    NSInteger pageSize;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) UITableViewCell *emptyCell;
@end
@implementation JHLivingCustomOrderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        pageNum = 1;
        pageSize = 20;
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)setStatus:(NSString *)status{
    _status = status;
    [self loadData];
}

-(void)loadData{
    NSString *url = FILE_BASE_STRING(@"/orderCustomize/auth/orderListByChannel");
    [HttpRequestTool postWithURL:url Parameters:@{@"status":self.status,@"pageIndex":@(pageNum),@"pageSize":@(pageSize)} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        NSArray *arr = [JHCustomizeOrderModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        if (pageNum == 1) {
            self.listArray = [NSMutableArray arrayWithArray:arr];
        }else {
            [self.listArray addObjectsFromArray:arr];
        }
       if (arr.count > 0) {
            pageNum += 1;
           [self.tableView.mj_footer resetNoMoreData];
           [self.tableView.mj_footer endRefreshing];
       }else{
           [self.tableView.mj_footer endRefreshingWithNoMoreData];
       }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.listArray.count == 0) {
        return 1;
    }
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listArray.count == 0) {
        return self.tableView.height;
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listArray.count == 0) {
        return self.emptyCell;
    }
    JHLivingCustomOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHLivingCustomOrderCell class])];
    cell.model = self.listArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listArray.count == 0) {
        return;
    }
    JHCustomizeOrderModel *model = self.listArray[indexPath.row];
    if (self.selectBlock) {
        self.selectBlock(model.orderId);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.backgroundColor = [UIColor redColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[JHLivingCustomOrderCell class] forCellReuseIdentifier:NSStringFromClass([JHLivingCustomOrderCell class])];
        JH_WEAK(self)
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            JH_STRONG(self)
            pageNum = 1;
            [self loadData];
        }];
        _tableView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            JH_STRONG(self)
            [self loadData];
        }];
        
    }
    return _tableView;
}

- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (UITableViewCell *)emptyCell{
    if (_emptyCell == nil) {
        _emptyCell = [[UITableViewCell alloc] init];
        _emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeCenter;
        [_emptyCell addSubview:imageView];

        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = HEXCOLOR(0xa7a7a7);
        label.textAlignment = NSTextAlignmentCenter;
        [_emptyCell addSubview:label];

        [imageView setImage:[UIImage imageNamed:@"img_default_page"]];
        label.text = @"您还没有相关订单";
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_emptyCell.mas_centerY).offset(-60);
            make.centerX.equalTo(_emptyCell.mas_centerX);

        }];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(10);
            make.centerX.equalTo(imageView.mas_centerX);
        }];
        
    }
    return _emptyCell;
}
@end
