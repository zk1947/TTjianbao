//
//  JHB2CAuctionInfoCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/7/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHB2CAuctionInfoCell.h"
#import "JHC2CProductDetailPaiMaiInfoBottomListView.h"
#import "JHC2CProductDetailChuJiaCell.h"
#import "UIButton+ImageTitleSpacing.h"


@interface JHB2CAuctionInfoCell()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIView * backView;

@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) UILabel * priceLbl;
@property(nonatomic, strong) NSArray<JHC2CJiangPaiRecord*> * records;

@property(nonatomic, strong) UIButton * countBtn;

@property(nonatomic, assign) BOOL  jumpMore;
@end

@implementation JHB2CAuctionInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setItems];
        [self layoutItems];

    }
    return self;
}

- (void)setItems{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.tableView];
    
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}


- (void)setViewModel:(JHStoreDetailAuctionListViewModel *)viewModel{
    _viewModel = viewModel;
    @weakify(self);
    [[viewModel.recordsArrSubject takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSArray<JHC2CJiangPaiRecord *> * _Nullable x) {
        @strongify(self);
        self.records = x;
        [self.viewModel.reloadCellSubject sendNext:RACTuplePack(@(self.viewModel.sectionIndex), @(self.viewModel.rowIndex))];
        [self.tableView reloadData];
    }];
    RAC(self.priceLbl, text) = [RACObserve(self.viewModel, addPrice)
                                                          takeUntil:self.rac_prepareForReuseSignal];
    [[RACObserve(viewModel, listCount) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        if (x.integerValue > 3) {
            self.jumpMore = YES;
            NSString *str = [NSString stringWithFormat:@"已出价%@次，查看更多",x];
            [self.countBtn setTitle:str forState:UIControlStateNormal];
            [self.countBtn setImage:[UIImage imageNamed:@"c2c_up_arrow"] forState:UIControlStateNormal];
            [self.countBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
        }else{
            self.jumpMore = NO;
            NSString *str = [NSString stringWithFormat:@"已出价%@次",x];
            [self.countBtn setTitle:str forState:UIControlStateNormal];
            [self.countBtn setImage:nil forState:UIControlStateNormal];
        }
    }];
}

- (void)refershPriceBtnActino:(UIButton*)sender{
    NSLog(@"refershPriceBtnActino");
    [NSNotificationCenter.defaultCenter postNotificationName:@"JHStoreDetailViewController_auctionRefershData" object:nil userInfo:@{@"fromRefresh": @YES}];
}

- (void)jumpMoreVC{
    if (self.jumpMore) {
        [self.viewModel.pushvc sendNext:@{}];
    }
}

#pragma mark -- <UITableViewDelegate and UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHC2CProductDetailChuJiaCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JHC2CProductDetailChuJiaCell.class) forIndexPath:indexPath];
    JHC2CJiangPaiRecord *model = self.records[indexPath.row];
    cell.nameLbl.text = model.name;
    [cell.iconImageView jhSetImageWithURL:[NSURL URLWithString:model.img] placeholder:kDefaultAvatarImage];
    cell.timeLbl.text = model.createTime;
    cell.priceLbl.text = [NSString stringWithFormat:@"%@￥%@",model.statusName,[CommHelp getPriceWithInterFen:model.price]];
    cell.indexRow = indexPath.row;
    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return MIN(self.records.count, 3);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self showListAlter];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  57;
}


#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        _backView = view;
    }
    return _backView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] init];
        view.delegate = self;
        view.dataSource = self;
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
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showListAlter)];
//    [view addGestureRecognizer:tap];
    UILabel *label = [UILabel new];
    label.font = JHMediumFont(14);
    label.textColor = HEXCOLOR(0x333333);
    label.text = @"竞拍记录";
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(14);
        make.left.equalTo(@0).offset(12);
    }];
    
    YYLabel *addPriceLbl = [YYLabel new];
    addPriceLbl.text = @"加价幅度";
    addPriceLbl.font = JHFont(10);
    addPriceLbl.textColor = HEXCOLOR(0xF63421);
    addPriceLbl.backgroundColor = HEXCOLORA(0xF23730, 0.1);
    addPriceLbl.textContainerInset = UIEdgeInsetsMake(2, 6, 2, 6);
    addPriceLbl.layer.cornerRadius = 2;
    [view addSubview:addPriceLbl];
    [addPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label);
        make.left.equalTo(label.mas_right).offset(8);
    }];
    
    UILabel *priceLbl = [UILabel new];
    priceLbl.font = JHFont(12);
    priceLbl.textColor = HEXCOLOR(0x222222);
    priceLbl.text = @"￥88";
    [view addSubview:priceLbl];
    [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label);
        make.left.equalTo(addPriceLbl.mas_right).offset(4);
    }];
    self.priceLbl = priceLbl;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"更新出价" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"c2c_pd_refresh"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
    btn.titleLabel.font = JHFont(13);
    [btn addTarget:self action:@selector(refershPriceBtnActino:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0).offset(-12);
        make.bottom.equalTo(@0);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(22);
    }];
    
    return view;
}

- (UIView*)getTableFooterView{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, kScreenWidth, 41);
    view.backgroundColor = UIColor.whiteColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    @weakify(self);
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        [self jumpMoreVC];
    }];
    [view addGestureRecognizer:tap];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"查看更多" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"c2c_up_arrow"] forState:UIControlStateNormal];
    btn.titleLabel.font = JHFont(13);
    btn.userInteractionEnabled = NO;
    [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [view addSubview:btn];
    self.countBtn =  btn;
    [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    return view;
}


@end





