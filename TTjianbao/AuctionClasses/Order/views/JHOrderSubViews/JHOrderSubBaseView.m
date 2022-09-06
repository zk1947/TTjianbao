//
//  JHOrderSubBaseView.m
//  TTjianbao
//
//  Created by jiang on 2020/5/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderSubBaseView.h"

@implementation JHOrderSubBaseView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.backgroundColor=[UIColor whiteColor];
        [self setSubViews];
    }
    return self;
}
-(void)setSubViews{
    
    //子类重新
    
}
@end
