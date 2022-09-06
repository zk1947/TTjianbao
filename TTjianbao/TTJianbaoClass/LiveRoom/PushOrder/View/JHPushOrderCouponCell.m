//
//  JHPushOrderCouponCell.m
//  TTjianbao
//
//  Created by apple on 2020/1/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPushOrderCouponCell.h"

@implementation JHPushOrderCouponCell

-(void)addSelfSubViews
{
    UIView *backgroundView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.contentView];
    [backgroundView jh_cornerRadius:2 borderColor:RGB(252, 66, 0) borderWidth:1.0];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.mas_equalTo(13);
    }];
    
    _contentLabel = [UILabel  jh_labelWithText:@"红包约减￥100" font:9 textColor:RGB(252, 66, 0) textAlignment:1 addToSuperView:self.contentView];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backgroundView).with.insets(UIEdgeInsetsMake(0, 5, 0, 5));
        make.width.mas_lessThanOrEqualTo(200);
    }];
}

@end
