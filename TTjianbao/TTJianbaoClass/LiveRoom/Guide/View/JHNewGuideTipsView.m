//
//  JHNewGuideTipsView.m
//  TTjianbao
//
//  Created by yaoyao on 2020/6/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHNewGuideTipsView.h"

@implementation JHNewGuideTipsViewModel
@end

@interface JHNewGuideTipsView ()

@property (nonatomic, assign) JHTipsGuideType type;
@property (nonatomic, assign) CGRect transparencyRect;

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) NSMutableArray *arrayModel;
@property (nonatomic, strong) UIView *superV;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation JHNewGuideTipsView

- (void)dealloc {
    
}

+ (void)showGuideWithType:(JHTipsGuideType)type transparencyRect:(CGRect)rect superView:(UIView *)superView {
    
    
    JHNewGuideTipsView *view = [JHNewGuideTipsView new];
    
    CGFloat radius = 0;
    switch (type) {
        case JHTipsGuideTypeSellMarket:{
            radius = 5.;
            [superView addSubview:view];
            [JHNewGuideTipsView drawEmptyFrame:rect emptyRadius:radius containerView:view];
            [view setStyleType:type transparencyRect:rect];
        }
            
            break;
        case JHTipsGuideTypeSellRoom:{
            radius = 18.5;
            [superView addSubview:view];
            [JHNewGuideTipsView drawEmptyFrame:rect emptyRadius:radius containerView:view];
            [view setStyleType:type transparencyRect:rect];
        }
            
            break;
        case JHTipsGuideTypeAppraiseRoom:{
            radius = 18.5;
            [superView addSubview:view];
            [JHNewGuideTipsView drawEmptyFrame:rect emptyRadius:radius containerView:view];
            [view setStyleType:type transparencyRect:rect];
        }
            
            break;
        case JHTipsGuideTypeAppraiseRoomApply:{
            radius = 18.5;
            [superView addSubview:view];
            [JHNewGuideTipsView drawEmptyFrame:rect emptyRadius:radius containerView:view];
            [view setStyleType:type transparencyRect:rect];
        }
            
            break;
        case JHTipsGuideTypeTianTianCustomize:{
            [superView addSubview:view];
            view.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.1f];
            // [JHNewGuideTipsView drawEmptyFrame:rect emptyRadius:radius containerView:view];
            [view setStyleType:type transparencyRect:rect];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                view.arrowImageView.alpha = 1;
                [UIView animateWithDuration:1 animations:^{
                    view.arrowImageView.alpha = 0;
                    
                } completion:^(BOOL finished) {
                    
                    [view removeSelf];
                    
                }];
                
            });
            
        }
            break;
        case JHTipsGuideTypeCustomizeRoom:{
            radius = 18.5;
            [superView addSubview:view];
            [JHNewGuideTipsView drawEmptyFrame:rect emptyRadius:radius containerView:view];
            [view setStyleType:type transparencyRect:rect];
        }
            break;
        default:
            break;
    }
    
    
}
+ (void)showGuideWithModelArray:(NSArray *)array superView:(UIView *)superView{
    JHNewGuideTipsView *view = [[JHNewGuideTipsView alloc] initWithClose];
    view.arrayModel = [NSMutableArray arrayWithArray:array];
    view.superV = superView;
    [superView addSubview:view];
    if (view.arrayModel.count>0) {
        JHNewGuideTipsViewModel *model = (JHNewGuideTipsViewModel*)[view.arrayModel firstObject];
        [view setStyleWithModel:model];
    }
}
- (void)setStyleWithModel:(JHNewGuideTipsViewModel*)model{
    CGFloat radius = 18.5;
    [self drawEmptyFrame_second:model.rect emptyRadius:radius containerView:self];
    [self setStyleType:model.type transparencyRect:model.rect];
}
- (instancetype)init
{
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.arrowImageView];
        
    }
    return self;
}

- (instancetype)initWithClose
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.arrowImageView];
        [self.arrowImageView addSubview:self.closeBtn];
    }
    return self;
}
- (void)removeSelf {
    if (self.arrayModel.count>0) {
        [self.arrayModel removeFirstObject];
        if (self.arrayModel.count>0) {
            
            [self.arrowImageView.layer removeAllAnimations];
            [self.shapeLayer removeFromSuperlayer];
            [self setStyleWithModel:(JHNewGuideTipsViewModel*)[self.arrayModel firstObject]];
        }else{
            [self.arrowImageView.layer removeAllAnimations];
            [self removeFromSuperview];
        }
    }else{
        [self.arrowImageView.layer removeAllAnimations];
        [self removeFromSuperview];
    }
    
}


- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImageView.layer.zPosition = 100;
    }
    
    return _arrowImageView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeBtn;
}

- (void)setStyleType:(JHTipsGuideType)type transparencyRect:(CGRect)rect {
    _type = type;
    _transparencyRect = rect;
    
    switch (type) {
        case JHTipsGuideTypeSellMarket:{
            self.arrowImageView.image = [UIImage imageNamed:@""];
            self.arrowImageView.image = [UIImage imageNamed:@"img_guide_sell_market"];
            [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_top).offset(rect.origin.y);
                make.centerX.equalTo(self.mas_leading).offset(rect.origin.x+rect.size.width/2.);
            }];
            [self createShakeAnimaition];
        }
            break;
        case JHTipsGuideTypeSellRoom:{
            self.arrowImageView.image = [UIImage imageNamed:@""];
            self.arrowImageView.image = [UIImage imageNamed:@"img_guide_sell_say"];
            [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_top).offset(rect.origin.y);
                make.leading.equalTo(self.mas_leading).offset(10);
            }];
            [self createShakeAnimaition];
            
        }
            break;
        case JHTipsGuideTypeAppraiseRoom:{
            self.arrowImageView.image = [UIImage imageNamed:@"img_guide_appraise"];
            [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_top).offset(rect.origin.y);
                make.trailing.equalTo(self).offset(-10);
            }];
            [self createShakeAnimaition];
        }
            break;
        case JHTipsGuideTypeAppraiseRoomApply: {
            self.arrowImageView.image = [UIImage imageNamed:@"img_guide_appraise"];
            [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_top).offset(rect.origin.y);
                make.trailing.equalTo(self).offset(-10);
            }];
            [self createShakeAnimaition];
        }
            break;
        case JHTipsGuideTypeTianTianCustomize: {
            self.arrowImageView.image = [UIImage imageNamed:@"customize_first_guige"];
            [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(rect.origin.y+rect.size.height-5);
                make.left.equalTo(self).offset(rect.origin.x-137/2+rect.size.width/2);
            }];
            
            self.arrowImageView.alpha = 0;
            [UIView animateWithDuration:1 animations:^{
                self.arrowImageView.alpha = 1;
                
            } completion:^(BOOL finished) {
                
                [self createShakeAnimaition];
            }];
        }
            break;
        case JHTipsGuideTypeCustomizeRoom:{//
            self.arrowImageView.image = [UIImage imageNamed:@"customizeRoom_first_guige_header"];
            self.arrowImageView.userInteractionEnabled = YES;
            [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(214, 85));
                make.top.equalTo(self.mas_top).offset(rect.origin.y-1.5);
                make.left.equalTo(self.mas_left).offset(rect.origin.x-3.5);
            }];
            [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(60, 40));
                make.bottom.mas_equalTo(self.arrowImageView.mas_bottom).offset(-10);
                make.right.mas_equalTo(-20);
            }];
//            [self createShakeAnimaition];  //产品不让动
        }
            break;
        case JHTipsGuideTypeCustomizeRoom_second:{//    //customizeRoom_first_guige_apply
            self.arrowImageView.image = [UIImage imageNamed:@"customizeRoom_first_guige_apply"];
            self.arrowImageView.userInteractionEnabled = YES;
            [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(256, 73));
                make.bottom.equalTo(self.mas_top).offset(rect.origin.y);
                make.centerX.equalTo(self.mas_left).offset(rect.origin.x + rect.size.width/2);
            }];
            [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(60, 40));
                make.bottom.mas_equalTo(self.arrowImageView.mas_bottom).offset(-17);
                make.right.mas_equalTo(-20);
            }];
//            [self createShakeAnimaition];   //产品不让动
        }
            break;
        default:
            break;
            
    }
    
    
    
    
}


- (void)createShakeAnimaition {
    
    [self layoutIfNeeded];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    CGFloat duration = 1.f;
    CGFloat height = 7.f;
    CGFloat currentY = self.arrowImageView.transform.ty;
    animation.duration = duration;
    animation.values = @[@(currentY),@(currentY - height/4),@(currentY - height/4*2),@(currentY - height/4*3),@(currentY - height),@(currentY - height/ 4*3),@(currentY - height/4*2),@(currentY - height/4),@(currentY)];
    animation.keyTimes = @[ @(0), @(0.025), @(0.085), @(0.2), @(0.5), @(0.8), @(0.915), @(0.975), @(1) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    [self.arrowImageView.layer addAnimation:animation forKey:@"shake"];
    
}

+ (void)drawEmptyFrame:(CGRect)frame emptyRadius:(CGFloat)radius containerView:(UIView *)view {
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:0];
    [bpath appendPath:[[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius] bezierPathByReversingPath]];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bpath.CGPath;
    shapeLayer.fillColor = HEXCOLORA(0x000000, 0.5).CGColor;
    [view.layer addSublayer:shapeLayer];
    
}
- (void)drawEmptyFrame_second:(CGRect)frame emptyRadius:(CGFloat)radius containerView:(UIView *)view {
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:0];
    [bpath appendPath:[[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius] bezierPathByReversingPath]];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bpath.CGPath;
    shapeLayer.fillColor = HEXCOLORA(0x000000, 0.5).CGColor;
    self.shapeLayer = shapeLayer;
    [view.layer addSublayer:shapeLayer];
    
}
@end
