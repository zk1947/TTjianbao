//
//  JHUnionSignSelectTimeView.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUnionSignSelectTimeView.h"
#import "TTjianbaoMarcoKeyword.h"

@interface JHUnionSignSelectTimeView ()

@property (nonatomic, weak) UIView *whiteView;
@property (nonatomic, copy) void(^longDateBlock)(NSString *timeString);

@end

@implementation JHUnionSignSelectTimeView

- (instancetype)initWithDateStyle:(JHDatePickerViewDateType)datePickerStyle completeBlock:(void(^)(NSString *dateString))completeBlock longDateBlock:(void(^)(NSString *timeString))longDateBlock{
    if (self = [super initWithDateStyle:datePickerStyle completeBlock:completeBlock]) {
        [self updateYearRange:31 beforeYear:0];
        self.longDateBlock = longDateBlock;
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        CGRect frame = self.buttomView.frame;
        self.buttomView.frame = CGRectMake(0, ScreenH, frame.size.width, frame.size.height + 54 + UI.bottomSafeAreaHeight);
        
        _whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.buttomView];
        _whiteView.frame = CGRectMake(0, frame.size.height, ScreenW, 54 + UI.bottomSafeAreaHeight);
        
        UIButton *button = [UIButton jh_buttonWithTitle:@"有效期为长期" fontSize:18 textColor:RGB515151 target:self action:@selector(clickMethod) addToSuperView:_whiteView];
        button.backgroundColor = RGB(254, 225, 0);
        [button jh_cornerRadius:22];
        button.frame = CGRectMake(15, 5, ScreenW - 30, 44);
    }
    return self;
}

- (void)clickMethod {
    ///长期时间为固定的
    if(_longDateBlock) {
        _longDateBlock(kUnionPayForeverTimeKey);
    }
    [self dismiss];
}

#pragma mark - Action
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.buttomView.frame;
        self.buttomView.frame = CGRectMake(0, ScreenH - frame.size.height, frame.size.width, frame.size.height);
        [self layoutIfNeeded];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.buttomView.frame;
        self.buttomView.frame = CGRectMake(0, ScreenH, frame.size.width, frame.size.height);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
