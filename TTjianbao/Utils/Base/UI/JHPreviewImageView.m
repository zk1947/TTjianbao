//
//  JHPreviewImageView.m
//  TTjianbao
//
//  Created by lihui on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPreviewImageView.h"

@interface JHPreviewImageView () {
    dispatch_block_t completionBlock;
}

@property (nonatomic, strong) UIImageView *preImageView;

@end

@implementation JHPreviewImageView


static JHPreviewImageView *shareInstance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[JHPreviewImageView alloc] init];
    });
    return shareInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

+ (JHPreviewImageView *)preImageView:(UIImage *)preImage {
     [[self shareInstance] createPreImageView:preImage];
    return shareInstance;
}

- (void)createPreImageView:(UIImage *)preImage {
    UIImageView *imageV = [[UIImageView alloc] initWithImage:preImage];
    imageV.frame = CGRectZero;
    imageV.center = self.center;
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.userInteractionEnabled = YES;
    [self addSubview:imageV];
    _preImageView = imageV;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [imageV addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [imageV addGestureRecognizer:doubleTap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [imageV addGestureRecognizer:pan];
}

- (void)show {
    CGRect endRect = CGRectMake(0, 0, ScreenW, ScreenH);
    [UIView animateWithDuration:.3 animations:^{
        CGRect rect = self.preImageView.frame;
        rect = endRect;
        self.preImageView.frame = rect;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        CGRect rect = self.preImageView.frame;
        rect.size.width = 0.f;
        rect.size.height = 0.f;
        self.preImageView.frame = rect;
    } completion:^(BOOL finished) {
        if (self.completionBlock) {
            self.completionBlock();
        }
        [self removeFromSuperview];
    }];
}

///单击
- (void)tapAction:(UIGestureRecognizer *)tap {
    [self dismiss];
}

///双击
- (void)doubleTapAction:(UIGestureRecognizer *)doubleTap {
    ///根据手势 放大图片
    
    
    
    
}

///拖拽
- (void)panAction:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    CGPoint center = gesture.view.center;
    center.x += translation.x;
    center.y += translation.y;
    gesture.view.center = center;
    [gesture setTranslation:CGPointZero inView:self];

//    [self dismiss];
}

@end
