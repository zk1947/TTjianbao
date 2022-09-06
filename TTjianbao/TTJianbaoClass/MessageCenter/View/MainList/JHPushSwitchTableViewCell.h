//
//  JHPushSwitchTableViewCell.h
//  TTjianbao
//  Description:通知开关
//  Created by mac on 2019/5/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPushSwitchCellHeight (55+10) //xib

typedef NS_ENUM(NSUInteger, PushSwitchType)
{
    PushSwitchTypeHidden, //不显示
    PushSwitchTypeShowClose, //"开启"
    PushSwitchTypeShowOpen, //"已开启"
};

NS_ASSUME_NONNULL_BEGIN

@interface JHPushSwitchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton* openSwitchBtn;

- (void)showTextWithType:(PushSwitchType)type;
@end

NS_ASSUME_NONNULL_END
