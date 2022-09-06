//
//  JHGoodManagerFilterTimeTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerFilterTimeTableViewCell.h"
#import "JHSpecialDatePickerView.h"
#import "JHGoodManagerSingleton.h"

@interface JHGoodManagerFilterTimeView : UIView
@property (nonatomic, strong) UIView      *backView;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UIView      *lineView;
@property (nonatomic, strong) UIImageView *timeImageView;
@end

@implementation JHGoodManagerFilterTimeView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _backView                     = [[UIView alloc] init];
    _backView.layer.cornerRadius  = 15.f;
    _backView.layer.masksToBounds = YES;
    _backView.backgroundColor     = HEXCOLOR(0xF5F5F5);
    [self addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _timeImageView = [[UIImageView alloc] init];
    _timeImageView.image = [UIImage imageNamed:@"jhGoodManagerList_time"];
    [self addSubview:_timeImageView];
    [_timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-11.f);
        make.width.mas_equalTo(17.f);
        make.height.mas_equalTo(18.f);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = HEXCOLOR(0xD8D8D8);
    _lineView.layer.cornerRadius  = 0.28f;
    _lineView.layer.masksToBounds = YES;
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeImageView.mas_left).offset(-11.f);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(1.f);
        make.height.mas_equalTo(16.f);
    }];
    
    _timeLabel               = [[UILabel alloc] init];
    _timeLabel.textColor     = HEXCOLOR(0xDADADA);
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(self.lineView.mas_left);
    }];
}

@end


@interface JHGoodManagerFilterTimeTableViewCell ()
@property (nonatomic, strong) JHGoodManagerFilterTimeView *startTimeView;
@property (nonatomic, strong) UIView                      *lineView;
@property (nonatomic, strong) JHGoodManagerFilterTimeView *endTimeView;
@end

@implementation JHGoodManagerFilterTimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _startTimeView                     = [[JHGoodManagerFilterTimeView alloc] init];
    _startTimeView.layer.cornerRadius  = 15.f;
    _startTimeView.layer.masksToBounds = YES;
    _startTimeView.backgroundColor     = HEXCOLOR(0xF5F5F5);
    _startTimeView.timeLabel.text      = @"开始日期";
    [self.contentView addSubview:_startTimeView];
    [_startTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(18.f);
        make.top.equalTo(self.contentView.mas_top).offset(7.f);
        make.width.mas_equalTo(141.f);
        make.height.mas_equalTo(30.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTap:)];
    [self.startTimeView addGestureRecognizer:tap1];
    
    
    /// 横划线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = HEXCOLOR(0x999999);
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startTimeView.mas_right).offset(6.f);
        make.centerY.equalTo(self.startTimeView.mas_centerY);
        make.width.mas_equalTo(6.f);
        make.height.mas_equalTo(1.f);
    }];
    
    _endTimeView = [[JHGoodManagerFilterTimeView alloc] init];
    _endTimeView.layer.cornerRadius  = 15.f;
    _endTimeView.layer.masksToBounds = YES;
    _endTimeView.backgroundColor     = HEXCOLOR(0xF5F5F5);
    _endTimeView.timeLabel.text      = @"结束日期";
    [self.contentView addSubview:_endTimeView];
    [_endTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(6.f);
        make.centerY.equalTo(self.startTimeView.mas_centerY);
        make.width.mas_equalTo(141.f);
        make.height.mas_equalTo(30.f);
    }];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endTap:)];
    [self.endTimeView addGestureRecognizer:tap2];
}

- (void)resetAllStatus {
    self.startTimeView.timeLabel.text = @"开始日期";
    self.startTimeView.timeLabel.textColor = HEXCOLOR(0xDADADA);

    self.endTimeView.timeLabel.text = @"结束日期";
    self.endTimeView.timeLabel.textColor = HEXCOLOR(0xDADADA);
    
    [JHGoodManagerSingleton shared].publishStartTime = @"";
    [JHGoodManagerSingleton shared].publishEndTime   = @"";
}

- (void)startTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.timePickerDidClickedBlock) {
        self.timePickerDidClickedBlock();
    }
    @weakify(self);
    JHSpecialDatePickerView *dateView = [[JHSpecialDatePickerView alloc]initWithDateStyle:JHDatePickerViewDateTypeYearMonthDayMode completeBlock:^(NSString *dateString) {
        @strongify(self);
        self.startTimeView.timeLabel.text                = dateString;
        self.startTimeView.timeLabel.textColor           = HEXCOLOR(0x222222);
        [JHGoodManagerSingleton shared].publishStartTime = dateString;
    }];
    [dateView show];
}


- (void)endTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.timePickerDidClickedBlock) {
        self.timePickerDidClickedBlock();
    }
    @weakify(self);
    JHSpecialDatePickerView *dateView = [[JHSpecialDatePickerView alloc]initWithDateStyle:JHDatePickerViewDateTypeYearMonthDayMode completeBlock:^(NSString *dateString) {
        @strongify(self);
        self.endTimeView.timeLabel.text                = dateString;
        self.endTimeView.timeLabel.textColor           = HEXCOLOR(0x222222);
        [JHGoodManagerSingleton shared].publishEndTime = dateString;
    }];
    [dateView show];
}



@end
