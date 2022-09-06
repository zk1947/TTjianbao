//
//  JHTimeSelectPickerView.m
//  TTjianbao
//
//  Created by zk on 2021/8/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHTimeSelectPickerView.h"

@interface JHTimeSelectPickerView ()

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIControl *shadowView;

@property (nonatomic, copy) NSString *titleStr;

@end

@implementation JHTimeSelectPickerView

- (instancetype)initWithFrame:(CGRect)frame withStyle:(PickerStyle)pickerStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleStr = pickerStyle == 1 ? @"发布日期":@"结束日期";
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    self.backgroundColor = kColorFFF;
    
    UILabel *titLab = [UILabel new];
    titLab.text = self.titleStr;
    titLab.textColor = kColor333;
    titLab.font = JHFont(16);
    titLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titLab];
    [titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
   
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    finishBtn.titleLabel.font = JHFont(16);
    [finishBtn addTarget:self action:@selector(finishBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:finishBtn];
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.right.left.bottom.mas_equalTo(@0);
    }];
}

- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        UIDatePicker * picker = [[UIDatePicker alloc] init];
        if (@available(iOS 13.4, *)) {
            picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
        //设置地区: zh-中国
        picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        //设置时间格式
        picker.datePickerMode = UIDatePickerModeDate;
        // 设置当前显示时间
        [picker setDate:[NSDate date] animated:YES];
        //设置显示最小时间
//        NSDate *minBegionTime = [[NSDate date] dateByAddingSeconds:1];
//        [picker setMinimumDate:minBegionTime];
        // 设置显示最大时间
        NSDate *maxBegionTime = [NSDate date];
        [picker setMaximumDate:maxBegionTime];
        _datePicker = picker;
    }
    return _datePicker;
}

- (void)finishBtnAction:(UIButton *)btn{
    NSDate *date = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *time = [formatter stringFromDate:date];
    if (_selectTimeBlock) {
        _selectTimeBlock(time);
    }
    [self hiddenMsgAlert];
}

-(void)showAlert{
    self.shadowView.alpha= 0;
    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.25 animations:^{
        _shadowView.alpha = 0.7;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:_shadowView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.bottom = [UIApplication sharedApplication].keyWindow.bottom + UI.bottomSafeAreaHeight;
}

-(void)hiddenMsgAlert{
    [self.shadowView removeFromSuperview];
    self.shadowView = nil;
    [self removeFromSuperview];
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIControl alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_shadowView addTarget:self action:@selector(hiddenMsgAlert) forControlEvents:UIControlEventTouchUpInside];
        _shadowView.backgroundColor = [UIColor blackColor];
    }
    return _shadowView;
}

@end
