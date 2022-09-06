//
//  JHDetailSvgaLoadingView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/9/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHDetailSvgaLoadingView.h"
#import <SVGAPlayer.h>
#import <SVGAParser.h>

@interface JHDetailSvgaLoadingView ()<SVGAPlayerDelegate>

@property (nonatomic, strong) SVGAPlayer *player;

@property (nonatomic, copy) NSString *placeholderImage;


@end


@implementation JHDetailSvgaLoadingView
-(void)dealloc
{
    NSLog(@"🔥");
}
-(instancetype)initWithFrame:(CGRect)frame placeholderImage:(NSString *)placeholderImage
{
    self = [super initWithFrame:frame];
    if (self) {
        _placeholderImage = placeholderImage;
        [self addSelfUI];
    }
    return self;
}



- (void)addSelfUI 
{
    _player = [[SVGAPlayer alloc] initWithFrame:self.bounds];
    [self addSubview:_player];
    _player.backgroundColor = [UIColor clearColor];
    _player.loops = 0;
    SVGAParser *parser = [[SVGAParser alloc] init];
    [parser parseWithNamed:_placeholderImage inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
        if (videoItem != nil) {
            self.player.videoItem = videoItem;
            [self.player startAnimation];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        NSLog(@"123");
    }];
}

-(void)showLoading
{
    [self.player startAnimation];
}

- (void)dismissLoading
{
    [self.player clear];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
