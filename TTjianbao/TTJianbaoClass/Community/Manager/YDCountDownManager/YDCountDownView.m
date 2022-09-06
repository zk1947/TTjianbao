//
//  YDCountDownView.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/25.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "YDCountDownView.h"
#import "TTjianbaoHeader.h"
#import "UIView+CornerRadius.h"

#define kTitleW         (36) //标题宽度
#define kTimeW          (17) //时分秒色块宽度
#define kSpaceW         (6) //分隔符宽度
#define kEdgeW          (5) //边缘距离、标题与天数、时分秒的距离
#define kViewW          ( kTitleW + kTimeW*3 + kSpaceW*2 + kEdgeW*3 ) //默认倒计时控件宽度（不含天数）

@implementation YDCountDownConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _title = @"距结束";
        _titleFont = [UIFont fontWithName:kFontNormal size:12];
        _titleColor = kColor333;
        
        _ddFont = [UIFont fontWithName:kFontMedium size:12];
        _ddColor = kColor333;
        _ddBgColor = [UIColor clearColor];
        
        _timeFont = [UIFont fontWithName:kFontNormal size:12];
        _timeColor = [UIColor whiteColor];
        _timeBgColor = kColor333;
        
        _spFont = [UIFont fontWithName:kFontNormal size:12];
        _spColor = kColor333;
    }
    return self;
}

@end


@interface YDCountDownView ()
@property (nonatomic,   copy) dispatch_block_t endBlock;

@property (nonatomic, strong) UILabel *titleLabel; //标题
@property (nonatomic, strong) UILabel *dLabel; //天
@property (nonatomic, strong) UILabel *hLabel; //时
@property (nonatomic, strong) UILabel *mLabel; //分
@property (nonatomic, strong) UILabel *sLabel; //秒

@property (nonatomic, strong) UILabel *spLabel0; //分隔符:
@property (nonatomic, strong) UILabel *spLabel1; //分隔符
@end

@implementation YDCountDownView

+ (instancetype)countDownWithConfig:(YDCountDownConfig *)config endBlock:(dispatch_block_t)endBlock {
    YDCountDownView *view = [[YDCountDownView alloc] initWithFrame:CGRectZero config:config];
    view.endBlock = endBlock;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame config:(YDCountDownConfig *)config {
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
    }
    
    //天
    if (!_dLabel) {
        _dLabel = [UILabel labelWithFont:_config.ddFont textColor:_config.ddColor];
        _dLabel.backgroundColor = _config.ddBgColor;
        _dLabel.textAlignment = NSTextAlignmentCenter;
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
    }
    
    //分
    if (!_mLabel) {
        _mLabel = [UILabel labelWithFont:_config.timeFont textColor:_config.timeColor];
        _mLabel.backgroundColor = _config.timeBgColor;
        _mLabel.textAlignment = NSTextAlignmentCenter;
        _mLabel.clipsToBounds = YES;
        [_mLabel yd_setCornerRadius:2 corners:UIRectCornerAllCorners];
    }
    
    //秒
    if (!_sLabel) {
        _sLabel = [UILabel labelWithFont:_config.timeFont textColor:_config.timeColor];
        _sLabel.backgroundColor = _config.timeBgColor;
        _sLabel.textAlignment = NSTextAlignmentCenter;
        _sLabel.clipsToBounds = YES;
        [_sLabel yd_setCornerRadius:2 corners:UIRectCornerAllCorners];
    }
    
    //分隔符
    if (!_spLabel0) {
        _spLabel0 = [UILabel labelWithFont:_config.spFont textColor:_config.spColor];
        _spLabel0.textAlignment = NSTextAlignmentCenter;
        _spLabel0.text = @":";
    }
    
    if (!_spLabel1) {
        _spLabel1 = [UILabel labelWithFont:_config.spFont textColor:_config.spColor];
        _spLabel1.textAlignment = NSTextAlignmentCenter;
        _spLabel1.text = @":";
    }
    
    _titleLabel.text = _config.title;
    _dLabel.text = @"";
    _hLabel.text = @"--";
    _mLabel.text = @"--";
    _sLabel.text = @"--";
    
    [self sd_addSubviews:@[_titleLabel, _dLabel, _hLabel, _spLabel0, _mLabel, _spLabel1, _sLabel]];
    
    //布局
    _sLabel.sd_layout
    .centerYEqualToView(self)
    .rightSpaceToView(self, kEdgeW)
    .heightIs(kTimeW).widthEqualToHeight();
    
    _spLabel1.sd_layout
    .centerYEqualToView(self)
    .rightSpaceToView(_sLabel, 0)
    .heightIs(kTimeW).widthIs(kSpaceW);
    
    _mLabel.sd_layout
    .centerYEqualToView(self)
    .rightSpaceToView(_spLabel1, 0)
    .heightIs(kTimeW).widthEqualToHeight();
    
    _spLabel0.sd_layout
    .centerYEqualToView(self)
    .rightSpaceToView(_mLabel, 0)
    .heightIs(kTimeW).widthIs(kSpaceW);
    
    _hLabel.sd_layout
    .centerYEqualToView(self)
    .rightSpaceToView(_spLabel0, 0)
    .heightIs(kTimeW).widthEqualToHeight();
    
//    _dLabel.sd_layout
//    .centerYEqualToView(self)
//    .rightSpaceToView(_hLabel, 3)
//    .widthIs(24).heightIs(18);
//
//    _titleLabel.sd_layout
//    .centerYEqualToView(self)
//    .rightSpaceToView(_dLabel, 3)
//    .widthIs(24).heightIs(18);
    
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
    
    CGFloat allW = kViewW;
    
    if (ddValue > 0) {
        _dLabel.text = [NSString stringWithFormat:@"%ld天", (long)ddValue];
        
        CGFloat ddW = [_dLabel.text getWidthWithFont:_config.ddFont constrainedToSize:CGSizeMake(50, kTimeW)];
        
        _dLabel.sd_resetLayout
        .centerYEqualToView(self)
        .rightSpaceToView(_hLabel, kEdgeW)
        .widthIs(ddW).heightIs(kTimeW);
        
        _titleLabel.sd_resetLayout
        .centerYEqualToView(self)
        //.leftSpaceToView(self, 2)
        .rightSpaceToView(_dLabel, kEdgeW)
        .widthIs(kTitleW).heightIs(kTimeW);
        
        allW = kViewW + ddW + kEdgeW;
        
    } else {
        _dLabel.sd_resetLayout.widthIs(0);
        
        _titleLabel.sd_resetLayout
        .centerYEqualToView(self)
        .rightSpaceToView(_hLabel, kEdgeW)
        .widthIs(kTitleW).heightIs(kTimeW);
    }
    
    self.sd_layout.widthIs(allW);
    //[self setupAutoWidthWithRightView:_sLabel rightMargin:0];
}

- (void)showEndStyle {
    _dLabel.sd_resetLayout.widthIs(0);
    
    _titleLabel.sd_resetLayout
    .centerYEqualToView(self)
    .leftSpaceToView(self, 2)
    .rightSpaceToView(_hLabel, 5)
    .widthIs(kTitleW).heightIs(kTimeW);
    
    _hLabel.text = @"--";
    _mLabel.text = @"--";
    _sLabel.text = @"--";
    
    self.sd_layout.widthIs(kViewW);
}

@end
