//
//  JHCustomSerDecorationView.m
//  TTjianbao
//
//  Created by apple on 2020/9/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomSerDecorationView.h"

@implementation JHCustomSerDecorationView
- (id)initWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];
    if (self) {

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:@"customizeListHeadImage"];
//        imageView.backgroundColor = [UIColor redColor];
        [self addSubview:imageView];
    }
    return self;
}
@end
