//
//  JHChatBlackListViewController.m
//  TTjianbao
//
//  Created by zk on 2021/7/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatBlackListViewController.h"
#import "JHChatBlackUserModel.h"
#import "JHChatBlackUserTableViewCell.h"
#import "JHChatUserManager.h"
#import "JHUserInfoViewController.h"
#import "JHChatBusiness.h"
#import "NTESLoginManager.h"

@interface JHChatBlackListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray  *dataSourceArray;

@end

@implementation JHChatBlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.jhTitleLabel.text = @"黑名单";
    self.jhNavBottomLine.hidden = NO;
    self.dataSourceArray = [NSMutableArray array];
    
    [self steupView];
    [self loadData];
}

- (void)loadData{
    NTESLoginData *data = [[NTESLoginManager sharedManager] currentNTESLoginData];
    @weakify(self);
    [JHChatBusiness getBlackUserListData:[data account] completion:^(NSError * _Nullable error, NSArray * _Nonnull resultArray) {
        @strongify(self);
        [self endRefresh];
        [self.dataSourceArray removeAllObjects];
        if (!resultArray) {//|| resultArray.count == 0
            [self.tableView jh_reloadDataWithEmputyView];
            self.tableView.jh_EmputyView.imageView.hidden = YES;
            self.tableView.jh_EmputyView.textLabel.text = @"您当前还没有拉黑任何人哦～";
            self.jhTitleLabel.text = @"黑名单";
            return;
        }
        [self.dataSourceArray addObjectsFromArray:resultArray];
        self.jhTitleLabel.text = [NSString stringWithFormat:@"黑名单(%ld)",self.dataSourceArray.count];
        [self.tableView reloadData];
    }];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

- (void)steupView{
    self.view.backgroundColor = kColorFFF;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavBottomLine.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    @weakify(self);
    self.tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadData];
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView                               = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource                     = self;
        _tableView.delegate                       = self;
        _tableView.backgroundColor                 = [UIColor clearColor];
        _tableView.separatorStyle                  = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight   = 0.1f;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        [_tableView registerClass:[JHChatBlackUserTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHChatBlackUserTableViewCell class])];
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _tableView;
}

#pragma mark - Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHChatBlackUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHChatBlackUserTableViewCell class])];
    if (!cell) {
        cell = [[JHChatBlackUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHChatBlackUserTableViewCell class])];
    }
    cell.delegate = self;
    cell.model = self.dataSourceArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)gotoPersonPage:(JHChatBlackUserModel *)model{
    @weakify(self)
    [JHChatUserManager getUserInfoWithID:model.wyAccid handler:^(JHChatUserInfo * _Nonnull userInfo) {
        @strongify(self)
        JHUserInfoViewController *vc = [[JHUserInfoViewController alloc] init];
        vc.userId = userInfo.customerId;
        [self.navigationController pushViewController:vc animated:true];
    }];
}

- (void)deleteCell:(JHChatBlackUserModel *)model{
    NSDictionary *param = @{@"blockId":@([model.ID integerValue]),
                          @"operatorType":@(2),
    };
    @weakify(self);
    [JHChatBusiness deleteBlackUser:param completion:^(NSError * _Nullable error, BOOL isSuccess) {
        @strongify(self)
        if (isSuccess) {
            [self.view makeToast:@"已成功移除黑名单" duration:1.0 position:CSToastPositionCenter];
        }
        [self loadData];
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
