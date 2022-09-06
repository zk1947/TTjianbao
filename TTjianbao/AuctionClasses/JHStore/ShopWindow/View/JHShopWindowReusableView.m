//
//  JHShopWindowReusableView.m
//  TTjianbao
//
//  Created by apple on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHShopWindowReusableView.h"
//#import "JHGoodsInfoMode.h"
#import "TTjianbaoMarcoUI.h"
#import "JHShopWindowModel.h"
#import "YDCountDown.h"
#import "YDCountDownView.h"


@interface JHShopWindowReusableView ()

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) YDCountDown *countDown;
@property (nonatomic, strong) YDCountDownView *countDownView;

@end

@implementation JHShopWindowReusableView

+ (CGFloat)headerHeight {
    return 220;
}

- (void)dealloc {
    NSLog(@"专题页面列表header被释放！！！！！");
    [self.countDown destoryTimer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF8F8F8);

        if (!_countDown) {
            _countDown = [[YDCountDown alloc] init];
        }
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.clipsToBounds = YES;
    _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_bgImgView];
    _bgImgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    [_bgImgView addSubview:_maskView];
    _maskView.sd_layout.spaceToSuperView(UIEdgeInsetsMake([[self class] headerHeight]-44, 0, 0, 0));
    
    _maskView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_maskView.bounds].CGPath;
    _maskView.layer.shadowColor = [UIColor blackColor].CGColor; //HEXCOLORA(0x000000, 0.3).CGColor;
    _maskView.layer.shadowOpacity = 0.2;
    _maskView.layer.shadowRadius = 10;
    _maskView.layer.shadowOffset = CGSizeMake(0, 10);
    
    //倒计时视图
    YDCountDownConfig *config = [[YDCountDownConfig alloc] init];
    config.titleColor = [UIColor whiteColor];
    config.ddColor = [UIColor whiteColor];
    config.spColor = [UIColor whiteColor];
    _countDownView = [YDCountDownView countDownWithConfig:config endBlock:^{}];
    [self addSubview:_countDownView];
    
    _countDownView.sd_layout
    .rightSpaceToView(self, 10)
    .bottomSpaceToView(self, 10)
    .heightIs(20);
}

- (void)setHeaderInfo:(JHShopWindowInfo *)headerInfo {
    _headerInfo = headerInfo;
    if (!_headerInfo) {
        return;
    }
    
    [_bgImgView jhSetImageWithURL:[NSURL URLWithString:_headerInfo.bg_img]
                                    placeholder:kDefaultCoverImage];
    
    if (![self isLegal:_headerInfo.server_at.integerValue endTime:_headerInfo.offline_at.integerValue]) {
        [_countDownView showEndStyle];
        return;
    }
    
    @weakify(self);
    [_countDown startWithbeginTimeStamp:_headerInfo.server_at.integerValue
                        finishTimeStamp:_headerInfo.offline_at.integerValue
                          completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second)
    {
        @strongify(self);
        [self.countDownView setDD:day hh:hour mm:minute ss:second];
        if (day == 0 && hour==0 && minute == 0 && second == 0) {
            [self.countDownView showEndStyle];
            ///停止定时器
            [self.countDown destoryTimer];
            if (self.timerBlock) {
                self.timerBlock();
            }
        }
        
        [self setNeedsLayout];
    }];
}

///判断结束时间是否大于开始时间
- (BOOL)isLegal:(long long)startTime endTime:(long long)endTime {
    if (endTime - startTime > 0) {
        return YES;
    }
    return NO;
}

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY {
//    CGRect frame = _bgImgView;
//    frame.size.height -= contentOffsetY;
//    frame.origin.y = contentOffsetY;
//    _bgImgView.frame = frame;
    
    if (contentOffsetY >= 0) {
        _bgImgView.sd_layout
        .heightIs([[self class] headerHeight]);
        //.topEqualToView(self);
    } else {
        _bgImgView.sd_layout
        .heightIs([[self class] headerHeight] - contentOffsetY);
        //.topEqualToView(self).offset(contentOffsetY);
    }
}

@end
