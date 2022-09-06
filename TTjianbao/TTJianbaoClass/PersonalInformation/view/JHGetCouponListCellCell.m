//
//  JHGetCouponListCellCell.m
//  TTjianbao
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHGetCouponListCellCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"

@implementation JHGetCouponListCellCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatar.layer.cornerRadius = 22.5;
    self.avatar.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setModel:(GetCouponUserModel *)model {
    [self.avatar jhSetImageWithURL:[NSURL URLWithString:model.img] placeholder:kDefaultAvatarImage];
    self.nameLabel.text = model.customerName;
    self.useTimeLabel.text = @"";
    NSString *userTime = model.useTime?[NSString stringWithFormat:@"\n使用时间：%@", model.useTime]:@"";
    self.getTimeLabel.text = [[NSString stringWithFormat:@"领取时间：%@", model.getTime] stringByAppendingString:OBJ_TO_STRING(userTime)];
    if ([model.state isEqualToString:@"en"]) {//未使用
        self.rightArrow.hidden = YES;

    }else if ([model.state isEqualToString:@"ed"]){//已使用
        self.rightArrow.hidden = NO;

    }
}

@end
