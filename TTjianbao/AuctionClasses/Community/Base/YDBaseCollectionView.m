//
//  YDBaseCollectionView.m
//  TTjianbao
//
//  Created by wuyd on 2020/2/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YDBaseCollectionView.h"

@implementation YDBaseCollectionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //当事件是传递给此View内部的子View时，让子View自己捕获事件，如果是传递给此View自己时，放弃事件捕获
    UIView* __tmpView = [super hitTest:point withEvent:event];
    if (__tmpView == self) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}
 */

@end
