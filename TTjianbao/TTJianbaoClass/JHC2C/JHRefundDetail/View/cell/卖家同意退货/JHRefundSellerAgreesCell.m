//
//  JHRefundSellerAgreesCell.m
//  TTjianbao
//
//  Created by hao on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRefundSellerAgreesCell.h"

@interface JHRefundSellerAgreesCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIButton *copyAddressBtn;

@property (nonatomic, strong) UIImageView *locationImgView;
@property (nonatomic, strong) UILabel *adressLabel;
@property (nonatomic, strong) UILabel *contactPersonLabel;
@property (nonatomic, strong) UILabel *phoneNumLabel;
@end

@implementation JHRefundSellerAgreesCell

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
    //说明表述
    [self.backView addSubview:self.descriptionLabel];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.backView).offset(10);
    }];
    //复制地址
    [self.backView addSubview:self.copyAddressBtn];
    [self.copyAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.descriptionLabel);
        make.left.equalTo(self.descriptionLabel.mas_right).offset(10);
    }];
    //地址
    [self.backView addSubview:self.locationImgView];
    [self.locationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(11);
        make.left.equalTo(self.backView).offset(11);
        make.size.mas_equalTo(CGSizeMake(14, 16));
    }];
    [self.backView addSubview:self.adressLabel];
    [self.adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(10);
        make.left.equalTo(self.locationImgView.mas_right).offset(10);
        make.right.equalTo(self.backView).offset(-8);
    }];
    [self.backView addSubview:self.contactPersonLabel];
    [self.contactPersonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adressLabel.mas_bottom).offset(2);
        make.left.equalTo(self.adressLabel);
        make.right.equalTo(self.backView).offset(-8);
    }];
    [self.backView addSubview:self.phoneNumLabel];
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contactPersonLabel.mas_bottom).offset(2);
        make.left.equalTo(self.adressLabel);
        make.right.equalTo(self.backView).offset(-8);
        make.bottom.equalTo(self.backView).offset(-10);
    }];

    
    
}
#pragma mark - LoadData
- (void)bindViewModel:(id)dataModel{
    JHRefundOperationListModel *listModel = dataModel;
    if ([listModel.operationType intValue] == 3) {
        self.titleLabel.text = @"卖家同意退货申请";
    }else if ([listModel.operationType intValue] == 4) {
        self.titleLabel.text = @"卖家超时未处理，系统同意退货";
       
    }else if ([listModel.operationType intValue] == 5) {
        self.titleLabel.text = @"平台介入，同意退货";
    }
    
    //时间
    self.timeLabel.text = [self timestampSwitchTime:[listModel.optTime integerValue]];
    //卖家地址
    self.adressLabel.text = [NSString stringWithFormat:@"卖家地址：%@",listModel.sellerAddress];
    //联系人
    self.contactPersonLabel.text = [NSString stringWithFormat:@"联 系  人：%@",listModel.sellerContacts];
    //联系电话
    self.phoneNumLabel.text = [NSString stringWithFormat:@"联系电话：%@",listModel.sellerPhone];

}


#pragma mark - Action
- (void)clickCopyAddressBtnAction{
    NSString *addressInfo = [NSString stringWithFormat:@"%@\n%@\n%@",self.adressLabel.text, self.contactPersonLabel.text, self.phoneNumLabel.text];
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.string = addressInfo;
    if (pab == nil) {
        JHTOAST(@"复制失败");
    } else {
        JHTOAST(@"已复制");
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
- (UILabel *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textColor = HEXCOLOR(0x666666);
        _descriptionLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _descriptionLabel.text = @"请买家将物品寄往以下地址";
    }
    return _descriptionLabel;
}
- (UIButton *)copyAddressBtn{
    if (!_copyAddressBtn) {
        _copyAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_copyAddressBtn setTitle:@"复制全部" forState:UIControlStateNormal];
        [_copyAddressBtn setTitleColor:HEXCOLOR(0x007AFF) forState:UIControlStateNormal];
        _copyAddressBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [_copyAddressBtn addTarget:self action:@selector(clickCopyAddressBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _copyAddressBtn;
}
- (UIImageView *)locationImgView{
    if (!_locationImgView) {
        _locationImgView = [[UIImageView alloc] init];
        _locationImgView.image = JHImageNamed(@"order_confirm_location_logo");
    }
    return _locationImgView;
}
- (UILabel *)adressLabel{
    if (!_adressLabel) {
        _adressLabel = [[UILabel alloc] init];
        _adressLabel.textColor = HEXCOLOR(0x333333);
        _adressLabel.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _adressLabel;
}
- (UILabel *)contactPersonLabel{
    if (!_contactPersonLabel) {
        _contactPersonLabel = [[UILabel alloc] init];
        _contactPersonLabel.textColor = HEXCOLOR(0x333333);
        _contactPersonLabel.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _contactPersonLabel;
}

- (UILabel *)phoneNumLabel{
    if (!_phoneNumLabel) {
        _phoneNumLabel = [[UILabel alloc] init];
        _phoneNumLabel.textColor = HEXCOLOR(0x333333);
        _phoneNumLabel.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _phoneNumLabel;
}


@end
