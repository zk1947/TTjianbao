//
//  JHRefundBuyerReturnedCell.m
//  TTjianbao
//
//  Created by hao on 2021/5/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRefundBuyerReturnedCell.h"
#import "JHRecycleLogisticsViewController.h"

@interface JHRefundBuyerReturnedCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *logisticsNumText;
@property (nonatomic, strong) UILabel *logisticsNumLabel;
@property (nonatomic, strong) UILabel *logisticsNameText;
@property (nonatomic, strong) UILabel *logisticsNameLabel;
@property (nonatomic, strong) UIButton *lookLogisticsBtn;

@end

@implementation JHRefundBuyerReturnedCell

#pragma mark - UI
- (void)setupViews{
    //标题
    [self.backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.backView).offset(10);
    }];
    //时间
    [self.backView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.backView).offset(-10);
    }];
    //物流单号
    [self.backView addSubview:self.logisticsNumText];
    [self.logisticsNumText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.backView).offset(10);
    }];
    [self.backView addSubview:self.logisticsNumLabel];
    [self.logisticsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logisticsNumText);
        make.left.equalTo(self.logisticsNumText.mas_right).offset(10);
    }];
    //物流名称
    [self.backView addSubview:self.logisticsNameText];
    [self.logisticsNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logisticsNumText.mas_bottom).offset(10);
        make.left.equalTo(self.backView).offset(10);
        make.bottom.equalTo(self.backView).offset(-10);
    }];
    [self.backView addSubview:self.logisticsNameLabel];
    [self.logisticsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logisticsNameText);
        make.left.equalTo(self.logisticsNameText.mas_right).offset(10);
    }];
    //查看物流动态
    [self.backView addSubview:self.lookLogisticsBtn];
    [self.lookLogisticsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logisticsNameText);
        make.left.equalTo(self.logisticsNameLabel.mas_right).offset(10);
    }];
    
}
#pragma mark - LoadData
- (void)bindViewModel:(id)dataModel{
    JHRefundOperationListModel *listModel = dataModel;
    //时间
    self.timeLabel.text = [self timestampSwitchTime:[listModel.optTime integerValue]];
    //物流单号
    self.logisticsNumLabel.text = listModel.logisticsOrderNo;
    //物流公司
    self.logisticsNameLabel.text = listModel.logisticsServiceName;
}

#pragma mark - Action
///查看物流动态
- (void)clickLookLogisticsBtnAction{
    JHRecycleLogisticsViewController *logisticsVC = [[JHRecycleLogisticsViewController alloc] init];
    logisticsVC.orderId = self.orderId;
    logisticsVC.type = 7;
//    logisticsVC.type = ([self.orderStatusCode integerValue] == 9 || [self.orderStatusCode integerValue] ==10) ? 7 : 6;
    [JHRootController.currentViewController.navigationController pushViewController:logisticsVC animated:YES];


}
#pragma mark - Delegate

#pragma mark - Lazy
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _titleLabel.text = @"买家已退货";
    }
    return _titleLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x999999);
        _timeLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _timeLabel;
}

- (UILabel *)logisticsNumText{
    if (!_logisticsNumText) {
        _logisticsNumText = [[UILabel alloc] init];
        _logisticsNumText.textColor = HEXCOLOR(0x999999);
        _logisticsNumText.font = [UIFont fontWithName:kFontNormal size:13];
        _logisticsNumText.text = @"物流单号";
    }
    return _logisticsNumText;
}
- (UILabel *)logisticsNumLabel{
    if (!_logisticsNumLabel) {
        _logisticsNumLabel = [[UILabel alloc] init];
        _logisticsNumLabel.textColor = HEXCOLOR(0x333333);
        _logisticsNumLabel.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _logisticsNumLabel;
}

- (UILabel *)logisticsNameText{
    if (!_logisticsNameText) {
        _logisticsNameText = [[UILabel alloc] init];
        _logisticsNameText.textColor = HEXCOLOR(0x999999);
        _logisticsNameText.font = [UIFont fontWithName:kFontNormal size:13];
        _logisticsNameText.text = @"物流公司";
    }
    return _logisticsNameText;
}
- (UILabel *)logisticsNameLabel{
    if (!_logisticsNameLabel) {
        _logisticsNameLabel = [[UILabel alloc] init];
        _logisticsNameLabel.textColor = HEXCOLOR(0x333333);
        _logisticsNameLabel.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _logisticsNameLabel;
}

- (UIButton *)lookLogisticsBtn{
    if (!_lookLogisticsBtn) {
        _lookLogisticsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lookLogisticsBtn setTitle:@"查看物流动态" forState:UIControlStateNormal];
        [_lookLogisticsBtn setTitleColor:HEXCOLOR(0x007AFF) forState:UIControlStateNormal];
        _lookLogisticsBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [_lookLogisticsBtn addTarget:self action:@selector(clickLookLogisticsBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookLogisticsBtn;
}
@end
