//
//  JHBackPlayTableViewCell.m
//  TTjianbao
//
//  Created by mac on 2019/10/31.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHBackPlayTableViewCell.h"
#import "CommHelp.h"

@implementation JHBackPlayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(JHBackPlayModel *)model {
    _model = model;
    self.beginTime.text = model.recordStartTime;
    self.endTime.text = model.recordEndTime;
    self.allTime.text = [CommHelp getHMSWithSecond:model.duration];
}
@end
