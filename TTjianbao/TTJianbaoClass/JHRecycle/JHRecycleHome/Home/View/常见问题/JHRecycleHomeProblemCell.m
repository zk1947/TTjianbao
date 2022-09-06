//
//  JHRecycleHomeProblemCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeProblemCell.h"
#import "JHRecycleHomeProblemTableViewCell.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHRecycleItemViewModel.h"
@interface JHRecycleHomeProblemCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UILabel *noMoreLabel;
@property (nonatomic, strong) UIButton *helpCentreButton;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JHRecycleHomeProblemCell

#pragma mark - UI
- (void)configUI{
    
    [self.backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.backView).offset(12);
    }];
    
    
    [self.backView addSubview:self.helpCentreButton];
    [self.helpCentreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView).offset(-12);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    [self.backView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.backView).insets(UIEdgeInsetsMake(38.5, 0, 46.5, 0));
        make.left.right.equalTo(self.backView);
        make.top.offset(38);
        make.bottom.offset(46);
    }];
    //查看更多
    [self.backView addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.bottom.equalTo(self.backView).offset(-10);
    }];
    
    [self.backView addSubview:self.noMoreLabel];
    [self.noMoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.moreButton);
    }];
    self.noMoreLabel.hidden = YES;
    
}
#pragma mark - Action

- (void)clickMoreBtnAction:(UIButton *)sender{
    
    [self.lookMoreSubject sendNext:@YES];
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickSeeMore" params:@{
        @"more_type":@"FAQ",
        @"page_position":@"recycleHome"
    } type:JHStatisticsTypeSensors];
   
//    [JHRouterManager pushWebViewWithUrl:H5_BASE_STRING(@"/jianhuo/help.html") title:@"帮助中心" controller:JHRootController];
//    [JHAllStatistics jh_allStatisticsWithEventId:@"clickSeeMore" params:@{
//        @"more_type":@"FAQ",
//        @"page_position":@"recycleHome"
//    } type:JHStatisticsTypeSensors];
}
- (void)helpBtnAction:(UIButton *)sender{
    [JHRouterManager pushWebViewWithUrl:H5_BASE_STRING(@"/jianhuo/help.html") title:@"帮助中心" controller:JHRootController];
   
}


#pragma mark - LoadData
- (void)bindViewModel:(id)dataModel{
    [self.dataArray removeAllObjects];

    JHRecycleItemViewModel *itemViewModel = dataModel;
    [self.dataArray addObjectsFromArray:itemViewModel.dataModel[@"rows"]];
    //[self.dataArray addObjectsFromArray:itemViewModel.dataModel];
    [self.tableView reloadData];
    
    if ([itemViewModel.dataModel[@"isHasMore"] isEqual:@"0"]) {
        self.moreButton.hidden = YES;
        self.noMoreLabel.hidden = NO;
    }
    else{
        self.moreButton.hidden = NO;
        self.noMoreLabel.hidden = YES;
    }
    
}



#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleHomeProblemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHRecycleHomeProblemTableViewCell class])];
    
    JHHomeRecycleHelpArticleListModel *problemListModel = self.dataArray[indexPath.row];
    [cell bindViewModel:problemListModel params:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    JHHomeRecycleHelpArticleListModel *problemListModel = self.dataArray[indexPath.row];
    NSString *urlStr = [NSString stringWithFormat:@"/jianhuo/helpdesc.html?id=%@&title=%@",problemListModel.ID, [problemListModel.title stringByURLEncode]];
    [JHRouterManager pushWebViewWithUrl:H5_BASE_STRING(urlStr) title:@"帮助中心" controller:JHRootController];

    [JHAllStatistics jh_allStatisticsWithEventId:@"clickCommonQuestion" params:@{
        @"question_name":problemListModel.title,
        @"page_position":@"recycleHome"
    } type:JHStatisticsTypeSensors];
}


#pragma mark - Lazy
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = 35;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[JHRecycleHomeProblemTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleHomeProblemTableViewCell class])];

        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
            _tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
            _tableView.scrollIndicatorInsets =_tableView.contentInset;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }

    }
    return  _tableView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = HEXCOLOR(0x222222);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:16];
        _titleLabel.text = @"常见问题";
    }
    return _titleLabel;
}

- (UILabel *)noMoreLabel{
    if (!_noMoreLabel) {
        _noMoreLabel = [UILabel new];
        _noMoreLabel.textColor = HEXCOLOR(0x222222);
        _noMoreLabel.text = @"已经到底了~";
        _noMoreLabel.backgroundColor = HEXCOLOR(0xF7F7F7);
        _noMoreLabel.layer.cornerRadius = 4;
        _noMoreLabel.textAlignment = NSTextAlignmentCenter;
        _noMoreLabel.font = [UIFont fontWithName:kFontNormal size:12];
        
    }
    return _noMoreLabel;
}
- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        [_moreButton setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_moreButton setImage:[UIImage imageNamed:@"recycle_homeMore_right_icon"] forState:UIControlStateNormal];
        [_moreButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
        [_moreButton addTarget:self action:@selector(clickMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreButton.backgroundColor = HEXCOLOR(0xF7F7F7);
        _moreButton.layer.cornerRadius = 4;
        _moreButton.layer.masksToBounds = YES;
        _moreButton.contentEdgeInsets = UIEdgeInsetsMake(5, 12, 5, 16);
        
    }
    return _moreButton;
}
- (UIButton *)helpCentreButton{
    if (!_helpCentreButton) {
        _helpCentreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpCentreButton setTitle:@"帮助中心" forState:UIControlStateNormal];
        [_helpCentreButton setTitleColor:HEXCOLOR(0x2F66A0) forState:UIControlStateNormal];
        _helpCentreButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_helpCentreButton addTarget:self action:@selector(helpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
       // _helpCentreButton.backgroundColor = HEXCOLOR(0xF7F7F7);
        
    }
    return _helpCentreButton;
}
- (RACSubject *)lookMoreSubject{
    if (!_lookMoreSubject) {
        _lookMoreSubject = [[RACSubject alloc] init];
    }
    return _lookMoreSubject;
}
@end
