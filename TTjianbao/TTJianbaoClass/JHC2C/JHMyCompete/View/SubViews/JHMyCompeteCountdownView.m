//
//  JHMyCompeteCountdownView.m
//  TTjianbao
//
//  Created by miao on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCompeteCountdownView.h"
#import "TTJianBaoColor.h"
#import "YDCountDown.h"
#import "CommHelp.h"

@interface JHMyCompeteCountdownView ()

/// 倒计时
@property (nonatomic, strong) YDCountDown *countDown;

@end


@implementation JHMyCompeteCountdownView

- (void)dealloc {
    [self.countDown destoryTimer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
//        self.backgroundColor = HEXCOLORA(0x000000, 0.5);
        self.backgroundColor = HEXCOLORA(0xFF6A00, 0.8);
        [self p_drawSubViews];
        [self p_makeLayouts];
    }
    return self;
}


#pragma mark - Private Methods

- (void)p_drawSubViews {
    
    _countdownLable = [[UILabel alloc] init];
    _countdownLable.font = JHFont(11);
    _countdownLable.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _countdownLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_countdownLable];
}

- (void)dealTextAlent{
    self.backgroundColor = [UIColor clearColor];
    _countdownLable.textAlignment = NSTextAlignmentLeft;
}

- (void)changeTextAttribute:(UIFont *)font color:(UIColor *)color bgColor:(UIColor *)bgColor{
    self.backgroundColor = bgColor;
    _countdownLable.font = font;
    _countdownLable.textColor = color;
}

- (void)p_makeLayouts {
    
    [_countdownLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setTheCompeteCountdownView:(NSString *)deadline
                         expString:(NSString *)expString completion:(void (^ __nullable)(BOOL finished))completion{
    int second = [CommHelp dateRemaining:deadline];
    if (second > 0) {
        self.hidden = false;
        @weakify(self);
        [self.countDown startWithFinishTimeStamp:second completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
            @strongify(self);
            NSInteger newHour = day*24+hour;
            if (newHour == 0 && minute == 0 && second == 0) {
                [self.countDown destoryTimer];
                if (completion) {
                    completion(YES);
                }
            } else {
                NSString *countDownTip = [NSString stringWithFormat:@"%@%ld时%ld分%ld秒",expString, (long)newHour, (long)minute, (long)second];
                _countdownLable.text = countDownTip;
            }
        }];
    }else {
        self.hidden = true;
        [self.countDown destoryTimer];
        self.countdownLable.text = @"";
    }
}

- (void)setSecandData:(NSInteger)secondNum expString:(NSString *)expString completion:(void (^ __nullable)(BOOL finished))completion{
    if (secondNum > 0) {
        self.hidden = false;
        @weakify(self);
        [self.countDown startWithFinishTimeStamp:secondNum completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
            @strongify(self);
            NSInteger newHour = day*24+hour;
            if (newHour == 0 && minute == 0 && second == 0) {
                [self.countDown destoryTimer];
                if (completion) {
                    completion(YES);
                }
            } else {
                NSString *countDownTip;
                //不足两位补0
                NSString *minuteStr = minute < 10 ? [NSString stringWithFormat:@"0%ld",(long)minute]:[NSString stringWithFormat:@"%ld",(long)minute];
                NSString *secondStr = second < 10 ? [NSString stringWithFormat:@"0%ld",(long)second]:[NSString stringWithFormat:@"%ld",(long)second];
                
                if ([expString isEqualToString:@""] || [expString isEqualToString:@"福袋进行中 "]) {
                    countDownTip = [NSString stringWithFormat:@"%@%@:%@",expString, minuteStr, secondStr];
                }else if ([expString isEqualToString:@"后开奖"]){
                    countDownTip = [NSString stringWithFormat:@"%@:%@%@",minuteStr, secondStr, expString];
                }else{
                    countDownTip = [NSString stringWithFormat:@"%@%ld时%ld分%ld秒",expString, (long)newHour, (long)minute, (long)second];
                }
                _countdownLable.text = countDownTip;
            }
        }];
    }else {
        self.hidden = true;
        [self.countDown destoryTimer];
        self.countdownLable.text = @"";
    }
}

- (YDCountDown *)countDown {
    if (!_countDown) {
        _countDown = [[YDCountDown alloc] init];
    }
    return _countDown;
}

@end
