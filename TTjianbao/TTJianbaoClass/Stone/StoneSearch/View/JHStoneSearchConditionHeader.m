//
//  JHStoneSearchConditionHeader.m
//  TTjianbao
//
//  Created by apple on 2020/2/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoneSearchConditionHeader.h"

@implementation JHStoneSearchConditionHeader

-(void)addSelfSubViews
{
    _titleLabel = [UILabel jh_labelWithBoldText:@"收入统计" font:12 textColor:RGB(51, 51, 51) textAlignment:0 addToSuperView:self];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self).offset(10);
    }];
}

+(CGSize)viewSize
{
    return CGSizeMake(275, 50);
}

@end
