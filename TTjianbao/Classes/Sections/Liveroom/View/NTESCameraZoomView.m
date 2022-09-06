//
//  NTESCameraZoomView.m
//  TTjianbao
//
//  Created by Simon Blue on 2017/5/19.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESCameraZoomView.h"
#import <NIMAVChat/NIMAVChat.h>
#import "UIView+NTES.h"
@interface NTESCameraZoomView ()<NIMNetCallManagerDelegate>

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) UIButton *minusButton;

@property (nonatomic, strong) UIButton *plusButton;


@end

@implementation NTESCameraZoomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.slider];
        [self addSubview:self.minusButton];
        [self addSubview:self.plusButton];
    }
    return self;
}

- (void)layoutSubviews
{
    _slider.top = 0;
    _slider.height = self.height;
    _slider.centerX = self.width * .5f;
    _slider.width = self.width - _minusButton.width - _plusButton.width - 2 * 15.f;
    
    _minusButton.left = 0;
    _minusButton.centerY = _slider.centerY;
    
    _plusButton.right = self.width;
    _plusButton.centerY = _slider.centerY;
}

- (UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc]init];
        [_slider setMinimumValue:1.f];
        [_slider setMaximumValue:6.f];
        [_slider addTarget:self action:@selector(onSliderValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    
    return _slider;
}

- (UIButton *)minusButton
{
    if (!_minusButton) {
        _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusButton setImage:[UIImage imageNamed:@"icon_zoom_minus"] forState:UIControlStateNormal];
        [_minusButton addTarget:self action:@selector(onMinusButtonPresseed)  forControlEvents:UIControlEventTouchUpInside];

        [_minusButton sizeToFit];
    }
    return _minusButton;
}

- (UIButton *)plusButton
{
    if (!_plusButton) {
        _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusButton setImage:[UIImage imageNamed:@"icon_zoom_plus"] forState:UIControlStateNormal];
        [_plusButton addTarget:self action:@selector(onPlusButtonPresseed)  forControlEvents:UIControlEventTouchUpInside];

        [_plusButton sizeToFit];
    }
    return _plusButton;
}

- (void)reset
{
    self.slider.value = 1.f;
}

- (void)onSliderValueChanged
{
    [[NIMAVChatSDK sharedSDK].netCallManager changeLensPosition: _slider.value];
}

- (void)onMinusButtonPresseed
{
    CGFloat zoomNum =  _slider.value - _slider.maximumValue / 6;
    if (zoomNum < _slider.minimumValue) {
        zoomNum = _slider.minimumValue;
    }
    _slider.value = zoomNum;
    [[NIMAVChatSDK sharedSDK].netCallManager changeLensPosition:zoomNum];
}

- (void)onPlusButtonPresseed
{
    CGFloat zoomNum =  _slider.value + _slider.maximumValue / 6;
    if (zoomNum > _slider.maximumValue) {
        zoomNum = _slider.maximumValue;
    }
    _slider.value = zoomNum;
    [[NIMAVChatSDK sharedSDK].netCallManager changeLensPosition:zoomNum];
}

@end
