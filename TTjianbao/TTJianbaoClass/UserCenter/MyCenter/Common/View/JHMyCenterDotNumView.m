//
//  JHMyCenterDotNumView.m
//  TTjianbao
//
//  Created by apple on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMyCenterDotNumView.h"

@implementation JHMyCenterDotNumView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self jh_cornerRadius:[self oneSize].height/2.f borderColor:UIColor.whiteColor borderWidth:1];
        self.font = [UIFont systemFontOfSize:11];
        self.textColor = UIColor.whiteColor;
        self.textAlignment = 1;
        self.backgroundColor = RGB(252, 66, 0);
    }
    return self;
}

-(void)setNumber:(NSInteger)number{
    
    self.hidden = (number <= 0);
    self.text = OBJ_TO_STRING(@(number));
    
    if (number < 10) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo([self oneSize]);
        }];
    }
    else if (number < 100) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo([self twoSize]);
        }];
    }
    else{
        self.text = @"99+";
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo([self moreSize]);
        }];
    }
}

- (CGSize)oneSize{
    return CGSizeMake(16, 16);
}

- (CGSize)twoSize{
    return CGSizeMake(21, 16);
}

- (CGSize)moreSize{
    return CGSizeMake(28, 16);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
