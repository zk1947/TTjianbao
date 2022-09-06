//
//  JHEasyPollLabel.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHEasyPollLabel.h"
#import "TTjianbaoHeader.h"

@interface JHEasyPollLabel ()
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) NSInteger msgIndex;
@property (nonatomic, strong) UILabel *pollLabel;
@property (nonatomic, strong) RACDisposable *racDisposable;
@end


@implementation JHEasyPollLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _msgIndex = 0;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
        
        _pollLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12]
                                  textColor:[UIColor whiteColor]];
        _pollLabel.backgroundColor = [UIColor colorWithHexStr:@"333333" alpha:0.79];
        _pollLabel.top = self.height;
        _pollLabel.left = 0;
        _pollLabel.height = self.height;
        _pollLabel.textAlignment = NSTextAlignmentCenter;
        _pollLabel.layer.cornerRadius = self.height/2;
        _pollLabel.clipsToBounds = YES;
        [self addSubview:_pollLabel];
    }
    return self;
}

- (void)setMsgArray:(NSArray<NSString *> *)msgArray {
    _msgArray = msgArray;
    [self startPollingMsg];
}

- (void)startPollingMsg {
    //RAC中的GCD
    if (!_racDisposable) {
        @weakify(self);
        _racDisposable = [[[RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDate * _Nullable x) {
            //[self.racDisposable dispose];
            @strongify(self);
            if (self.isShowing) {
                [self hidePollLabel];
            } else {
                [self showPollLabel];
            }
        }];
    }
}

- (void)showPollLabel {
    if (_msgIndex >= _msgArray.count) {
//        _msgIndex = 0;
        [self hidePollLabel];
        [_racDisposable dispose];
        return;
    }
    
    NSString *text = _msgArray[_msgIndex];
    CGFloat textW = [text getWidthWithFont:_pollLabel.font constrainedToSize:CGSizeMake(self.width-30, self.height)];
    
    _pollLabel.text = text;
    _pollLabel.width = textW + 26;
    
    self.pollLabel.top = self.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.pollLabel.top = 0;
        
    } completion:^(BOOL finished) {
        self.isShowing = YES;
    }];
    
    _msgIndex++;
}

- (void)hidePollLabel {
    [UIView animateWithDuration:0.3 animations:^{
        self.pollLabel.top -= self.height;
        
    } completion:^(BOOL finished) {
        self.isShowing = NO;
    }];
}

- (void)dealloc {
    [_racDisposable dispose];
}

@end
