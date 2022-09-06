//
//  JHTopicSelectListFooter.m
//  TTjianbao
//
//  Created by wuyd on 2019/7/30.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTopicSelectListFooter.h"

@interface JHTopicSelectListFooter ()

@end


@implementation JHTopicSelectListFooter

+ (CGFloat)footerHeight {
    return 20.0;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
