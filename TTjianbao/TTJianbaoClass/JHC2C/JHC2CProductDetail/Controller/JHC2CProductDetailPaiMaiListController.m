//
//  JHC2CProductDetailPaiMaiListController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailPaiMaiListController.h"
#import "SVProgressHUD.h"
#import "JHC2CProductDetailChuJiaCell.h"
#import "JHTextInPutView.h"
#import "JHC2CProductDetailBusiness.h"

#import "CommHelp.h"

@interface JHC2CProductDetailPaiMaiListController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) UIView * topView;
@property(nonatomic, strong) UITableView * tableView;

@property(nonatomic, strong) JHC2CJiangPaiListModel * listModel;

@property(nonatomic, strong) NSMutableArray< JHC2CJiangPaiRecord* > * dataRecords;
@property(nonatomic, strong) UILabel * titleLbl;


@property(nonatomic) NSInteger  page;
@end

@implementation JHC2CProductDetailPaiMaiListController

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
    @weakify(self);
    self.tableView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];

    [JHC2CProductDetailBusiness requestC2CProductDetailPaiMaiList:self.ansID page:@(self.page) completion:^(NSError * _Nullable error, JHC2CJiangPaiListModel * _Nullable model) {
        if (!error && model.records.count > 0) {
            [self.dataRecords addObjectsFromArray: model.records];
            if (model.records.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }
    }];

}


- (void)loadMoreData{
    self.page += 1;
    [JHC2CProductDetailBusiness requestC2CProductDetailPaiMaiList:self.ansID page:@(self.page) completion:^(NSError * _Nullable error, JHC2CJiangPaiListModel * _Nullable model) {
        [self.tableView.mj_footer endRefreshing];
        if (!error && model.records.count > 0) {
            [self.dataRecords addObjectsFromArray:model.records];
            if (model.records.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }
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
        make.top.equalTo(@300);
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


#pragma mark -- <UITableViewDelegate and UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JHC2CProductDetailChuJiaCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JHC2CProductDetailChuJiaCell.class) forIndexPath:indexPath];
    JHC2CJiangPaiRecord *model = self.dataRecords[indexPath.row];
    cell.nameLbl.text = model.name;
    [cell.iconImageView jhSetImageWithURL:[NSURL URLWithString:model.img] placeholder:kDefaultAvatarImage];
    cell.timeLbl.text = model.createTime;
    cell.priceLbl.text = [NSString stringWithFormat:@"%@￥%@",model.statusName,[CommHelp getPriceWithInterFen:model.price]];
    cell.indexRow = indexPath.row;
    return  cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataRecords.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark -- <set and get>
- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 10;
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
        label.font = JHMediumFont(16);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"竞价记录";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
        }];
        self.titleLbl = label;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"newStore_coupon_close_icon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(@0);
            make.width.mas_equalTo(54);
        }];
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
        view.estimatedRowHeight = 60;
        [view registerClass:JHC2CProductDetailChuJiaCell.class forCellReuseIdentifier:NSStringFromClass(JHC2CProductDetailChuJiaCell.class)];
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

- (void)setFormB2C:(BOOL)formB2C{
    _formB2C = formB2C;
    self.titleLbl.text = formB2C? @"竞拍记录" : @"竞价记录";
}

@end
