//
//  JHBasePostDetailController.m
//  TTjianbao
//
//  Created by lihui on 2020/11/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBasePostDetailController.h"
#import "UIScrollView+JHEmpty.h"
#import "UIView+CornerRadius.h"
#import "JHRecyclingMoneyLayer.h"


@interface JHBasePostDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JHRecyclingMoneyLayer *recyclingMoneyLayer; /// 钱币回收弹窗
@end

@implementation JHBasePostDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupToolBar];
}

- (void)setupRecyclingMoneyLayer:(JHPostDetailModel *)detailModel {
   
    _recyclingMoneyLayer = [[JHRecyclingMoneyLayer alloc] init];
    [_recyclingMoneyLayer setDetailModel:detailModel];
    [self.view addSubview:_recyclingMoneyLayer];
    
    [_recyclingMoneyLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49.f);
        make.left.mas_equalTo(0.f);
        make.right.mas_equalTo(0.f);
        make.bottom.mas_equalTo(self.toolBar.mas_top).mas_offset(-1.f);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view bringSubviewToFront:self.recyclingMoneyLayer];
    });
}


///底部评论框
- (void)setupToolBar {
    if (!_toolBar) {
        _toolBar = [[JHPostDetailToolBar alloc] init];
        _toolBar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_toolBar];
        [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(kToolBarHeight);
        }];
        @weakify(self);
        _toolBar.actionBlock = ^(JHPostDetailActionType actionType) {
            @strongify(self);
            [self bottomToolBarAction:actionType];
        };
    }
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 74.f;
        _mainTableView.estimatedSectionHeaderHeight = 74.f;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.tableFooterView = self.tableFooter;
        _mainTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.view addSubview:_mainTableView];
        ///注册cell
        [_mainTableView registerClass:[JHPostDetailHeaderTableCell class] forCellReuseIdentifier:kJHPostDetailHeaderCellIdentifer];
        [_mainTableView registerClass:[JHPostDtailEnterTableCell class] forCellReuseIdentifier:kPostDetailEnterIdentifer];
        [_mainTableView registerClass:[JHPostDetailPlateEnterTableCell class] forCellReuseIdentifier:kPostDetailPlateEnterCellIdentifer];
        [_mainTableView registerClass:[JHSubCommentTableCell class] forCellReuseIdentifier:kSubCommentCellIdentifer];
        [_mainTableView registerClass:[JHPostMainCommentHeader class] forCellReuseIdentifier:kCommentSectionHeader];
        @weakify(self);
        [_mainTableView jh_headerWithRefreshingBlock:^{
            @strongify(self);
            [self refreshData];
        } footerWithRefreshingBlock:^{
            @strongify(self);
            [self loadMoreData];
        }];
    }
    return _mainTableView;
}
- (UIView *)tableFooter {
    if (!_tableFooter) {
        _tableFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 15.f)];
        _tableFooter.backgroundColor = kColorFFF;
        [_tableFooter yd_setCornerRadius:8.f corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    }
    return _tableFooter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)refreshData {
    
}

- (void)loadMoreData {
    
}

///底部工具栏点击事件
- (void)bottomToolBarAction:(JHPostDetailActionType)actionType {
    
}


@end
