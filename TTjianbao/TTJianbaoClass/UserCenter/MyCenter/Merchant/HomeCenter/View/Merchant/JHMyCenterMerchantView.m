//
//  JHMyCenterMerchantView.m
//  TTjianbao
//
//  Created by apple on 2020/4/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMyCenterMerchantView.h"
#import "JHMyCenterMerchantHeaderView.h"
#import "JHMyCenterMerchantBottomView.h"
#import "JHMyCenterMerchantViewModel.h"
#import "JHMyCenterDotModel.h"



@interface JHMyCenterMerchantView () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHMyCenterMerchantHeaderView *headerView;
@property (nonatomic, strong) JHMyCenterMerchantBottomView *bottomView;
@property (nonatomic, strong) JHMyCenterMerchantViewModel *viewModel;
@property (nonatomic, assign) CGFloat contentCellHeight;
@property (nonatomic, assign) NSInteger currentSelectIndex;

@end

@implementation JHMyCenterMerchantView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF8F8F8);
        _contentCellHeight = CGFLOAT_MIN;
        _currentSelectIndex = 1;
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = HEXCOLOR(0xF8F8F8);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = self.bottomView;
        _tableView.tableHeaderView = self.headerView;
        [self addSubview:_tableView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGFLOAT_MIN;
}

-(void)reload{
    [self.viewModel.livingData removeAllObjects];
    [self.viewModel.storeData removeAllObjects];
    [self.viewModel reloadDataArray];
    [self.viewModel.requestCommand execute:nil];
    self.bottomView.livingData = self.viewModel.livingData.copy;
    self.bottomView.storeData = self.viewModel.storeData.copy;
    self.bottomView.currentIndex = self.currentSelectIndex;
    if (self.bottomView.currentIndex == 1) {
        self.bottomView.lastDayCompleteMoney = [JHMyCenterDotModel shareInstance].shopAllDealStr;
    } else {
        self.bottomView.lastDayCompleteMoney = [JHMyCenterDotModel shareInstance].liveAllDealStr;
    }
    [self setHeaderViewData];
}

- (JHMyCenterMerchantHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[JHMyCenterMerchantHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, [JHMyCenterMerchantHeaderView headerHeight])];
        _headerView.defaultIndex = 1;
        @weakify(self);
        _headerView.actionBlock = ^(NSInteger selectIndex) {
            @strongify(self);
            ///根据选择的tab展示对应的页面 0 直播 1 商城
            self.currentSelectIndex = selectIndex;
            [self.bottomView changeContentOffset:selectIndex];
            ///需要获取一下当前业务线订单
            [JHNotificationCenter postNotificationName:@"jh_changeMyCenterTabNotification" object:@{@"bussId" : @(selectIndex+1).stringValue}];
        };
    }
    return _headerView;
}

- (void)updateOrderInfo:(NSInteger)index {
    if (index == 1) {
        self.bottomView.lastDayCompleteMoney = [JHMyCenterDotModel shareInstance].shopAllDealStr;
    } else {
        self.bottomView.lastDayCompleteMoney = [JHMyCenterDotModel shareInstance].liveAllDealStr;
    }
    [self.bottomView updateOrderInfo:index];
}

- (JHMyCenterMerchantBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[JHMyCenterMerchantBottomView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _bottomView.currentIndex = 1;
        @weakify(self);
        _bottomView.changeHeightBlock = ^(CGFloat height) {
            @strongify(self);
            [self updateBottomViewHeight:height];
        };
    }
    return _bottomView;
}

- (void)updateBottomViewHeight:(CGFloat)height {
    CGRect rect = self.bottomView.frame;
    rect.size.height = height;
    self.bottomView.frame = rect;
    [self.tableView reloadData];
}

-(JHMyCenterMerchantViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [JHMyCenterMerchantViewModel new];
        [_viewModel reloadDataArray];
        @weakify(self);
        [_viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self setHeaderViewData];
            [self.tableView reloadData];
        }];
    }
    return _viewModel;
}

-(void)setHeaderViewData {
    self.bottomView.withDrawMoney = [NSString stringWithFormat:@"%.2f",self.viewModel.dataSource.account.withdrawAccount];
}

#pragma mark --------------- scrollview ---------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"offsetY:---- %f", offsetY)
    if (self.scrollBlock) {
        self.scrollBlock(offsetY);
    }
}
@end
