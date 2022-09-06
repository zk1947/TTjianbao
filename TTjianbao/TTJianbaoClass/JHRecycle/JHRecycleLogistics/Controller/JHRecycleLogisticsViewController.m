//
//  JHRecycleLogisticsViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleLogisticsViewController.h"
#import "JHRecycleLogisticsModel.h"
#import "JHRecycleLogisticsCell.h"
#import "SVProgressHUD.h"
#import "JHRecycleOrderPurseViewModel.h"
#import "JHRefreshGifHeader.h"
#import "JHEmptyTableViewCell.h"
#import "JHReLayoutButton.h"
#import "JHExpressLogisticsChangeView.h"

@interface JHRecycleLogisticsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <JHRecycleLogisticsListModel *>*listArray;
/** 表头*/
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *headerBackView;
/** 快递logo*/
//@property (nonatomic, strong) UIImageView *logisticsImageView;
/** 快递名称*/
@property (nonatomic, strong) UILabel *logisticsLabel;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) JHRecycleLogisticsModel *logisticsModel;
/// 新增用于直发
@property (nonatomic, strong) UIButton                     *copyBtn;    /// 复制按钮
@property (nonatomic, strong) JHReLayoutButton             *editBtn;    /// 修改按钮
@property (nonatomic, strong) JHExpressLogisticsChangeView *changeView; /// 修改地址视图
@property (nonatomic, strong) NSMutableArray               *changeLogisticsArray; /// 修改地址数组
@end

@implementation JHRecycleLogisticsViewController

- (NSMutableArray *)changeLogisticsArray {
    if (!_changeLogisticsArray) {
        _changeLogisticsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _changeLogisticsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xf5f6fa);
    self.title = @"查看物流";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.view).offset(-10);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    
    [self.headerView addSubview:self.headerBackView];
//    [self.headerBackView addSubview:self.logisticsImageView];
    [self.headerBackView addSubview:self.logisticsLabel];
    [self.headerBackView addSubview:self.lineView];
    
    [self.headerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView);
        make.bottom.mas_equalTo(self.headerView);
        make.left.mas_equalTo(self.headerView).offset(10);
        make.right.mas_equalTo(self.headerView).offset(-10);
    }];
    
//    [self.logisticsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.headerBackView);
//        make.left.mas_equalTo(self.headerBackView).offset(12);
//        make.width.height.mas_equalTo(15);
//    }];
    
    [self.logisticsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headerBackView);
        make.left.mas_equalTo(self.headerBackView).offset(12);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headerBackView);
        make.left.mas_equalTo(self.headerBackView).offset(10);
        make.right.mas_equalTo(self.headerBackView).offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.headerBackView addSubview:self.copyBtn];
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logisticsLabel.mas_right).offset(7.f);
        make.centerY.equalTo(self.logisticsLabel.mas_centerY);
        make.width.mas_equalTo(35.f);
        make.height.mas_equalTo(19.f);
    }];
    if (self.isBusinessZhiSend && self.isZhifaSeller) {
        [self.headerBackView addSubview:self.editBtn];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.headerBackView.mas_right).offset(-16.f);
            make.centerY.equalTo(self.logisticsLabel.mas_centerY);
            make.width.mas_equalTo(40.f);
            make.height.mas_equalTo(17.f);
        }];
        self.editBtn.hidden = self.isZhifaOrderComplete;
        self.changeView = [[JHExpressLogisticsChangeView alloc] init];
        self.changeView.hidden = YES;
        [self.view addSubview:self.changeView];
        [self.changeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        @weakify(self);
        self.changeView.saveBlock = ^(NSString * _Nonnull com, NSString * _Nonnull num) {
            @strongify(self);
            /// 请求网络
            if (!isEmpty(com) && !isEmpty(num)) {
                [self saveNewLogisticsInfo:com num:num];
            } else {
                if (isEmpty(com)) {
                    [UITipView showTipStr:@"修改失败，请选择快递公司"];
                }
                if (isEmpty(num)) {
                    [UITipView showTipStr:@"修改失败，请填写快递单号"];
                }
            }
        };
        self.changeView.cancleBlock = ^{
            @strongify(self);
            self.changeView.hidden = YES;
        };
    }
    self.tableView.tableHeaderView = self.headerView;
    [self loadData];
    if (self.isBusinessZhiSend) {
        [self getNewLogisticsData];
    }
}

- (void)loadData {
    if (self.isBusinessZhiSend) {
        /// 直发物流
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"orderId"]          = @(self.orderId.integerValue);
//        params[@"ordxerId"]          = @(225335);
        params[@"type"]             = [NSString stringWithFormat:@"%ld",self.type];
        [SVProgressHUD show];
        [JHRecycleOrderPurseViewModel getZhifaLogisticsList:params Completion:^(NSError * _Nullable error, JHRecycleLogisticsModel * _Nullable logisticsModel) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            if (!error) {
                self.logisticsModel = logisticsModel;
                self.listArray = logisticsModel.data;
                if (self.isBusinessZhiSend) {
                    self.logisticsLabel.text = [NSString stringWithFormat:@"%@ %@",logisticsModel.com,logisticsModel.nu];
                } else {
                    self.logisticsLabel.text = logisticsModel.com;
                }
                if (logisticsModel.com.length > 0) {
                    self.tableView.tableHeaderView = self.headerView;
                } else {
                    self.tableView.tableHeaderView = nil;
                }
                [self.tableView reloadData];
            }
            if (self.listArray.count == 0) {
                self.headerBackView.hidden = YES;

            } else {
                self.headerBackView.hidden = NO;
            }
        }];
    } else {
        /// 回收物流
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"orderId"] = @(self.orderId.integerValue);
        params[@"type"] = @(self.type);
        [SVProgressHUD show];
        [JHRecycleOrderPurseViewModel getRecycleLogisticsList:params Completion:^(NSError * _Nullable error, JHRecycleLogisticsModel * _Nullable logisticsModel) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            if (!error) {
                self.logisticsModel = logisticsModel;
                self.listArray = logisticsModel.data;
                self.logisticsLabel.text = [NSString stringWithFormat:@"%@ %@",logisticsModel.com,logisticsModel.nu];
                if (logisticsModel.com.length > 0) {
                    self.tableView.tableHeaderView = self.headerView;
                } else {
                    self.tableView.tableHeaderView = nil;
                }
                [self.tableView reloadData];
            }
            if (self.listArray.count == 0) {
                self.headerBackView.hidden = YES;
            } else {
                self.headerBackView.hidden = NO;
            }
        }];
    }
}

- (void)getNewLogisticsData {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/express/") Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:respondObject.data];
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            [muArray addObject:dic[@"name"]];
        }
        self.changeLogisticsArray = muArray;
    } failureBlock:^(RequestModel *respondObject) {}];
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
        cell.emptyLabel.text = @"抱歉,暂无相关物流信息";
        return cell;
    }
    
    JHRecycleLogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleLogisticsCell"];
    cell.model = self.listArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.timeLabel.textColor = HEXCOLOR(0x333333);
        cell.lineTopView.hidden = YES;
        if ([self.logisticsModel.status isEqualToString:@"200"]) {
            cell.desLabel.textColor = HEXCOLOR(0x333333);
            cell.tagImageView.image = [UIImage imageNamed:@"recycle_logistics_finish"];
        } else {
            cell.desLabel.textColor = HEXCOLOR(0xffbf10);
            cell.tagImageView.image = [UIImage imageNamed:@"recycle_logistics_ing"];
        }
    } else {
        cell.timeLabel.textColor = HEXCOLOR(0x999999);
        cell.desLabel.textColor = HEXCOLOR(0x999999);
        cell.tagImageView.image = [UIImage imageNamed:@"recycle_logistics_ed"];
        cell.lineTopView.hidden = NO;
    }
    if (indexPath.row == self.listArray.count - 1) {
        cell.lineBottomView.hidden = YES;
    } else {
        cell.lineBottomView.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listArray.count == 0) {
        return;
    }
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
        _headerView.backgroundColor = HEXCOLOR(0xf5f6fa);
    }
    return _headerView;
}

- (UIView *)headerBackView {
    if (_headerBackView == nil) {
        _headerBackView = [[UIView alloc] init];
        _headerBackView.backgroundColor = HEXCOLOR(0xffffff);
        _headerBackView.hidden = YES;
    }
    return _headerBackView;
}

//- (UIImageView *)logisticsImageView {
//    if (_logisticsImageView == nil) {
//        _logisticsImageView = [[UIImageView alloc] init];
//        _logisticsImageView.image = kDefaultCoverImage;
//    }
//    return _logisticsImageView;
//}

- (UILabel *)logisticsLabel {
    if (_logisticsLabel == nil) {
        _logisticsLabel = [[UILabel alloc] init];
        _logisticsLabel.textColor = HEXCOLOR(0x333333);
        _logisticsLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _logisticsLabel.text = @"";
    }
    return _logisticsLabel;
}

- (UIButton *)copyBtn {
    if (!_copyBtn) {
        _copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _copyBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:11.f];
        [_copyBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_copyBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_copyBtn addTarget:self action:@selector(copyBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _copyBtn.layer.cornerRadius  = 10.5f;
        _copyBtn.layer.masksToBounds = YES;
        _copyBtn.layer.borderWidth   = 0.5f;
        _copyBtn.layer.borderColor   = HEXCOLOR(0xFEE100).CGColor;
        _copyBtn.backgroundColor     = HEXCOLORA(0xFEE100, 0.2f);
    }
    return _copyBtn;
}

- (JHReLayoutButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [JHReLayoutButton buttonWithType:UIButtonTypeCustom];
        _editBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
        [_editBtn setTitle:@"修改" forState:UIControlStateNormal];
        [_editBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_editBtn setImage:[UIImage imageNamed:@"jh_logistics_editIcon"] forState:UIControlStateNormal];
        _editBtn.layoutType = RelayoutTypeRightLeft;
        _editBtn.margin     = -39.f;
    }
    return _editBtn;
}


- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xeeeeee);
    }
    return _lineView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f6fa);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[JHEmptyTableViewCell class] forCellReuseIdentifier:@"JHEmptyTableViewCell"];
        [_tableView registerClass:[JHRecycleLogisticsCell class] forCellReuseIdentifier:@"JHRecycleLogisticsCell"];
        @weakify(self);
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self loadData];
        }];
    }
    return _tableView;
}


/// 复制
- (void)copyBtnClickAction:(UIButton *)btn {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.logisticsModel.nu];
    [UITipView showTipStr:@"复制成功"];
}

/// 修改
- (void)editBtnClickAction:(UIButton *)btn {
    self.changeView.hidden = NO;
    if (self.changeLogisticsArray.count >0) {
        self.changeView.dataArray = self.changeLogisticsArray;
    } else {
        [UITipView showTipStr:@"获取物流信息失败，请稍后再试"];
    }
}

/// 修改快递信息
- (void)saveNewLogisticsInfo:(NSString *)com num:(NSString *)num {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"expressCompany"]   = com;
    dic[@"expressNumber"]    = num;
    dic[@"orderId"]          = self.orderId;
    dic[@"type"]             = @(6);
    dic[@"id"]               = NONNULL_STR(self.logisticsModel.logisticsId);
    [SVProgressHUD show];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/express/updateExpressNo") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        self.changeView.hidden = YES;
        [SVProgressHUD dismiss];
        [UITipView showTipStr:@"修改成功"];
    } failureBlock:^(RequestModel *respondObject) {
        self.changeView.hidden = YES;
        [SVProgressHUD dismiss];
        [UITipView showTipStr:respondObject.message];
    }];
}

@end
