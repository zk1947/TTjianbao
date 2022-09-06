//
//  JHMessagesTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2020/2/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessagesTableViewCell.h"

@implementation JHMessagesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = HEXCOLOR(0xF5F6FA);
        self.accessoryType = UITableViewCellAccessoryNone;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        self.backgroundsView = [[UIView alloc] init];
        self.backgroundsView.backgroundColor = [UIColor whiteColor];
        self.backgroundsView.layer.cornerRadius = 8;
        self.backgroundsView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.backgroundsView];
        [self.backgroundsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.width.equalTo(self.contentView).offset(-15*2);
            make.top.equalTo(self.contentView);
            make.height.equalTo(self.contentView).offset(-10);
        }];
    }
    
    return self;
}

- (void)changeCellStyle:(BOOL)isYES
{
    if (isYES)
    {
        self.backgroundsView.layer.cornerRadius = 0;
        [self.backgroundsView mas_updateConstraints:^(MASConstraintMaker *make)
        {
            make.left.equalTo(self.contentView).offset(0);
            make.width.equalTo(self.contentView).offset(0);
            make.top.equalTo(self.contentView);
            make.height.equalTo(self.contentView).offset(-10);
        }];
    }
}

- (void)updateData:(id)model
{
    ///子类重写
}

@end
