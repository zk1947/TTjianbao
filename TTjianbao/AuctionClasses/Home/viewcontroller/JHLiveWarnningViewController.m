//
//  JHLiveWarnningViewController.m
//  TTjianbao
//
//  Created by mac on 2019/7/30.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHLiveWarnningViewController.h"
#import "JHWarnningTableViewCell.h"
#import "JHRecommendAppraiserListItem.h"
#import "JHGemmologistViewController.h"
#import "JHGrowingIO.h"

@interface JHLiveWarnningViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<JHRecommendAppraiserListItem *> *dataList;


@end

@implementation JHLiveWarnningViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self  initToolsBar];
    self.title = @"开播通知"; //背景色有差异
//    [self.navbar setTitle:@"开播通知"];
//    self.view.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:[UIImage imageNamed:@"Custom Preset.png"] withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhNavView.mas_bottom).offset(1);
        make.bottom.equalTo(self.view);
        make.leading.equalTo(self.view).offset(0);
        make.trailing.equalTo(self.view).offset(0);
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self appraiserPlan];

}

#pragma mark - GET

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHWarnningTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"JHWarnningTableViewCell"];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
        
    
        
    }
    return _tableView;
}


#pragma mark - UITableViewDelegate UITableViewDataSource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHWarnningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHWarnningTableViewCell"];
    JH_WEAK(self)
    cell.openWarnningBlock = ^(id sender) {
        JH_STRONG(self)
        [self followAction:sender];
    };
    cell.model = self.dataList[indexPath.row];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHGemmologistViewController *vc = [[JHGemmologistViewController alloc] init];
    vc.anchorId = self.dataList[indexPath.row].appraiserCustomerId;
    [self.navigationController pushViewController:vc animated:YES];
    

}

- (void)appraiserPlan {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/channel/appraiserPlan/auth") Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.dataList = [JHRecommendAppraiserListItem mj_objectArrayWithKeyValuesArray:respondObject.data];
        [self.tableView reloadData];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message];

    }];
}

- (void)followAction:(JHRecommendAppraiserListItem *)model {
    
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/authoptional/appraise/follow") Parameters:@{@"followCustomerId":model.appraiserCustomerId,@"status":@(1)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {

        model.follow = 1;
        [self.tableView reloadData];
                
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message];
    }];
    [JHGrowingIO trackPublicEventId:JHIdentifyActivityChooseRemindClick];
}
@end
