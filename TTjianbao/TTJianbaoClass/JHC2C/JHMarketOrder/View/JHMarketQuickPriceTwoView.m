//
//  JHMarketQuickPriceTwoView.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/6/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketQuickPriceTwoView.h"
#import "JHNumberKeyboard.h"
#import "IQKeyboardManager.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHMarketOrderViewModel.h"
#import "MCDatePicker.h"
#import "CommAlertView.h"
#import "JHC2CSureMoneyAlertController.h"
#import "CommHelp.h"

static NSInteger const LimitNum = 6;

@interface JHMarketQuickPriceTwoView()<UITextFieldDelegate>
/** backView*/
@property (nonatomic, strong) UIView *backView;
/** 快速调价*/
@property (nonatomic, strong) UILabel *titleLabel;
/** 关闭按钮*/
@property (nonatomic, strong) UIButton *closeButton;
/** 起拍价*/
@property (nonatomic, strong) UILabel *oriPriceLabel;
/** 起拍价输入框*/
@property (nonatomic, strong) UITextField *oriPriceTextField;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView1;
/** 加价幅度*/
@property (nonatomic, strong) UILabel *ratePriceLabel;
/** 加价幅度输入框*/
@property (nonatomic, strong) UITextField *rateTextField;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView2;
/** 保证金*/
@property (nonatomic, strong) UIButton *depositButton;
/** 保证金输入框*/
@property (nonatomic, strong) UITextField *depositTextField;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView3;
/** 开始时间按钮*/
@property (nonatomic, strong) UILabel *beginTimeButton;
@property (nonatomic, strong) UIImageView *beginArrowImageView;
/** 横线*/
@property (nonatomic, strong) UIView *lineView4;
/** 结束时间按钮*/
@property (nonatomic, strong) UILabel *endTimeButton;
@property (nonatomic, strong) UIImageView *endArrowImageView;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView5;
/** 键盘*/
@property (nonatomic, strong) JHNumberKeyboard *keyboardView;

@property (nonatomic, strong) MCDatePicker *datePicker;
@end

@implementation JHMarketQuickPriceTwoView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        [self configUI];
    }
    return self;
}

- (void)setPublishModel:(JHMarketPublishModel *)publishModel {
    _publishModel = publishModel;
    self.oriPriceTextField.text = [NSString stringWithFormat:@"¥%@", publishModel.currentPrice.doubleValue > 0 ? publishModel.currentPrice : NONNULL_STR(publishModel.startPrice)];
    self.rateTextField.text = [NSString stringWithFormat:@"¥%@", publishModel.bidIncrement];
    self.depositTextField.text = [NSString stringWithFormat:@"¥%@", publishModel.earnestMoney];
    self.beginTimeButton.text = publishModel.auctionStartTime;
    self.endTimeButton.text = publishModel.auctionEndTime;
    NSDate *date = [NSDate dateFromString:publishModel.auctionStartTime];
    [self.datePicker setupDate:date];
}

// 输入框改变
- (void)textFieldChanged:(NSString *)textString {
    UITextField *editTextField = [[UITextField alloc] init];
    if (self.oriPriceTextField.isFirstResponder) {
        editTextField = self.oriPriceTextField;
    } else if(self.rateTextField.isFirstResponder){
        editTextField = self.rateTextField;
    } else {
        editTextField = self.depositTextField;
    }
    
    if (textString.integerValue == 13) {  //删除
        if (editTextField.text > 0) {
            editTextField.text = [editTextField.text substringToIndex:[editTextField.text length] - 1];
        }
    } else if(textString.integerValue == 10) {
        editTextField.text = [editTextField.text stringByAppendingString:@"."];
    } else if(textString.integerValue == 12) { //退下键盘
        [self close];
    } else if(textString.integerValue == 14) { //完成
        [self finish];
    } else {
        NSInteger count = editTextField.text.length;
        if ([editTextField.text containsString:@"."]) {
            if (count <= 8) {
                editTextField.text = [editTextField.text stringByAppendingString:textString];
            }
        }else{
            if (count < LimitNum) {
                editTextField.text = [editTextField.text stringByAppendingString:textString];
            }
        }
    }
    
    if (editTextField.text.length == 0) {
        editTextField.text = @"¥";
    }
    // 1. 去空格
    editTextField.text = [editTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 2. 保证输入数字的有效性
    if ( editTextField.text.length > 0 ) {
        // 1. 防止输入多个小数点
        if ( [editTextField.text componentsSeparatedByString:@"."].count > 2 ) {
            editTextField.text = [editTextField.text substringToIndex:editTextField.text.length - 1];
        }
        // 2. 控制精度
        if ( [editTextField.text componentsSeparatedByString:@"."].count == 2 && [[editTextField.text componentsSeparatedByString:@"."] lastObject].length > 2 ) {
            
            NSString *firstString = [[editTextField.text componentsSeparatedByString:@"."] firstObject];
            NSString *lastString = [[editTextField.text componentsSeparatedByString:@"."] lastObject];
            editTextField.text = [NSString stringWithFormat:@"%@.%@", firstString, [lastString substringToIndex:2]];
        }
        // 3.如果第一位是0则后面必须输入点，否则不能输入
        if ([editTextField.text hasPrefix:@"0"] && editTextField.text.length > 1) {
             NSString *secondStr = [editTextField.text substringWithRange:NSMakeRange(1, 1)];
             if (![secondStr isEqualToString:@"."]) {
                 editTextField.text = [editTextField.text substringToIndex:editTextField.text.length - 1];
             }
         }
    }
    
}

#pragma selectTime 时间选择器
- (void)beginTimeSelect{
    NSDate *startTime = [[NSDate date] dateByAddingMinutes:15];
    NSDate *endTime = [startTime dateByAddingDays:3];
    
    self.datePicker.minBegionTime = startTime;
    self.datePicker.maxBegionTime = endTime;
    NSDate *date = [NSDate dateFromString:self.beginTimeButton.text];
    [self.datePicker setupDate:date];
    @weakify(self);
    self.datePicker.selectBlock = ^(NSString * _Nonnull str) {
        @strongify(self)
        self.beginTimeButton.text  = str;
        NSDate *startTime = [self.datePicker.date dateByAddingMinutes:30];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *date = [formatter stringFromDate:startTime];
        self.endTimeButton.text = date;
    };
    [[UIApplication sharedApplication].keyWindow addSubview:self.datePicker];
}
- (void)endTimeSelect{
    MCDatePicker *datePicker = [[MCDatePicker alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    datePicker.titleText = @"结束时间";
    NSDate *startTime = [self.datePicker.date dateByAddingMinutes:30];
    NSDate *endTime = [startTime dateByAddingDays:3];
    
    datePicker.minBegionTime = startTime;
    datePicker.maxBegionTime = endTime;
    
    MJWeakSelf;
    datePicker.selectBlock = ^(NSString * _Nonnull str) {
        weakSelf.endTimeButton.text = str;
    };
    [[UIApplication sharedApplication].keyWindow addSubview:datePicker];
}
- (NSDate *)getCurrentDate {
    return [CommHelp getCurrentTrueDate];
}
- (NSDate *)getStartTime {
    NSDate *date = [NSDate dateFromString:self.publishModel.auctionStartTime];
    
    return date;
}
- (NSDate *)getEndTime {
    NSDate *date = [NSDate dateFromString:self.publishModel.auctionEndTime];
    
    return date;
}

- (void)close {
    [self removeFromSuperview];
}

- (void)finish {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"productId"] = self.publishModel.productId;
    params[@"startPrice"] = [self.oriPriceTextField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    params[@"bidIncrement"] = [self.rateTextField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    params[@"earnestMoney"] = [self.depositTextField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    params[@"auctionStartTime"] = self.beginTimeButton.text;
    params[@"auctionEndTime"] = self.endTimeButton.text;
    [JHMarketOrderViewModel updateProductPrice:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [SVProgressHUD dismiss];
        if (!error) {
            JHTOAST(@"价格修改成功");
            if (self.completeBlock) {
                self.completeBlock();
            }
            [self close];
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

- (void)alertButtonClick {
    JHC2CSureMoneyAlertController *vc = [JHC2CSureMoneyAlertController new];
    [JHRootController presentViewController:vc animated:NO completion:nil];
}

- (void)configUI {
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.closeButton];
    [self.backView addSubview:self.oriPriceLabel];
    [self.backView addSubview:self.oriPriceTextField];
    [self.backView addSubview:self.lineView1];
    [self.backView addSubview:self.ratePriceLabel];
    [self.backView addSubview:self.rateTextField];
    [self.backView addSubview:self.lineView2];
    [self.backView addSubview:self.depositButton];
    [self.backView addSubview:self.depositTextField];
    [self.backView addSubview:self.lineView3];
    [self.backView addSubview:self.beginTimeButton];
    [self.backView addSubview:self.beginArrowImageView];
    [self.backView addSubview:self.lineView4];
    [self.backView addSubview:self.endTimeButton];
    [self.backView addSubview:self.endArrowImageView];
    [self.backView addSubview:self.lineView5];
    [self.backView addSubview:self.keyboardView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(ScreenW);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(14);
        make.left.mas_equalTo(self.backView).offset(20);
        make.height.mas_equalTo(24);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.equalTo(self.backView).offset(-10);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.oriPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView).offset(20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(32);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    
    [self.oriPriceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.oriPriceLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
        make.centerY.equalTo(self.oriPriceLabel);
        make.height.mas_equalTo(20);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView);
        make.right.mas_equalTo(self.backView);
        make.top.equalTo(self.oriPriceLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(1);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1.mas_bottom).offset(15);
        make.centerX.equalTo(self.backView);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
    }];
    
    [self.ratePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView).offset(20);
        make.top.equalTo(self.lineView2);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(56);
    }];
    
    [self.rateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ratePriceLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.lineView2.mas_left).offset(-10);
        make.centerY.equalTo(self.ratePriceLabel);
        make.height.mas_equalTo(20);
    }];
    
    [self.depositButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView2).offset(10);
        make.top.equalTo(self.lineView2);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    
    [self.depositTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.depositButton.mas_right).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
        make.centerY.equalTo(self.depositButton);
        make.height.mas_equalTo(20);
    }];
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ratePriceLabel.mas_bottom).offset(15);
        make.left.equalTo(self.backView);
        make.right.equalTo(self.backView);
        make.height.mas_equalTo(1);
    }];
    
    [self.lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView3.mas_bottom).offset(26);
        make.centerX.mas_equalTo(self.backView);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(1);
    }];
    
    [self.lineView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView4.mas_bottom).offset(26);
        make.left.equalTo(self.backView);
        make.right.equalTo(self.backView);
        make.height.mas_equalTo(0);
    }];
    
    [self.beginTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView).offset(20);
        make.top.equalTo(self.lineView3.mas_bottom).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.beginArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.beginTimeButton.mas_right).offset(10);
        make.centerY.equalTo(self.beginTimeButton);
    }];
    
    [self.endTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_centerX).offset(10);
        make.top.equalTo(self.lineView3.mas_bottom).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.endArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.endTimeButton.mas_right).offset(10);
        make.centerY.equalTo(self.endTimeButton);
    }];
    
    [self.keyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView5.mas_bottom);
        make.left.mas_equalTo(self.backView);
        make.right.mas_equalTo(self.backView);
        make.bottom.mas_equalTo(self.backView);
        make.height.mas_equalTo(209);
    }];
}
- (MCDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[MCDatePicker alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _datePicker.titleText = @"开始时间";
        
    }
    return _datePicker;
}
- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = HEXCOLOR(0xffffff);
        _backView.layer.cornerRadius = 8;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc]init];
        [_closeButton setImage:[UIImage imageNamed:@"c2c_class_alert_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:17];
        _titleLabel.text = @"快速调价";
    }
    return _titleLabel;
}

- (UILabel *)oriPriceLabel {
    if (_oriPriceLabel == nil) {
        _oriPriceLabel = [[UILabel alloc] init];
        _oriPriceLabel.textColor = HEXCOLOR(0x333333);
        _oriPriceLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _oriPriceLabel.text = @"起拍价(包邮)";
    }
    return _oriPriceLabel;
}

- (UITextField *)oriPriceTextField {
    if (_oriPriceTextField == nil) {
        _oriPriceTextField = [[UITextField alloc] init];
        _oriPriceTextField.borderStyle = UITextBorderStyleNone;
        _oriPriceTextField.text = @"¥";
        _oriPriceTextField.textColor = HEXCOLOR(0xf23730);
        _oriPriceTextField.font = [UIFont fontWithName:kFontNormal size:20];
        _oriPriceTextField.delegate = self;
        _oriPriceTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
        _oriPriceTextField.inputAccessoryView =  [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _oriPriceTextField;
}

- (UIView *)lineView1 {
    if (_lineView1 == nil) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = HEXCOLOR(0xd8d8d8);
    }
    return _lineView1;
}

- (UILabel *)ratePriceLabel {
    if (_ratePriceLabel == nil) {
        _ratePriceLabel = [[UILabel alloc] init];
        _ratePriceLabel.textColor = HEXCOLOR(0x333333);
        _ratePriceLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _ratePriceLabel.text = @"加价幅度";
    }
    return _ratePriceLabel;
}

- (UITextField *)rateTextField {
    if (_rateTextField == nil) {
        _rateTextField = [[UITextField alloc] init];
        _rateTextField.delegate = self;
        _rateTextField.borderStyle = UITextBorderStyleNone;
        _rateTextField.text = @"¥";
        _rateTextField.textColor = HEXCOLOR(0x333333);
        _rateTextField.font = [UIFont fontWithName:kFontNormal size:14];
        _rateTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
        _rateTextField.inputAccessoryView =  [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _rateTextField;
}

- (UIView *)lineView2 {
    if (_lineView2 == nil) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = HEXCOLOR(0xd8d8d8);
    }
    return _lineView2;
}

- (UIButton *)depositButton {
    if (_depositButton == nil) {
        _depositButton = [[UIButton alloc]init];
        [_depositButton setImage:[UIImage imageNamed:@"c2c_class_alert_alert"] forState:UIControlStateNormal];
        [_depositButton setTitle:@"买家保证金" forState:UIControlStateNormal];
        [_depositButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _depositButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _depositButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_depositButton addTarget:self action:@selector(alertButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_depositButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:15];
    }
    return _depositButton;
}

- (UITextField *)depositTextField {
    if (_depositTextField == nil) {
        _depositTextField = [[UITextField alloc] init];
        _depositTextField.delegate = self;
        _depositTextField.borderStyle = UITextBorderStyleNone;
        _depositTextField.text = @"¥";
        _depositTextField.textColor = HEXCOLOR(0x333333);
        _depositTextField.font = [UIFont fontWithName:kFontNormal size:14];
        _depositTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
        _depositTextField.inputAccessoryView =  [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _depositTextField;
}

- (UIView *)lineView3 {
    if (_lineView3 == nil) {
        _lineView3 = [[UIView alloc] init];
        _lineView3.backgroundColor = HEXCOLOR(0xd8d8d8);
    }
    return _lineView3;
}


- (UILabel *)beginTimeButton {
    if (_beginTimeButton == nil) {
        _beginTimeButton = [[UILabel alloc] init];
        _beginTimeButton.textColor = HEXCOLOR(0x333333);
        _beginTimeButton.font = [UIFont fontWithName:kFontNormal size:14];
        _beginTimeButton.text = @"选择开始时间";
        _beginTimeButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *begin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginTimeSelect)];
        [_beginTimeButton addGestureRecognizer:begin];
    }
    return _beginTimeButton;
}

- (UIImageView *)beginArrowImageView{
    if (_beginArrowImageView == nil) {
        _beginArrowImageView = [[UIImageView alloc] init];
        _beginArrowImageView.image = [UIImage imageNamed:@"c2c_class_alert_right"];
    }
    return _beginArrowImageView;
}


- (UIView *)lineView4 {
    if (_lineView4 == nil) {
        _lineView4 = [[UIView alloc] init];
        _lineView4.backgroundColor = HEXCOLOR(0xd8d8d8);
    }
    return _lineView4;
}

- (UILabel *)endTimeButton {
    if (_endTimeButton == nil) {
        _endTimeButton = [[UILabel alloc] init];
        _endTimeButton.textColor = HEXCOLOR(0x333333);
        _endTimeButton.font = [UIFont fontWithName:kFontNormal size:14];
        _endTimeButton.text = @"选择结束时间";
        _endTimeButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *begin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endTimeSelect)];
        [_endTimeButton addGestureRecognizer:begin];
    }
    return _endTimeButton;
}

- (UIImageView *)endArrowImageView{
    if (_endArrowImageView == nil) {
        _endArrowImageView = [[UIImageView alloc] init];
        _endArrowImageView.image = [UIImage imageNamed:@"c2c_class_alert_right"];
    }
    return _endArrowImageView;
}

- (UIView *)lineView5 {
    if (_lineView5 == nil) {
        _lineView5 = [[UIView alloc] init];
        _lineView5.backgroundColor = HEXCOLOR(0xd8d8d8);
    }
    return _lineView5;
}

- (JHNumberKeyboard *)keyboardView {
    if (_keyboardView == nil) {
        _keyboardView = [[JHNumberKeyboard alloc] init];
        @weakify(self);
        _keyboardView.handler = ^(NSString * _Nonnull text) {
            @strongify(self);
            [self textFieldChanged:text];
        };
    }
    return _keyboardView;
}

@end
