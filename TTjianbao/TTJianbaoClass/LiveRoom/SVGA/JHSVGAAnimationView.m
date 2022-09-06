//
//  JHSVGAAnimationView.m
//  Demo
//
//  Created by apple on 2020/2/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "JHSVGAAnimationView.h"
#import <SVGAPlayer.h>
#import <SVGAParser.h>

@interface JHSVGAAnimationView ()<SVGAPlayerDelegate>

@property (nonatomic, strong) SVGAPlayer *player;

@end
@implementation JHSVGAAnimationView
-(void)dealloc
{
    NSLog(@"🔥");
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self addSelfUI];
    }
    return self;
}

-(void)addSelfUI
{
    _player = [[SVGAPlayer alloc] initWithFrame:self.bounds];
    [self addSubview:_player]; // Add subview by yourself.
    _player.backgroundColor = [UIColor clearColor];
    _player.loops = 1;
    _player.delegate = self;
    SVGAParser *parser = [[SVGAParser alloc] init];
    
    [parser parseWithNamed:@"animation_svga" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
        if (videoItem != nil) {
            self.player.videoItem = videoItem;
            [self.player startAnimation];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark --------------- svga 动画结束回调 ---------------
-(void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player
{
    [self removeFromSuperview];
}

+(void)showToView:(UIView *)sender
{
    JHSVGAAnimationView *playView = [[JHSVGAAnimationView alloc] initWithFrame:sender.bounds];
    [sender addSubview:playView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
