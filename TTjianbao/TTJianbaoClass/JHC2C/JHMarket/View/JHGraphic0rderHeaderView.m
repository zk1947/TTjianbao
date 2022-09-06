//
//  JHGraphic0rderHeaderView.m
//  TTjianbao
//
//  Created by miao on 2021/6/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGraphic0rderHeaderView.h"
#import "JHOrderDetailMode.h"
#import "YDCountDown.h"
#import "CommHelp.h"

@interface JHGraphic0rderHeaderView ()

/** 背景色图*/
@property (nonatomic, strong) UIImageView *backImageView;
/** 状态值*/
@property (nonatomic, strong) UIButton *statusButton;
/** 状态文字*/
@property (nonatomic, strong) UILabel *statusLabel;
/// 倒计时
@property (nonatomic, strong) YDCountDown *countDown;

@end

@implementation JHGraphic0rderHeaderView

- (void)dealloc {
    [self.countDown destoryTimer];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self p_drawSubViews];
        [self p_makeLayouts];
    }
    return self;
}

- (void)p_drawSubViews {
    
    _backImageView = [[UIImageView alloc] init];
    _backImageView.image = [UIImage imageNamed:@"c2c_header_bg"];
    [self addSubview:_backImageView];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textColor = HEXCOLOR(0xffffff);
    _statusLabel.font = [UIFont fontWithName:kFontNormal size:13];
    _statusLabel.text = @"";
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.numberOfLines = 0;
    [self addSubview:_statusLabel];
    
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_statusButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_statusButton setTitle:@"" forState:UIControlStateNormal];
    _statusButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:20];
    [_statusButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [_statusButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self addSubview:_statusButton];
}

- (void)p_makeLayouts {
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.height.mas_equalTo(140 + UI.topSafeAreaHeight);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(-7);
        make.left.mas_equalTo(self).offset(20);
        make.right.mas_equalTo(self).offset(-20);
        make.height.mas_equalTo(60);
    }];
    
    [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.statusLabel.mas_top).offset(-10);
        make.centerX.mas_equalTo(self.statusLabel);
        make.height.mas_equalTo(28);
    }];
}

- (void)updateGraphic0rderHeaderView:(JHOrderDetailMode *)orderDetailMode {
   
    if (!orderDetailMode) {
        return;
    }
    [self.statusButton setTitle:orderDetailMode.orderStatusText forState:UIControlStateNormal];
    self.statusLabel.text = orderDetailMode.orderStatusDesc;
    /*
     1, "待付款",
     2, "待付款",
     11, "待鉴定"
     12, "已鉴定"
     除了以上状态其他都是已关闭
     
     */
    switch (orderDetailMode.orderStatus.intValue) {
        case 1:
            [self.statusButton setImage:[UIImage imageNamed:@"c2c_class_order_time"] forState:UIControlStateNormal];
            
            break;
        case 2:
            [self.statusButton setImage:[UIImage imageNamed:@"c2c_class_order_time"] forState:UIControlStateNormal];
            
            break;
        case 11:
            
            [self.statusButton setImage:[UIImage imageNamed:@"c2c_class_order_wait"] forState:UIControlStateNormal];
            break;
        case 12:
            
            [self.statusButton setImage:[UIImage imageNamed:@"c2c_class_order_complete"] forState:UIControlStateNormal];
            break;
            
        default:
            [self.statusButton setImage:[UIImage imageNamed:@"c2c_class_order_fail"] forState:UIControlStateNormal];
            break;
    }
    
    if (orderDetailMode.orderStatus.intValue == 1
        || orderDetailMode.orderStatus.intValue == 2 ||
        orderDetailMode.orderStatus.intValue == 11) {
        
        int expireTime= orderDetailMode.expireTime.intValue/1000;
        if (expireTime > 0) {
            @weakify(self);
            [self.countDown destoryTimer];
            [self.countDown startWithFinishTimeStamp:expireTime completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
                @strongify(self);
                NSInteger newHour = day*24+hour;
                if (newHour == 0 && minute == 0 && second == 0) {
                    [self.countDown destoryTimer];
                    self.statusLabel.text = @"订单已关闭";
                    if (self.countDownFinshBlock) {
                        self.countDownFinshBlock();
                    }
                } else {
                    NSString *countDownTip = [NSString stringWithFormat:@"%ld时%ld分%ld秒", (long)newHour, (long)minute, (long)second];
                    
                    NSString *notPaying = [NSString stringWithFormat:@"剩%@后未付款,订单自动关闭",countDownTip];
                    NSString *toIdentify = [NSString stringWithFormat:@"鉴定师正在加紧为您鉴定中，%@后未鉴定,系统将自动退款",countDownTip];
                    NSString *resultTip = orderDetailMode.orderStatus.intValue == 11 ? toIdentify : notPaying;
                    self.statusLabel.text = resultTip;
                }
            }];
        } else {
            [self.countDown destoryTimer];
            self.statusLabel.text = @"订单已关闭";
        }
    }else {
        [self.countDown destoryTimer];
        self.statusLabel.text = orderDetailMode.orderStatusDesc;
    }
    
}

#pragma mark - set/get
- (YDCountDown *)countDown {
    if (!_countDown) {
        _countDown = [[YDCountDown alloc] init];
    }
    return _countDown;
}

@end
