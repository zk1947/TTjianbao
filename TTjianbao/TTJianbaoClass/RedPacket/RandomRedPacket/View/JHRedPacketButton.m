//
//  JHRedPacketButton.m
//  TTjianbao
//
//  Created by apple on 2020/1/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRedPacketButton.h"
#import "AnimotionObject.h"
#import "JHLine.h"
@interface JHRedPacketButton ()

@property (nonatomic, weak) UILabel *numLabel;

@property (nonatomic, weak) UIImageView *button;

@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, weak) UIImageView *timeLabelBg;

@end

@implementation JHRedPacketButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *button = [UIImageView jh_imageViewWithImage:@"red_packet_button" addToSuperview:self];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(5.5, 0, 0, 5.5));
        }];

        _numLabel = [UILabel jh_labelWithText:@"2" font:9 textColor:RGB(51, 51, 51) textAlignment:1 addToSuperView:self];
        _numLabel.backgroundColor = RGB(254, 225, 0);
        [_numLabel jh_cornerRadius:6.5];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.mas_right);
            make.centerY.equalTo(button.mas_top);
            make.height.width.mas_equalTo(13.f);
        }];

        _timeLabelBg = [UIImageView jh_imageViewWithImage:@"live_room_ladder_countdown_bg" addToSuperview:self];
        [_timeLabelBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(4);
            make.centerX.equalTo(self).offset(-2);
            make.size.mas_equalTo(CGSizeMake(45, 17));
        }];
        
        _timeLabel = [UILabel jh_labelWithFont:12 textColor:RGB(254, 0, 58) addToSuperView:_timeLabelBg];
        _timeLabel.textAlignment = 1;
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.timeLabelBg);
        }];
        self.hidden = YES;
    }
    return self;
}

- (void)setRedPacketNum:(NSInteger)redPacketNum
{
    _redPacketNum = redPacketNum;
    _numLabel.hidden = (redPacketNum <= 1);
    if (redPacketNum > 1) {
        _numLabel.text = @(redPacketNum).stringValue;
    }
    self.hidden = (_redPacketNum <= 0);
}

- (void)setTimeNum:(long)timeNum
{
    _timeLabelBg.hidden = (timeNum < 0);
    
    if(timeNum == 0)
    {
        _timeLabel.text = @"领取";
    }
    else if(timeNum > 0)
    {
        _timeLabel.text = [NSString stringWithFormat:@"%@s",@(timeNum)];
    }
}

- (void)starAnimation
{
    CGFloat value = M_PI/8.f;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(-value), @(value) , @(-value)];
    anim.duration = 0.3;
    anim.repeatCount = MAXFLOAT;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:anim forKey:nil];
}

-(void)stopRemoveAllAnimation
{
    [self.layer removeAllAnimations];
}

+ (CGSize)viewSize{
    return CGSizeMake(39.f + 5.5, 47.f + 5.5);
}

@end
