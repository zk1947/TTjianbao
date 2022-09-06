//
//  JHMuteListCell.m
//  TTjianbao
//
//  Created by mac on 2019/8/26.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHMuteListCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"

@implementation JHMuteListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)setNotMute:(UIButton *)sender {
    if (self.openMuteBlock) {
        self.openMuteBlock(self.indexPath);
    }
}

- (void)setModel:(JHMuteListModel *)model {
    _model = model;
    [self.avatar jhSetImageWithURL:[NSURL URLWithString:model.viewerIcon] placeholder:kDefaultAvatarImage];
    self.nameLabel.text = model.viewerName;
    NSString *string = [NSString stringWithFormat:@"禁言时间:%@ 禁言时长:%@ 剩余时长:%@", model.muteStartTime, model.muteTime, model.hasTime];
    self.desLabel.text = string;
}

- (IBAction)privateMsgAction:(UIButton *)sender {
    if (sender.selected) {
        
    }else {
        
    }
}

@end
