//
//  JHLikeImageView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/4/16.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHLikeImageView.h"

@implementation JHLikeImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.contentMode = UIViewContentModeScaleAspectFit;
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i<25; i++) {
            [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"biglike_000%02d",i]]];
        }
        self.animationImages = array;
        self.animationRepeatCount = 0;
        self.animationDuration = 0.5;
    

    }
    return self;
}


- (instancetype)initDragWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentMode = UIViewContentModeScaleAspectFit;
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i<35; i++) {
            NSString *name = [NSString stringWithFormat:@"tuo_%04d_%05d",i,i];
            
            [array addObject:[UIImage imageNamed:name]];
        }
        self.animationImages = array;
        self.animationRepeatCount = 3;
        self.animationDuration = 1.5;
        
        
    }
    return self;
}

- (instancetype)initVideoDragWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentMode = UIViewContentModeScaleAspectFit;
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i<27; i++) {
            NSString *name = [NSString stringWithFormat:@"video_slide_%04d_%02d",i,i];
            
            [array addObject:[UIImage imageNamed:name]];
        }
        self.animationImages = array;
        self.animationRepeatCount = MAXFLOAT;
        self.animationDuration = 1;
        
        
    }
    return self;

}

- (void)beginAnimationDuring:(CGFloat)during {
    [self startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(during * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopAnimating];
        [self removeFromSuperview];
    });
}


- (void)beginAnimation {
    [self startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopAnimating];
        [self removeFromSuperview];
    });
}

- (void)startAnimation {
    [self startAnimating];
}

- (void)endAnimation {
    [self stopAnimating];
    [self removeFromSuperview];
}
@end

@implementation JHLodingImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentMode = UIViewContentModeScaleAspectFit;
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i<12; i++) {
            [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"lineloading_000%02d",i]]];
        }
        self.animationImages = array;
        self.animationRepeatCount = 100;
        self.animationDuration = 0.5;
        self.hidden = YES;
        
    }
    return self;
}

- (void)beginAnimation {
    [self startAnimating];
    self.hidden = NO;

}

- (void)endAnimation {
    [self stopAnimating];
    self.hidden = YES;
}

@end
