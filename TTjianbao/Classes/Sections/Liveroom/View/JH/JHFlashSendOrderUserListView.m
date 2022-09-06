//
//  JHFlashSendOrderUserListView.m
//  TTjianbao
//
//  Created by user on 2021/10/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFlashSendOrderUserListView.h"
#import "JHFlashSendOrderModel.h"
#import "UIButton+LXExpandBtn.h"

@interface JHFlashSendOrderUserListTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
- (void)setViewModel:(JHFlashSendOrderUserListPeopleModel *)viewModel;
@end

@implementation JHFlashSendOrderUserListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.height.offset(18.f);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.height.offset(18.f);
    }];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont fontWithName:kFontNormal size:13.f];
        _nameLabel.textColor = HEXCOLOR(0x333333);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont fontWithName:kFontNormal size:13.f];
        _timeLabel.textColor = HEXCOLOR(0x333333);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (void)setViewModel:(JHFlashSendOrderUserListPeopleModel *)viewModel {
    if (!isEmpty(viewModel.nickName)) {
        if (viewModel.nickName.length>6) {
            self.nameLabel.text = [NSString stringWithFormat:@"%@...",[viewModel.nickName substringWithRange:NSMakeRange(0, 6)]];
        }
    } else {
        self.nameLabel.text = @"";
    }
    self.timeLabel.text = NONNULL_STR(viewModel.createTime);
}

@end


@interface JHFlashSendOrderUserListView ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UILabel        *topTitleLabel;
@property (nonatomic, strong) UILabel        *subTitleLabel;
@property (nonatomic, strong) UIButton       *refreshButton;
@property (nonatomic, strong) UITableView    *userTabelView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) NSInteger       pageIndex;
@end

@implementation JHFlashSendOrderUserListView
- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)showAlert {
    [self makeUI];
    [self getData:YES];
    [super showAlert];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageIndex = 1;
    }
    return self;
}

- (void)makeUI {
    self.closeBtn.hidden = YES;
    [self.backView addSubview:self.topTitleLabel];
    if (!self.isFinish) {
        self.topTitleLabel.text = @"本轮闪购用户名单";
    } else {
        self.topTitleLabel.text = @"本轮闪购结束";
    }
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-30);
        make.width.equalTo(@270);
    }];
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top).offset(16.f);
        make.leading.trailing.equalTo(self.backView);
        make.height.offset(22.f);
    }];
    
    [self.backView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTitleLabel.mas_bottom).offset(5.f);
        make.leading.trailing.equalTo(self.backView);
        make.height.offset(17);
    }];
    
    if (!self.isFinish) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
        [_refreshButton setImage:[UIImage imageNamed:@"JHSendOrder_flashRefresh"] forState:UIControlStateNormal];
        /// 增加点击区域
        _refreshButton.hitTestEdgeInsets = UIEdgeInsetsMake(-5.f, -5.f, -5.f, -5.f);
        [self.backView addSubview:_refreshButton];
        [_refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backView.mas_right).offset(-19.f);
            make.top.equalTo(self.backView.mas_top).offset(14.f);
            make.width.height.offset(14.f);
        }];
    }
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(clickSureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:kFontMedium size:15.f];
    btn.backgroundColor = kColorMain;
    btn.layer.cornerRadius = 20;
    btn.layer.masksToBounds = YES;
    [self.backView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(15.f);
        make.trailing.offset(-15.f);
        make.height.offset(38.f);
        make.bottom.offset(-13.f);
    }];
    
    
    [self.backView addSubview:self.userTabelView];
    [self.userTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(14.f);
        make.leading.trailing.equalTo(self.backView);
        make.bottom.equalTo(btn.mas_top).offset(-11.5f);
        make.height.mas_equalTo(165.f);
    }];
    
    @weakify(self);
    self.userTabelView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];
}

- (void)getData:(BOOL)firstRequest {
    if (firstRequest) {
        [SVProgressHUD show];
    }
    
    if (self.isFinish) {
        @weakify(self);
        [JHDispatch after:1.f execute:^{
            @strongify(self);
            [self request:firstRequest];
        }];
    } else {
        [self request:firstRequest];
    }
}

- (void)request:(BOOL)firstRequest {
    self.pageIndex = 1;
    NSDictionary *dic = @{
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(20),
        @"productCode":NONNULL_STR(self.productCode),
        @"anchorId":NONNULL_STR(self.anchorId)
    };
    @weakify(self);
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/flash/sales/product/buyers") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        if (firstRequest) {
            [SVProgressHUD dismiss];
        }
        [self endRefresh];
        JHFlashSendOrderUserListModel *model = [JHFlashSendOrderUserListModel mj_objectWithKeyValues:respondObject.data];
        if (model) {
            self.subTitleLabel.text = [NSString stringWithFormat: @"参与人数：%@    剩余库存：%@",isEmpty(model.userNumber)?@"0":model.userNumber,isEmpty(model.usableStore)?@"0":model.usableStore];
            [self.dataSourceArray removeAllObjects];
            if (model.rows.count >0) {
                [self.dataSourceArray addObjectsFromArray:model.rows];
                if (self.dataSourceArray.count < [model.total integerValue]) {
                    self.pageIndex ++;
                    [self.userTabelView jh_footerStatusWithNoMoreData:NO];
                    self.userTabelView.mj_footer.hidden = NO;
                } else {
                    [self.userTabelView jh_footerStatusWithNoMoreData:YES];
                    self.userTabelView.mj_footer.hidden = YES;
                }
                [self.userTabelView reloadData];
                self.userTabelView.jh_EmputyView.hidden = YES;
            } else {
                /// 空
                self.userTabelView.jh_EmputyView.hidden = NO;
                [self.userTabelView jh_reloadDataWithEmputyView];
                [self.userTabelView.jh_EmputyView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.self.userTabelView.mas_centerY).offset(40.f);
                }];
                [self.userTabelView jh_footerStatusWithNoMoreData:YES];
                self.userTabelView.mj_footer.hidden = YES;
            }
        } else {
            /// 空
            self.userTabelView.jh_EmputyView.hidden = NO;
            [self.userTabelView jh_reloadDataWithEmputyView];
            [self.userTabelView.jh_EmputyView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.self.userTabelView.mas_centerY).offset(40.f);
            }];
            [self.userTabelView jh_footerStatusWithNoMoreData:YES];
            self.userTabelView.mj_footer.hidden = YES;
        }
    } failureBlock:^(RequestModel *respondObject) {
        @strongify(self);
        if (firstRequest) {
            [SVProgressHUD dismiss];
        }
        [self endRefresh];
        self.userTabelView.jh_EmputyView.hidden = NO;
        [self.userTabelView jh_reloadDataWithEmputyView];
        [self.userTabelView.jh_EmputyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.self.userTabelView.mas_centerY).offset(40.f);
        }];
        [self.userTabelView jh_footerStatusWithNoMoreData:YES];
        self.userTabelView.mj_footer.hidden = YES;
    }];
}

- (void)refreshAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    [sender.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    sender.userInteractionEnabled = YES;
    [self performSelector:@selector(clickAction) withObject:nil afterDelay:0.6f];
}

- (void)clickAction {
    [self getData:NO];
}

- (void)loadMoreData {
    NSDictionary *dic = @{
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(20),
        @"productCode":NONNULL_STR(self.productCode),
        @"anchorId":NONNULL_STR(self.anchorId)
    };
    @weakify(self);
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/flash/sales/product/buyers") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [self endRefresh];
        JHFlashSendOrderUserListModel *model = [JHFlashSendOrderUserListModel mj_objectWithKeyValues:respondObject.data];
        if (model) {
            if (model.rows.count >0) {
                [self.dataSourceArray addObjectsFromArray:model.rows];
                if (self.dataSourceArray.count < [model.total integerValue]) {
                    self.pageIndex ++;
                    [self.userTabelView jh_footerStatusWithNoMoreData:NO];
                    self.userTabelView.mj_footer.hidden = NO;
                } else {
                    [self.userTabelView jh_footerStatusWithNoMoreData:YES];
                    self.userTabelView.mj_footer.hidden = YES;
                }
                [self.userTabelView reloadData];
            } else {
                /// 无更多
                [self.userTabelView jh_footerStatusWithNoMoreData:YES];
                self.userTabelView.mj_footer.hidden = YES;
            }
        } else {
            /// 无更多
            [self.userTabelView jh_footerStatusWithNoMoreData:YES];
            self.userTabelView.mj_footer.hidden = YES;
        }
    } failureBlock:^(RequestModel *respondObject) {
        @strongify(self);
        /// 无更多
        [self endRefresh];
        [self.userTabelView jh_footerStatusWithNoMoreData:YES];
        self.userTabelView.mj_footer.hidden = YES;
    }];
}

- (void)endRefresh {
    [self.userTabelView.mj_header endRefreshing];
    [self.userTabelView.mj_footer endRefreshing];
}

- (void)clickSureBtnAction:(UIButton *)sender {
    [super closeAction:sender];
}

- (UILabel *)topTitleLabel {
    if (!_topTitleLabel) {
        _topTitleLabel = [UILabel new];
        _topTitleLabel.font = [UIFont fontWithName:kFontBoldDIN size:16.f];
        _topTitleLabel.textColor = HEXCOLOR(0x333333);
        _topTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topTitleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
        _subTitleLabel.textColor = HEXCOLOR(0x666666);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLabel;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (UITableView *)userTabelView {
    if (!_userTabelView) {
        _userTabelView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _userTabelView.dataSource                     = self;
        _userTabelView.delegate                       = self;
        _userTabelView.backgroundColor                = HEXCOLOR(0xFFFFFF);
        _userTabelView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _userTabelView.estimatedRowHeight             = 10.f;
        if (@available(iOS 11.0, *)) {
            _userTabelView.estimatedSectionHeaderHeight   = 0.1f;
            _userTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_userTabelView registerClass:[JHFlashSendOrderUserListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHFlashSendOrderUserListTableViewCell class])];
    }
    return _userTabelView;
}

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 33.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHFlashSendOrderUserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHFlashSendOrderUserListTableViewCell class])];
    if (!cell) {
        cell = [[JHFlashSendOrderUserListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHFlashSendOrderUserListTableViewCell class])];
    }
    [cell setViewModel:self.dataSourceArray[indexPath.row]];
    return cell;
}


@end
