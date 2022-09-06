//
//  JHRefundSellerProcessingCell.m
//  TTjianbao
//
//  Created by hao on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRefundSellerProcessingCell.h"
#import "JHIMEntranceManager.h"
#import "JHReportAddressManagerViewController.h"

@interface JHRefundSellerProcessingCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *contactSellerLabel;
@end

@implementation JHRefundSellerProcessingCell

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
    //说明
    [self.backView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.backView).offset(10);
        make.right.equalTo(self.backView).offset(-10);
    }];
    [self.backView addSubview:self.contactSellerLabel];
    [self.contactSellerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.backView).offset(10);
        make.bottom.equalTo(self.backView).offset(-10);
    }];
    self.contactSellerLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *jh_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickContactSellerBtnAction)];
    [self.contactSellerLabel addGestureRecognizer:jh_tapGesture];
    

}
#pragma mark - LoadData
- (void)bindViewModel:(id)dataModel{
    JHRefundOperationListModel *listModel = dataModel;
    //时间
    self.timeLabel.text = [self timestampSwitchTime:[listModel.optTime integerValue]];
    //标题
    if ([listModel.operationType intValue] == 4) {
        self.titleLabel.text = @"卖家超时未处理，系统同意退货";
        self.contentLabel.text = listModel.text3;
        if (self.userIdentity == 1) {
            self.contactSellerLabel.text = @"联系卖家";
        }else{
            self.contactSellerLabel.text = @"+ 填写退货地址";
        }
    }else if ([listModel.operationType intValue] == 5) {
        self.titleLabel.text = @"平台介入，同意退货";
        self.contentLabel.text = listModel.text3;
        if (self.userIdentity == 1) {
            self.contactSellerLabel.text = @"联系卖家";
        }else{
            self.contactSellerLabel.text = @"+ 填写退货地址";
        }
    }
    else if ([listModel.operationType intValue] == 7){
        self.titleLabel.text = @"卖家收货后同意退款";
        ///只显示一行标题的状态
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.backView).offset(10);
            make.bottom.equalTo(self.backView).offset(-10);
        }];
    }else if ([listModel.operationType intValue] == 8){
        self.titleLabel.text = @"卖家超时未处理，系统同意退款";
        ///只显示一行标题的状态
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.backView).offset(10);
            make.bottom.equalTo(self.backView).offset(-10);
        }];
    }else if ([listModel.operationType intValue] == 12){
        self.titleLabel.text = @"卖家同意退款";
        ///只显示一行标题的状态
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.backView).offset(10);
            make.bottom.equalTo(self.backView).offset(-10);
        }];
    }else if ([listModel.operationType intValue] == 13){
        self.titleLabel.text = @"卖家超时未处理，系统自动退款";
        ///只显示一行标题的状态
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.backView).offset(10);
            make.bottom.equalTo(self.backView).offset(-10);
        }];
    }else if ([listModel.operationType intValue] == 16){
        self.titleLabel.text = @"平台介入，同意退款";
        ///只显示一行标题的状态
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.backView).offset(10);
            make.bottom.equalTo(self.backView).offset(-10);
        }];
    }

}


#pragma mark - Action
///联系卖家--IM
- (void)clickContactSellerBtnAction{
    
    //if买家端 -- 联系卖家
    if (self.userIdentity == 1) {
        [JHIMEntranceManager pushSessionWithUserId:self.userId orderInfo:self.orderInfo];
    }else{//if卖家端 -- 填写退货地址
        JHReportAddressManagerViewController *addressVC = [[JHReportAddressManagerViewController alloc] init];
        addressVC.orderId = self.orderId;
        addressVC.workOrderId = self.workOrderId;
        addressVC.workOrderStatus = self.workOrderStatus;
        [JHRootController.currentViewController.navigationController pushViewController:addressVC animated:YES];
        @weakify(self);
        [addressVC.reloadUPData subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            //成功刷新页面
            if (self.reloadDataBlock) {
                self.reloadDataBlock();
            }
        }];
    }
}
#pragma mark - Delegate

#pragma mark - Lazy
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
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
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXCOLOR(0x666666);
        _contentLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (UILabel *)contactSellerLabel{
    if (!_contactSellerLabel) {
        _contactSellerLabel = [[UILabel alloc] init];
        _contactSellerLabel.textColor = HEXCOLOR(0x007AFF);
        _contactSellerLabel.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _contactSellerLabel;
}

@end
