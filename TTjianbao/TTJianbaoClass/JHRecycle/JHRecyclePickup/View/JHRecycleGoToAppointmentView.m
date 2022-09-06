//
//  JHRecycleGoToAppointmentView.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleGoToAppointmentView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHUIFactory.h"
#import "AdressManagerViewController.h"
#import "JHPickupDatePickerView.h"


@interface JHRecycleGoToAppointmentView ()
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *pickUpinfoView;
@property (nonatomic, strong) UIImageView *logisticsLogoImg;//快递logo
@property (nonatomic, strong) UILabel *logisticsTitleLabel;//快递名称
@property (nonatomic, strong) UIStackView *logisticsStackView;
//上门时间
@property (nonatomic, strong) UILabel *timeTitleLabel;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UILabel *timeTextLabel;
@property (nonatomic, strong) UILabel *timeLabel;//取件时间
//取件地址
@property (nonatomic, strong) UILabel *addressTitleLabel;
@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UILabel *addressTextLabel;
@property (nonatomic, strong) UIImageView *addressLogoImg;
@property (nonatomic, strong) UILabel *addressLabel;//取件地址
@property (nonatomic, strong) UILabel *changeLabel;
//包装
@property (nonatomic, strong) UIView *packageInfoView;
@property (nonatomic, strong) UILabel *packageTitleLabel;
@property (nonatomic, strong) UILabel *packageLabel;//包装文字内容
@property (nonatomic, strong) UIImageView *packageImg;//包装图片
@property (nonatomic, strong) UILabel *remindLabel;


@end

@implementation JHRecycleGoToAppointmentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF5F5F8);
        [self initSubViews];
    }
    return self;
}

#pragma mark - UI
- (void)initSubViews{
    [self addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //预约取件信息
    [self addPickUpInfoView];
    
    //包装说明信息
    [self addPackageInfoView];
    
    //选择时间
    [self clickTimeAction];

    //选择地址
    [self clickAddressAction];

}
///预约取件信息
- (void)addPickUpInfoView{
    [self.contentScrollView addSubview:self.pickUpinfoView];
    [self.pickUpinfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScrollView).offset(10);
        make.left.equalTo(self.contentScrollView).offset(12);
        make.right.equalTo(self.contentScrollView).offset(-12);
        make.width.offset(kScreenWidth-24);
    }];
    //物流
    [self.pickUpinfoView addSubview:self.logisticsStackView];
    [self.logisticsStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickUpinfoView).offset(12);
        make.centerX.equalTo(self.pickUpinfoView);
        make.height.mas_equalTo(14);
    }];
    
    //时间View
    [self.pickUpinfoView addSubview:self.timeTitleLabel];
    [self.timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logisticsStackView.mas_bottom).offset(20);
        make.left.equalTo(self.pickUpinfoView).offset(12);
    }];
    [self.pickUpinfoView addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeTitleLabel.mas_bottom).offset(0);
        make.left.right.equalTo(self.pickUpinfoView).offset(0);
        make.height.mas_equalTo(44);
    }];
    [self.timeView addSubview:self.timeTextLabel];
    [self.timeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeView).offset(12);
        make.centerY.equalTo(self.timeView);
        make.width.mas_equalTo(85);
    }];
    //时间
    [self.timeView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeView).offset(-28);
        make.left.equalTo(self.timeTextLabel.mas_right).offset(20);
        make.centerY.equalTo(self.timeView);
    }];
    UIImageView *timeNextImg = [[UIImageView alloc] init];
    timeNextImg.image = JHImageNamed(@"recycle_uploadproduct_arrow");
    [self.timeView addSubview:timeNextImg];
    [timeNextImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeView).offset(-15);
        make.centerY.equalTo(self.timeView);
    }];
    JHCustomLine *line = [JHUIFactory createLine];
    [self.pickUpinfoView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView.mas_bottom).offset(0);
        make.height.offset(0.5);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    
    //地址View
    [self.pickUpinfoView addSubview:self.addressTitleLabel];
    [self.addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView.mas_bottom).offset(12);
        make.left.equalTo(self.pickUpinfoView).offset(12);
    }];
    [self.pickUpinfoView addSubview:self.addressView];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTitleLabel.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.pickUpinfoView);
    }];
    [self.addressView addSubview:self.addressTextLabel];

    //图标
    [self.addressView addSubview:self.addressLogoImg];

    //地址
    [self.addressView addSubview:self.addressLabel];

    //联系方式
    [self.addressView addSubview:self.nameLabel];

    
    UIImageView *addressNextImg = [[UIImageView alloc] init];
    addressNextImg.image = JHImageNamed(@"recycle_uploadproduct_arrow");
    [self.addressView addSubview:addressNextImg];
    [addressNextImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressView).offset(-15);
        make.centerY.equalTo(self.addressView);
    }];
    
    [self.addressView addSubview:self.changeLabel];
    [self.changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressView).offset(-28);
        make.centerY.equalTo(self.addressView);
    }];
    
    
    
}
///包装说明信息
- (void)addPackageInfoView{
    [self.contentScrollView addSubview:self.packageInfoView];
    [self.packageInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickUpinfoView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScrollView).offset(12);
        make.right.equalTo(self.contentScrollView).offset(-12);
        make.width.offset(kScreenWidth-24);
    }];
    [self.packageInfoView addSubview:self.packageTitleLabel];
    [self.packageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.packageInfoView).offset(12);
        make.left.equalTo(self.packageInfoView).offset(10);
    }];
    //包装说明
    [self.packageInfoView addSubview:self.packageLabel];
    [self.packageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.packageTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.packageInfoView).offset(10);
        make.right.equalTo(self.packageInfoView).offset(-10);
    }];
    //包装图
    [self.packageInfoView addSubview:self.packageImg];
    [self.packageImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.packageLabel.mas_bottom).offset(10);
        make.left.equalTo(self.packageInfoView).offset(10);
        make.right.equalTo(self.packageInfoView).offset(-10);
        make.bottom.equalTo(self.packageInfoView).offset(-12);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-44, (kScreenWidth-44)*9/16));//16:9
    }];
    
    //温馨提示
    [self.contentScrollView addSubview:self.remindLabel];
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.packageInfoView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScrollView).offset(12);
        make.right.equalTo(self.contentScrollView).offset(-12);
        make.bottom.equalTo(self.contentScrollView).offset(-40);
    }];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: _remindLabel.text];
    [attrString addAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x666666)} range:[[attrString string] rangeOfString:@"温馨提示："]];
    _remindLabel.attributedText = attrString;
    
}



#pragma mark - LoadData
- (void)bindViewModel:(id)dataModel params:(NSDictionary *)parmas{
    JHRecyclePickupGoToAppointmentModel *goToAppointmentModel = dataModel;
    //物流logo
    JHRecyclePickupLogisticsInfoModel *logisticsInfo = goToAppointmentModel.logisticsInfo[0];
    self.logisticsTitleLabel.text = [NSString stringWithFormat:@"%@上门取件",logisticsInfo.logisticsTitle];
    [self.logisticsLogoImg jh_setImageWithUrl:[logisticsInfo.logisticsImage small] placeHolder:@"newStore_default_placehold"];
    CGFloat w = 14*[[logisticsInfo.logisticsImage w] floatValue]/[[logisticsInfo.logisticsImage h] floatValue];
    [self.logisticsLogoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(w, 14));
    }];
    
    //包装说明
    self.packageLabel.text = goToAppointmentModel.packingAdvice;
    //包装图
    NSString *packageImgUrl = [goToAppointmentModel.adviceImgUrl.medium stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    [self.packageImg jh_setImageWithUrl:packageImgUrl placeHolder:@"newStore_default_placehold"];
    //地址
    if (goToAppointmentModel.pickAddress.phone.length > 0) {
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",goToAppointmentModel.pickAddress.province, goToAppointmentModel.pickAddress.city, goToAppointmentModel.pickAddress.county, goToAppointmentModel.pickAddress.detail];
        self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",goToAppointmentModel.pickAddress.receiverName, goToAppointmentModel.pickAddress.phone];

        self.pickupAddressModel = goToAppointmentModel.pickAddress;

    }

    [self updateAddressInfoView];
}




#pragma mark - Action
- (void)clickTimeAction{
    @weakify(self);
    [self.timeView jh_addTapGesture:^{
        @strongify(self);
        JHPickupDatePickerView *pickerView = [[JHPickupDatePickerView alloc] initWithDatePickerViewCompleteBlock:^(NSString * _Nonnull startTimeStr, NSString * _Nonnull endTimeStr, NSString * _Nonnull showDateStr) {
            self.timeLabel.textColor = HEXCOLOR(0x333333);
            self.timeLabel.font = [UIFont fontWithName:kFontMedium size:14];
            self.timeLabel.text = showDateStr;
            //返回时间段
            self.startTime = startTimeStr;
            self.endTime = endTimeStr;
        }];
        [pickerView show];
        
    }];
}
///选择地址薄
- (void)clickAddressAction{
    @weakify(self);
    [self.addressView jh_addTapGesture:^{
        @strongify(self);
        //修改地址/新增地址
        NSString *operation_type = self.addressLabel.text.length>0 ? @"change" : @"add";
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickAddress" params:@{
            @"operation_type":operation_type,
            @"page_position":@"appointmentPickUp"
        } type:JHStatisticsTypeSensors];
        
        AdressManagerViewController *addressVC = [AdressManagerViewController new];
        addressVC.selectedBlock = ^(AdressMode *model) {
            self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",model.province, model.city, model.county, model.detail];
            self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",model.receiverName, model.phone];
            self.addressModel = model;
            
            [self updateAddressInfoView];
        };
        [self.viewController.navigationController  pushViewController:addressVC animated:YES];
        
    }];
}
///更新地址显示
- (void)updateAddressInfoView{
    if (self.addressLabel.text.length > 0) {
        self.changeLabel.text = @"修改";
        self.addressTextLabel.hidden = YES;
        //图标
        [self.addressLogoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addressView).offset(12);
            make.centerY.equalTo(self.addressView);
            make.size.mas_equalTo(CGSizeMake(24, 27));
        }];
        //地址
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addressView).offset(12);
            make.left.equalTo(self.addressLogoImg.mas_right).offset(12);
            make.right.equalTo(self.addressView).offset(-80);
        }];
        //联系方式
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addressLabel.mas_bottom).offset(4);
            make.left.equalTo(self.addressLabel);
            make.right.equalTo(self.addressView).offset(-80);
            make.bottom.equalTo(self.addressView).offset(-12);
        }];
    }else{
        self.changeLabel.text = @"新增地址";
        self.addressTextLabel.hidden = NO;
        [self.addressTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addressView).offset(12);
            make.left.equalTo(self.addressView).offset(12);
            make.bottom.equalTo(self.addressView).offset(-12);

        }];
    }
}


#pragma mark - Delegate



#pragma mark - Lazy
- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = YES;
        _contentScrollView.scrollEnabled = YES;
        _contentScrollView.alwaysBounceVertical = YES;
    }
    return _contentScrollView;
}
- (UIView *)pickUpinfoView{
    if (!_pickUpinfoView) {
        _pickUpinfoView = [[UIView alloc] init];
        _pickUpinfoView.backgroundColor = UIColor.whiteColor;
        _pickUpinfoView.layer.cornerRadius = 5;
        _pickUpinfoView.layer.masksToBounds = YES;
    }
    return _pickUpinfoView;
}
- (UIImageView *)logisticsLogoImg{
    if (!_logisticsLogoImg) {
        _logisticsLogoImg = [[UIImageView alloc] init];
    }
    return _logisticsLogoImg;
}
- (UILabel *)logisticsTitleLabel{
    if (!_logisticsTitleLabel) {
        _logisticsTitleLabel = [[UILabel alloc] init];
        _logisticsTitleLabel.textColor = HEXCOLOR(0x333333);
        _logisticsTitleLabel.font = [UIFont fontWithName:kFontMedium size:14];
    }
    return _logisticsTitleLabel;
}
- (UIStackView *)logisticsStackView {
    if (!_logisticsStackView) {
        _logisticsStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.logisticsLogoImg, self.logisticsTitleLabel]];
        _logisticsStackView.spacing = 5;
    }
    return _logisticsStackView;
}
- (UILabel *)timeTitleLabel{
    if (!_timeTitleLabel) {
        _timeTitleLabel = [[UILabel alloc] init];
        _timeTitleLabel.textColor = HEXCOLOR(0x333333);
        _timeTitleLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _timeTitleLabel.text = @"预约信息";
    }
    return _timeTitleLabel;
}
- (UIView *)timeView{
    if (!_timeView) {
        _timeView = [[UIView alloc] init];
        _timeView.backgroundColor = UIColor.whiteColor;
    }
    return _timeView;
}
- (UILabel *)timeTextLabel{
    if (!_timeTextLabel) {
        _timeTextLabel = [[UILabel alloc] init];
        _timeTextLabel.textColor = HEXCOLOR(0x999999);
        _timeTextLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _timeTextLabel.text = @"上门取件时间";
    }
    return _timeTextLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x999999);
        _timeLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _timeLabel.text = @"请选择";
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)addressTitleLabel{
    if (!_addressTitleLabel) {
        _addressTitleLabel = [[UILabel alloc] init];
        _addressTitleLabel.textColor = HEXCOLOR(0x333333);
        _addressTitleLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _addressTitleLabel.text = @"取件地址";
    }
    return _addressTitleLabel;
}
- (UIView *)addressView{
    if (!_addressView) {
        _addressView = [[UIView alloc] init];
        _addressView.backgroundColor = UIColor.whiteColor;
    }
    return _addressView;
}
- (UILabel *)addressTextLabel{
    if (!_addressTextLabel) {
        _addressTextLabel = [[UILabel alloc] init];
        _addressTextLabel.textColor = HEXCOLOR(0x999999);
        _addressTextLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _addressTextLabel.text = @"您还没有取件地址";
    }
    return _addressTextLabel;
}
- (UIImageView *)addressLogoImg{
    if (!_addressLogoImg) {
        _addressLogoImg = [[UIImageView alloc] init];
        _addressLogoImg.image = JHImageNamed(@"recycle_orderDetail_address_icon");
    }
    return _addressLogoImg;
}
- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = HEXCOLOR(0x333333);
        _addressLabel.font = [UIFont fontWithName:kFontNormal size:14];
    }
    return _addressLabel;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEXCOLOR(0x666666);
        _nameLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _nameLabel;
}
- (UILabel *)changeLabel{
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.textColor = HEXCOLOR(0x999999);
        _changeLabel.font = [UIFont fontWithName:kFontNormal size:14];
    }
    return _changeLabel;
}

- (UIView *)packageInfoView{
    if (!_packageInfoView) {
        _packageInfoView = [[UIView alloc] init];
        _packageInfoView.backgroundColor = UIColor.whiteColor;
        _packageInfoView.layer.cornerRadius = 5;
        _packageInfoView.layer.masksToBounds = YES;
    }
    return _packageInfoView;
}
- (UILabel *)packageTitleLabel{
    if (!_packageTitleLabel) {
        _packageTitleLabel = [[UILabel alloc] init];
        _packageTitleLabel.textColor = HEXCOLOR(0x333333);
        _packageTitleLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _packageTitleLabel.text = @"包装原则";
    }
    return _packageTitleLabel;
}
- (UILabel *)packageLabel{
    if (!_packageLabel) {
        _packageLabel = [[UILabel alloc] init];
        _packageLabel.textColor = HEXCOLOR(0x666666);
        _packageLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _packageLabel.numberOfLines = 0;
    }
    return _packageLabel;
}
- (UIImageView *)packageImg{
    if (!_packageImg) {
        _packageImg = [[UIImageView alloc] init];
        _packageImg.layer.cornerRadius = 5;
        _packageImg.layer.masksToBounds = YES;
    }
    return _packageImg;
}

- (UILabel *)remindLabel{
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] init];
        _remindLabel.textColor = HEXCOLOR(0x999999);
        _remindLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _remindLabel.numberOfLines = 0;
        _remindLabel.text = @"温馨提示：运费需要您自行承担，到付件会导致拒收。";
        
    }
    return _remindLabel;
}
@end
