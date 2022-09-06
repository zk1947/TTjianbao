//
//  CountDownBar.m
//  CountDownBar
//
//  Created by jpz on 2019/4/20.
//  Copyright © 2019 jpz. All rights reserved.
//

#import "JHCountDownBarView.h"
#import "BYTimer.h"

static CGFloat layerWidth = 3.f;

@interface JHCountDownBarView()

@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, assign) CGFloat endAngle;
@property (nonatomic, strong) BYTimer *timer;
@property(nonatomic, assign) CGFloat currentTime;

@end

@implementation JHCountDownBarView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.hidden = YES;
        [self setupSubviews];
    }
    return self;
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (void)dealloc {
    [self.timer stopGCDTimer];
}

- (void)setupSubviews {
    self.contentLabel = [UILabel jh_labelWithFont:13 textColor:HEXCOLOR(0xFF333333) addToSuperView:self];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
}

/**
 开启、刷新动画
 */
- (void)startAnimation {
    [self initParams];
}

- (void)initParams {
    self.currentTime = self.time;
    self.endAngle = -M_PI_2;
    self.hidden = NO;
    [self countDown];
}

- (void)countDown {
    if (!self.timer) {
        self.timer = [[BYTimer alloc] init];
    }
    
    [self.timer createTimerWithTimeout:30.f handlerBlock:^(int presentTime) {
        self.endAngle = 2*M_PI*(1-presentTime/self.time) - 0.5 * M_PI;
        self.contentLabel.text = [NSString stringWithFormat:@"%ds",presentTime];
        [self setNeedsDisplay];
    } finish:^{
        self.endAngle = 1.5*M_PI;
        self.contentLabel.text = @"0s";
        self.hidden = YES;
        [self setNeedsDisplay];
    }];
}

- (void)drawRect:(CGRect)rect {
    // 阴影
    UIBezierPath *circle1 = [UIBezierPath bezierPath];
    [circle1 addArcWithCenter:CGPointMake(rect.size.width*0.5, rect.size.height*0.5)
                      radius:rect.size.width*0.5-layerWidth*0.5
                  startAngle:-M_PI_2
                    endAngle:1.5*M_PI
                   clockwise:YES];
    circle1.lineWidth = layerWidth;
    [HEXCOLOR(0xFFE6E6E6) setStroke];
    [circle1 stroke];
    
    // 进度
    UIBezierPath *circle = [UIBezierPath bezierPath];
    [circle addArcWithCenter:CGPointMake(rect.size.width*0.5, rect.size.height*0.5)
                      radius:rect.size.width*0.5-layerWidth*0.5
                  startAngle:-M_PI_2
                    endAngle:self.endAngle
                   clockwise:YES];
    circle.lineWidth = layerWidth;
    [HEXCOLOR(0xFFF7B500) setStroke];
    [circle stroke];
}

@end
