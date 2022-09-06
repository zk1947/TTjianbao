//
//  MCDatePicker.m
//  Mclouds
//
//  Created by Jiwei Wang on 2020/8/4.
//  Copyright © 2020 Mclouds. All rights reserved.
//

#import "MCDatePicker.h"
@interface MCDatePicker()
/**时间选择器*/
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *containerView;
/**菜单*/
@property (nonatomic, strong) UIView *toolView;
/**确定*/
@property (nonatomic, strong) UIButton *ensureButton;
/**title*/
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation MCDatePicker

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [UIView animateWithDuration:0.4 animations:^{
            self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        }];
        [self setUpUI];
    }
    return self;
}

- (void)ensureButtonClickAction {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [formatter stringFromDate:self.datePicker.date];
    if (self.selectBlock) {
        self.selectBlock(date);
    }
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.containerView.frame = CGRectMake(0, ScreenH, ScreenW, 215);
        self.toolView.frame = CGRectMake(0, ScreenH, ScreenW, 40);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)datePickerChange:(id)sender {
    if ([sender isKindOfClass:[UIDatePicker class]]) {
//        UIDatePicker * datePicker = sender;
//        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString * dateString = [formatter stringFromDate:datePicker.date];
//        self.titleLabel.text = dateString;
    }
}
- (void)setUpUI{
    [self addSubview:self.toolView];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.datePicker];
    [self.toolView addSubview:self.ensureButton];
    [self.toolView addSubview:self.titleLabel];
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.frame = CGRectMake(0, ScreenH - 215, ScreenW, 215);
        self.toolView.frame = CGRectMake(0, self.containerView.top - 40, ScreenW, 40);
    }];
}

- (void)setMinBegionTime:(NSDate *)minBegionTime {
    _minBegionTime = minBegionTime;
    [self.datePicker setMinimumDate:minBegionTime];
}

- (void)setMaxBegionTime:(NSDate *)maxBegionTime {
    _maxBegionTime = maxBegionTime;
    [self.datePicker setMaximumDate:maxBegionTime];
}
- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.titleLabel.text = titleText;
}
- (NSDate *)date {
    return self.datePicker.date;
}
- (void)setupDate : (NSDate *)date {
    [self.datePicker setDate:date];
    self.date = date;
}
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, 215)];
        _containerView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _containerView;
}
- (UIDatePicker *)datePicker{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame = CGRectMake(0, 0, ScreenW, 215);
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
        }
//        [_datePicker setDate:[NSDate date] animated:YES];
        [_datePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];

        [self datePickerChange:_datePicker];
    }
    return _datePicker;
}

- (UIView *)toolView{
    if (_toolView == nil) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.containerView.top - 40, ScreenW, 40)];
        _toolView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _toolView;
}

- (UIButton *)ensureButton{
    if (_ensureButton == nil) {
        _ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ensureButton.frame = CGRectMake(self.toolView.width - 60, 0, 50, self.toolView.height);
        [_ensureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureButton  setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_ensureButton addTarget:self action:@selector(ensureButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureButton;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.toolView.width - 120, self.toolView.height)];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end
