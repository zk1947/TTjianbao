//
//  JHRecycleSoldCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleSoldCell.h"
#import "JHRecycleSoldButtonView.h"
#import "UIImageView+JHWebImage.h"
@interface JHRecycleSoldCell()
/** 背景色视图*/
@property (nonatomic, strong) UIView *backView;
/** 状态*/
@property (nonatomic, strong) UILabel *statusLabel;
/** 时间*/
@property (nonatomic, strong) UILabel *timeLabel;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView;
/** 图片*/
@property (nonatomic, strong) UIImageView *productImageView;
/** 标题*/
@property (nonatomic, strong) UILabel *productTitleLabel;
/** 分类*/
@property (nonatomic, strong) UILabel *productTypeLabel;
/** 按钮*/
@property (nonatomic, strong) JHRecycleSoldButtonView *buttonsView;
/** 提示框*/
@property (nonatomic, strong) UIImageView *alertImageView;
@end
@implementation JHRecycleSoldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = HEXCOLOR(0xf5f5f8);
        [self configUI];
    }
    return self;
}

- (void)setModel:(JHRecycleSoldModel *)model {
    _model = model;
    self.timeLabel.text = @"";
    self.buttonsView.buttonModel = model.buttonsVo;
    self.statusLabel.text = model.orderStatus;
    [self.productImageView jh_setImageWithUrl:model.goodsUrl.small];
    self.productTitleLabel.text = [NSString stringWithFormat:@"回收说明: %@", NONNULL_STR(model.goodsDesc)];
    self.productTypeLabel.text = [NSString stringWithFormat:@"回收分类: %@", NONNULL_STR(model.goodsCateName)];
    self.buttonsView.orderId = model.orderId;
    self.buttonsView.soldModel = model;
    
    if (model.buttonsVo.seeCallDoorBtnFlag) {
        self.alertImageView.hidden = NO;
    } else {
        self.alertImageView.hidden = YES;
    }
}

// 刷新计时器UI
- (void)refreshTimerUI {
    if (self.model.timeDuring == 0) {
        if (self.reloadCellDataBlock) {
            self.reloadCellDataBlock(NO);
        }
    }
    self.model.timeDuring --;
    if (self.model.timeDuring > 0) {
        self.timeLabel.text = [self updateTimeForRow:self.model.timeDuring];
    }else {
        self.timeLabel.text = @"";
    }
}
- (NSString *)updateTimeForRow:(NSInteger )timerDuring {
    NSString *hour = [NSString stringWithFormat:@"%02ld", timerDuring / 3600];
    NSString *minute = [NSString stringWithFormat:@"%02ld", (timerDuring % 3600) / 60];
    NSString *second = [NSString stringWithFormat:@"%02ld", timerDuring % 60];
    return [NSString stringWithFormat:@"%@:%@:%@", hour, minute, second];
}

- (void)configUI {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.statusLabel];
    [self.backView addSubview:self.timeLabel];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.productImageView];
    [self.backView addSubview:self.productTypeLabel];
    [self.backView addSubview:self.productTitleLabel];
    [self.backView addSubview:self.buttonsView];
    [self.backView addSubview:self.alertImageView];
    
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(10);
        make.left.mas_equalTo(self.backView).offset(10);
        make.height.mas_equalTo(17);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusLabel);
        make.right.mas_equalTo(self.backView).offset(-10);
        make.height.mas_equalTo(17);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.backView).offset(10);
        make.right.mas_equalTo(self.backView);
        make.height.mas_equalTo(1);
    }];
    
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.backView).offset(10);
        make.width.height.mas_equalTo(75);
    }];
    
    [self.productTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productImageView);
        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
    }];
    
    [self.productTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productTypeLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
    }];
    
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productImageView.mas_bottom).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
        make.left.mas_equalTo(self.backView).offset(10);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.backView).offset(-10);
    }];
    
    [self.alertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.buttonsView.mas_top);
        make.right.mas_equalTo(self.backView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(196, 59));
    }];
    
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = HEXCOLOR(0xffffff);
        _backView.layer.cornerRadius = 8;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UILabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = HEXCOLOR(0x333333);
        _statusLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _statusLabel.text = @"等待商家付款";
    }
    return _statusLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0xff4200);
        _timeLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _timeLabel.text = @"";
    }
    return _timeLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xf0f0f0);
    }
    return _lineView;
}

- (UIImageView *)productImageView {
    if (_productImageView == nil) {
        _productImageView = [[UIImageView alloc] init];
        _productImageView.image = kDefaultCoverImage;
        _productImageView.layer.cornerRadius = 4;
        _productImageView.clipsToBounds = YES;
        _productImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _productImageView;
}

- (UILabel *)productTypeLabel {
    if (_productTypeLabel == nil) {
        _productTypeLabel = [[UILabel alloc] init];
        _productTypeLabel.textColor = HEXCOLOR(0x333333);
        _productTypeLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _productTypeLabel.text = @"";
    }
    return _productTypeLabel;
}

- (UILabel *)productTitleLabel {
    if (_productTitleLabel == nil) {
        _productTitleLabel = [[UILabel alloc] init];
        _productTitleLabel.textColor = HEXCOLOR(0x666666);
        _productTitleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _productTitleLabel.text = @"";
        _productTitleLabel.numberOfLines = 2;
    }
    return _productTitleLabel;
}

- (JHRecycleSoldButtonView *)buttonsView {
    if (_buttonsView == nil) {
        _buttonsView = [[JHRecycleSoldButtonView alloc] init];
        @weakify(self);
        _buttonsView.reloadDataBlock = ^(BOOL iSdelete) {
            @strongify(self);
            if (self.reloadCellDataBlock) {
                self.reloadCellDataBlock(iSdelete);
            }
        };
    }
    return _buttonsView;
}

- (UIImageView *)alertImageView{
    if (_alertImageView == nil) {
        _alertImageView = [[UIImageView alloc] init];
        _alertImageView.image = [UIImage imageNamed:@"c2c_market_alert_back"];
        
        UILabel *alertLabel = [[UILabel alloc] init];
        alertLabel.text = @"实际发货后，请填写物流单号，否则交易后钱款没法到账";
        alertLabel.textColor = HEXCOLOR(0x333333);
        alertLabel.font = [UIFont fontWithName:kFontNormal size:11];
        alertLabel.numberOfLines = 2;
        [_alertImageView addSubview:alertLabel];
        [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_alertImageView).offset(10);
            make.left.mas_equalTo(_alertImageView).offset(10);
            make.right.mas_equalTo(_alertImageView).offset(-10);
        }];
        _alertImageView.hidden = YES;
    }
    return _alertImageView;
}

@end
