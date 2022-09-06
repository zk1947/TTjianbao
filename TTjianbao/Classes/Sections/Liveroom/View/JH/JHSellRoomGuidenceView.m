//
//  JHSellRoomGuidenceView.m
//  TTjianbao
//
//  Created by mac on 2019/7/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHSellRoomGuidenceView.h"
#import "JHStoneLiveWindowGuideView.h"
@interface JHSellRoomGuidenceView ()
@property (weak, nonatomic) IBOutlet UIView *firstGuide;
@property (weak, nonatomic) IBOutlet UIView *secondGuide;
@property (weak, nonatomic) IBOutlet UIView *lastGuide;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhinanToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeBtnToBottom;

@end


@implementation JHSellRoomGuidenceView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction1)];
    [self.firstGuide addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction2)];
    [self.secondGuide addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction3)];
    [self.lastGuide addGestureRecognizer:tap3];
    self.zhinanToTop.constant = UI.bottomSafeAreaHeight+10+40+10+15+20;
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
    if (self.type == 1) {
        //原石直播间小窗引导
        if (self.completBlock) {
            self.completBlock(nil);
        }
        
    } else if (self.type == 2) {
        //回血直播间引导
//        if ([CommHelp isFirstForName:@"isFirstShowResaleGuide"]){
//            [JHStoneLiveWindowGuideView showGuideViewWithIndex:1];
//        }
    }
}

@end
