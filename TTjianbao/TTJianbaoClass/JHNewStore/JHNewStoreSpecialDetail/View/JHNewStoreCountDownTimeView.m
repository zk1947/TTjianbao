//
//  JHNewStoreCountDownTimeView.m
//  TTjianbao
//
//  Created by liuhai on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreCountDownTimeView.h"

#import "TTjianbaoHeader.h"
#import "UIView+CornerRadius.h"

#define kTitleW         (36) //标题宽度
#define kTimeW          (17) //时分秒色块宽度

@implementation JHNewStoreCountDownConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _title = @"距结束";
        _titleFont = [UIFont fontWithName:kFontNormal size:14];
        _titleColor = kColor333;
        
        _ddFont = [UIFont fontWithName:kFontMedium size:12];
        _ddColor = kColor333;
        _ddBgColor = [UIColor clearColor];
        
        _timeFont = [UIFont fontWithName:kFontNormal size:12];
        _timeColor = [UIColor whiteColor];
        _timeBgColor = HEXCOLOR(0xF23730);
        
        _spFont = [UIFont fontWithName:kFontNormal size:14];
        _spColor = kColor333;
    }
    return self;
}

@end

@interface JHNewStoreCountDownTimeView ()
@property (nonatomic,   copy) dispatch_block_t endBlock;

@property (nonatomic, strong) UILabel *titleLabel; //标题
@property (nonatomic, strong) UILabel *dLabel; //天
@property (nonatomic, strong) UILabel *hLabel; //时
@property (nonatomic, strong) UILabel *mLabel; //分
@property (nonatomic, strong) UILabel *sLabel; //秒

@property (nonatomic, strong) UILabel *spLabel0; //分隔符:
@property (nonatomic, strong) UILabel *spLabel1; //分隔符
@property (nonatomic, strong) UILabel *spLabel2;
@property (nonatomic, strong) UILabel *spLabel3;  //天
@end

@implementation JHNewStoreCountDownTimeView

+ (instancetype)newcountDownWithConfig:(JHNewStoreCountDownConfig *)config endBlock:(dispatch_block_t)endBlock {
    JHNewStoreCountDownTimeView *view = [[JHNewStoreCountDownTimeView alloc] initWithFrame:CGRectZero config:config];
    view.endBlock = endBlock;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame config:(JHNewStoreCountDownConfig *)config {
    self = [super initWithFrame:frame];
    if (self) {
        _config = config;
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    //标题
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:_config.titleFont textColor:_config.titleColor];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_titleLabel];
    }
    
    //天
    if (!_dLabel) {
        _dLabel = [UILabel labelWithFont:_config.timeFont textColor:_config.timeColor];
        _dLabel.backgroundColor = _config.timeBgColor;
        _dLabel.textAlignment = NSTextAlignmentCenter;
        _dLabel.clipsToBounds = YES;
        [_dLabel yd_setCornerRadius:2 corners:UIRectCornerAllCorners];
        [self addSubview:_dLabel];
        //_dLabel.minimumScaleFactor = 0.8;
        //_dLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    //时
    if (!_hLabel) {
        _hLabel = [UILabel labelWithFont:_config.timeFont textColor:_config.timeColor];
        _hLabel.backgroundColor = _config.timeBgColor;
        _hLabel.textAlignment = NSTextAlignmentCenter;
        _hLabel.clipsToBounds = YES;
        [_hLabel yd_setCornerRadius:2 corners:UIRectCornerAllCorners];
        [self addSubview:_hLabel];
    }
    
    //分
    if (!_mLabel) {
        _mLabel = [UILabel labelWithFont:_config.timeFont textColor:_config.timeColor];
        _mLabel.backgroundColor = _config.timeBgColor;
        _mLabel.textAlignment = NSTextAlignmentCenter;
        _mLabel.clipsToBounds = YES;
        [_mLabel yd_setCornerRadius:2 corners:UIRectCornerAllCorners];
        [self addSubview:_mLabel];
    }
    
    //秒
    if (!_sLabel) {
        _sLabel = [UILabel labelWithFont:_config.timeFont textColor:_config.timeColor];
        _sLabel.backgroundColor = _config.timeBgColor;
        _sLabel.textAlignment = NSTextAlignmentCenter;
        _sLabel.clipsToBounds = YES;
        [_sLabel yd_setCornerRadius:2 corners:UIRectCornerAllCorners];
        [self addSubview:_sLabel];
    }
    
    //分隔符
    if (!_spLabel3) {
        _spLabel3 = [UILabel labelWithFont:_config.spFont textColor:_config.spColor];
        _spLabel3.textAlignment = NSTextAlignmentCenter;
        _spLabel3.text = @"天";
        [self addSubview:_spLabel3];
    }
    if (!_spLabel0) {
        _spLabel0 = [UILabel labelWithFont:_config.spFont textColor:_config.spColor];
        _spLabel0.textAlignment = NSTextAlignmentCenter;
        _spLabel0.text = @"时";
        [self addSubview:_spLabel0];
    }
    
    if (!_spLabel1) {
        _spLabel1 = [UILabel labelWithFont:_config.spFont textColor:_config.spColor];
        _spLabel1.textAlignment = NSTextAlignmentCenter;
        _spLabel1.text = @"分";
        [self addSubview:_spLabel1];
    }
    if (!_spLabel2) {
        _spLabel2 = [UILabel labelWithFont:_config.spFont textColor:_config.spColor];
        _spLabel2.textAlignment = NSTextAlignmentCenter;
        _spLabel2.text = @"秒";
        [self addSubview:_spLabel2];
    }
    
    _titleLabel.text = _config.title;
    _dLabel.text = @"--";
    _hLabel.text = @"--";
    _mLabel.text = @"--";
    _sLabel.text = @"--";
    
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(13);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(kTimeW);
    }];
    
    NSArray *array = @[_dLabel,_spLabel3, _hLabel, _spLabel0, _mLabel,_spLabel1,_sLabel,_spLabel2];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(13);
        make.height.mas_equalTo(kTimeW);
//        make.left.mas_equalTo(self.titleLabel.right).offset(7);
        make.width.mas_equalTo(20);
    }];
    [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:3 leadSpacing:67 tailSpacing:10];
  
}

/** 设置倒计时时间，timeValue是未经转换的总秒数 */
- (void)setCountDownTime:(NSInteger)timeValue {
    NSInteger hh = (timeValue/3600)%24;
    NSInteger mm = (timeValue/60)%60;
    NSInteger ss = timeValue%60;
    NSInteger dd = (timeValue/3600)/24;
    [self setDD:dd hh:hh mm:mm ss:ss];
}

/** 单独设置倒计时的时分秒 */
- (void)setDD:(NSInteger)ddValue hh:(NSInteger)hhValue mm:(NSInteger)mmValue ss:(NSInteger)ssValue {
    _hLabel.text = [NSString stringWithFormat:@"%02ld", (long)hhValue];
    _mLabel.text = [NSString stringWithFormat:@"%02ld", (long)mmValue];
    _sLabel.text = [NSString stringWithFormat:@"%02ld", (long)ssValue];
    _dLabel.text = [NSString stringWithFormat:@"%02ld", (long)ddValue];
}

- (void)showEndStyle {
//    _dLabel.text = @"__";
//    _hLabel.text = @"--";
//    _mLabel.text = @"--";
//    _sLabel.text = @"--";
}

- (void)setTitleColor:(UIColor *)color andTimeColor:(UIColor *)tcolor andBgColor:(UIColor *)bgcolor{
    self.titleLabel.textColor = color;
    self.dLabel.textColor = tcolor;
    self.hLabel.textColor = tcolor;
    self.mLabel.textColor = tcolor;
    self.sLabel.textColor = tcolor;
    self.dLabel.backgroundColor = bgcolor;
    self.hLabel.backgroundColor = bgcolor;
    self.mLabel.backgroundColor = bgcolor;
    self.sLabel.backgroundColor = bgcolor;
    self.spLabel3.textColor = color;
    self.spLabel2.textColor = color;
    self.spLabel1.textColor = color;
    self.spLabel0.textColor = color;
}
@end
