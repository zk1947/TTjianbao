//
//  JHDoteNumberLabel.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/24.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHDoteNumberLabel.h"
#import "MJRefresh.h"

@implementation JHDoteNumberLabel
- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = self.mj_h/2.;
    self.layer.masksToBounds = YES;
    self.font = [UIFont systemFontOfSize:12];
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = HEXCOLOR(0xfc4414);
    self.textAlignment = NSTextAlignmentCenter;
    self.layer.shouldRasterize = YES;
    self.adjustsFontSizeToFitWidth = YES;

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.mj_h/2.;
        self.layer.masksToBounds = YES;
        self.font = [UIFont systemFontOfSize:12];
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = HEXCOLOR(0xfc4414);
        self.textAlignment  = NSTextAlignmentCenter;
        self.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.layer.cornerRadius = self.mj_h/2.;
        self.layer.masksToBounds = YES;
        self.font = [UIFont systemFontOfSize:12];
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = HEXCOLOR(0xfc4414);
        self.textAlignment  = NSTextAlignmentCenter;
        self.adjustsFontSizeToFitWidth = YES;

        
    }
    return self;
}

- (void)setText:(NSString *)text {
    super.text = text;
    if ([text integerValue] == 0) {
        self.hidden = YES;
        super.text = @"";
    }else {
        if ([text integerValue]>999)
        super.text = @"999";
        self.hidden = NO;
    }
    
    self.layer.cornerRadius = self.mj_h/2.;

}
@end
