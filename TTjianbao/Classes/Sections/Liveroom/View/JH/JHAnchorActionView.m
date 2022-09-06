//
//  JHAnchorActionView.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/24.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHAnchorActionView.h"
#import "NTESLiveManager.h"
#import "JHLiveRoomListViewCellModel.h"

typedef NS_ENUM(NSInteger, JHAnchorActionType)
{
    JHAnchorActionTypeDefault,
    JHAnchorActionTypeSendRedpacket = JHAnchorActionTypeDefault,    //发送红包
    JHAnchorActionTypeSetMute,    //禁言
    JHAnchorActionTypeGuess,
    JHAnchorActionTypeNomute,
    JHAnchorActionTypeCamera,
    JHAnchorActionTypeLight
};

CGFloat const ButtonHeight = 70;
NSInteger const ButtonCount = 6;  //5+1发送红包

@implementation JHAnchorActionView
- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateQuality) name:@"SwitchVideoQualityLevel" object:nil];
        NSArray *arrayImage = @[ @"icon_appraiser_send_redpacket", @"icon_live_setMute",@"icon_live_guess",@"icon_live_nomute",@"icon_circle_camera", @"icon_circle_light"];
        NSArray *pressarrayImage = @[@"icon_appraiser_send_redpacket", @"icon_live_setMute",@"icon_live_noguess",@"icon_live_mute",@"icon_circle_camera", @"icon_circle_light"];
        for (int i = 0; i<arrayImage.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:arrayImage[i]] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, (ButtonHeight) * i, ButtonHeight, ButtonHeight);
            btn.tag = JHAnchorActionTypeDefault + i;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [btn setImage:[UIImage imageNamed:pressarrayImage[i]] forState:UIControlStateSelected];
            if(i == JHAnchorActionTypeSendRedpacket)
            {
                btn.hidden = YES;
                _sendRedpacketBtn = btn;
            }
            else if (i == JHAnchorActionTypeSetMute) {
                _muteListBtn = btn;
                btn.hidden = YES;
            }
            else if (i == JHAnchorActionTypeGuess) {
                _guessBtn = btn;
                _guessBtn.hidden=YES;
            }
            else  if (i == JHAnchorActionTypeNomute) {
                _muteBtn = btn;
            }else if (i == JHAnchorActionTypeCamera){
                _camaraBtn = btn;
            }else  if (i == JHAnchorActionTypeLight){
                _lightBtn = btn;
            }
        }
    }
    return self;
}

- (void)btnAction:(UIButton *)btn {
    switch (btn.tag) {
        case JHAnchorActionTypeCamera:
            [self switchCameraAction:btn];
            break;
        case JHAnchorActionTypeLight:
            [self autoLightAction:btn];
            break;
//        case 3:
//            [self changePXAction:btn];
//            break;
        case JHAnchorActionTypeNomute:
            [self muteAction:btn];
            break;
        case JHAnchorActionTypeGuess:
            [self guessAction:btn];
            break;
            
        case JHAnchorActionTypeSetMute:
            [self muteListAction:btn];
            break;

        case JHAnchorActionTypeSendRedpacket:
             [self sendRedPacketAction:btn];
             break;
            
        default:
            break;
    }
}

- (void)muteListAction:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [_delegate onActionType:NTESLiveActionTypeMuteList sender:btn];
    }
}

- (void)muteAction:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [_delegate onActionType:NTESLiveActionTypeMute sender:sender];
    }
    
}

- (void)switchCameraAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [_delegate onActionType:NTESLiveActionTypeCamera sender:sender];
    }
}

- (void)sendRedPacketAction:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [_delegate onActionType:NTESLiveActionTypeSendRedPacket sender:sender];
    }
    
}

- (void)guessAction:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [_delegate onActionType:NTESLiveActionTypeGuess sender:sender];
    }
    
}
- (void)autoFocusAction:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [_delegate onActionType:NTESLiveActionTypeFocus sender:sender];
    }
    
}
- (void)autoLightAction:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        sender.selected = !sender.selected;
        [_delegate onActionType:NTESLiveActionTypeFlash sender:nil];
    }
    
}


- (void)changePXAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [_delegate onActionType:NTESLiveActionTypeQuality sender:sender];
    }
    
}

- (void)updateQuality {
    NTESLiveQuality type = [NTESLiveManager sharedInstance].liveQuality;
    if (type == NTESLiveQualityHigh) {
        self.pxBtn.selected = YES;
    }else {
        self.pxBtn.selected = NO;
    }

}

- (void)setHidden:(BOOL)hidden {
    super.hidden = hidden;
    if (!hidden) {
        _muteBtn.selected = NO;
    }
}

@end

@implementation JHSaleAnchorActionView
- (void)dealloc {
}
- (void)resetActionView:(NSInteger)showtype  andShowSendLivingTip:(BOOL)canshow{
    self.btnArray = [NSMutableArray arrayWithCapacity:4];
    if (canshow) {
        [self.btnArray addObject:@{@"title":@"开播提醒",@"icon":@"icon_circle_starPlayTip"}];
    }
    NSArray *arr1;
    if(showtype == 2) {
        arr1 = @[
            @{@"title":@"公告",@"icon":@"icon_live_announcement"},
            @{@"title":@"禁言",@"icon":@"icon_live_setMute"}
        ];
    } else {
        arr1 = @[
            @{@"title":@"公告",@"icon":@"icon_live_announcement"},
            @{@"title":@"禁言",@"icon":@"icon_live_setMute"},
            @{@"title":@"心愿单",@"icon":@"icon_live_wish"},
            @{@"title":@"静音",@"icon":@"icon_live_nomute"},
            @{@"title":@"切换",@"icon":@"icon_circle_camera"}
        ];
    }
    [self.btnArray addObjectsFromArray:arr1];
    for (int i = 0; i<self.btnArray.count; i++) {
        NSDictionary *dict = self.btnArray[i];
        JHLiveRoomListViewCellModel *model = [JHLiveRoomListViewCellModel modelWithDictionary:dict];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, (ButtonHeight) * i, ButtonHeight, ButtonHeight);
        btn.tag = i;
        if ([model.title isEqualToString:@"静音"]) {
            [btn setImage:[UIImage imageNamed:@"icon_live_mute"] forState:UIControlStateSelected];

        }
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

    }
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //开播提醒图片@"icon_circle_starPlayTip",
    }
    return self;
}

- (void)btnAction:(UIButton *)btn {
    NSDictionary *dict = self.btnArray[btn.tag];
    JHLiveRoomListViewCellModel *model = [JHLiveRoomListViewCellModel modelWithDictionary:dict];
    if ([model.title isEqualToString:@"开播提醒"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
            [_delegate onActionType:NTESLiveActionTypeSendStarPlayTips sender:btn];
        }
    } else if([model.title isEqualToString:@"公告"]) {
        [self showAnnouncementAction:btn];
    }else if([model.title isEqualToString:@"禁言"]) {
        [self muteListAction:btn];
    }
    else if([model.title isEqualToString:@"静音"]) {
        [self muteAction:btn];
    }
    else if([model.title isEqualToString:@"心愿单"]) {
        [self wishPaperAction:btn];
    }
    else if([model.title isEqualToString:@"切换"]) {
        [self switchCameraAction:btn];
    }
    
}

- (void)switchCameraAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [_delegate onActionType:NTESLiveActionTypeCamera sender:sender];
    }
}

- (void)muteAction:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [_delegate onActionType:NTESLiveActionTypeMute sender:sender];
    }
    
}

- (void)wishPaperAction:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [_delegate onActionType:NTESLiveActionTypeWishPaper sender:sender];
    }
    
}

- (void)muteListAction:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [_delegate onActionType:NTESLiveActionTypeMuteList sender:btn];
    }
}

- (void)showAnnouncementAction:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [_delegate onActionType:NTESLiveActionTypeAnnouncement sender:btn];
    }
}

@end
