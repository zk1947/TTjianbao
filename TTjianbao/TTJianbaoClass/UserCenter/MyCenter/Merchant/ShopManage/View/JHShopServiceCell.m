//
//  JHShopServiceCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHShopServiceCell.h"
#import "JHShopServiceInfo.h"

@interface JHShopServiceCell()
/** 名称*/
@property (nonatomic, strong) UILabel *titleLabel;
/** 剩余时间*/
@property (nonatomic, strong) UILabel *leftTimeLabel;
/** 开始时间*/
@property (nonatomic, strong) UILabel *beginTagLabel;
@property (nonatomic, strong) UILabel *beginValueLabel;
/** 结束时间*/
@property (nonatomic, strong) UILabel *endTagLabel;
@property (nonatomic, strong) UILabel *endValueLabel;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView;

@end
@implementation JHShopServiceCell

- (void)setServiceModel:(JHShopServiceInfo *)serviceModel {
    if (!serviceModel) {
        return;
    }
    
    _serviceModel = serviceModel;
    _titleLabel.text = [self serviceName];
    _leftTimeLabel.text = [NSString stringWithFormat:@"%@天", [serviceModel.days isNotBlank]?serviceModel.days :@"0"];
    _beginValueLabel.text = [serviceModel.startTime isNotBlank]?serviceModel.startTime:@"--";
    _endValueLabel.text = [serviceModel.endTime isNotBlank]?serviceModel.endTime:@"--";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.leftTimeLabel];
    [self.contentView addSubview:self.beginTagLabel];
    [self.contentView addSubview:self.beginValueLabel];
    [self.contentView addSubview:self.endTagLabel];
    [self.contentView addSubview:self.endValueLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(15);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.height.mas_equalTo(20);
    }];
    
    [self.leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.contentView).offset(-12);
    }];
    
    [self.beginTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.height.mas_equalTo(17);
    }];
    
    [self.beginValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.beginTagLabel);
        make.right.mas_equalTo(self.contentView).offset(-12);
    }];
    
    [self.endTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.beginTagLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.height.mas_equalTo(17);
    }];
    
    [self.endValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.endTagLabel);
        make.right.mas_equalTo(self.contentView).offset(-12);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _titleLabel.text = @"--";
    }
    return _titleLabel;
}

- (UILabel *)leftTimeLabel {
    if (_leftTimeLabel == nil) {
        _leftTimeLabel = [[UILabel alloc] init];
        _leftTimeLabel.textColor = HEXCOLOR(0x333333);
        _leftTimeLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _leftTimeLabel.text = @"0天";
    }
    return _leftTimeLabel;
}

- (UILabel *)beginTagLabel {
    if (_beginTagLabel == nil) {
        _beginTagLabel = [[UILabel alloc] init];
        _beginTagLabel.textColor = HEXCOLOR(0x999999);
        _beginTagLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _beginTagLabel.text = @"开始时间";
    }
    return _beginTagLabel;
}

- (UILabel *)beginValueLabel {
    if (_beginValueLabel == nil) {
        _beginValueLabel = [[UILabel alloc] init];
        _beginValueLabel.textColor = HEXCOLOR(0x999999);
        _beginValueLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _beginValueLabel.text = @"2020-11-11 18:26:29";
    }
    return _beginValueLabel;
}
- (UILabel *)endTagLabel {
    if (_endTagLabel == nil) {
        _endTagLabel = [[UILabel alloc] init];
        _endTagLabel.textColor = HEXCOLOR(0x999999);
        _endTagLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _endTagLabel.text = @"截止时间";
    }
    return _endTagLabel;
}

- (UILabel *)endValueLabel {
    if (_endValueLabel == nil) {
        _endValueLabel = [[UILabel alloc] init];
        _endValueLabel.textColor = HEXCOLOR(0x999999);
        _endValueLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _endValueLabel.text = @"2020-11-11 18:26:29";
    }
    return _endValueLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xf2f2f2);
    }
    return _lineView;
}

- (NSString *)serviceName {
    if ([_serviceModel.lineType isEqualToString:@"live"]) {
        return @"直播服务剩余时间";
    }
    if ([_serviceModel.lineType isEqualToString:@"shop"]) {
        return @"店铺服务剩余时间";
    }
    if ([_serviceModel.lineType isEqualToString:@"recycle"]) {
        return @"回收服务剩余时间";
    }

    if ([_serviceModel.lineType isEqualToString:@"excellent"]) {
        return @"优店服务剩余时间";
    }
    return @"基础服务剩余时间";
}

@end
