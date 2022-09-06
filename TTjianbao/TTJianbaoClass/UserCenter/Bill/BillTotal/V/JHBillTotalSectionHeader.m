//
//  JHBillTotalSectionHeader.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBillTotalSectionHeader.h"

@implementation JHBillTotalSectionHeader

-(void)addSelfSubViews
{
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    _iconView = [UIImageView jh_imageViewWithImage:@"" addToSuperview:self.contentView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.f);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(15.0, 15.0));
    }];
    
    _titleLabel = [UILabel jh_labelWithBoldText:@"收入统计" font:15 textColor:RGB(51, 51, 51) textAlignment:0 addToSuperView:self.contentView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(5);
        make.centerY.equalTo(self.contentView);
    }];
}
+(CGFloat)viewHeight
{
    return 40.f;
}
+(NSString *)reuseIdentifier
{
    
    return NSStringFromClass([JHBillTotalSectionHeader class]);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
