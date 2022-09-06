//
//  JHNewStoreSearchResultSortMenuView.m
//  TTjianbao
//
//  Created by hao on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreSearchResultSortMenuView.h"
#import "JHNewStoreSearchResultSortCell.h"
#import "UIView+JHGradient.h"


@interface JHNewStoreSearchResultSortMenuView ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation JHNewStoreSearchResultSortMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self initSubviews];
        self.hidden = YES;
        
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self.tableView jh_cornerRadius:8.0 rectCorner:UIRectCornerBottomLeft|UIRectCornerBottomRight bounds:self.tableView.bounds];

}
#pragma mark - UI
- (void)initSubviews{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(0);
    }];
    [self layoutIfNeeded];
    [self setNeedsLayout];
    
    //点击背景是否隐藏
    self.tapView = [UIView jh_viewWithColor:UIColor.clearColor addToSuperview:self];
    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.top.equalTo(self.tableView.mas_bottom);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackView)];
    tap.delegate = self;
    [self.tapView addGestureRecognizer:tap];

}

#pragma mark - Action functions
- (void)show {
    self.hidden = NO;
}

- (void)dismiss {
    self.hidden = YES;
}
///点击背景
- (void)tapBackView {
    if (self.selectCompleteBlock) {
        self.selectCompleteBlock(-1);
    }
    [self dismiss];
}


#pragma mark - Data
- (void)setSortDataArray:(NSArray *)sortDataArray{
    _sortDataArray = sortDataArray;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.sortDataArray.count*48+12);
    }];
    [self.tableView reloadData];
}

- (void)setIsReset:(BOOL)isReset{
    _isReset = isReset;
    if (isReset) {
        self.selectIndex = 0;
        [self.tableView reloadData];
    }
}
#pragma mark - Delegate
#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHNewStoreSearchResultSortCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JHNewStoreSearchResultSortCell.class)
                                                                           forIndexPath: indexPath];

    cell.titleLabel.text = self.sortDataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = indexPath.row;

    if (self.selectCompleteBlock) {
        self.selectCompleteBlock(indexPath.row);
    }
    [self dismiss];

}

#pragma mark - Lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = 48;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[JHNewStoreSearchResultSortCell class] forCellReuseIdentifier:NSStringFromClass(JHNewStoreSearchResultSortCell.class)];
    }
    return _tableView;
}



@end
