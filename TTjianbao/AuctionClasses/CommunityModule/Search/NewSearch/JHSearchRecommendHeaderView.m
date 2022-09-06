//
//  JHSearchRecommendHeaderView.m
//  TTjianbao
//
//  Created by liuhai on 2021/10/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSearchRecommendHeaderView.h"
#import "UIView+JHGradient.h"
@implementation JHSearchRecommendHeaderView

- (instancetype)initWithFrame:(CGRect)frame withTitleName:(NSString*)str{
    self = [super initWithFrame:frame];
    if (self) {
        [self createHeaderTitle:str];
        
    }
    return self;
}
- (void)createHeaderTitle:(NSString*)str{
    
    [self jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFDF8E0), HEXCOLOR(0xFFFFFF)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    
    UIImageView * imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"searchRecommenHot_icon"];
    [self addSubview:imageV];
    imageV.frame = CGRectMake(14, 15, 19, 16);
    
    UILabel * label = [[UILabel alloc]init];
    label.text = str;
    [self addSubview:label];
    label.font = JHBoldFont(16);
    label.textColor = HEXCOLOR(0x9D5A2A);
    label.frame = CGRectMake(imageV.right+11, 12, 160, 22);
    
}

@end
