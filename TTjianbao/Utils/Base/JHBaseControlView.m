//
//  JHBaseControlView.m
//  TTjianbao
//
//  Created by yaoyao on 2020/4/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseControlView.h"

@implementation JHBaseControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initGesture];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initGesture];
    }
    return self;
}


- (void)initGesture {
    
}

- (void)setPlayer:(ZFPlayerController *)player {
    
}

- (void)gestureDoubleTapped:(ZFPlayerGestureControl *)gestureControl {
    if (self.doubleTapBack) {
        self.doubleTapBack();
    }
}

- (void)gestureSingleTapped:(ZFPlayerGestureControl *)gestureControl {
    if (self.singleTapBack) {
        self.singleTapBack();
    }
}

@end
