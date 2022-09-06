//
//  JHRedPacketAlertListView.m
//  TTjianbao
//
//  Created by apple on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRedPacketAlertListView.h"
#import "JHRedPacketListMoneyHeader.h"
#import "UIScrollView+JHEmpty.h"
#import "JHRedPacketTableViewCell.h"
#import "JHRedPacketListUserInfoHeader.h"


@interface JHRedPacketAlertListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) JHRedPacketListUserInfoHeader *sectionHeader;

@property (nonatomic, strong) JHRedPacketListMoneyHeader *headerBg;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIView *emputyView;

@end

@implementation JHRedPacketAlertListView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
    }
    return self;
}
#pragma mark --------------- method creatUI ---------------
-(void)setHasHeader:(BOOL)hasHeader
{
    _hasHeader = hasHeader;
    _bgView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [_bgView jh_cornerRadius:12.f];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(280.f, 370.f));
        make.center.equalTo(self);
    }];
    
    if(_hasHeader)
    {
        _headerBg = [JHRedPacketListMoneyHeader new];
        [_bgView addSubview:_headerBg];
        [_headerBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.bgView);
            make.height.mas_equalTo(148.f);
        }];
        [_headerBg setTitle:self.viewModel.dataSources.wishes price:self.viewModel.dataSources.takeMoney];

    }
    
    UIButton *closeButton = [UIButton jh_buttonWithImage:@"appraise_redPacket_close" target:self action:@selector(hiddenAlert) addToSuperView:self];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_right);
        make.bottom.equalTo(self.bgView.mas_top);
        make.size.mas_equalTo(CGSizeMake(54, 54));
    }];
    
    _tipLabel = [UILabel jh_labelWithText:@"未领取的红包将于24小时后退回" font:12 textColor:RGB(153, 153, 153) textAlignment:1 addToSuperView:self.bgView];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(10.f);
        make.left.right.equalTo(self.bgView);
    }];
    if(!_hasHeader)
    {
        [self.viewModel.requestCommand execute:@1];
    }
}

-(UIView *)createTableHeaderView
{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280.f, 115.5)];
    tableHeaderView.backgroundColor = UIColor.clearColor;
    UIButton *closeButton = [UIButton jh_buttonWithTarget:self action:@selector(balanceClick) addToSuperView:tableHeaderView];
    closeButton.backgroundColor = UIColor.clearColor;
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(tableHeaderView);
        make.height.mas_equalTo(40.f);
    }];
    return tableHeaderView;
}

#pragma mark --------------- tabview Delegate ---------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.emputyView.hidden = self.viewModel.dataSources.takeList.count > 0;
    return self.viewModel.dataSources.takeList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _sectionHeader = [JHRedPacketListUserInfoHeader dequeueReusableHeaderFooterViewWithTableView:tableView];
    if(!_hasHeader)
    {
        [self.sectionHeader.bgViewBottom mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(109.f);
        }];
    }
    
    [_sectionHeader.avatorView jh_setAvatorWithUrl:self.viewModel.dataSources.sendCustomerImg];
    _sectionHeader.nameLabel.text = self.viewModel.dataSources.sendCustomerName;
    _sectionHeader.descLabel.text = self.viewModel.dataSources.countDesc;
    
    return _sectionHeader;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRedPacketTableViewCell *cell = [JHRedPacketTableViewCell dequeueReusableCellWithTableView:tableView];
    NSArray *array = self.viewModel.dataSources.takeList;
    if(indexPath.row < array.count){
        JHGetRedpacketDetailModel *model = array[indexPath.row];
        cell.model = model;
    }
    return cell;
}

#pragma mark --------------- scrollView delagate ---------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_hasHeader) {
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        if(contentOffsetY < 125.f)
        {
            [self.sectionHeader.bgViewBottom mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(77 + 32.f/125.f*contentOffsetY);
            }];
        }
        else
        {
            [self.sectionHeader.bgViewBottom mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(109.f);
            }];
        }
    }
}

#pragma mark --------------- get set ---------------
-(JHRedPacketDetailViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [JHRedPacketDetailViewModel new];
        _viewModel.pageIndex = 0;
        _viewModel.pageSize = 100;
        @weakify(self);
        [_viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self reloadViewData];
            [self.tableView jh_endRefreshing];
        }];
    }
    return _viewModel;
}

-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLine target:self addToSuperView:self.bgView];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionHeaderHeight = 115.5;
        _tableView.rowHeight = 48.f;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
        if (_hasHeader) {
            _tableView.tableHeaderView = [self createTableHeaderView];
        }
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.separatorColor = RGB(238.f, 238.f, 238.f);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bgView).insets(UIEdgeInsetsMake(0, 0, 37, 0));
        }];
        @weakify(self);
        [_tableView jh_headerWithRefreshingBlock:nil footerWithRefreshingBlock:^{
            @strongify(self);
            self.viewModel.pageIndex = 1;
            [self.viewModel.requestCommand execute:@1];
        }];
    }
    return _tableView;
}

#pragma mark --------------- action ---------------
- (void)balanceClick
{
    [JHRouterManager pushAllowanceWithController:self.viewController];
}

#pragma mark --------------- method ---------------
-(void)reloadViewData{
    [self.headerBg setTitle:self.viewModel.dataSources.wishes price:self.viewModel.dataSources.takeMoney];
    if(self.viewModel.dataSources.tips2)
    {
        _tipLabel.text = self.viewModel.dataSources.tips2;
    }
    
    [self.tableView reloadData];
}

-(UIView *)emputyView
{
    if(!_emputyView)
    {
        _emputyView = [UIView jh_viewWithColor:UIColor.clearColor addToSuperview:self.bgView];
        [_emputyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView).offset(-110);
            make.centerX.equalTo(self.bgView);
            make.size.mas_equalTo(CGSizeMake(90, 105));
        }];
        
        UIImageView *icon = [UIImageView jh_imageViewWithImage:@"redpacket_emputy" addToSuperview:_emputyView];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_emputyView);
            make.height.mas_equalTo(71);
        }];
        
        UILabel *label = [UILabel jh_labelWithText:@"暂无数据" font:12 textColor:RGB(153, 153, 153) textAlignment:1 addToSuperView:_emputyView];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.equalTo(_emputyView);
        }];
    }
    return _emputyView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
