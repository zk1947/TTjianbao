//
//  JHStoreDetailCountdownView.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCountdownView.h"

static const CGFloat TimeWidth = 22;
static const CGFloat TimeHeight = 18;


@interface JHStoreDetailCountdownView()
@property (nonatomic, strong) UILabel *hoursLabel;
@property (nonatomic, strong) UILabel *minutesLabel;
@property (nonatomic, strong) UILabel *secondsLabel;
@property (nonatomic, strong) UIStackView *stackView;
/// :
@property (nonatomic, strong) UILabel *spotLabel;
@property (nonatomic, strong) UILabel *spotLabel1;

@property(nonatomic, assign) JHStoreDetailCountdownView_Type  type;
@end
@implementation JHStoreDetailCountdownView

#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = JHStoreDetailCountdownView_Type_Defalut;
        [self setupUI];
        [self bindData];
    }
    return self;
}

- (instancetype)initCountDownViewWithType:(JHStoreDetailCountdownView_Type)type{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.type = type;
        [self setupUI];
        [self bindData];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Action functions

#pragma mark - Private Functions
///设置倒计时时间，timeValue是未经转换的总秒数
- (void)setCountDownTime:(NSInteger)timeValue {
    NSInteger hh = (timeValue/3600);
    NSInteger mm = (timeValue%3600)/60;
    NSInteger ss = timeValue%60;
    NSInteger dd = (timeValue/3600)/24;
    [self setDD:dd hh:hh mm:mm ss:ss];
}

///单独设置倒计时的时分秒
- (void)setDD:(NSInteger)ddValue hh:(NSInteger)hhValue mm:(NSInteger)mmValue ss:(NSInteger)ssValue {
    self.hoursLabel.text = [NSString stringWithFormat:@"%02ld", (long)hhValue];
    self.minutesLabel.text = [NSString stringWithFormat:@"%02ld", (long)mmValue];
    self.secondsLabel.text = [NSString stringWithFormat:@"%02ld", (long)ssValue];
}
#pragma mark - Bind
- (void) bindData {
    
}

#pragma mark - UI
- (void) setupUI {
    [self addSubview:self.stackView];
}
- (void) layoutViews {
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    CGFloat wide = self.type == 0 ? TimeWidth : 19.f;
    [self.hoursLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(wide);
//        make.width.mas_equalTo(TimeWidth);
        make.height.mas_equalTo(TimeHeight);
    }];
    [self.minutesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(wide);
        make.height.mas_equalTo(TimeHeight);
    }];
    [self.secondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(wide);
        make.height.mas_equalTo(TimeHeight);
    }];
}
#pragma mark - Lazy
- (void)setTimeStamp:(NSInteger)timeStamp {
    _timeStamp = timeStamp;
    [self setCountDownTime:timeStamp];
}
- (UILabel *)getTimeLabel {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.font = [self getFont];
    label.textColor = UIColor.whiteColor;
    CGFloat corner = self.type == JHStoreDetailCountdownView_Type_Defalut ? 2.f : 3.6;
    [label jh_cornerRadius:corner];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [self getColor];
    return label;
}
- (UILabel *)getSpotLabel {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = @":";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [self getColor];
    return label;
}

- (UIFont*)getFont{
    switch (self.type) {
        case JHStoreDetailCountdownView_Type_Defalut:
            return [UIFont boldSystemFontOfSize:12];
            break;
        case JHStoreDetailCountdownView_Type_MiaoSha:
            return JHFont(12);
            break;
        default:
            break;
    }
    return JHFont(12);
}

- (UIColor*)getColor{
    switch (self.type) {
        case JHStoreDetailCountdownView_Type_Defalut:
            return HEXCOLOR(0x474747);
            break;
        case JHStoreDetailCountdownView_Type_MiaoSha:
            return HEXCOLOR(0x020401);
            break;
        default:
            break;
    }
    return HEXCOLOR(0x474747);
}


- (UILabel *)hoursLabel {
    if (!_hoursLabel) {
        _hoursLabel = [self getTimeLabel];
    }
    return _hoursLabel;
}
- (UILabel *)minutesLabel {
    if (!_minutesLabel) {
        _minutesLabel = [self getTimeLabel];
    }
    return _minutesLabel;
}
- (UILabel *)secondsLabel {
    if (!_secondsLabel) {
        _secondsLabel = [self getTimeLabel];
    }
    return _secondsLabel;
}
- (UILabel *)spotLabel {
    if (!_spotLabel) {
        _spotLabel = [self getSpotLabel];
    }
    return _spotLabel;
}
- (UILabel *)spotLabel1 {
    if (!_spotLabel1) {
        _spotLabel1 = [self getSpotLabel];
    }
    return _spotLabel1;
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc]initWithArrangedSubviews:@[self.hoursLabel,self.spotLabel, self.minutesLabel, self.spotLabel1, self.secondsLabel]];
        _stackView.spacing = 1;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.alignment = UIStackViewAlignmentTrailing;
        _stackView.distribution = UIStackViewDistributionEqualSpacing;
    }
    return _stackView;
}
@end
