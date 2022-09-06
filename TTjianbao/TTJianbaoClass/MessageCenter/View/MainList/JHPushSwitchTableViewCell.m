//
//  JHPushSwitchTableViewCell.m
//  TTjianbao
//
//  Created by mac on 2019/5/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHPushSwitchTableViewCell.h"
#import "CommHelp.h"
#import "JHGrowingIO.h"

@implementation JHPushSwitchTableViewCell
{
    PushSwitchType pushSwitchType;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showTextWithType:(PushSwitchType)type
{
    pushSwitchType = type;
    if(type == PushSwitchTypeShowOpen)
    {
        self.openSwitchBtn.backgroundColor = HEXCOLOR(0xf7f7f7);
        [self.openSwitchBtn setTitle:@"已开启" forState:UIControlStateNormal];
    }
    else //if(type == PushSwitchTypeShowClose)
    {
        [self.openSwitchBtn setTitle:@"开启" forState:UIControlStateNormal];
        self.openSwitchBtn.backgroundColor = HEXCOLOR(0xFEE100);
    }
}

- (IBAction)openpush:(id)sender {
    if(pushSwitchType == PushSwitchTypeShowClose)
    {
        [CommHelp goToAppSystemSetting];
        [JHGrowingIO trackPublicEventId:JHTrackMsgCenterTopPushClick];
    }
}

@end
