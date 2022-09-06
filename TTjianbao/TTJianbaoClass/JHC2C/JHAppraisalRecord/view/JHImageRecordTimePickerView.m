//
//  JHImageRecordTimePickerView.m
//  TTjianbao
//
//  Created by liuhai on 2021/6/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHImageRecordTimePickerView.h"
#import "JHSpecialDatePickerView.h"
#import "UIButton+ImageTitleSpacing.h"

@interface JHImageRecordTimePickerView()
@property (nonatomic,strong) UIButton * beginBtn;
@property (nonatomic,strong) UIButton * endBtn;
@end

@implementation JHImageRecordTimePickerView

static JHImageRecordTimePickerView *shareManager = nil;
static dispatch_once_t onceToken;
///实例化单例
+ (JHImageRecordTimePickerView *)shareManger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[JHImageRecordTimePickerView alloc] init];
//        [shareManager creatUI];
    });
    return shareManager;
}
- (void)resetTime{
    [self.beginBtn setTitle:[self beforeTime] forState:UIControlStateNormal];
    [self.endBtn setTitle:[self currentTime] forState:UIControlStateNormal];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.backgroundColor = UIColor.whiteColor;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xE6E6E6);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(0);
    }];
    
    UILabel *centerLaber = [[UILabel alloc] init];
    centerLaber.text = @"至";
    centerLaber.font = JHFont(14);
    centerLaber.textColor = HEXCOLOR(0x333333);
    [self addSubview:centerLaber];
    [centerLaber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    self.beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.beginBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    self.beginBtn.titleLabel.font = JHFont(13);
    self.beginBtn.tag = 11;
    [self.beginBtn setTitle:[self beforeTime] forState:UIControlStateNormal];
    [self.beginBtn setImage:[UIImage imageNamed:@"icon_shop_bill_push_gray"] forState:UIControlStateNormal];
    [self.beginBtn addTarget:self action:@selector(popDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.beginBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:12];
    [self addSubview:self.beginBtn];
    [self.beginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 18));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(centerLaber.mas_left).offset(-10);
    }];
    
    self.endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.endBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    self.endBtn.titleLabel.font = JHFont(13);
    self.endBtn.tag = 22;
    [self.endBtn setTitle:[self currentTime] forState:UIControlStateNormal];
    [self.endBtn setImage:[UIImage imageNamed:@"icon_shop_bill_push_gray"] forState:UIControlStateNormal];
    [self.endBtn addTarget:self action:@selector(popDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.endBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:12];
    [self addSubview:self.endBtn];
    [self.endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 18));
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(centerLaber.mas_right).offset(6);
    }];
}

- (void)popDatePicker:(UIButton *)sender{
    @weakify(self);
    JHSpecialDatePickerView *dateView = [[JHSpecialDatePickerView alloc]initWithDateStyle:JHDatePickerViewDateTypeYearMonthDayMode completeBlock:^(NSString *dateString) {
        @strongify(self);
        
        if (sender.tag == 11) {
            if ([CommHelp timeSwitchDatestamp:self.endBtn.currentTitle]>=[CommHelp timeSwitchDatestamp:dateString]) {
                [sender setTitle:dateString forState:UIControlStateNormal];
                if (self.delegate && [self.delegate respondsToSelector:@selector(reloadRecordData)]) {
                    [self.delegate reloadRecordData];
                }
            }
            else{
                [[UIApplication sharedApplication].keyWindow makeToast:@"结束时间不能小于开始时间" duration:1.0 position:CSToastPositionCenter];
                return;
            }
        }else if(sender.tag == 22){
            if ([CommHelp timeSwitchDatestamp:dateString]>= [CommHelp timeSwitchDatestamp:self.beginBtn.currentTitle]) {
                [sender setTitle:dateString forState:UIControlStateNormal];
                if (self.delegate && [self.delegate respondsToSelector:@selector(reloadRecordData)]) {
                    [self.delegate reloadRecordData];
                }
            }
            else{
                [[UIApplication sharedApplication].keyWindow makeToast:@"结束时间不能小于开始时间" duration:1.0 position:CSToastPositionCenter];
                return;
            }
        }

        
    }];
    [dateView show];
}
- (NSString *)currentTime{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}
- (NSString *)beforeTime{
    NSDate *datenow = [NSDate date];
    NSDate *newDate = [datenow dateByAddingTimeInterval:-24 * 60 * 60  * 7];
    return [CommHelp getDateStringFromDate:newDate];
}
-(NSString *)getStartTime{
    return self.beginBtn.currentTitle;
}
-(NSString *)getEndTime{
    return self.endBtn.currentTitle;
}
@end
