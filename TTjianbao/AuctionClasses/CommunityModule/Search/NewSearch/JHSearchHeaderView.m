//
//  JHSearchHeaderView.m
//  TTjianbao
//
//  Created by liuhai on 2021/10/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSearchHeaderView.h"

@implementation JHSearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame withTitleName:(NSString*)str{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createHeaderTitle:str];
        
    }
    return self;
}
- (void)createHeaderTitle:(NSString*)str{
    
    
    
    UILabel * label = [[UILabel alloc]init];
    label.text = str;
    [self addSubview:label];
    label.font = JHBoldFont(16);
    label.textColor = HEXCOLOR(0x333333);
//    if ([str isEqualToString:@"历史记录"]) {
//        label.font = kFontCustom(FontStyleMedium, 14);
//        label.textColor = kLightDefaultWordColor;
//    }
    
    label.frame = CGRectMake(20, 15, 200, 17);
    
//    UILabel * lineLabel = [[UILabel alloc]init];
//    [self addSubview:lineLabel];
//    lineLabel.backgroundColor = kUIColorFromHex(0xcacaca);
    
}

@end
