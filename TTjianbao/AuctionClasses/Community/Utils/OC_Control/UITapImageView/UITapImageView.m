//
//  UITapImageView.m
//  TTjianbao
//
//  Created by wuyd on 2019/8/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "UITapImageView.h"
#import "UIImageView+JHWebImage.h"

@interface  UITapImageView ()
@property (nonatomic, copy) void(^tapAction)(id);
@end

@implementation UITapImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.exclusiveTouch = YES;
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)tap {
    if (self.tapAction) {
        self.tapAction(self);
    }
}
- (void)addTapBlock:(void(^)(id obj))tapAction {
    self.tapAction = tapAction;
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}

- (void)setImageWithUrl:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void(^)(id obj))tapAction {
    [self jhSetImageWithURL:imgUrl placeholder:placeholderImage];
    [self addTapBlock:tapAction];
}

@end
