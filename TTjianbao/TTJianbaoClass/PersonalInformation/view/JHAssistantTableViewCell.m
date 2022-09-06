//
//  JHAssistantTableViewCell.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/28.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHAssistantTableViewCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"

@implementation JHAssistantTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(JHAssistantModel *)model {
    _model = model;
    [_iconImage jhSetImageWithURL:[NSURL URLWithString:model.icon] placeholder:kDefaultAvatarImage];
    _nickLabel.text = model.name;
    _phoneLabel.text = model.phone;
}


@end
