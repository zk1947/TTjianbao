//
//  JHAllowanceDetailDescCell.m
//  TTjianbao
//
//  Created by apple on 2020/2/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAllowanceDetailDescCell.h"

@implementation JHAllowanceDetailDescCell

-(void)addSelfSubViews
{
    _titleLabel = [UILabel jh_labelWithText:@"订单时间" font:13 textColor:RGB(153, 153, 153) textAlignment:0 addToSuperView:self.contentView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
    }];
    
    _descLabel = [UILabel jh_labelWithText:@"2020-02-02 02:02:02" font:13 textColor:RGB(51, 51, 51) textAlignment:2 addToSuperView:self.contentView];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

+(CGFloat)cellHeight
{
    return 35.f;
}
@end
