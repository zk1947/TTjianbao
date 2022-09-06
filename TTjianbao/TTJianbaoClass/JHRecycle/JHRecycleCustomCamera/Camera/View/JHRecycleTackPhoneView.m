//
//  JHRecycleTackPhoneView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleTackPhoneView.h"
@interface JHRecycleTackPhoneView()<CAAnimationDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *takeButtonView;

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation JHRecycleTackPhoneView


#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.allowTakePhone = true;
        self.allowRecordVideo = true;
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"回收订单详情ViewController-%@ 释放", [self class]);
}

#pragma mark - Action
/// 拍照
- (void)didTouchUpInside {
    if (self.allowTakePhone == false) return;
    if (self.isRemake) {
        self.isRemake = false;
        if (self.remakePhone) {
            self.remakePhone();
        }
        return;
    }
    if (self.takePhone) {
        self.takePhone();
    }
}

- (void)didLongPressWithAction : (UILongPressGestureRecognizer *)sender {
    if (self.allowRecordVideo == false) return;
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.startRecord) {
            self.startRecord();
            [self startAnimation];
        }
        
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.stopRecord) {
            self.stopRecord();
            [self stopAnimation];
        }
    }
}

#pragma mark - Private Functions
- (void)startAnimation {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.delegate = self;
    pathAnimation.duration = 60;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
   
    [self.progressLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}
- (void)stopAnimation {
    [self.progressLayer removeAllAnimations];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        if (self.stopRecord) {
            self.stopRecord();
            [self stopAnimation];
        }
    }
}

#pragma mark - Bind
- (void)bindData {
    
}
#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = UIColor.blackColor;
    [self addSubview:self.takeButtonView];
    [self.layer addSublayer:self.backgroundLayer];
    [self.layer addSublayer:self.progressLayer];
}
- (void)layoutViews {
    CGFloat width = self.frame.size.width;
    self.backgroundLayer.path = self.bezierPath.CGPath;
    self.progressLayer.path = self.bezierPath.CGPath;
    [self jh_cornerRadius:width / 2];
    [self.takeButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
}

#pragma mark - Lazy
- (void)setIsRemake:(BOOL)isRemake {
    _isRemake = isRemake;
    if (isRemake) {
        [self.takeButtonView setTitle:@"重拍" forState:UIControlStateNormal];
    }else {
        [self.takeButtonView setTitle:@"" forState:UIControlStateNormal];
    }
}

- (UIButton *)takeButtonView {
    if (!_takeButtonView) {
        _takeButtonView = [UIButton buttonWithType:UIButtonTypeCustom];
        _takeButtonView.backgroundColor = UIColor.clearColor;
        [_takeButtonView setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        _takeButtonView.titleLabel.font = [UIFont fontWithName:kFontNormal size:16];
        
        [_takeButtonView addTarget:self action:@selector(didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] init];
        longPress.minimumPressDuration = 0.5;
        [longPress addTarget:self action:@selector(didLongPressWithAction:)];
        
        [_takeButtonView addGestureRecognizer:longPress];
    }
    return _takeButtonView;
}
- (UIBezierPath *)bezierPath {
    if (!_bezierPath) {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        _bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2, height/2) radius:(width / 2 - 6) startAngle:M_PI *3/2 endAngle: M_PI * 3 + M_PI / 2 clockwise:true];
    }
    return _bezierPath;
}
- (CAShapeLayer *)backgroundLayer {
    if (!_backgroundLayer) {
        _backgroundLayer = [[CAShapeLayer alloc] init];
        _backgroundLayer.fillColor = UIColor.clearColor.CGColor;
        _backgroundLayer.strokeColor = UIColor.whiteColor.CGColor;
        _backgroundLayer.lineWidth = 3;
        _backgroundLayer.strokeEnd = 1;
        
    }
    return _backgroundLayer;
}
- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [[CAShapeLayer alloc] init];
        _progressLayer.fillColor = UIColor.clearColor.CGColor;
        _progressLayer.strokeColor = HEXCOLOR(0xffd700f).CGColor;
        _progressLayer.lineWidth = 3;
        _progressLayer.opacity = 1;
        _progressLayer.strokeEnd = 0;
        _progressLayer.strokeStart = 0;
        _progressLayer.lineCap = kCALineCapRound;
    }
    return _progressLayer;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0xffffff);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:16];
    }
    return _titleLabel;
}
@end
