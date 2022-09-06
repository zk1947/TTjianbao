//
//  JHFoucsPlateController.m
//  TTjianbao
//
//  Created by apple on 2020/9/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHFoucsPlateController.h"
#import "UIScrollView+JHEmpty.h"
#import "JHFoucsPlateModel.h"
#import "JHFoucsPlateViewCell.h"

@interface JHFoucsPlateController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation JHFoucsPlateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jhNavView.hidden = YES;
    [self requestData:@"0"];
    [self tableView];
    
}
- (void)requestData:(NSString *)lastId{
    if (!lastId) {
        [self.tableView jh_endRefreshing];
        [self.tableView jh_noMoreDataStatus];
        return;
    }
    NSString *userId = [NSString stringWithFormat:@"%@",@(self.userId)];
    [JHFoucsPlateModel requestFoucsPlateWithId:lastId userId:userId successBlock:^(NSMutableArray * array) {
        [self.dataArray addObjectsFromArray:array];
        
        [self.tableView reloadData];
        
        if (self.dataArray.count==0) {
            [self.tableView jh_reloadDataWithEmputyView];
        }
        [self.tableView jh_endRefreshing];
        if (array.count == 0 && ![lastId isEqualToString:@"0"]) {
            [self.tableView jh_noMoreDataStatus];
        }
    } failBlock:^(RequestModel * _Nonnull reqModel) {
        
    }];
}
#pragma mark --------------- UITableViewDelegate DataSource ---------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHFoucsPlateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plateCell"];
    if (!cell) {
        cell = [[JHFoucsPlateViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"plateCell"];
    }
    JHFoucsPlateModel * model = (JHFoucsPlateModel*)self.dataArray[indexPath.row];
    [cell resetCellDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row < self.dataArray.count)
    {
        [self enterShopPageIndex:indexPath.row];
    }
}

-(void)enterShopPageIndex:(NSInteger)index
{
    JHFoucsPlateModel * model = (JHFoucsPlateModel*)self.dataArray[index];
    [JHRouterManager pushPlateDetailWithPlateId:model.channel_id pageType:self.pageType];
}


-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLine target:self addToSuperView:self.view];
        _tableView.sectionFooterHeight = 10.f;
        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorColor = APP_BACKGROUND_COLOR;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        @weakify(self);
        [_tableView jh_headerWithRefreshingBlock:^{
            @strongify(self);
            [self.dataArray removeAllObjects];
            [self requestData:@"0"];
        } footerWithRefreshingBlock:^{
            @strongify(self);
            JHFoucsPlateModel * model = (JHFoucsPlateModel*)[self.dataArray lastObject];
            [self requestData:model.follow_id];
        }];
    }
    return _tableView;
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
@end
