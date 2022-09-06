//
//  UITapView.m
//  TTjianbao
//
//  Created by wuyd on 2019/8/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "UITapView.h"

@interface  UITapView ()
@property (nonatomic, copy) void(^tapAction)(id);
@property (nonatomic, copy) void(^tapAction2)(id obj,BOOL isLeft);
@end


@implementation UITapView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)addTapBlock:(void(^)(id obj))tapAction {
    self.tapAction = tapAction;
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}

- (void)tap {
    if (self.tapAction) {
        self.tapAction(self);
    }
}

- (void)addTapBlock2:(void(^)(id obj, BOOL isLeft))tapAction2 {
    self.tapAction2 = tapAction2;
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2:)];
        [self addGestureRecognizer:tap2];
    }
}

- (void)tap2:(UITapGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self];
    BOOL isLeft = touchPoint.x > self.width-50 ? NO:YES;
    if (self.tapAction2) {
        self.tapAction2(self,isLeft);
    }
}

@end
