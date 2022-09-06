//
//  JHHonnerCerDetailTimeTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/12/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHonnerCerDetailTimeTableViewCell.h"
#import "UILabel+TextAlignment.h"

@interface JHHonnerCerDetailTimeTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation JHHonnerCerDetailTimeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _titleLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 75.f, 21.f)];
    _titleLabel.textColor     = HEXCOLOR(0x333333);
    _titleLabel.font          = [UIFont fontWithName:kFontNormal size:15.f];
    _titleLabel.text          = @"发证日期：";
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(75.f);
        make.height.mas_equalTo(21.f);
    }];
    [_titleLabel changeAlignmentBothSides];

    _subTitleLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 75.f, 21.f)];
    _subTitleLabel.textColor     = HEXCOLOR(0x333333);
    _subTitleLabel.font          = [UIFont fontWithName:kFontNormal size:15.f];
    [self.contentView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(5.f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.equalTo(self.contentView.mas_top).offset(5.f);
        make.height.mas_equalTo(21.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.f);
    }];
}

- (void)setViewModel:(NSString *)viewModel {
    if (!isEmpty(viewModel)) {
        NSString *confromTimespStr = [self getTime:viewModel];
        self.subTitleLabel.text = NONNULL_STR(confromTimespStr);
    }
}

#pragma mark -- time convert method
- (NSString *)convertSecondsToTime:(long long)time
                            Format:(NSString *)dateFormat {
    // long long time=[timeStr longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //[formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [formatter setDateFormat:dateFormat];
    NSString*timeString = [formatter stringFromDate:d];
    
    return timeString;
}
 
//A、如果是当天的交易，显示 精准到时分，如：19：30 ；
//B、如果是往日的交易，显示为 “ 月-日 时：分 ” ，如： 09-01 16：12
- (NSString *)getTime:(NSString *)timeStr {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:timeStr];
    NSTimeInterval timeStamp = [inputDate timeIntervalSince1970]*1000;
    //当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval currentStamp = [dat timeIntervalSince1970]*1000;
    
    NSString *_timeStr = [self convertSecondsToTime:timeStamp Format:@"yyyy.MM"];
    return _timeStr;
}








@end
