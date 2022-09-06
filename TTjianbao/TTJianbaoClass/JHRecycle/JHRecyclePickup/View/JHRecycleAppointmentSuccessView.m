//
//  JHRecycleAppointmentSuccessView.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleAppointmentSuccessView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHUIFactory.h"
#import "JHQYChatManage.h"
#import "JHRecyclePickupModel.h"

@interface JHRecycleAppointmentSuccessView ()<UITextViewDelegate>
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *pickUpinfoView;
@property (nonatomic, strong) UIImageView *logisticsLogoImg;//快递logo
@property (nonatomic, strong) UILabel *logisticsTitleLabel;//快递名称
@property (nonatomic, strong) UIStackView *logisticsStackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *descriptionTextview;//预约说明-客服
@property (nonatomic, strong) UILabel *timeTextLabel;
@property (nonatomic, strong) UILabel *timeLabel;//取件时间
@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UILabel *addressTextLabel;
@property (nonatomic, strong) UILabel *addressLabel;//取件地址
@property (nonatomic, strong) UILabel *nameLabel;//联系方式
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UIButton *serviceButton;//客服
@property (nonatomic, strong) JHRecyclePickupAppointmentSuccessModel *appointmentSuccessModel;

@end

@implementation JHRecycleAppointmentSuccessView

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
    
    [self.pickUpinfoView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logisticsStackView.mas_bottom).offset(20);
        make.left.equalTo(self.pickUpinfoView).offset(12);
    }];
    //预约说明-客服
    [self.pickUpinfoView addSubview:self.descriptionTextview];
    [self.descriptionTextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.pickUpinfoView).offset(12);
        make.right.equalTo(self.pickUpinfoView).offset(-12);
    }];
    JHCustomLine *line1 = [JHUIFactory createLine];
    [self.pickUpinfoView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionTextview.mas_bottom).offset(12);
        make.height.offset(0.5);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    //上门取件时间
    [self.pickUpinfoView addSubview:self.timeTextLabel];
    [self.timeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(13);
        make.left.equalTo(self.pickUpinfoView).offset(12);
    }];
    //时间
    [self.pickUpinfoView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeTextLabel);
        make.right.equalTo(self.pickUpinfoView).offset(-12);
        make.left.equalTo(self.timeTextLabel.mas_right).offset(30);
    }];
    JHCustomLine *line2 = [JHUIFactory createLine];
    [self.pickUpinfoView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeTextLabel.mas_bottom).offset(13);
        make.height.offset(0.5);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    //取件地址
    [self.pickUpinfoView addSubview:self.addressView];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom);
        make.left.right.bottom.equalTo(self.pickUpinfoView);
    }];
    [self.addressView addSubview:self.addressTextLabel];
    [self.addressTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressView);
        make.left.equalTo(self.addressView).offset(12);
    }];
    //地址
    [self.addressView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView).offset(12);
        make.right.equalTo(self.addressView).offset(-12);
        make.left.equalTo(self.addressTextLabel.mas_right).offset(50);
    }];
    //联系方式
    [self.addressView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(5);
        make.right.equalTo(self.addressView).offset(-12);
        make.left.equalTo(self.addressTextLabel.mas_right).offset(50);
        make.bottom.equalTo(self.addressView).offset(-13);
    }];
    
    //温馨提示
    [self.contentScrollView addSubview:self.remindLabel];
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickUpinfoView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScrollView).offset(12);
        make.right.equalTo(self.contentScrollView).offset(-12);
        make.bottom.equalTo(self.contentScrollView).offset(-40);
    }];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: _remindLabel.text];
    [attrString addAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x666666)} range:[[attrString string] rangeOfString:@"温馨提示："]];
    _remindLabel.attributedText = attrString;
    
    //联系客服 按钮
    [self.contentScrollView addSubview:self.serviceButton];
    [self.serviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remindLabel.mas_bottom).offset(20);
        make.left.equalTo(self.contentScrollView).offset(28);
        make.right.equalTo(self.contentScrollView).offset(-28);
        make.height.offset(44);
    }];
}

#pragma mark - LoadData
- (void)bindViewModel:(id)dataModel params:(NSDictionary *)parmas{
    JHRecyclePickupAppointmentSuccessModel *appointmentSuccessModel = dataModel;
    self.appointmentSuccessModel = appointmentSuccessModel;
    //物流logo
    JHRecyclePickupLogisticsInfoModel *logisticsInfo = appointmentSuccessModel.logisticsInfo[0];
    self.logisticsTitleLabel.text = [NSString stringWithFormat:@"%@上门取件",logisticsInfo.logisticsTitle];
    [self.logisticsLogoImg jh_setImageWithUrl:[logisticsInfo.logisticsImage small] placeHolder:@"newStore_default_placehold"];
    CGFloat w = 14*[[logisticsInfo.logisticsImage w] floatValue]/[[logisticsInfo.logisticsImage h] floatValue];
    [self.logisticsLogoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(w, 14));
    }];
    //预约信息
    self.descriptionTextview.text = appointmentSuccessModel.preorderMessage;
    NSString *phone1 = appointmentSuccessModel.platformWaiterPhone;
    NSString *phone2 = appointmentSuccessModel.contactWaiterPhone;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:appointmentSuccessModel.preorderMessage];
    [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontMedium size:13], NSForegroundColorAttributeName:HEXCOLOR(0xFF4200)} range:[[attrString string] rangeOfString:phone1]];
    [attrString addAttributes:@{NSLinkAttributeName:@"telphone://", NSForegroundColorAttributeName:HEXCOLOR(0x2F66A0)} range:[[attrString string] rangeOfString:phone2]];
    _descriptionTextview.attributedText = attrString;

    //时间
    self.timeLabel.text = appointmentSuccessModel.preorderTime;
    //地址
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",appointmentSuccessModel.sellerAddress.province, appointmentSuccessModel.sellerAddress.city, appointmentSuccessModel.sellerAddress.county, appointmentSuccessModel.sellerAddress.detail];
    self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",appointmentSuccessModel.sellerAddress.receiverName, appointmentSuccessModel.sellerAddress.phone];
    
    
}

#pragma mark - Action
- (void)clickServiceButtonAction:(UIButton *)sender{
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickAppointmentInfo" params:@{
        @"page_position":@"appointmentComplete"
    } type:JHStatisticsTypeSensors];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"在线客服" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[JHQYChatManage shareInstance] showChatWithViewcontroller:[JHRootController currentViewController]];
        
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickCustomer" params:@{
            @"operation_type":@"online",
            @"page_position":@"appointmentComplete"
        } type:JHStatisticsTypeSensors];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"电话客服" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006230666"]];
        
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickCustomer" params:@{
            @"operation_type":@"telephone",
            @"page_position":@"appointmentComplete"
        } type:JHStatisticsTypeSensors];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {

    NSString *phoneString = [NSString stringWithFormat:@"tel://%@",self.appointmentSuccessModel.contactWaiterPhone];
    if ([[URL scheme] isEqualToString:@"telphone"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
        return NO;
    }
    return YES;
}

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
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _titleLabel.text = @"预约信息";
    }
    return _titleLabel;
}
- (UITextView *)descriptionTextview{
    if (!_descriptionTextview) {
        _descriptionTextview = [[UITextView alloc] init];
        _descriptionTextview.delegate = self;
        _descriptionTextview.editable = NO;
        _descriptionTextview.scrollEnabled = NO;
        _descriptionTextview.textContainerInset = UIEdgeInsetsZero;
        _descriptionTextview.textContainer.lineFragmentPadding = 0;
        _descriptionTextview.textColor = HEXCOLOR(0x333333);
        _descriptionTextview.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _descriptionTextview;
}
- (UILabel *)timeTextLabel{
    if (!_timeTextLabel) {
        _timeTextLabel = [[UILabel alloc] init];
        _timeTextLabel.textColor = HEXCOLOR(0x666666);
        _timeTextLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _timeTextLabel.text = @"上门取件时间";
    }
    return _timeTextLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x333333);
        _timeLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
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
        _addressTextLabel.textColor = HEXCOLOR(0x666666);
        _addressTextLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _addressTextLabel.text = @"取件地址";
    }
    return _addressTextLabel;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = HEXCOLOR(0x333333);
        _addressLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _addressLabel.textAlignment = NSTextAlignmentRight;
    }
    return _addressLabel;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEXCOLOR(0x666666);
        _nameLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _nameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nameLabel;
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
- (UIButton *)serviceButton{
    if (!_serviceButton) {
        _serviceButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _serviceButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        [_serviceButton setTitleColor:kColor333 forState:UIControlStateNormal];
        [_serviceButton setTitle:@"更改预约 联系客服" forState:UIControlStateNormal];
        [_serviceButton setBackgroundColor:UIColor.clearColor];
        _serviceButton.layer.cornerRadius = 22.0;
        _serviceButton.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
        _serviceButton.layer.borderWidth = 0.5f;
        [_serviceButton addTarget:self action:@selector(clickServiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _serviceButton;
}

@end
