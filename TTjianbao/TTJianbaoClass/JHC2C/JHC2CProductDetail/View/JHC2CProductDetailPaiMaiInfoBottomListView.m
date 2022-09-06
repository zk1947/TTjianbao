//
//  JHC2CProductDetailPaiMaiInfoBottomListView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailPaiMaiInfoBottomListView.h"
#import "JHC2CProductDetailChuJiaCell.h"
#import "UIButton+ImageTitleSpacing.h"
#import "CommHelp.h"

@interface JHC2CProductDetailPaiMaiInfoBottomListView() <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView * tableView;

@end

@implementation JHC2CProductDetailPaiMaiInfoBottomListView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = HEXCOLOR(0xF2F2F2);
    [self addSubview:self.tableView];
    
}

- (void)layoutItems{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(@0);
        make.bottom.equalTo(@0).offset(-10);
    }];
}

- (void)refershPriceBtnActino{
    if (self.refreshPriceBlock) {
        self.refreshPriceBlock();
    }
}
- (void)showListAlter{
    if (self.tapBlock) {
        self.tapBlock();
    }
}

#pragma mark -- <UITableViewDelegate and UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHC2CProductDetailChuJiaCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JHC2CProductDetailChuJiaCell.class) forIndexPath:indexPath];
    JHC2CJiangPaiRecord *model = self.model.records[indexPath.row];
    cell.nameLbl.text = model.name;
    
    [cell.iconImageView jhSetImageWithURL:[NSURL URLWithString:model.img] placeholder:kDefaultAvatarImage];
    cell.timeLbl.text = model.createTime;
    cell.priceLbl.text = [NSString stringWithFormat:@"%@￥%@",model.statusName,[CommHelp getPriceWithInterFen:model.price]];
    cell.indexRow = indexPath.row;
    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return MIN(self.model.records.count, 3);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self showListAlter];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  58;
}

- (void)setModel:(JHC2CJiangPaiListModel *)model{
    _model = model;
    [self.tableView reloadData];
}

#pragma mark -- <set and get>

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] init];
        view.delegate = self;
        view.dataSource = self;
        view.rowHeight = 89;
        view.tableHeaderView = [self getTableHeaderView];
        view.tableFooterView = [self getTableFooterView];
        view.backgroundColor = UIColor.whiteColor;
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.estimatedRowHeight = 0;
        view.scrollEnabled = NO;
        [view registerClass:JHC2CProductDetailChuJiaCell.class forCellReuseIdentifier:NSStringFromClass(JHC2CProductDetailChuJiaCell.class)];
        _tableView = view;
    }
    return _tableView;
}

- (UIView*)getTableHeaderView{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, kScreenWidth, 35);
    view.backgroundColor = UIColor.whiteColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showListAlter)];
    [view addGestureRecognizer:tap];
    UILabel *label = [UILabel new];
    label.font = JHMediumFont(14);
    label.textColor = HEXCOLOR(0x333333);
    label.text = @"竞价记录";
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0).offset(12);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"更新出价" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"c2c_pd_refresh"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
    btn.titleLabel.font = JHFont(13);
    [btn addTarget:self action:@selector(refershPriceBtnActino) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0).offset(-12);
        make.top.bottom.equalTo(@0);
        make.width.mas_equalTo(70);
    }];
    
    return view;
}

- (UIView*)getTableFooterView{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, kScreenWidth, 41);
    view.backgroundColor = UIColor.whiteColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showListAlter)];
    [view addGestureRecognizer:tap];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"查看更多" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"c2c_up_arrow"] forState:UIControlStateNormal];
    btn.titleLabel.font = JHFont(13);
    btn.userInteractionEnabled = NO;
    [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.mas_equalTo(100);
    }];
    return view;
}

@end
