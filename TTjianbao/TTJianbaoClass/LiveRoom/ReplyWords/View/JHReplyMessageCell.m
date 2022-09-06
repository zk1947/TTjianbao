//
//  JHReplyMessageCell.m
//  TTjianbao
//
//  Created by apple on 2020/2/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHReplyMessageCell.h"

@implementation JHReplyMessageCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSelfSubViews];
    }
    return self;
}
-(void)addSelfSubViews
{
    
    UIView * lineV = [[UIView alloc] init];
    lineV.backgroundColor = HEXCOLOR(0x5A5A5A);
    [self.contentView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.height.mas_equalTo(0.5);
    }];
    
    
    _contentLabel = [UILabel  jh_labelWithText:@"666" font:14 textColor:UIColor.whiteColor textAlignment:0 addToSuperView:self.contentView];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24.f);
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    _contentLabel.backgroundColor = UIColor.clearColor;
}


@end
