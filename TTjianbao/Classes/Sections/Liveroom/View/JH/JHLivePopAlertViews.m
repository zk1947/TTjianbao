//
//  JHLivePopAlertViews.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/10.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHLivePopAlertViews.h"
#import "NTESLiveManager.h"

@interface JHLivePopAlertViews ()
@property (weak, nonatomic) IBOutlet UIButton *sdBtn;

@property (weak, nonatomic) IBOutlet UIButton *hdBtn;


@end


@implementation JHLivePopAlertViews

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

+ (JHLivePopAlertViews *)moreListAlert {
   
    return  (JHLivePopAlertViews *)[[NSBundle mainBundle] loadNibNamed:@"JHLivePopAlertViews" owner:nil options:nil].firstObject;
}

+ (JHLivePopAlertViews *)hdAlert {
    
    return  (JHLivePopAlertViews *)[[NSBundle mainBundle] loadNibNamed:@"JHLivePopAlertViews" owner:nil options:nil].lastObject;
    
}

- (void)showAlert {
    CGRect rect = self.frame;
    if (rect.size.width<ScreenW) {
        rect.origin.y = ScreenH - rect.size.height - 49;

    }else {
        rect.origin.y = ScreenH - rect.size.height;
        [self setSelectedBtn];

    }
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
}

- (void)hiddenAlert{
    CGRect rect = self.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];

}

- (IBAction)switchCameraAction:(id)sender {
    [self hiddenAlert];
    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [_delegate onActionType:NTESLiveActionTypeCamera sender:sender];
    }
}

- (IBAction)autoFocusAction:(id)sender {
    [self hiddenAlert];

    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [_delegate onActionType:NTESLiveActionTypeFocus sender:sender];
    }

}

- (IBAction)changePXAction:(id)sender {
    
    [self hiddenAlert];
    if (_delegate && [_delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [_delegate onActionType:NTESLiveActionTypeQuality sender:sender];
    }
    
}

- (IBAction)sdAction:(id)sender {
    [self hiddenAlert];
    if (_qualityDelegate && [_qualityDelegate respondsToSelector:@selector(onVideoQualitySelected:)]) {
        [_qualityDelegate onVideoQualitySelected:NTESLiveQualityNormal];
    }
}

- (IBAction)hdAction:(id)sender {
    [self hiddenAlert];
    
    if (_qualityDelegate && [_qualityDelegate respondsToSelector:@selector(onVideoQualitySelected:)]) {
        [_qualityDelegate onVideoQualitySelected:NTESLiveQualityHigh];
    }

}

- (void)setSelectedBtn {

     NTESLiveQuality type = [NTESLiveManager sharedInstance].liveQuality;
    if (type == NTESLiveQualityHigh) {
        _hdBtn.selected = YES;
        _sdBtn.selected = NO;
    }else {
        _hdBtn.selected = NO;
        _sdBtn.selected = YES;

    }

}
@end
