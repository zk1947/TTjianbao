//
//  JHLadderWidget.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLadderWidget.h"
#import "YYControl.h"
#import <UIImage+webP.h>
#import "UIView+SDAutoLayout.h"
#import "YDCategoryKit/YDCategoryKit.h"

@interface JHLadderWidget ()
@property (nonatomic,   copy) dispatch_block_t clickBlock;

@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) YYAnimatedImageView *imgView;
@property (nonatomic, strong) UIButton *countDownBtn;

@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) NSInteger timeInterval; //倒计时时间
@property (nonatomic, strong) RACDisposable *racDisposable; //RAC中的GCD 用于倒计时
@property (nonatomic, strong) RACDisposable *shakeDisposable; //用于抖动动画计时

@end

@implementation JHLadderWidget

- (void)dealloc {
    [_racDisposable dispose];
    [_shakeDisposable dispose];
}

//箱子静态尺寸46x43、动态尺寸50x60，按钮大小45x17，按钮底部距箱子底部5px
+ (CGSize)widgetSize {
    return CGSizeMake(80, 65);
}

+ (instancetype)ladderWithClickBlock:(dispatch_block_t)block {
    JHLadderWidget *widget = [[JHLadderWidget alloc] initWithFrame:CGRectMake(0, 0, [self widgetSize].width, [self widgetSize].height)];
    widget.clickBlock = block;
    return widget;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    if (!_contentControl) {
        _contentControl = [YYControl new];
        _contentControl.exclusiveTouch = YES;
        [self addSubview:_contentControl];
        @weakify(self);
        _contentControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            @strongify(self);
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:self];
                if (CGRectContainsPoint(self.bounds, p)) {
                    if (self.isEnabled) {
                        if (self.clickBlock) {
                            self.clickBlock();
                        }
                    }
                }
            }
        };
    }
    
    if (!_imgView) {
        _imgView = [[YYAnimatedImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"live_room_ladder_box"];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [_contentControl addSubview:_imgView];
    }
    
    if (!_countDownBtn) {
        _countDownBtn = [UIButton buttonWithTitle:@"" titleColor:UIColorHex(0xFE003A)];
        _countDownBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:12];
        [_countDownBtn setBackgroundImage:[UIImage imageNamed:@"live_room_ladder_countdown_bg"] forState:UIControlStateNormal];
        _countDownBtn.userInteractionEnabled = NO;
        [_contentControl addSubview:_countDownBtn];
    }
    
    //布局
    _contentControl.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 15, 0, 15));
    
    _countDownBtn.sd_layout
    .bottomSpaceToView(_contentControl, 0)
    .centerXEqualToView(_contentControl)
    .widthIs(45).heightIs(17);
    
    _imgView.sd_layout
    .bottomSpaceToView(_contentControl, 8)
    .centerXEqualToView(_contentControl)
    .widthIs(46).heightIs(43);
}

- (void)startTimerWithTimeInterval:(NSInteger)timeInterval {
    _timeInterval = timeInterval;
    [_countDownBtn setTitle:[NSString stringWithFormat:@"%lds", (long)_timeInterval] forState:UIControlStateNormal];
    [self updateImageForNormal:YES]; //更新箱子状态
    [self startTimer];
    [self endShakeTimer];
}

- (void)startTimer {
    self.isEnabled = NO;
    if (!_racDisposable) {
        @weakify(self);
        _racDisposable = [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDate * _Nullable x) {
            @strongify(self);
            
            self.timeInterval--;
            if (self.timeInterval > 0) {
                NSString *str = [NSString stringWithFormat:@"%lds", (long)self.timeInterval];
                [self.countDownBtn setTitle:str forState:UIControlStateNormal];
            } else {
                [self endTimer];
            }
        }];
    }
}

- (void)endTimer {
    self.isEnabled = YES;
    [_racDisposable dispose];
    _racDisposable = nil;
    [_countDownBtn setTitle:@"领取" forState:UIControlStateNormal];
    
    [self updateImageForNormal:NO]; //更新箱子状态
    [self startShakeTimer];
}

#pragma mark - 更新箱子状态
//箱子静态尺寸46x43、动态尺寸50x60，按钮大小45x17，按钮底部距箱子底部5px
- (void)updateImageForNormal:(BOOL)isNormal {
    if (isNormal) {
        _imgView.image = [UIImage imageNamed:@"live_room_ladder_box"];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        _imgView.sd_layout
        .centerXEqualToView(_contentControl).offset(0)
        .widthIs(46).heightIs(43);
        
    } else {
        _imgView.image = [YYImage imageNamed:@"live_room_ladder_box_w.webp"];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        _imgView.sd_layout
        .centerXEqualToView(_contentControl).offset(-1)
        .widthIs(53).heightIs(60);
    }
}

#pragma mark - 按钮抖动效果

- (void)startShakeTimer {
    if (!_shakeDisposable) {
        @weakify(self);
        _shakeDisposable = [[[RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDate * _Nullable x) {
            @strongify(self);
            [self __startShakeAnimation];
        }];
    }
}

- (void)endShakeTimer {
    if (_shakeDisposable) {
        [_shakeDisposable dispose];
        _shakeDisposable = nil;
    }
    [self __stopShakeAnimation];
}

- (void)__startShakeAnimation {
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置抖动幅度
    shake.fromValue = [NSNumber numberWithFloat:-0.3];
    shake.toValue = [NSNumber numberWithFloat:+0.3];
    shake.duration = 0.1;
    shake.autoreverses = YES;
    shake.repeatCount = 1; //重复次数
    [_countDownBtn.layer addAnimation:shake forKey:@"transform.rotation"];
}

- (void)__stopShakeAnimation {
    [_countDownBtn.layer removeAnimationForKey:@"transform.rotation"];
}

- (void)setWidgetEnabled:(BOOL)enabled {
    self.userInteractionEnabled = enabled;
    self.alpha = enabled ? 1 : 0.4;
}

@end
