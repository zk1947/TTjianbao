
//
//  JHLiveRoomGuidanceView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/3/1.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHLiveRoomGuidanceView.h"
@interface JHLiveRoomGuidanceView ()

@property (weak, nonatomic) IBOutlet UIView *firstGuide;
@property (weak, nonatomic) IBOutlet UIView *secondGuide;
@property (weak, nonatomic) IBOutlet UIView *lastGuide;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appraiseBtnToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeBtnToBottom;

@end


@implementation JHLiveRoomGuidanceView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction1)];
    [self.firstGuide addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction2)];
    [self.secondGuide addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction3)];
    [self.lastGuide addGestureRecognizer:tap3];
    self.appraiseBtnToBottom.constant = UI.bottomSafeAreaHeight + 6;
    self.likeBtnToBottom.constant = UI.bottomSafeAreaHeight + 6;

}


- (void)tapAction1 {
    self.firstGuide.hidden = YES;
    self.secondGuide.hidden = NO;
    self.lastGuide.hidden = YES;
}

- (void)tapAction2 {
    self.firstGuide.hidden = YES;
    self.secondGuide.hidden = YES;
    self.lastGuide.hidden = NO;
}

- (void)tapAction3 {
    [self removeFromSuperview];
}

@end
