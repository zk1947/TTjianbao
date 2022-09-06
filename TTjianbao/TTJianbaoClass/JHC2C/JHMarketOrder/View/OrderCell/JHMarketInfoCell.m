//
//  JHMarketInfoCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketInfoCell.h"
#import "JHMarketOrderModel.h"
@interface JHMarketInfoCell()
/** 背景色视图*/
@property (nonatomic, strong) UIView *backView;
/** 订单信息*/
@property (nonatomic, strong) UILabel *infoLabel;
/** 订单编号*/
@property (nonatomic, strong) UILabel *noLabel;
/** 复制按钮*/
@property (nonatomic, strong) UIButton *copyButton;
/** 下单时间*/
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation JHMarketInfoCell

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
    self.noLabel.text = [NSString stringWithFormat:@"订单编号: %@", model.orderCode];
    self.timeLabel.text = [NSString stringWithFormat:@"下单时间: %@", model.orderCreateTime];
}

- (void)copyButtonClick {
    if (self.model.orderCode.length <= 0) return;
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.string = self.model.orderCode;
    if (pab == nil) {
        JHTOAST(@"复制失败");
    } else {
        JHTOAST(@"已复制");
    }
}

- (void)configUI {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.infoLabel];
    [self.backView addSubview:self.noLabel];
    [self.backView addSubview:self.copyButton];
    [self.backView addSubview:self.timeLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(91);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView).offset(10);
        make.top.mas_equalTo(self.backView).offset(10);
        make.height.mas_equalTo(18);
    }];
    
    [self.noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView).offset(10);
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(17);
    }];
    
    [self.copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.noLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.noLabel);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView).offset(10);
        make.top.mas_equalTo(self.noLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(17);
    }];
    
    
    
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = HEXCOLOR(0xffffff);
        _backView.layer.cornerRadius = 5;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = HEXCOLOR(0x333333);
        _infoLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _infoLabel.text = @"订单信息";
    }
    return _infoLabel;
}

- (UILabel *)noLabel {
    if (_noLabel == nil) {
        _noLabel = [[UILabel alloc] init];
        _noLabel.textColor = HEXCOLOR(0x666666);
        _noLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _noLabel.text = @"订单编号:";
    }
    return _noLabel;
}

- (UIButton *)copyButton {
    if (_copyButton == nil) {
        _copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_copyButton setTitle:@"复制" forState:UIControlStateNormal];
        [_copyButton setTitleColor:HEXCOLOR(0x408ffe) forState:UIControlStateNormal];
        _copyButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_copyButton addTarget:self action:@selector(copyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _copyButton;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x666666);
        _timeLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _timeLabel.text = @"下单时间:";
    }
    return _timeLabel;
}


@end
