//
//  NTESAnchorMicView.m
//  TTjianbao
//
//  Created by chris on 16/7/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESAnchorMicView.h"
#import "UIView+NTES.h"

@interface NTESAnchorMicView()

@property (nonatomic,strong) UIImageView *micView;

@end

@implementation NTESAnchorMicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImage imageNamed:@"icon_anchor_mic_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        
        UIImage *image1 = [UIImage imageNamed:@"icon_mic_anchor_1"];
        UIImage *image2 = [UIImage imageNamed:@"icon_mic_anchor_2"];
        UIImage *image3 = [UIImage imageNamed:@"icon_mic_anchor_3"];
        _micView = [[UIImageView alloc] initWithImage:image1];
        [_micView sizeToFit];
        _micView.animationImages   = @[image1,image2,image3];
        _micView.animationDuration = 1.2f;
        [self addSubview:_micView];
    }
    return self;
}

- (void)startAnimating
{
    [self.micView startAnimating];
}

- (void)stopAnimating
{
    [self.micView stopAnimating];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat top = 162.f;
    self.micView.top = top;
    self.micView.centerX = self.width * .5f;
}

@end
