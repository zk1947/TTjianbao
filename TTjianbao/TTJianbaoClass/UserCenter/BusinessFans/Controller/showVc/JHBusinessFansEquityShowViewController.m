//
//  JHBusinessFansEquityShowViewController.m
//  TTjianbao
//
//  Created by user on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansEquityShowViewController.h"
#import "JHBusinessFansEquityShowTableViewCell.h"

@interface JHBusinessFansEquityShowViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView    *fansTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@end

@implementation JHBusinessFansEquityShowViewController

- (void)dealloc {
    NSLog(@"++++ 展示—权益 release");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jhNavView.hidden = YES;
    self.view.backgroundColor = HEXCOLOR(0xFFFFFF);
    [self setupViews];
    [self loadData];
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)loadData {
    [self.dataSourceArray removeAllObjects];
    if (self.showModel.levelRewardDTOList.count > 0) {
        [self.dataSourceArray addObjectsFromArray:self.showModel.levelRewardDTOList];
        [self.fansTableView reloadData];
    } else {
        [self.fansTableView jh_reloadDataWithEmputyView];
    }
}

- (void)setupViews {
    [self.view addSubview:self.fansTableView];
    [self.fansTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UITableView *)fansTableView {
    if (!_fansTableView) {
        _fansTableView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _fansTableView.dataSource                     = self;
        _fansTableView.delegate                       = self;
        _fansTableView.backgroundColor                = HEXCOLOR(0xFFFFFF);
        _fansTableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _fansTableView.estimatedRowHeight             = 10.f;
        if (@available(iOS 11.0, *)) {
            _fansTableView.estimatedSectionHeaderHeight   = 0.1f;
            _fansTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        for (int i = 0; i<10; i++) {
            NSString *string = [NSString stringWithFormat:@"%@_%d",NSStringFromClass([JHBusinessFansEquityShowTableViewCell class]),i];
            [_fansTableView registerClass:[JHBusinessFansEquityShowTableViewCell class] forCellReuseIdentifier:string];
        }
        if ([_fansTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_fansTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_fansTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_fansTableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _fansTableView;
}

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = [NSString stringWithFormat:@"%@_%ld",NSStringFromClass([JHBusinessFansEquityShowTableViewCell class]),(long)indexPath.row];
    JHBusinessFansEquityShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[JHBusinessFansEquityShowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHBusinessFansEquityShowTableViewCell class])];
    }
    cell.isLastLine = (indexPath.row == (self.dataSourceArray.count - 1))?YES:NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JHBusinessFansSettinglevelRewardDTOListModel *showModel = self.dataSourceArray[indexPath.row];
    cell.showModel = showModel;
    return cell;
}




@end
