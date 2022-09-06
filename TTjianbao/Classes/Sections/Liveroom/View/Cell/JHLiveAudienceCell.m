//
//  JHLiveAudienceCell.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/7.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHLiveAudienceCell.h"
#import "NIMAvatarImageView.h"
#import "TTjianbaoMarcoUI.h"

@interface JHLiveAudienceCell ()
@property (weak, nonatomic) IBOutlet NIMAvatarImageView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *playImage;

@end


@implementation JHLiveAudienceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setMember:(NIMChatroomMember *)member {
    [_avatarView nim_setImageWithURL:[NSURL URLWithString:member.roomAvatar] placeholderImage:kDefaultAvatarImage];

}

@end

