//
//  JHFlashSendOrderRecordListView.m
//  TTjianbao
//
//  Created by user on 2021/10/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFlashSendOrderRecordListView.h"
#import "JHFlashSendOrderModel.h"
#import "JHShanGouProductInfoView.h"

@interface JHFlashSendOrderRecordListViewTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
- (void)setViewModel:(JHFlashSendOrderRecordListItemModel *)viewModel;
@end

@implementation JHFlashSendOrderRecordListViewTableViewCell

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
    [self.contentView addSubview:self.moneyLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(6.f);
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.width.mas_equalTo(67.f);
        make.height.mas_equalTo(37.f);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.left.equalTo(self.nameLabel.mas_right).offset(27.f);
        make.width.mas_equalTo(67.f);
        make.height.mas_equalTo(37.f);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.left.equalTo(self.timeLabel.mas_right).offset(36.f);
        make.right.equalTo(self.contentView.mas_right).offset(-18.f);
        make.height.mas_equalTo(18.f);
    }];
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    rightImageView.image = [UIImage imageNamed:@"c2c_class_alert_right"];
    [self.contentView addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLabel.mas_centerY);
        make.left.equalTo(self.moneyLabel.mas_right).offset(4.f);
        make.width.mas_equalTo(4.f);
        make.height.mas_equalTo(8.f);
    }];

    UIView *line = [UIView new];
    line.backgroundColor = HEXCOLOR(0xE6E6E6);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6.f);
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(@(0.5));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont fontWithName:kFontNormal size:13.f];
        _nameLabel.textColor = HEXCOLOR(0x333333);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
        _timeLabel.textColor = HEXCOLOR(0x333333);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.numberOfLines = 0;
    }
    return _timeLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.font = [UIFont fontWithName:kFontNormal size:13.f];
        _moneyLabel.textColor = HEXCOLOR(0x333333);
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

- (void)setViewModel:(JHFlashSendOrderRecordListItemModel *)viewModel {
    self.nameLabel.text  = NONNULL_STR(viewModel.productTitle);
    self.timeLabel.text  = NONNULL_STR(viewModel.createTime);
    self.moneyLabel.text = NONNULL_STR(viewModel.price);
}

@end


@interface JHFlashSendOrderRecordListView ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UILabel        *topTitleLabel;
@property (nonatomic, strong) UITableView    *recordTabelView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) NSInteger       pageIndex;
@end

@implementation JHFlashSendOrderRecordListView

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
    [self.backView addSubview:self.topTitleLabel];
    self.topTitleLabel.text = @"闪购记录";
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
    
    NSArray *titleArrays = @[@"商品标题",@"创建时间",@"金额"];
    CGFloat  labelWidth  = 270.f/3.f;
    for (int i = 0; i< 3; i++) {
        UILabel *label      = [[UILabel alloc] init];
        label.font          = [UIFont fontWithName:kFontNormal size:12.f];
        label.textColor     = HEXCOLOR(0x666666);
        label.textAlignment = NSTextAlignmentCenter;
        label.text          = titleArrays[i];
        [self.backView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView.mas_left).offset(0+labelWidth *i);
            make.top.equalTo(self.topTitleLabel.mas_bottom).offset(10.f);
            make.width.mas_equalTo(labelWidth);
            make.height.mas_equalTo(17.f);
        }];
    }
        
    [self.backView addSubview:self.recordTabelView];
    [self.recordTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTitleLabel.mas_bottom).offset(10.f+17.f+14.f);
        make.leading.trailing.equalTo(self.backView);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.height.mas_equalTo(225.f);
    }];
    
    @weakify(self);
    [self.recordTabelView jh_headerWithRefreshingBlock:^{
        @strongify(self);
        [self getData:NO];
    } footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];
}

- (void)getData:(BOOL)firstRequest {
    self.pageIndex = 1;
    NSDictionary *dic = @{
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(20),
        @"anchorId":NONNULL_STR(self.anchorId)
    };
    if (firstRequest) {
        [SVProgressHUD show];
    }
    @weakify(self);
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/flash/sales/product/records") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        if (firstRequest) {
            [SVProgressHUD dismiss];
        }
        [self endRefresh];
        JHFlashSendOrderRecordListModel *model = [JHFlashSendOrderRecordListModel mj_objectWithKeyValues:respondObject.data];
        if (model) {
            [self.dataSourceArray removeAllObjects];
            if (model.rows.count >0) {
                [self.dataSourceArray addObjectsFromArray:model.rows];
                if (self.dataSourceArray.count < [model.total integerValue]) {
                    self.pageIndex ++;
                    [self.recordTabelView jh_footerStatusWithNoMoreData:NO];
                    self.recordTabelView.mj_footer.hidden = NO;
                } else {
                    [self.recordTabelView jh_footerStatusWithNoMoreData:YES];
                    self.recordTabelView.mj_footer.hidden = YES;
                }
                [self.recordTabelView reloadData];
                self.recordTabelView.jh_EmputyView.hidden = YES;
            } else {
                /// 空
                self.recordTabelView.jh_EmputyView.hidden = NO;
                [self.recordTabelView jh_reloadDataWithEmputyView];
                [self.recordTabelView jh_footerStatusWithNoMoreData:YES];
                self.recordTabelView.mj_footer.hidden = YES;
            }
        } else {
//            /// 空
            self.recordTabelView.jh_EmputyView.hidden = NO;
            [self.recordTabelView jh_reloadDataWithEmputyView];
            [self.recordTabelView jh_footerStatusWithNoMoreData:YES];
            self.recordTabelView.mj_footer.hidden = YES;
        }
    } failureBlock:^(RequestModel *respondObject) {
        @strongify(self);
        if (firstRequest) {
            [SVProgressHUD dismiss];
        }
        [self endRefresh];
        self.recordTabelView.jh_EmputyView.hidden = NO;
        [self.recordTabelView jh_reloadDataWithEmputyView];
        [self.recordTabelView jh_footerStatusWithNoMoreData:YES];
        self.recordTabelView.mj_footer.hidden = YES;
    }];
}

- (void)loadMoreData {
    NSDictionary *dic = @{
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(20),
        @"anchorId":NONNULL_STR(self.anchorId)
    };
    @weakify(self);
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/flash/sales/product/records") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [self endRefresh];
        JHFlashSendOrderRecordListModel *model = [JHFlashSendOrderRecordListModel mj_objectWithKeyValues:respondObject.data];
        if (model) {
            if (model.rows.count >0) {
                [self.dataSourceArray addObjectsFromArray:model.rows];
                if (self.dataSourceArray.count < [model.total integerValue]) {
                    self.pageIndex ++;
                    [self.recordTabelView jh_footerStatusWithNoMoreData:NO];
                    self.recordTabelView.mj_footer.hidden = NO;
                } else {
                    [self.recordTabelView jh_footerStatusWithNoMoreData:YES];
                    self.recordTabelView.mj_footer.hidden = YES;
                }
                [self.recordTabelView reloadData];
            } else {
                /// 无更多
                [self.recordTabelView jh_footerStatusWithNoMoreData:YES];
                self.recordTabelView.mj_footer.hidden = YES;
            }
        } else {
            /// 无更多
            [self.recordTabelView jh_footerStatusWithNoMoreData:YES];
            self.recordTabelView.mj_footer.hidden = YES;
        }
    } failureBlock:^(RequestModel *respondObject) {
        @strongify(self);
        /// 无更多
        [self endRefresh];
        [self.recordTabelView jh_footerStatusWithNoMoreData:YES];
        self.recordTabelView.mj_footer.hidden = YES;
    }];
}

- (void)endRefresh {
    [self.recordTabelView.mj_header endRefreshing];
    [self.recordTabelView.mj_footer endRefreshing];
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

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (UITableView *)recordTabelView {
    if (!_recordTabelView) {
        _recordTabelView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _recordTabelView.dataSource                     = self;
        _recordTabelView.delegate                       = self;
        _recordTabelView.backgroundColor                = HEXCOLOR(0xFFFFFF);
        _recordTabelView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _recordTabelView.estimatedRowHeight             = 10.f;
        if (@available(iOS 11.0, *)) {
            _recordTabelView.estimatedSectionHeaderHeight   = 0.1f;
            _recordTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_recordTabelView registerClass:[JHFlashSendOrderRecordListViewTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHFlashSendOrderRecordListViewTableViewCell class])];
    }
    return _recordTabelView;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHFlashSendOrderRecordListViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHFlashSendOrderRecordListViewTableViewCell class])];
    if (!cell) {
        cell = [[JHFlashSendOrderRecordListViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHFlashSendOrderRecordListViewTableViewCell class])];
    }
    [cell setViewModel:self.dataSourceArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHFlashSendOrderRecordListItemModel *model = self.dataSourceArray[indexPath.row];
    /// 跳转闪购商品详情
    if (self.showProductBlock) {
        self.showProductBlock(model.productCode);
    }
    [self hiddenAlert];
}



@end
