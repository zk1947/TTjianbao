//
//  JHCornerTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHCornerTableViewCell.h"

@implementation JHCornerTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HEXCOLOR(0xf8f8f8);
        self.background = [[UIView alloc] init];
        [self.contentView addSubview:self.background];
        [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, kCellMargin, kCellMargin, kCellMargin));
        }];
        self.background.backgroundColor = [UIColor whiteColor];
        self.background.layer.cornerRadius = 4;
        self.background.layer.masksToBounds = YES;
    }
    
    return self;
}

@end
