//
//  JHStoneDetailSectionHeader.m
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneDetailSectionHeader.h"

@interface JHStoneDetailSectionHeader ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JHStoneDetailSectionHeader

-(void)addSelfSubViews
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _titleLabel = [UILabel jh_labelWithBoldText:@"收入统计" font:15 textColor:RGB(51, 51, 51) textAlignment:0 addToSuperView:self];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    self.contentView.backgroundColor = UIColor.whiteColor;
}

-(void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    _titleLabel.text = _titleStr;
    if (titleStr.length>0) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
        }];
    }
    else{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(CGFLOAT_MIN);
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
