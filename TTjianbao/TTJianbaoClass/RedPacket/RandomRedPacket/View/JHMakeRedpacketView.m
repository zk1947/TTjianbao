//
//  JHMakeRedpacketView.m
//  TTjianbao
//
//  Created by Jesse on 2020/1/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMakeRedpacketView.h"
#import "JHUIFactory.h"
#import "JHPickerView.h"
#import "JHMakeRedpacketModel.h"
#import "NSString+Extension.h"

#define kPickerDefaultText @"请选择"
#define kValidTimeTips @"未领取的红包，将于24小时后退款"

@interface JHMakeRedpacketView () <UITextFieldDelegate, STPickerSingleDelegate>
{
    NSString* defaultWishes;
    UITextField* moneyTextField;
    UITextField* redpacketTotalTextField;
    UILabel* typeDescLabel;
    UILabel* moneyTotalLabel;
    UILabel* validTimeLabel;
    UIButton* timeButton;
    UIButton* conditionButton;
    UIButton* descTextButton;
    UIButton* chargeMoneyButton;
    JHMakeRedpacketPageModel* dataModel;
    NSInteger timeSelectedIndex;
    NSInteger conditionSelectedIndex;
    NSInteger descSelectedIndex;
    UIView* conditionBg;//动态显示有无
    UIView* redpacketTotalBg;
}
//这个picker封装的不太好,不使用多picker情况
@property (nonatomic, strong) JHPickerView* timePicker;
@property (nonatomic, strong) JHPickerView* conditionPicker;
@property (nonatomic, strong) JHPickerView* descPicker;
@end

@implementation JHMakeRedpacketView

- (instancetype)initWithDelegate:(id)aDelegate
{
    if(self = [super init])
    {
        self.delegate = aDelegate;
    }
    return self;
}

- (void)drawSubview
{
    self.backgroundColor = kColorF5F6FA;
    
    //money total
    UIView* moneyTotalBg = [self cellBackground];
    [moneyTotalBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
    }];
    
    UIImageView* moneyTag = [UIImageView new];
    [moneyTag setImage:[UIImage imageNamed:@"red_packet_pin"]];
    [moneyTotalBg addSubview:moneyTag];
    [moneyTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-19);
        make.size.mas_equalTo(12);
    }];
    
    UILabel* moneyTotalTag = [JHUIFactory createLabelWithTitle:@"总金额" titleColor:HEXCOLOR(0x333333) font:JHFont(15) textAlignment:NSTextAlignmentCenter];
    [moneyTotalBg addSubview:moneyTotalTag];
    [moneyTotalTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(moneyTag.mas_right).offset(3);
        make.top.mas_equalTo(15);
    }];
    
    UILabel* moneyUnitTag = [JHUIFactory createLabelWithTitle:@"元" titleColor:HEXCOLOR(0x333333) font:JHFont(15) textAlignment:NSTextAlignmentCenter];
    [moneyTotalBg addSubview:moneyUnitTag];
    [moneyUnitTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-10);
    }];
    
    moneyTextField = [self cellTextField];
    [moneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [moneyTotalBg addSubview:moneyTextField];
    [moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(moneyUnitTag.mas_left).offset(-5);
        make.width.mas_equalTo(ScreenW/2.0);
    }];
    
    //redpacket type descriptin
    typeDescLabel = [JHUIFactory createLabelWithTitle:@"此红包为拼手气红包" titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
    [self addSubview:typeDescLabel];
    [typeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(moneyTotalBg.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
    }];
    
    //redpacket total
    redpacketTotalBg = [self cellBackground];
    [redpacketTotalBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(moneyTotalBg.mas_bottom).offset(27);
    }];
    
    UILabel* redpacketTotalTag = [JHUIFactory createLabelWithTitle:@"红包个数" titleColor:HEXCOLOR(0x333333) font:JHFont(15) textAlignment:NSTextAlignmentLeft];
    [redpacketTotalBg addSubview:redpacketTotalTag];
    [redpacketTotalTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(10);
    }];
    
    UILabel* redpacketTotalUnitTag = [JHUIFactory createLabelWithTitle:@"个" titleColor:HEXCOLOR(0x333333) font:JHFont(15) textAlignment:NSTextAlignmentCenter];
    [redpacketTotalBg addSubview:redpacketTotalUnitTag];
    [redpacketTotalUnitTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-10);
    }];
    
    redpacketTotalTextField = [self cellTextField];
    redpacketTotalTextField.keyboardType = UIKeyboardTypeNumberPad;
    redpacketTotalTextField.placeholder = @"填写个数";
    [redpacketTotalBg addSubview:redpacketTotalTextField];
    [redpacketTotalTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(moneyUnitTag.mas_left).offset(-5);
        make.width.mas_equalTo(ScreenW/3.0);
    }];
    
    //condition
    conditionBg = [self cellBackground];
    [conditionBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(redpacketTotalBg.mas_bottom).offset(10);
    }];
    
    UILabel* conditionLabel = [JHUIFactory createLabelWithTitle:@"抢红包条件" titleColor:HEXCOLOR(0x333333) font:JHFont(15) textAlignment:NSTextAlignmentLeft];
    [conditionBg addSubview:conditionLabel];
    [conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(10);
    }];
    
    conditionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [conditionButton setTitle:kPickerDefaultText forState:UIControlStateNormal];
    [conditionButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    conditionButton.titleLabel.font = JHFont(15);
    [conditionButton setImage:[UIImage imageNamed:@"icon_shop_default"] forState:UIControlStateNormal];
    conditionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [conditionButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 3, 16)];
    [conditionButton setImageEdgeInsets:UIEdgeInsetsMake(6, kScreenWidth*2/3.0-8, 6, 3)];
    [conditionButton addTarget:self action:@selector(selectConditionButton:) forControlEvents:UIControlEventTouchUpInside];
    [conditionBg addSubview:conditionButton];
    [conditionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth*2/3.0, 20));
    }];
    
    //time
    UIView* timeBg = [self cellBackground];
    [timeBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(conditionBg.mas_bottom).offset(10);
    }];
    
    UILabel* timeLabel = [JHUIFactory createLabelWithTitle:@"有效时间" titleColor:HEXCOLOR(0x333333) font:JHFont(15) textAlignment:NSTextAlignmentLeft];
    [timeBg addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(10);
    }];
    
    timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [timeButton setTitle:kPickerDefaultText forState:UIControlStateNormal];
    [timeButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    timeButton.titleLabel.font = JHFont(15);
    [timeButton setImage:[UIImage imageNamed:@"icon_shop_default"] forState:UIControlStateNormal];
    [timeButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 3, 16)];
    [timeButton setImageEdgeInsets:UIEdgeInsetsMake(6, 72, 6, 3)];
    timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [timeButton addTarget:self action:@selector(selectTimeButton:) forControlEvents:UIControlEventTouchUpInside];
    [timeBg addSubview:timeButton];
    [timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(80, 20));//UI的宽度小了
    }];
    
    //Description
    UIView* descBg = [self cellBackground];
    [descBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeBg.mas_bottom).offset(10);
        make.height.mas_equalTo(60);
    }];
    
    descTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [descTextButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    descTextButton.titleLabel.font = JHFont(15);
    descTextButton.titleLabel.numberOfLines = 0;
    descTextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [descTextButton addTarget:self action:@selector(selectDescTextButton:) forControlEvents:UIControlEventTouchUpInside];
    [descBg addSubview:descTextButton];
    [descTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-19);
    }];
    
    UIImageView* imageView = [UIImageView new];
    [imageView setImage:[UIImage imageNamed:@"icon_shop_default"]];
    [descBg addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(descBg.centerY);
        make.right.mas_equalTo(-12);
    }];
    
    //￥money
    moneyTotalLabel = [JHUIFactory createLabelWithTitle:@"0.00" titleColor:HEXCOLOR(0x333333) font:JHDINBoldFont(47) textAlignment:NSTextAlignmentLeft];
    [self addSubview:moneyTotalLabel];
    [moneyTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(descBg.mas_bottom).offset(40);
        make.centerX.mas_equalTo(self.mas_centerX).offset(25/2.0);
    }];
    
    UILabel* moneyTagLabel = [JHUIFactory createLabelWithTitle:@"¥" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(25) textAlignment:NSTextAlignmentLeft];
    [self addSubview:moneyTagLabel];
    [moneyTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(moneyTotalLabel.mas_bottom).offset(-3);
        make.right.mas_equalTo(moneyTotalLabel.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(15, 36));
    }];
    
    //塞钱进红包
    chargeMoneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chargeMoneyButton.layer.cornerRadius = 20;
    chargeMoneyButton.backgroundColor = HEXCOLOR(0xEEEEEE);
    [chargeMoneyButton setTitle:@"塞钱进红包" forState:UIControlStateNormal];
    [chargeMoneyButton setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
    chargeMoneyButton.titleLabel.font = JHMediumFont(15);
    [chargeMoneyButton addTarget:self action:@selector(chargeMoneyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chargeMoneyButton];
    [chargeMoneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(moneyTotalLabel.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    UIImageView *tipsImageView = [[UIImageView alloc] init];
    tipsImageView.image = [UIImage imageNamed:@"jhPlayer_markRedPackage_tips"];
    [self addSubview:tipsImageView];
    [tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chargeMoneyButton.mas_bottom).offset(14.f);
        make.centerX.equalTo(chargeMoneyButton);
        make.size.mas_equalTo(CGSizeMake(223.f, 58.f));
    }];

    //有效期温馨提示
    validTimeLabel = [JHUIFactory createLabelWithTitle:kValidTimeTips titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentCenter];
    [self addSubview:validTimeLabel];
    [validTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15-UI.bottomSafeAreaHeight);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-10*2, 17));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}

- (UIView*)cellBackground
{
    UIView* background = [[UIView alloc] init];
    background.backgroundColor = HEXCOLOR(0xFFFFFF);
    background.layer.cornerRadius = 4.0;
    [self addSubview:background];
    [background mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self).offset(15);
         make.right.mas_equalTo(self).offset(-15);
         make.height.mas_equalTo(50);
     }];
    return background;
}

- (UITextField*)cellTextField
{
    UITextField* textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentRight;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.font = JHFont(15);
    textField.textColor = HEXCOLOR(0x333333);
    textField.placeholder = @"0.00";
    [textField placeHolderColor:HEXCOLOR(0x999999)];
    return textField;
}

- (JHPickerView *)timePicker
{
    if(!_timePicker)
       {
           _timePicker = [[JHPickerView alloc] init];
           _timePicker.widthPickerComponent = 300;
           _timePicker.delegate = self;
           [self addSubview:_timePicker];
       }
    return _timePicker;
}

- (JHPickerView *)conditionPicker
{
    if(!_conditionPicker)
       {
           _conditionPicker = [[JHPickerView alloc] init];
           _conditionPicker.widthPickerComponent = 300;
           _conditionPicker.delegate = self;
           [self addSubview:_conditionPicker];
       }
    return _conditionPicker;
}

- (JHPickerView *)descPicker
{
    if(!_descPicker)
       {
           _descPicker = [[JHPickerView alloc] init];
           _descPicker.widthPickerComponent = 300;
           _descPicker.delegate = self;
           [self addSubview:_descPicker];
       }
    return _descPicker;
}

#pragma mark - refresh view
- (void)refreshView:(JHMakeRedpacketPageModel*)model
{
    dataModel = model;
    moneyTextField.placeholder = [NSString stringWithFormat:@"总金额需大于等于%@", model.minAmountOfMoney ? : @"0.01"];
    redpacketTotalTextField.placeholder = [NSString stringWithFormat:@"需大于等于%zd", model.minCount ? : 3];
    validTimeLabel.text = model.tips ? : kValidTimeTips;
    //picker 数据源
    self.timePicker.arrayData = [self showValueArray:dataModel.validMinutesList];
    //条件
    if([dataModel.conditionList count] > 0)
    {
        self.conditionPicker.arrayData = [self showValueArray:dataModel.conditionList];
    }
    else
    {
        [conditionBg setHidden:YES];
        [conditionBg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(redpacketTotalBg.mas_bottom);
            make.height.mas_equalTo(0);
        }];
    }
    //寄语
    if([dataModel.wishesList count] > 0)
    {
        defaultWishes = [dataModel.wishesList firstObject];
        self.descPicker.arrayData = [NSMutableArray arrayWithArray: dataModel.wishesList];
    }
    else
    {
        defaultWishes = dataModel.defaultWishes;
    }
    [descTextButton setTitle:defaultWishes ? : kDefaultWishes forState:UIControlStateNormal];
}

- (NSMutableArray*)showValueArray:(NSArray<NSDictionary*>*)timeArr
{
    NSMutableArray* array = [NSMutableArray array];

    for (NSDictionary* dic in timeArr)
    {
        [array addObject:[dic objectForKey:@"value"]];
    }
    
    return array;
}

- (NSUInteger)keyOfArray:(NSArray*)array value:(NSString*)showValue
{
    NSUInteger keyUint = 0;
  
    for (NSDictionary* dic in array)
    {
        NSString* valueStr = [dic objectForKey:@"value"];
        if([valueStr isEqualToString:showValue])
        {
            keyUint = [[dic objectForKey:@"key"] integerValue];
            break;
        }
    }
    
    return keyUint;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0)
    {
        return YES;
    }
    
    if (textField == moneyTextField)
    {
        NSString* moneyStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        return [NSString validateMoney:moneyStr];
    }
    else if(textField == redpacketTotalTextField)
    {
        NSString* numStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        return [NSString validateNumbers:numStr];
    }
//    else if(textField == descTextField)
//    {
//        if(range.location >= dataModel.wishesLength)
//        {
//            return NO;
//        }
//    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if([textField.text length] > 0)
    {
        moneyTotalLabel.text = textField.text;
        chargeMoneyButton.backgroundColor = HEXCOLOR(0xFF4200);
    }
    else
    {
        moneyTotalLabel.text = @"0.00";
        chargeMoneyButton.backgroundColor = HEXCOLOR(0xEEEEEE);
    }
}

#pragma mark - STPickerSingleDelegate
- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    if(pickerSingle == self.timePicker)
    {
        if(selectedTitle)
        {
            timeSelectedIndex = pickerSingle.selectedIndex;
            [timeButton setTitle:selectedTitle forState:UIControlStateNormal];
            [timeButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        }
        else
        {
            [timeButton setTitle:kPickerDefaultText forState:UIControlStateNormal];
            [timeButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        }
    }
    else if(pickerSingle == self.conditionPicker)
    {
        if(selectedTitle)
        {
            conditionSelectedIndex = pickerSingle.selectedIndex;
            [conditionButton setTitle:selectedTitle forState:UIControlStateNormal];
            [conditionButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        }
        else
        {
            [conditionButton setTitle:kPickerDefaultText forState:UIControlStateNormal];
            [conditionButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        }
    }
    else if(pickerSingle == self.descPicker)
    {
        if(selectedTitle)
        {
            descSelectedIndex = pickerSingle.selectedIndex;
            [descTextButton setTitle:selectedTitle forState:UIControlStateNormal];
            [descTextButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        }
        else
        {
            [descTextButton setTitle:defaultWishes forState:UIControlStateNormal];
            [descTextButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        }
    }
}

#pragma mark - event
- (void)selectTimeButton:(UIButton*)button
{
    [self.timePicker selectRow:timeSelectedIndex inComponent:1 animated:YES];
    [self.timePicker show];
    [moneyTextField resignFirstResponder];
    [redpacketTotalTextField resignFirstResponder];
}

- (void)selectConditionButton:(UIButton*)button
{
    [self.conditionPicker selectRow:conditionSelectedIndex inComponent:1 animated:NO];
    [self.conditionPicker show];
    [moneyTextField resignFirstResponder];
    [redpacketTotalTextField resignFirstResponder];
}

- (void)selectDescTextButton:(UIButton*)button
{
    [self.descPicker selectRow:descSelectedIndex inComponent:1 animated:NO];
    [self.descPicker show];
    [moneyTextField resignFirstResponder];
    [redpacketTotalTextField resignFirstResponder];
}

- (void)chargeMoneyButton:(UIButton*)button
{
    if([moneyTotalLabel.text length] > 0)
    {
        CGFloat moneyTotal = [moneyTotalLabel.text floatValue];
        CGFloat minMoney = [dataModel.minAmountOfMoney floatValue];
        CGFloat maxMoney = [dataModel.maxAmountOfMoney floatValue];
        if(moneyTotal < minMoney)
        {
            NSString* txt = [NSString stringWithFormat:@"红包最低金额%.2f元", minMoney];
            [SVProgressHUD showInfoWithStatus:txt];
        }
        else if(moneyTotal > maxMoney)
        {
            NSString* txt = [NSString stringWithFormat:@"红包最高金额%.2f元", maxMoney];
            [SVProgressHUD showInfoWithStatus:txt];
        }
        else if([redpacketTotalTextField.text length] > 0)
        {
            NSInteger total = [redpacketTotalTextField.text intValue];
            NSInteger minCount = dataModel.minCount;
            NSInteger maxCount = dataModel.maxCount;
            if(total < minCount)
            {
                NSString* txt = [NSString stringWithFormat:@"红包个数不小于%zd个", minCount];
                [SVProgressHUD showInfoWithStatus:txt];
            }
            else if(total > maxCount)
            {
                NSString* txt = [NSString stringWithFormat:@"红包个数不大于%zd个", maxCount];
                [SVProgressHUD showInfoWithStatus:txt];
            }
            else
            {
                if([dataModel.conditionList count] > 0 && [conditionButton.titleLabel.text isEqualToString:kPickerDefaultText])
                {
                    [SVProgressHUD showInfoWithStatus:@"请选择抢红包条件"];
                }
                else if([timeButton.titleLabel.text isEqualToString:kPickerDefaultText])
                {
                    [SVProgressHUD showInfoWithStatus:@"请选择红包有效时间"];
                }
                else if([self.delegate respondsToSelector:@selector(chargeMoneyIntoRedpacket:)])
                {
                    JHMakeRedpacketReqModel* model = [JHMakeRedpacketReqModel new];
                    model.amountOfMoney = moneyTotalLabel.text;
                    model.totalCount = [redpacketTotalTextField.text integerValue];
                    model.validMinutes = [self keyOfArray:dataModel.validMinutesList value:timeButton.titleLabel.text];
                    model.takeCondition = [self keyOfArray:dataModel.conditionList value:conditionButton.titleLabel.text];
                    model.wishes = [descTextButton.titleLabel.text length] > 0 ? descTextButton.titleLabel.text : defaultWishes;
                    [self.delegate chargeMoneyIntoRedpacket:model];
                }
            }
        }
        else
        {
            NSString* txt = [NSString stringWithFormat:@"红包个数不小于%zd个", dataModel.minCount];
            [SVProgressHUD showInfoWithStatus:txt];
        }
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"请输入红包金额"];
    }
}

@end
