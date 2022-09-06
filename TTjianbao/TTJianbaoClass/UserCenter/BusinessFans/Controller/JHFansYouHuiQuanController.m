//
//  JHFansYouHuiQuanController.m
//  TTjianbao
//
//  Created by Paros on 2021/11/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansYouHuiQuanController.h"

#import "SVProgressHUD.h"
#import "JHC2CProductDetailChuJiaCell.h"
#import "JHTextInPutView.h"
#import "JHC2CProductDetailBusiness.h"
#import "JHFansYouHuiQuanCell.h"

#import "CommHelp.h"

@interface JHFansYouHuiQuanController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) UIView * topView;
@property(nonatomic, strong) UITableView * tableView;

@property(nonatomic, strong) JHC2CJiangPaiListModel * listModel;

@property(nonatomic, strong) NSMutableArray< JHFansCoupouModel* > * dataRecords;
@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic) NSInteger  page;
@end

@implementation JHFansYouHuiQuanController

- (instancetype)init{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setItems];
    [self layoutItems];
    self.page = 1;
    self.dataRecords = [NSMutableArray arrayWithCapacity:0];
    [self getData];
    [self.tableView jh_reloadDataWithEmputyView];
    [self fitEmptyView];
}
- (void)fitEmptyView{
    self.tableView.jh_EmputyView.textLabel.hidden = YES;
    
    UILabel *label = [UILabel new];
    label.font = JHFont(14);
    label.text = @"您还没有可用的代金券，";
    label.textColor = HEXCOLOR(0x999999);
    [self.tableView.jh_EmputyView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:HEXCOLOR(0xFFB715) forState:UIControlStateNormal];
    [btn setTitle:@"去创建" forState:UIControlStateNormal];
    btn.titleLabel.font = JHFont(14);
    [btn addTarget:self action:@selector(goCreate) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:btn];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.jh_EmputyView.imageView.mas_bottom).offset(20);
        make.left.equalTo(self.tableView.jh_EmputyView.imageView).offset(-40);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label);
        make.left.equalTo(label.mas_right);
    }];
    RAC(btn, hidden) = RACObserve(self.tableView.jh_EmputyView, hidden);
}


- (void)getData{
    NSString *url = FILE_BASE_STRING(@"/app/fans/fans-club/sendCouponList");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        NSMutableArray<JHFansCoupouModel*> * arr= [JHFansCoupouModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        self.dataRecords =  arr;
        [self.tableView jh_reloadDataWithEmputyView];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
    }];
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.transform = CGAffineTransformIdentity;
    }];
}

- (void)setItems{
    self.view.backgroundColor = HEXCOLORA(0x000000, 0.3);
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.topView];
    [self.backView addSubview:self.tableView];
    self.jhNavView.hidden = YES;
    self.backView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@400);
        make.bottom.equalTo(@0).offset(20);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.mas_equalTo(54);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(@0).offset(-20);
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self closeVC];
}


- (void)closeVC{
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)goCreate{
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.createCoup) {
        self.createCoup();
    }
}

#pragma mark -- <UITableViewDelegate and UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHFansCoupouModel *model = self.dataRecords[indexPath.row];
    JHFansYouHuiQuanCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JHFansYouHuiQuanCell.class) forIndexPath:indexPath];
    cell.model = model;
    return  cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataRecords.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  101;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.seleBlock) {
        JHFansCoupouModel *model = self.dataRecords[indexPath.row];
        self.seleBlock(model);
    }
}

#pragma mark -- <set and get>
- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 8;
        _backView = view;
    }
    return _backView;
}
- (UIView *)topView{
    if (!_topView) {
        UIView *view = [UIButton new];
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 10;
        
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(17);
        label.textColor = HEXCOLOR(0x333333);
        label.text = @"请选择代金券";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
        }];
        self.titleLbl = label;
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setImage:[UIImage imageNamed:@"newStore_coupon_close_icon"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.right.equalTo(@0);
//            make.width.mas_equalTo(54);
//        }];
        
        _topView = view;
    }
    return _topView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] init];
        view.delegate = self;
        view.dataSource = self;
//        view.tableFooterView = [self getTableFooterView];
        view.tableFooterView = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.estimatedRowHeight = 0;
        [view registerClass:JHFansYouHuiQuanCell.class forCellReuseIdentifier:NSStringFromClass(JHFansYouHuiQuanCell.class)];
        _tableView = view;
    }
    return _tableView;
}

- (UIView*)getTableFooterView{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, kScreenWidth, 41);
    view.backgroundColor = UIColor.whiteColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"查看更多" forState:UIControlStateNormal];
    btn.titleLabel.font = JHFont(13);
    [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
    return view;
}


@end
