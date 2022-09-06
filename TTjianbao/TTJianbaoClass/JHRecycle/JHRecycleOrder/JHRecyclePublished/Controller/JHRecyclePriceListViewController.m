//
//  JHRecyclePriceListViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePriceListViewController.h"
#import "JHRecyclePriceModel.h"
#import "JHRecyclePriceCell.h"
#import "JHEmptyTableViewCell.h"
#import "CommAlertView.h"
#import "JHRecyclePublishedViewModel.h"
#import "NSString+AttributedString.h"
#import "JHRecycleOrderDetailViewController.h"

@interface JHRecyclePriceListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <JHRecyclePriceModel *>*listArray;
/** 底部工具条*/
@property (nonatomic, strong) UIView *bottomView;
/** 已选价格*/
@property (nonatomic, strong) UILabel *selectLabel;
/** 确认报价*/
@property (nonatomic, strong) UIButton *submitButton;
/** 当前选择cell的索引*/
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@end

@implementation JHRecyclePriceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部报价";
    [self configUI];
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"productId"] = self.productId;
    [SVProgressHUD show];
    [JHRecyclePublishedViewModel getPriceList:params Completion:^(NSError * _Nullable error, NSArray<JHRecyclePriceModel *> * _Nullable array) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        if (!error) {
            self.listArray = [NSMutableArray arrayWithArray:array];
            if (self.listArray.count > 0) {
                JHRecyclePriceModel *model = self.listArray.firstObject;
                model.isSelect = YES;
                self.listArray[0] = model;
                self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)configUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.selectLabel];
    [self.bottomView addSubview:self.submitButton];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(44 + UI.bottomSafeAreaHeight);
    }];
    
    [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomView).offset(12);
        make.left.mas_equalTo(self.bottomView).offset(12);
        make.height.mas_equalTo(21);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bottomView).offset(-10);
        make.centerY.mas_equalTo(self.selectLabel);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(30);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavView.mas_bottom);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
}
//提交报价
- (void)submitButtonClickAction:(UIButton *)sender {
    JHRecyclePriceModel *priceModel = self.listArray[self.currentIndexPath.row];
    if (priceModel) {
    NSString *desc = [NSString stringWithFormat:@"您确认接受(%@)的宝贝报价:¥%@", priceModel.shopName, priceModel.bidPriceYuan];
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"提示" andDesc:desc cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        [self confirmPrice:priceModel];
    };
        
    } else {
        
    }
}

/// 确认报价
- (void)confirmPrice:(JHRecyclePriceModel *)priceModel {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"bidId"] = priceModel.bidId;
    params[@"source"] = @"";
    [SVProgressHUD show];
    [JHRecyclePublishedViewModel confirmPrice:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [SVProgressHUD dismiss];
        if (!error) {
            [JHNotificationCenter postNotificationName:@"RecycleGoodsNumChangeNotification" object:@"0"];

            if (self.fromPageIsDismiss) { //来源页面消失,隔级跳
                NSInteger index= [[self.navigationController viewControllers] indexOfObject: self];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: index - 2] animated:NO];
            } else {
                [self.navigationController popViewControllerAnimated:NO];
            }
            JHRecycleOrderDetailViewController *orderDetailView = [[JHRecycleOrderDetailViewController alloc] init];
            orderDetailView.orderId = data[@"orderId"];
            [JHRootController.navigationController pushViewController:orderDetailView animated:YES];
        } else {
            JHTOAST(error.userInfo[@"NSLocalizedDescription"]);
        }
    }];
    
    NSMutableDictionary *paramsUp = [NSMutableDictionary dictionary];
    paramsUp[@"commodity_id"] = priceModel.productId;
    paramsUp[@"recycler_id"] = priceModel.businessId;
    paramsUp[@"page_position"] = @"confirmQuotedPrice";
    paramsUp[@"recovery_quoted_price"] = @([ priceModel.bidPriceYuan floatValue]);
    paramsUp[@"remaining_time"] = @(priceModel.timeLeft*1000);
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickConfirmPrice" params:paramsUp type:JHStatisticsTypeSensors];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count ? self.listArray.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.listArray.count ? UITableViewAutomaticDimension : self.tableView.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listArray.count == 0) {
        JHEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHEmptyTableViewCell"];
        cell.backgroundColor = HEXCOLOR(0xf5f5f8);
        return cell;
    }
    JHRecyclePriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecyclePriceCell"];
    JHRecyclePriceModel *model = self.listArray[indexPath.row];
    cell.priceModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取cell
    JHRecyclePriceCell *cell = (JHRecyclePriceCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    JHRecyclePriceModel *modelC = self.listArray[self.currentIndexPath.row];
    modelC.isSelect = NO;
    self.listArray[self.currentIndexPath.row] = modelC;
    JHRecyclePriceCell *currentCell = (JHRecyclePriceCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    currentCell.priceModel = modelC;
    
    self.currentIndexPath = indexPath;
    JHRecyclePriceModel *model = self.listArray[self.currentIndexPath.row];
    model.isSelect = YES;
    self.listArray[self.currentIndexPath.row] = model;
    cell.priceModel = model;
}

- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath {
    _currentIndexPath = currentIndexPath;
    JHRecyclePriceModel *priceModel = self.listArray[currentIndexPath.row];
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    itemsArray[0] = @{@"string":@"已选: ", @"color":HEXCOLOR(0x333333), @"font":[UIFont fontWithName:kFontNormal size:12]};
    itemsArray[1] = @{@"string":[NSString stringWithFormat:@"¥%@", priceModel.bidPriceYuan], @"color":HEXCOLOR(0xff4200), @"font":[UIFont fontWithName:kFontBoldDIN size:18]};
    itemsArray[2] = @{@"string":[NSString stringWithFormat:@"(%@)", priceModel.shopName], @"color":HEXCOLOR(0x666666), @"font":[UIFont fontWithName:kFontNormal size:10]};
    self.selectLabel.attributedText = [NSString mergeStrings:itemsArray];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f8);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[JHRecyclePriceCell class] forCellReuseIdentifier:@"JHRecyclePriceCell"];
        [_tableView registerClass:[JHEmptyTableViewCell class] forCellReuseIdentifier:@"JHEmptyTableViewCell"];
        @weakify(self);
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self loadData];
        }];
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _bottomView;
}

- (UILabel *)selectLabel {
    if (_selectLabel == nil) {
        _selectLabel = [[UILabel alloc] init];
        _selectLabel.textColor = HEXCOLOR(0x333333);
        _selectLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _selectLabel.text = @"已选: ";
    }
    return _selectLabel;
}

- (UIButton *)submitButton {
    if (_submitButton == nil) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"确认报价" forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [_submitButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _submitButton.backgroundColor = HEXCOLOR(0xffd70f);
        _submitButton.layer.cornerRadius = 15;
        _submitButton.clipsToBounds = YES;
        [_submitButton addTarget:self action:@selector(submitButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}


- (NSMutableArray<JHRecyclePriceModel *> *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}


@end
