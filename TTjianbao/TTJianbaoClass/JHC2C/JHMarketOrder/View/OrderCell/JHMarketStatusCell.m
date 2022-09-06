//
//  JHMarketStatusCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketStatusCell.h"
#import "JHMarketOrderModel.h"
@interface JHMarketStatusCell()
/** 背景色图*/
@property (nonatomic, strong) UIImageView *backImageView;
/** 状态值*/
@property (nonatomic, strong) UIButton *statusButton;
@end

@implementation JHMarketStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEXCOLOR(0xf5f6fa);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

- (void)setModel:(JHMarketOrderModel *)model {
    _model = model;
    if (!model) {
        return;
    }
    [self.statusButton setTitle:model.orderStatusText forState:UIControlStateNormal];

    /** 订单状态code  1 待确认 2 待付款 3 支付中 4 待发货 5 已预约 6 待收货 7 已完成 8 退货退款中 9 已退款 10 已关闭 11 待鉴定 12 已鉴定*/
    if (model.orderText.length > 0) {
        self.statusLabel.text = model.orderText;
    }else {
        self.statusLabel.text = @"";
    }
    switch (model.orderStatus.integerValue) {
        case 4:
        case 5:
            if (isEmpty(model.remindText)) {
                self.statusLabel.text = @"买家已支付,等待卖家发货";
            } else {
                self.statusLabel.text = model.remindText;
            }
            break;
        case 2:
        case 6:
            [self.statusButton setImage:[UIImage imageNamed:@"c2c_class_order_goods"] forState:UIControlStateNormal];
            break;
        case 7:  //已完成
        {
            if (model.commentStatus.integerValue == 1 || !self.isBuyer) { //已评价
                [self.statusButton setImage:[UIImage imageNamed:@"c2c_class_order_complete"] forState:UIControlStateNormal];
                self.statusLabel.text = @"";
            } else { //未评价
                self.statusLabel.text = @"快去发表评价";
                [self.statusButton setImage:[UIImage imageNamed:@"c2c_class_order_comment"] forState:UIControlStateNormal];
            }
        }
            break;
        case 10:
            [self.statusButton setImage:[UIImage imageNamed:@"c2c_class_order_fail"] forState:UIControlStateNormal];
            break;
        default:
            [self.statusButton setImage:[UIImage imageNamed:@"c2c_class_order_time"] forState:UIControlStateNormal];
            break;
    }
}

- (void)configUI {
    [self.contentView addSubview:self.backImageView];
    [self.contentView addSubview:self.statusButton];
    [self.contentView addSubview:self.statusLabel];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
        make.height.mas_equalTo(140 + UI.topSafeAreaHeight);
    }];
    
    [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(UI.topSafeAreaHeight + 30);
        make.centerX.mas_equalTo(self.statusLabel);
        make.height.mas_equalTo(28);
        make.left.mas_greaterThanOrEqualTo(self.contentView).offset(20);
        make.right.mas_greaterThanOrEqualTo(self.contentView).offset(-20);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusButton.mas_bottom).offset(10);
        make.left.mas_equalTo(self.contentView).offset(20);
        make.right.mas_equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(60);
    }];
}

- (UIImageView *)backImageView {
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = [UIImage imageNamed:@"c2c_header_bg"];
    }
    return _backImageView;
}

- (UIButton *)statusButton {
    if (_statusButton == nil) {
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_statusButton setTitle:@"" forState:UIControlStateNormal];
        _statusButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:20];
        [_statusButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [_statusButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    }
    return _statusButton;
}

- (YYLabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [[YYLabel alloc] init];
        _statusLabel.textColor = HEXCOLOR(0xffffff);
        _statusLabel.font = [UIFont fontWithName:kFontNormal size:13];
//        _statusLabel.text = @"";
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.numberOfLines = 0;
        _statusLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    }
    return _statusLabel;
}



@end
