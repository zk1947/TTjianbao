//
//  JHStoneLiveWindowGuideView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/12/20.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneLiveWindowGuideView.h"
#import "JHUIFactory.h"
#import "JHResaleLiveRoomStretchView.h"

@implementation JHStoneLiveWindowGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLORA(0x000000, 0.8);
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextTapAction:)]];
    }
    return self;
}

- (UIImageView *)arrowImg {
    if (!_arrowImg) {
        _arrowImg = [JHUIFactory createImageView];
    }
    return _arrowImg;
}

- (UIButton *)knowBtn {
    if (!_knowBtn) {
        _knowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_knowBtn setImage:[UIImage imageNamed:@"guide_know_btn"] forState:UIControlStateNormal];
        [_knowBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _knowBtn;
}

- (UIImageView *)localImg {
    if (!_localImg) {
        _localImg = [JHUIFactory createImageView];
    }
    return _localImg;
}

- (void)windowGuide {
    self.backgroundColor = [UIColor clearColor];
    [self drawLayerFrame:CGRectMake(ScreenW-120, UI.statusAndNavBarHeight+75, 110, 160)];
    [self addSubview:self.arrowImg];

    self.arrowImg.image = [UIImage imageNamed:@"img_guide_stone_live_arrow0"];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(UI.statusAndNavBarHeight+75+80);
        make.trailing.offset (-40);
    }];

    self.tag = 0;

}

- (void)windowGuide1 {
    
    [self addSubview:self.arrowImg];
    
    self.arrowImg.image = [UIImage imageNamed:@"img_guide_stone_1"];

    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-(kResaleLiveShrinkHeight-30));
        make.centerX.equalTo(self);
    }];

    self.tag = 1;

}
- (void)windowGuide2 {

    [self addSubview:self.arrowImg];
    self.arrowImg.image = [UIImage imageNamed:@"img_guide_stone_2"];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-20-UI.bottomSafeAreaHeight);
        make.trailing.equalTo(self).offset(-20);
    }];

    self.tag = 2;

}

- (void)windowGuide3 {

    [self addSubview:self.arrowImg];
       self.arrowImg.image = [UIImage imageNamed:@"img_guide_stone_3"];
       [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
           make.bottom.equalTo(self);
           make.leading.trailing.equalTo(self);

       }];

       self.tag = 3;

}


- (void)drawLayerFrame:(CGRect)frame
{
    
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0];
    [bpath appendPath:[[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:0] bezierPathByReversingPath]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bpath.CGPath;
    shapeLayer.fillColor = HEXCOLORA(0x000000, 0.8).CGColor;
    [self.layer addSublayer:shapeLayer];
    
}


- (void)nextAction:(UIButton *)btn {
    [self removeFromSuperview];
    if (btn.tag>0 && btn.tag<4) {
        [JHStoneLiveWindowGuideView showGuideViewWithIndex:btn.tag+1];
    }
}

- (void)nextTapAction:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
    if (tap.view.tag>0 && tap.view.tag<3) {
        [JHStoneLiveWindowGuideView showGuideViewWithIndex:tap.view.tag+1];
    }
}

- (void)windowPersonGuideY:(CGFloat)y {

    [self addSubview:self.arrowImg];
    self.arrowImg.image = [UIImage imageNamed:@"img_guide_stone_personal"];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(y+160-self.arrowImg.image.size.height);
        make.centerX.offset(0);
    }];
    
}

+ (void)showGuideView {
    JHStoneLiveWindowGuideView *view = [[JHStoneLiveWindowGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [view windowGuide];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
}

+ (void)showGuideViewWithIndex:(NSInteger)index {
    JHStoneLiveWindowGuideView *view = [[JHStoneLiveWindowGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSString *method = [NSString stringWithFormat:@"windowGuide%zd",index];
    SEL _selector = NSSelectorFromString(method);
    ((void (*)(id, SEL))[view methodForSelector:_selector])(view, _selector);
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
}

+ (void)showPersonGuideY:(CGFloat)y {
    
    if ([CommHelp isFirstForName:@"showStonePersonGuide"])
    {
            JHStoneLiveWindowGuideView *view = [[JHStoneLiveWindowGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [view windowPersonGuideY:y];
            [[UIApplication sharedApplication].keyWindow addSubview:view];
    }

        
}
@end
