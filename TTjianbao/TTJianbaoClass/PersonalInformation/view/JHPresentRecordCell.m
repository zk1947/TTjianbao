//
//  JHPresentRecordCell.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/3.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "NIMAvatarImageView.h"
#import "JHPresentRecordCell.h"
#import "TTjianbaoMarcoUI.h"

@interface JHPresentRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet NIMAvatarImageView *avatar;

@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end


@implementation JHPresentRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)setModel:(JHPresentRecordModel *)model {
    _model = model;
    if (self.type == 1) {
        [self.avatar nim_setImageWithURL:[NSURL URLWithString:model.receiverAvatar] placeholderImage:kDefaultAvatarImage];
        self.nickLabel.text = model.receiverNick;
        self.coinLabel.text = [NSString stringWithFormat:@"%@ x %ld",model.name, (long)model.amount];
        self.dateLabel.text = model.senderTime;

    } else if (self.type == 2) {
        [self.avatar nim_setImageWithURL:[NSURL URLWithString:model.senderAvatar] placeholderImage:kDefaultAvatarImage];
        self.nickLabel.text = model.senderNick;
        self.coinLabel.text = [NSString stringWithFormat:@"%@ x %ld",model.name, (long)model.amount];
        self.dateLabel.text = model.receiveTime;
        self.rightImage.hidden = YES;

    }
}
@end
