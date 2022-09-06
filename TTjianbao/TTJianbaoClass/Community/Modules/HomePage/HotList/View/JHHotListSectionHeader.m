//
//  JHHotListSectionHeader.m
//  TTjianbao
//
//  Created by lihui on 2020/6/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHotListSectionHeader.h"
#import "CommHelp.h"
#import "JHLine.h"

#define dateSpace 3

@interface JHHotListSectionHeader ()

@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UILabel *yearValueLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *monthValueLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *dayValueLabel;

@end

@implementation JHHotListSectionHeader

- (void)setDateTimeString:(NSString *)dateTimeString {
    if (!dateTimeString) {
        return;
    }
    
    _dateTimeString = dateTimeString;
    NSArray *timeArray = [_dateTimeString componentsSeparatedByString:@"-"];
    if ([CommHelp isSameYear:[timeArray firstObject]]) {
        _yearValueLabel.text = @"";
        _yearLabel.text = @"";
    }
    else {
        _yearValueLabel.text = [timeArray firstObject];
        _yearLabel.text = @"年";
    }
    _monthValueLabel.text = timeArray[1];
    _dayValueLabel.text = [timeArray lastObject];
    
    CGFloat space = [CommHelp isSameYear:[timeArray firstObject]] ? dateSpace : 0;
    [_yearLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yearValueLabel.mas_right).offset(space);
    }];
    [_monthValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yearLabel.mas_right).offset(space);
    }];
}

- (void)addSelfSubViews
{
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:whiteView];

    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = HEXCOLOR(0xF9FAF9);
    [self.contentView addSubview:grayView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXCOLOR(0xEAEAEE);
    [self.contentView addSubview:lineView];

    UIImageView *circleView = [[UIImageView alloc] init];
    circleView.image = [UIImage imageNamed:@"icon_hotlist_circle"];
    circleView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:circleView];
    
    _yearValueLabel = [[UILabel alloc] init];
    _yearValueLabel.text = @"";
    _yearValueLabel.textColor = [UIColor blackColor];
    _yearValueLabel.font = [UIFont fontWithName:kFontBoldDIN size:21];
    [grayView addSubview:_yearValueLabel];

    _yearLabel = [[UILabel alloc] init];
    _yearLabel.text = @"";
    _yearLabel.textColor = [UIColor blackColor];
    _yearLabel.font = [UIFont fontWithName:kFontNormal size:10];
    [grayView addSubview:_yearLabel];
    
    _monthValueLabel = [[UILabel alloc] init];
    _monthValueLabel.text = @"xx";
    _monthValueLabel.textColor = [UIColor blackColor];
    _monthValueLabel.font = [UIFont fontWithName:kFontBoldDIN size:21];
    [grayView addSubview:_monthValueLabel];

    _monthLabel = [[UILabel alloc] init];
    _monthLabel.text = @"月";
    _monthLabel.textColor = [UIColor blackColor];
    _monthLabel.font = [UIFont fontWithName:kFontNormal size:10];
    [grayView addSubview:_monthLabel];

    _dayValueLabel = [[UILabel alloc] init];
    _dayValueLabel.text = @"xx";
    _dayValueLabel.textColor = [UIColor blackColor];
    _dayValueLabel.font = [UIFont fontWithName:kFontBoldDIN size:21];
    [grayView addSubview:_dayValueLabel];

    _dayLabel = [[UILabel alloc] init];
    _dayLabel.text = @"日";
    _dayLabel.textColor = [UIColor blackColor];
    _dayLabel.font = [UIFont fontWithName:kFontNormal size:10];
    [grayView addSubview:_dayLabel];
    
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(20);
    }];
    
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(40);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(14);
        make.width.mas_equalTo(3);
    }];
    
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(grayView);
        make.centerX.equalTo(lineView);
    }];
    
    [_yearValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayView).offset(26);
        make.centerY.equalTo(grayView);
    }];
    
    [_yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yearValueLabel.mas_right).offset(dateSpace);
        make.bottom.equalTo(self.yearValueLabel).offset(-2);
    }];
    
    [_monthValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yearLabel.mas_right).offset(dateSpace);
        make.centerY.equalTo(self.yearValueLabel);
    }];
    
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.monthValueLabel.mas_right).offset(dateSpace);
        make.bottom.equalTo(self.monthValueLabel).offset(-2);
    }];
    
    [_dayValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.monthLabel.mas_right).offset(dateSpace);
        make.centerY.equalTo(grayView);
    }];
    
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayValueLabel.mas_right).offset(dateSpace);
        make.bottom.equalTo(self.dayValueLabel).offset(-2);
    }];
}

@end

@implementation JHHotListSectionFooter

- (void)addSelfSubViews
{
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    [[UIView jh_viewWithColor:HEXCOLOR(0xEAEAEE) addToSuperview:self.contentView]
     mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(14);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(3);
    }];
    
    UILabel *label = [UILabel jh_labelWithText:@"今天没有更多了" font:12 textColor:RGB153153153 textAlignment:1 addToSuperView:self.contentView];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    [self.contentView addSubview:label];
    
    JHGradientLine *line1 = [JHGradientLine jh_viewWithColor:UIColor.clearColor addToSuperview:self.contentView];
    [line1 setGradientColor:@[(__bridge id)RGBA(238, 238, 238, 0).CGColor,(__bridge id)RGBA(238, 238, 238, 1).CGColor] orientation:JHGradientOrientationHorizontal];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label.mas_left).offset(-5);
        make.centerY.equalTo(label);
        make.size.mas_equalTo(CGSizeMake(80, 1));
    }];
    
    JHGradientLine *line2 = [JHGradientLine jh_viewWithColor:UIColor.clearColor addToSuperview:self.contentView];
    [line2 setGradientColor:@[(__bridge id)RGBA(238, 238, 238, 1).CGColor,(__bridge id)RGBA(238, 238, 238, 0).CGColor] orientation:JHGradientOrientationHorizontal];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(5);
        make.centerY.width.height.equalTo(line1);
    }];

}

@end
