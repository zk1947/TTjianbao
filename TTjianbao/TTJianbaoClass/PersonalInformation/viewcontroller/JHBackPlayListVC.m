//
//  JHBackPlayListVC.m
//  TTjianbao
//
//  Created by mac on 2019/10/31.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHBackPlayListVC.h"
#import "JHBackPlayTableViewCell.h"
#import "JHOrderAppraisalVideoViewController.h"
#import "JHVideoFiltrateView.h"
#import "TTjianbaoHeader.h"


@interface JHSectionModel : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, strong)NSMutableArray<JHBackPlayModel *> *array;

@end

@implementation JHSectionModel
- (NSMutableArray<JHBackPlayModel *> *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    
    return _array;
}

@end

@interface JHBackPlayListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray<JHSectionModel *> *sectionArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) JHVideoFiltrateView *searchView;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;


@end

@implementation JHBackPlayListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageSize = 20;
    self.beginTime = @"";
    self.endTime = @"";
//    [self  initToolsBar];
    
//    self.view.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.navbar setTitle:@"直播回放记录"];
    
//    [self.navbar addrightBtn:@"筛选" withImage:nil withHImage:nil withFrame:CGRectMake(ScreenW-80,0,80,44)];
//       
//    [self.navbar.rightBtn addTarget:self action:@selector(filtrateAction:) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"直播回放记录";//背景颜色不一致
    [self initRightButtonWithName:@"筛选" action:@selector(filtrateAction:)];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
    
    [self makeUI];
   
}

- (void)filtrateAction:(UIButton *)btn {
    if (self.searchView && !self.searchView.hidden) {
        if (_searchView) {
            [_searchView hiddenAlert];
        }
    }else {
        if (self.searchView) {
            
        }else {
            JHVideoFiltrateView *alert = [[JHVideoFiltrateView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight+1, ScreenW, ScreenH-UI.statusAndNavBarHeight)];
            [self.view addSubview:alert];
            MJWeakSelf
            alert.handle = ^(OrderSearchParamMode *object, id sender) {
                if (object) {
                  weakSelf.beginTime = object.startTime;
                weakSelf.endTime = object.endTime;
                }else {
                    weakSelf.beginTime = @"";
                    weakSelf.endTime = @"";
                }
                [weakSelf loadOneData];
               
            };
            self.searchView = alert;

        }
        
        [self.searchView showAlert];
        
    }
    
    btn.selected = !btn.selected;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)makeUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
    }];
}

#pragma mark - GET

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHBackPlayTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"JHBackPlayTableViewCell"];
        

        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 45;
        
        JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadOneData)];
        _tableView.mj_header = header;
        header.automaticallyChangeAlpha = YES;
        
        JHRefreshNormalFooter *footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.mj_footer = footer;
        [_tableView.mj_header beginRefreshing];
        
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionArray[section].array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        JHBackPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHBackPlayTableViewCell"];
    JHBackPlayModel *model = self.sectionArray[indexPath.section].array[indexPath.row];

        cell.model = model;
        return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [UIView new];
    view.backgroundColor = HEXCOLOR(0xf7f7f7);
    view.size = CGSizeMake(ScreenW, 48);
    UILabel *title = [UILabel new];
    title.text = self.sectionArray[section].title;
    title.font = [UIFont fontWithName:kFontNormal size:13];
    title.textColor = HEXCOLOR(0x333333);
    [view addSubview:title];
    title.frame = CGRectMake(10, 0, ScreenW, 48);
    return view;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHBackPlayModel *model = self.sectionArray[indexPath.section].array[indexPath.row];
    [self toVideo:model];
    
}

#pragma mark - 请求数据
- (void)loadOneData {
    _pageNo = 0;
    _pageSize = 20;
    [self requestData];
}

- (void)loadMoreData {
    _pageNo ++;
    _pageSize = 20;
    [self requestData];
}


- (void)requestData {
    NSMutableDictionary *parameters = @{@"pageNo":@(_pageNo),@"pageSize":@(_pageSize)}.mutableCopy;
    parameters[@"start"] = self.beginTime;
    parameters[@"end"] = self.endTime;
    NSString *url = FILE_BASE_STRING(@"/channelVideo/auth/list");

    [HttpRequestTool postWithURL:url Parameters:parameters requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [self dealDataWithDic:respondObject.data];
        [self endRefresh];

        if (((NSArray *)respondObject.data).count) {
            
        }else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
    
    
}

- (void)endRefresh {
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    if (self.dataArray.count) {
        [self hiddenDefaultImage];

    }else {
        [self showDefaultImageWithView:self.tableView];
    }
}
- (void)dealDataWithDic:(NSArray *)array {
    
    
    NSArray *arr = @[];
    arr = [JHBackPlayModel mj_objectArrayWithKeyValuesArray:array];

    if (arr.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    if (self.pageNo == 0) {
        self.dataArray = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.dataArray addObjectsFromArray:arr];
    }
    [self dealSectionArray];
    [self.tableView reloadData];
}

- (void)dealSectionArray {
   
    self.sectionArray =[NSMutableArray array];
    NSMutableArray *timeArr = [NSMutableArray array];
    [self.dataArray enumerateObjectsUsingBlock:^(JHBackPlayModel *model, NSUInteger idx, BOOL *stop) {
        if (model.recordStartTime.length>10) {
            [timeArr addObject:[model.recordStartTime substringToIndex:10]];
        }
    }];
    NSSet *set = [NSSet setWithArray:timeArr];
    NSArray *userArray = [set allObjects];
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];//yes升序排列，no,降序排列
    NSArray *descendingDateArr = [userArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];
    
    [descendingDateArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JHSectionModel *om = [[JHSectionModel alloc]init];
        [self.sectionArray addObject:om];
    }];
    [self.dataArray enumerateObjectsUsingBlock:^(JHBackPlayModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSString *str in descendingDateArr) {
            if([model.recordStartTime hasPrefix:str]) {
                JHSectionModel *om = [self.sectionArray objectAtIndex:[descendingDateArr indexOfObject:str]];
                om.title = str;
                [om.array addObject:model];
            }
        }
    }];
}


- (void)toVideo:(JHBackPlayModel *)model {
    
   
    JHOrderAppraisalVideoViewController * appraisalVideo = [[JHOrderAppraisalVideoViewController alloc]initWithStreamUrl:model.videoUrl];
    appraisalVideo.from = 6;
    [self.navigationController pushViewController:appraisalVideo animated:YES];
}
@end
