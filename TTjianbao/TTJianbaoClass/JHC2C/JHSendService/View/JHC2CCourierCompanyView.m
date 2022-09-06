//
//  JHC2CCourierCompanyView.m
//  TTjianbao
//
//  Created by hao on 2021/6/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CCourierCompanyView.h"
#import "JHC2CCourierCompanyTableCell.h"
#import "UIView+JHGradient.h"
#import "JHRecycleOrderCancelCellViewModel.h"
#import "JHC2CSendServiceModel.h"


@interface JHC2CCourierCompanyView ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation JHC2CCourierCompanyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
                
        [self initSubviews];
        
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self.headerView jh_cornerRadius:8.0 rectCorner:UIRectCornerTopLeft|UIRectCornerTopRight bounds:self.headerView.bounds];

}
#pragma mark - UI
- (void)initSubviews{
    UIView *bottomView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(84);
    }];
    [bottomView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomView);
        make.left.equalTo(bottomView).offset(32);
        make.right.equalTo(bottomView).offset(-32);
        make.height.mas_equalTo(44);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_top).offset(0);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(322);
    }];

    [self addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(51);
        make.bottom.equalTo(self.tableView.mas_top);
    }];
    [self layoutIfNeeded];
    [self setNeedsLayout];

    [self.headerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(14);
        make.centerX.equalTo(self.headerView);
    }];
    [self.headerView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.headerView).offset(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    //点击背景是否隐藏
    self.tapView = [UIView jh_viewWithColor:UIColor.clearColor addToSuperview:self];
    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.headerView.mas_top);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self.tapView addGestureRecognizer:tap];
    
    [JHKeyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(JHKeyWindow);
    }];

}

#pragma mark - Action functions
- (void)show {
    self.hidden = NO;

}
- (void)dismiss {
    self.hidden = YES;
}
///关闭
- (void)didClickCloseWithAction : (UIButton *)sender {
    [self dismiss];
}
///确定
- (void)didClickConfirmAction : (UIButton *)sender {
    if (self.selectCompleteBlock) {
        self.selectCompleteBlock(self.selectIndex);
    }
    [self dismiss];
}


#pragma mark - Data
- (void)setExpressCompanyListData:(NSArray *)expressCompanyListData{
    _expressCompanyListData = expressCompanyListData;
    if (expressCompanyListData.count < 7) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.expressCompanyListData.count*50);
        }];
        self.tableView.scrollEnabled = NO;
    }
    [self.tableView reloadData];
}

#pragma mark - uitableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.expressCompanyListData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHC2CCourierCompanyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHC2CCourierCompanyTableCell"
                                                                           forIndexPath: indexPath];
    JHC2CExpressCompanyListModel *listModel = self.expressCompanyListData[indexPath.row];
    cell.titleLabel.text = listModel.expressCompanyName;
       
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = indexPath.row;

}

#pragma mark - Lazy
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = UIColor.whiteColor;
    }
    return _headerView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"请选择快递公司";
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:17];
    }
    return _titleLabel;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton
        .jh_imageName(@"recycle_pickup_close_icon")
        .jh_action(self,@selector(didClickCloseWithAction:));
        _closeButton.contentEdgeInsets = UIEdgeInsetsMake(13, 13, 13, 13);

    }
    return _closeButton;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.rowHeight = 50;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[JHC2CCourierCompanyTableCell class] forCellReuseIdentifier:@"JHC2CCourierCompanyTableCell"];
    }
    return _tableView;
}
- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        [_confirmButton jh_cornerRadius:22];
        [_confirmButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xffd710), HEXCOLOR(0xffc242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        [_confirmButton addTarget:self action:@selector(didClickConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
