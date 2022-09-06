//
//  JHSelectorCell.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/9.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHSelectorCell.h"

@implementation JHSelectorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLab.textColor = HEXCOLOR(0x666666);
    self.titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
