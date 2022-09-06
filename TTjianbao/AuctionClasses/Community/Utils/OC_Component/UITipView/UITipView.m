//
//  UITipView.m
//  DYSport
//
//  Created by Wujg on 16/5/6.
//  Copyright © 2016年 Wujg. All rights reserved.
//

#import "UITipView.h"
#import "TTjianbao.h"

#define kPaddingLeft    (20.0)
#define kDuration       (2)
#define kFontSize       (14.0)
#define kTipTag         (9999)

@interface UITipView ()
@property (nonatomic, strong) UIView *contentView;
@end

@implementation UITipView

#pragma mark -
#pragma mark public methods
+ (void)showTipStr:(NSString *)tipStr {
    UIView *tipView = [JHKeyWindow viewWithTag:kTipTag];
    if (tipView) {
        [tipView removeFromSuperview];
        tipView = nil;
    }
    UITipView *tip = [[UITipView alloc] initWithText:tipStr];
    [tip show];
}

- (void)dealloc {
    NSLog(@"UITipView::dealloc");
    _contentView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}

#pragma mark -
#pragma mark life cycle
- (id)initWithText:(NSString *)text {
    if (self = [super init]) {
        NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:kFontSize] forKey:NSFontAttributeName];
        CGRect rect = [text boundingRectWithSize:CGSizeMake(ScreenWidth*0.8, CGFLOAT_MAX)
                                         options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                      attributes:dict context:nil];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPaddingLeft, 0, CGRectGetWidth(rect), rect.size.height + 28 + 4)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:kFontSize];
        textLabel.text = text;
        textLabel.numberOfLines = 0;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(textLabel.frame) + kPaddingLeft*2, CGRectGetHeight(textLabel.frame))];
        _contentView.center = JHKeyWindow.center;
        _contentView.backgroundColor = HEXCOLORA(0x000000, 0.7);
        [_contentView addSubview:textLabel];
        _contentView.layer.cornerRadius = 4.5; //_contentView.height/2; //圆角
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _contentView.tag = kTipTag;
        _contentView.alpha = 0.0f;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView)];
        [_contentView addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:[UIDevice currentDevice]];
    }
    
    return self;
}

- (void)deviceOrientationDidChanged:(NSNotification *)notify {
    [self hideAnimation];
}

#pragma mark -
#pragma mark pravite methods
- (void)show {
    _contentView.center = JHKeyWindow.center;
    [JHKeyWindow  addSubview:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:kDuration];
}

- (void)showAnimation {
    _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.contentView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contentView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)hideAnimation {
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissTip];
    }];
}

- (void)dismissTip {
    [_contentView removeFromSuperview];
}

- (void)tapContentView {
    [self hideAnimation];
}

@end
