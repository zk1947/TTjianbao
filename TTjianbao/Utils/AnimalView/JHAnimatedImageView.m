//
//  JHAnimatedImageView.m
//  TTjianbao
//
//  Created by wangjianios on 2021/1/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAnimatedImageView.h"
#import <SVGAParser.h>
#import <SVGAPlayer.h>

@interface JHAnimatedImageView ()

///svga 播放器
@property (nonatomic, strong) SVGAPlayer *player;

@end

@implementation JHAnimatedImageView

- (void)jh_setImageWithUrl:(NSString *)imageUrl {
    [self jh_setImageWithUrl:imageUrl placeholder:@"cover_default_image"];
}
- (void)jh_setImageWithUrl:(NSString *)imageUrl placeholder:(NSString *)placeholder {
    
    if(imageUrl && ([imageUrl containsString:@".svga"] || [imageUrl containsString:@".SVGA"]))
    {
        SVGAParser *parser = [[SVGAParser alloc] init];
        [parser parseWithURL:[NSURL URLWithString:imageUrl] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            if (videoItem != nil) {
                self.player.videoItem = videoItem;
                [self start];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            NSLog(@"123");
        }];
        self.image = nil;
        _player.hidden = NO;
    }
    else {
        if(_player) {
            [_player clear];
            [_player removeFromSuperview];
            _player = nil;
        }
        
        [self setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:placeholder ? JHImageNamed(placeholder) : nil];
    }
    
    [self stop];
}

- (SVGAParser *)player {
    if(!_player) {
        _player = [[SVGAPlayer alloc] initWithFrame:self.bounds];
        [self addSubview:_player];
        _player.backgroundColor = [UIColor clearColor];
        _player.loops = 0;
    }
    return _player;
}

- (void)start {
    if(_player) {
        [_player startAnimation];
    }
}

- (void)stop {
    if(_player) {
        [_player stopAnimation];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
