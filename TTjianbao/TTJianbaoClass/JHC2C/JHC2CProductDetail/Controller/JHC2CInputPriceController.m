//
//  JHC2CInputPriceController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CInputPriceController.h"
#import "IQKeyboardManager.h"
#import "JHNumberKeyboard.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHC2CSureMoneyAlertController.h"


@interface JHC2CInputPriceController ()<UITextFieldDelegate>

@property(nonatomic, strong) UIButton * inputView;

@property(nonatomic, strong) UIView * noticeServerPriceView;


@property(nonatomic, strong) UIButton * menuOneBtn;
@property(nonatomic, strong) UIButton * menuTwoBtn;
@property(nonatomic, strong) UIButton * closeBtn;
@property(nonatomic, strong) UIView * seltedView;

///一口价
@property(nonatomic, strong) UIView * bottom1View;
@property(nonatomic, strong) UITextField * priceTFd1;
@property(nonatomic, strong) UITextField * orignPriceTFd1;
@property(nonatomic, strong) UITextField * postPriceTFd1;
///包邮按钮
@property(nonatomic, strong) UIButton * postBtn;



///竞拍
@property(nonatomic, strong) UIView * bottom2View;
@property(nonatomic, strong) UITextField * priceTFd2;
@property(nonatomic, strong) UITextField * orignPriceTFd2;
@property(nonatomic, strong) UITextField * postPriceTFd2;
///开始时间
@property(nonatomic, strong) UIButton * begionTimeBtn;
///结束时间
@property(nonatomic, strong) UIButton * endTimeBtn;


@property(nonatomic, strong) UIView * timeView;
@property(nonatomic, strong) UIDatePicker * dataPick;

@property(nonatomic, strong) NSString * beginTime;
@property(nonatomic, strong) NSString * endTime;

@property(nonatomic, strong) NSDate * begionDate;
@property(nonatomic, strong) JHNumberKeyboard * keyboardView;

@property(nonatomic, strong) UIButton * depositButton;

@property(nonatomic, strong) UIButton * disApperBtn;

@property(nonatomic, strong) UIView * alertRulerView;

@property(nonatomic, strong) JHIssueGoodsEditModel *myModel;

@end

@implementation JHC2CInputPriceController

///数据回显
- (void)reloadUIData:(NSDictionary *)param{
    //productType(0一口价 priceDic  1拍卖 auctionDic)
    if ([param[@"productType"] integerValue] == 0) {
        //一口价信息 price  originPrice   freight    needFreight 0  1
        [self changePriceType:YES];
        NSDictionary *priceDic = param[@"priceDic"];
        if (priceDic.allKeys.count>0) {
            NSNumber *num1 = priceDic[@"price"];
            NSNumber *num2 = priceDic[@"originPrice"];
            NSNumber *num3 = priceDic[@"freight"];
            self.priceTFd1.text = [self changeNumToStr:num1];
            self.orignPriceTFd1.text = [self changeNumToStr:num2];
            self.postPriceTFd1.text = [self changeNumToStr:num3];
            self.postBtn.selected = [priceDic[@"needFreight"] integerValue] == 1 ? NO:YES;
        }
    }else{
        //拍卖信息 startPrice  bidIncrement   earnestMoney   auctionStartTime   auctionEndTime
        [self changePriceType:NO];
        NSDictionary *auctionDic = param[@"auctionDic"];
        if (auctionDic.allKeys.count>0) {
            NSNumber *num1 = auctionDic[@"startPrice"];
            NSNumber *num2 = auctionDic[@"bidIncrement"];
            NSNumber *num3 = auctionDic[@"earnestMoney"];
            self.priceTFd2.text = [self changeNumToStr:num1];
            self.orignPriceTFd2.text = [self changeNumToStr:num2];
            self.postPriceTFd2.text = [self changeNumToStr:num3];
            ///开始时间
            NSString *startStr = auctionDic[@"auctionStartTime"];
            [self.begionTimeBtn setTitle:startStr forState:UIControlStateSelected];
            self.begionTimeBtn.selected = startStr.length > 0 ?YES:NO;
            self.beginTime = auctionDic[@"auctionStartTime"];
            ///结束时间
            NSString *endStr = auctionDic[@"auctionEndTime"];
            [self.endTimeBtn setTitle:endStr forState:UIControlStateSelected];
            self.endTimeBtn.selected = endStr.length > 0 ?YES:NO;
            self.endTime = auctionDic[@"auctionEndTime"];
        }
    }
}

- (void)reloadNetUIData:(JHIssueGoodsEditModel *)model{
    _myModel = model;
    if (model.productType == 0) {
        //一口价信息 price  originPrice   freight    needFreight 0  1
        [self changePriceType:YES];
        NSDictionary *priceDic = model.price;
        if (priceDic.allKeys.count>0) {
            NSNumber *num1 = priceDic[@"price"];
            NSNumber *num2 = priceDic[@"originPrice"];
            NSNumber *num3 = priceDic[@"freight"];
            self.priceTFd1.text = [self changeNumToStr:num1];
            self.orignPriceTFd1.text = [self changeNumToStr:num2];
            self.postPriceTFd1.text = [self changeNumToStr:num3];
            self.postBtn.selected = [priceDic[@"needFreight"] integerValue] == 1 ? NO:YES;
        }
    }else{
        //拍卖信息 startPrice  bidIncrement   earnestMoney   auctionStartTime   auctionEndTime
        [self changePriceType:NO];
        NSDictionary *auctionDic = model.auction;
        if (auctionDic.allKeys.count>0) {
            NSNumber *num1 = auctionDic[@"startPrice"];
            NSNumber *num2 = auctionDic[@"bidIncrement"];
            NSNumber *num3 = auctionDic[@"earnestMoney"];
            self.priceTFd2.text = [self changeNumToStr:num1];
            self.orignPriceTFd2.text = [self changeNumToStr:num2];
            self.postPriceTFd2.text = [self changeNumToStr:num3];
            ///开始时间
            NSString *startStr = auctionDic[@"auctionStartTime"];
            [self.begionTimeBtn setTitle:startStr forState:UIControlStateSelected];
            self.begionTimeBtn.selected = startStr.length > 0 ?YES:NO;
            self.beginTime = auctionDic[@"auctionStartTime"];
            ///结束时间
            NSString *endStr = auctionDic[@"auctionEndTime"];
            [self.endTimeBtn setTitle:endStr forState:UIControlStateSelected];
            self.endTimeBtn.selected = endStr.length > 0 ?YES:NO;
            self.endTime = auctionDic[@"auctionEndTime"];
        }
    }
    
}

///将以分为单位的number转换成以元为单位的字符串
- (NSString *)changeNumToStr:(NSNumber *)num{
    //将分转为元为单位
    NSString *numStr = nil;
    numStr = [NSString stringWithFormat:@"%ld",num.integerValue/100];
    if (num.integerValue%100 == 0) {//整数
        return numStr;
    }
    if (num.integerValue%10 == 0) {//有一位小数
        numStr = [NSString stringWithFormat:@"%@.%ld",numStr,num.integerValue/10%10];
        return numStr;
    }
    //有两位小数
    numStr = [NSString stringWithFormat:@"%@.%ld",numStr,num.integerValue%100];
    return numStr;
}

- (instancetype)init{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setItems];
    [self layoutItems];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = NO;
    IQKeyboardManager.sharedManager.enable = NO;
    [self.priceTFd1 becomeFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        self.inputView.transform = CGAffineTransformMakeTranslation(0, - 419 - UI.bottomSafeAreaHeight);
        self.noticeServerPriceView.transform = CGAffineTransformMakeTranslation(0,- 419 - UI.bottomSafeAreaHeight);
        self.keyboardView.transform = CGAffineTransformMakeTranslation(0,- 419 - UI.bottomSafeAreaHeight);
    }];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    IQKeyboardManager.sharedManager.enable = YES;
}


- (void)closeActionWithSender:(UIButton*)sender{
    [UIView animateWithDuration:0.3f animations:^{
        self.inputView.transform = CGAffineTransformIdentity;
        self.noticeServerPriceView.transform = CGAffineTransformIdentity;
        self.keyboardView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }];

}

- (void)regiAllTextField{
    if (self.orignPriceTFd1.isFirstResponder) {
        [self.orignPriceTFd1 resignFirstResponder];
    } else if(self.orignPriceTFd2.isFirstResponder){
        [self.orignPriceTFd2 resignFirstResponder];
    } else  if(self.priceTFd1.isFirstResponder){
        [self.priceTFd1 resignFirstResponder];
    } else if(self.priceTFd2.isFirstResponder){
        [self.priceTFd2 resignFirstResponder];
    } else if(self.postPriceTFd1.isFirstResponder){
        [self.postPriceTFd1 resignFirstResponder];
    } else if(self.postPriceTFd2.isFirstResponder){
        [self.postPriceTFd2 resignFirstResponder];
    }
    [self closeActionWithSender:nil];
}

- (void)changeMode:(UIButton*)sender{
    //编辑模式禁止切换
    if (_isEdit){
        NSString *msgStr = _myModel.productType == 0 ? @"您编辑的是一口价商品，不能修改为拍卖商品":@"您编辑的是拍卖商品，不能修改为一口价商品";
        [self.view makeToast:msgStr duration:1.0 position:CSToastPositionCenter];
    }else{
        BOOL isLeft = sender.tag == 0;
        [self changePriceType:isLeft];
    }
}

- (void)changePriceType:(BOOL)isLeft{
    UIButton *sender = isLeft ? _menuOneBtn : _menuTwoBtn;
    self.menuOneBtn.selected = isLeft;
    self.menuTwoBtn.selected = !isLeft;
    self.bottom1View.hidden = !isLeft;
    self.bottom2View.hidden = isLeft;
    if (isLeft) {
        [self.priceTFd1 becomeFirstResponder];
    }else{
        [self.priceTFd2 becomeFirstResponder];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.seltedView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0).offset(46);
            make.size.mas_equalTo(CGSizeMake(28, 4));
            make.centerX.equalTo(sender);
        }];
        [self.inputView setNeedsLayout];
        [self.inputView layoutIfNeeded];
    }];
}

- (BOOL)checkData{
    BOOL yiKouJia = self.menuOneBtn.selected;
    BOOL ok = NO;
    if (yiKouJia) {
        BOOL isneed = self.postPriceTFd1.text.length;
        if (self.postBtn.isSelected) {
            isneed = YES;
        }
        if (self.priceTFd1.text.length && isneed) {
            ok = YES;
        }else{
            NSString * notice = self.priceTFd1.text.length ? @"请输入运费" : @"请输入价格";
            [SVProgressHUD showErrorWithStatus:notice];
        }
        
        if (isneed & ([self.postPriceTFd1.text intValue] > 200)) {
            ok = NO;
            [self.view makeToast:@"运费不能超过200元" duration:1.0 position:CSToastPositionCenter];
        }
        
    }else{
        if (self.priceTFd2.text.length && self.orignPriceTFd2.text.length && self.beginTime.length && self.endTime.length) {
            ok = YES;
        }else{
            if (!self.priceTFd2.text.length) {
                [SVProgressHUD showErrorWithStatus:@"请输入起拍价"];
            }else if(!self.orignPriceTFd2.text.length){
                [SVProgressHUD showErrorWithStatus:@"请输入加价幅度"];
            }else if(!self.beginTime.length){
                [SVProgressHUD showErrorWithStatus:@"请选择开始时间"];
            }else{
                [SVProgressHUD showErrorWithStatus:@"请选择结束时间"];
            }
        }
    }
    return ok;
}

- (void)postActionWithSender:(UIButton*)sender{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.postPriceTFd1.text = nil;
        if (self.postPriceTFd1.isFirstResponder) {
            [self.priceTFd1 becomeFirstResponder];
        }
        self.postPriceTFd1.enabled = NO;
    }else{
        self.postPriceTFd1.enabled = YES;
    }
}

// 输入框改变
- (void)textFieldChanged:(NSString *)textString {
    UITextField *editTextField = [[UITextField alloc] init];
    if (self.orignPriceTFd1.isFirstResponder) {
        editTextField = self.orignPriceTFd1;
    } else if(self.orignPriceTFd2.isFirstResponder){
        editTextField = self.orignPriceTFd2;
    } else  if(self.priceTFd1.isFirstResponder){
        editTextField = self.priceTFd1;
    } else if(self.priceTFd2.isFirstResponder){
        editTextField = self.priceTFd2;
    } else if(self.postPriceTFd1.isFirstResponder){
        editTextField = self.postPriceTFd1;
    } else if(self.postPriceTFd2.isFirstResponder){
        editTextField = self.postPriceTFd2;
    }
    
    if (textString.integerValue == 13) {  //删除
        if (editTextField.text > 0) {
            editTextField.text = [editTextField.text substringToIndex:[editTextField.text length] - 1];
        }
    } else if(textString.integerValue == 10) {
        editTextField.text = [editTextField.text stringByAppendingString:@"."];
    } else if(textString.integerValue == 12) { //退下键盘
        [self regiAllTextField];
    } else if(textString.integerValue == 14) { //完成
        [self finishAction];
    } else {
        NSInteger count = editTextField.text.length;
        if ([editTextField.text containsString:@"."]) {
            if (count <= 8) {
                editTextField.text = [editTextField.text stringByAppendingString:textString];
            }
        }else{
            if (count <= 5) {
                editTextField.text = [editTextField.text stringByAppendingString:textString];
            }
        }
    }
    
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


- (void)setItems{
    self.view.backgroundColor = HEXCOLORA(0x000000, 0.4);
    self.disApperBtn = [UIButton new];
    [self.disApperBtn addTarget:self action:@selector(closeActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.disApperBtn];
    self.noticeServerPriceView = [self getPriceView];
    [self.view addSubview:self.noticeServerPriceView];
    
    [self.view addSubview:self.inputView];
    [self.inputView addSubview:self.closeBtn];
    [self.inputView addSubview:self.menuOneBtn];
    [self.inputView addSubview:self.menuTwoBtn];
    [self.inputView addSubview:self.seltedView];
    [self.inputView addSubview:self.bottom1View];
    [self.inputView addSubview:self.bottom2View];
    [self.view addSubview:self.keyboardView];
    [self.noticeServerPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(113, 37));
        make.top.equalTo(self.inputView).offset(-27);
        make.left.equalTo(@0);
    }];
}

- (void)layoutItems{
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@0);
        make.top.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(210);
    }];
    [self.disApperBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(@0);
        make.height.mas_equalTo((kScreenHeight - 210 - 209 - UI.bottomSafeAreaHeight));
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.menuOneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(45, 54));
        make.left.equalTo(@0).offset(35);
    }];
    [self.menuTwoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(45, 54));
        make.left.equalTo(self.menuOneBtn.mas_right).offset(50);
    }];
    [self.seltedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(46);
        make.size.mas_equalTo(CGSizeMake(28, 4));
        make.centerX.equalTo(self.menuOneBtn);
    }];
    
    [self.bottom1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(54);
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(157);
    }];
    [self.bottom2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(54);
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(157);
    }];
    
    [self.keyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(209 + UI.bottomSafeAreaHeight);
    }];
}


- (void)showBegionTimeFill{
    [self showPickViewWithStartTime];
}

- (void)showEndTimeFill{
    if (!self.beginTime.length) {
        [SVProgressHUD showInfoWithStatus:@"请先选择开始时间"];
    }else{
        [self showPickViewWithEndTime];
    }
}

- (void)finishSelTime:(UIButton*)sender{
    NSDate *date = self.dataPick.date;
    NSTimeInterval sec = [date timeIntervalSinceDate:self.dataPick.minimumDate];
    if (sec < 0) {
        date = self.dataPick.minimumDate;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *time = [formatter stringFromDate:date];
    if (sender.tag == 0) {
        [self.begionTimeBtn setTitle:time forState:UIControlStateSelected];
        self.begionTimeBtn.selected = YES;
        self.beginTime = time;
        self.begionDate = date;
        self.endTimeBtn.selected = NO;
        self.endTime = nil;
    }else{
        [self.endTimeBtn setTitle:time forState:UIControlStateSelected];
        self.endTimeBtn.selected = YES;
        self.endTime = time;
    }
    [self.timeView removeFromSuperview];
    self.timeView = nil;
}


- (void)showPickViewWithStartTime{
    
    UIView *backView = [UIView new];
    backView.backgroundColor = HEXCOLORA(0x000000, 0.3);
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    UIView *timeView = [UIView new];
    timeView.backgroundColor = UIColor.whiteColor;
    [backView addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(@0);
        make.height.mas_equalTo(209 + UI.bottomSafeAreaHeight);
    }];
    NSString *title =  @"开始时间";
    UILabel *titleLbl = [self getLabelWithFont:JHFont(16) andColor:HEXCOLOR(0x333333) andText:title];
    [timeView addSubview:titleLbl];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(finishSelTime:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 0 ;
    [timeView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(btn);
    }];

    UIDatePicker * picker = [[UIDatePicker alloc] init];
    if (@available(iOS 13.4, *)) {
        picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
    }
    //设置地区: zh-中国
    picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    // 设置当前显示时间
    [picker setDate:[NSDate date] animated:YES];
    // 设置显示最大时间（此处为当前时间）
    NSDate *minBegionTime = [[NSDate date] dateByAddingMinutes:15];
    [picker setMinimumDate:minBegionTime];
    NSDate *maxBegionTime = [minBegionTime dateByAddingDays:3];
    [picker setMaximumDate:maxBegionTime];
    [timeView addSubview:picker];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@0);
        make.top.equalTo(titleLbl.mas_bottom);
        make.height.mas_equalTo(150);
    }];
    self.timeView = backView;
    self.dataPick = picker;
}

- (void)showPickViewWithEndTime{
    UIView *backView = [UIView new];
    backView.backgroundColor = HEXCOLORA(0x000000, 0.3);
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    UIView *timeView = [UIView new];
    timeView.backgroundColor = UIColor.whiteColor;
    [backView addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(@0);
        make.height.mas_equalTo(209 + UI.bottomSafeAreaHeight);
    }];
    NSString *title = @"结束时间";
    UILabel *titleLbl = [self getLabelWithFont:JHFont(16) andColor:HEXCOLOR(0x333333) andText:title];
    [timeView addSubview:titleLbl];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(finishSelTime:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 1;
    [timeView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(btn);
    }];

    UIDatePicker * picker = [[UIDatePicker alloc] init];
    if (@available(iOS 13.4, *)) {
        picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
    }
    
    //设置地区: zh-中国
    picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    // 设置当前显示时间
    [picker setDate:[NSDate date] animated:YES];
    // 设置显示最大时间（此处为当前时间）
    NSDate *minBegionTime = [self.begionDate dateByAddingMinutes:30];
    [picker setMinimumDate:minBegionTime];
    NSDate *maxBegionTime = [self.begionDate dateByAddingDays:3];
    [picker setMaximumDate:maxBegionTime];

    [timeView addSubview:picker];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@0);
        make.top.equalTo(titleLbl.mas_bottom);
        make.height.mas_equalTo(150);
    }];
    self.timeView = backView;
    self.dataPick = picker;

}



#pragma mark -- <UITextFieldDelegate>

- (void)finishAction{
    if (self.timeView) {return;}
    //检查数据
    BOOL success = [self checkData];
    if (success) {
        //
        if (self.finish) {
            if (self.menuOneBtn.selected) {
                self.finish(YES, self.priceTFd1.text, self.orignPriceTFd1.text, self.postPriceTFd1.text, self.postBtn.selected, self.beginTime, self.endTime);
                self.priceTFd2.text = nil;
                self.orignPriceTFd2.text = nil;
                self.postPriceTFd2.text = nil;
                self.beginTime = nil;
                self.endTime = nil;
                self.begionTimeBtn.selected = NO;
                self.endTimeBtn.selected = NO;
            }else{
                self.finish(NO, self.priceTFd2.text, self.orignPriceTFd2.text, self.postPriceTFd2.text, self.postBtn.selected, self.beginTime, self.endTime);
                self.priceTFd1.text = nil;
                self.orignPriceTFd1.text = nil;
                self.postPriceTFd1.text = nil;
                self.postBtn.selected = NO;
            }
            
        }
        [self regiAllTextField];
    }
}

#pragma mark -- <set and get>


- (UIButton *)inputView{
    if (!_inputView) {
        UIButton *view = [UIButton new];
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 10;
        _inputView = view;
    }
    return _inputView;
}

- (UIView*)getPriceView{
    UIView *priceView = [UIView new];
    priceView.backgroundColor = HEXCOLOR(0xEBE1D3);
    priceView.layer.cornerRadius = 5;
    UILabel *label2 = [self getLabelWithFont:JHFont(11) andColor:HEXCOLOR(0x7B541D) andText:@"2%的技术服务费"];
    [priceView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(6);
        make.centerX.equalTo(@0);
    }];
    return priceView;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"orderPopView_closeIcon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(regiAllTextField) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = btn;
    }
    return _closeBtn;
}

- (UIButton *)menuOneBtn{
    if (!_menuOneBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *strSel = [[NSMutableAttributedString alloc] initWithString:@"一口价" attributes:@{NSFontAttributeName: JHMediumFont(15),NSForegroundColorAttributeName: HEXCOLOR(0x333333)
        }];
        [btn setAttributedTitle:strSel forState:UIControlStateSelected];
        NSMutableAttributedString *strNor = [[NSMutableAttributedString alloc] initWithString:@"一口价" attributes:@{NSFontAttributeName: JHFont(15),NSForegroundColorAttributeName: HEXCOLOR(0x666666)
        }];
        [btn setAttributedTitle:strNor forState:UIControlStateNormal];
        btn.tag = 0;
        [btn addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventTouchUpInside];
        btn.selected = YES;
        _menuOneBtn = btn;
    }
    return _menuOneBtn;
}

- (UIButton *)menuTwoBtn{
    if (!_menuTwoBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *strSel = [[NSMutableAttributedString alloc] initWithString:@"上拍卖" attributes:@{NSFontAttributeName: JHMediumFont(15),NSForegroundColorAttributeName: HEXCOLOR(0x333333)
        }];
        [btn setAttributedTitle:strSel forState:UIControlStateSelected];
        NSMutableAttributedString *strNor = [[NSMutableAttributedString alloc] initWithString:@"上拍卖" attributes:@{NSFontAttributeName: JHFont(15),NSForegroundColorAttributeName: HEXCOLOR(0x666666)
        }];
        [btn setAttributedTitle:strNor forState:UIControlStateNormal];
        btn.tag = 1;
        [btn addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventTouchUpInside];
        _menuTwoBtn = btn;
    }
    return _menuTwoBtn;
}
- (UIView *)seltedView{
    if (!_seltedView) {
        UIView *view = [UIView new];
        view.layer.cornerRadius = 2;
        view.backgroundColor = HEXCOLOR(0xFFD70F);
        _seltedView = view;
    }
    return _seltedView;
}

- (UIView *)bottom1View{
    if (!_bottom1View) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        
        UIView *oneRegionView = [UIView new];
        UIView *twoRegionView = [UIView new];
        UIView *thirdRegionView = [UIView new];
        [view addSubview:oneRegionView];
        [view addSubview:twoRegionView];
        [view addSubview:thirdRegionView];
        [oneRegionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(@0);
            make.height.mas_equalTo(51);
        }];
        [twoRegionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(oneRegionView.mas_bottom);
            make.height.mas_equalTo(51);
        }];
        [thirdRegionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(@0);
            make.top.equalTo(twoRegionView.mas_bottom);
        }];
        
        UILabel *label1 = [self getLabelWithFont:JHFont(14) andColor:HEXCOLOR(0x333333) andText:@"* 价格"];
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:label1.text];
        [attText addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xF23730) range:NSMakeRange(0, 1)];
        label1.attributedText = attText;
        [oneRegionView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0).offset(20);
            make.centerY.equalTo(@0);
        }];
        UILabel *priceLbl1 = [self getLabelWithFont:JHBoldFont(20) andColor:HEXCOLOR(0xF23730) andText:@"￥"];
        [oneRegionView addSubview:priceLbl1];
        [priceLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0).offset(80);
            make.centerY.equalTo(@0);
        }];
        
        self.priceTFd1 = [self getTextField];
        self.priceTFd1.font = [UI getDINBoldFont:20];
        self.priceTFd1.textColor = HEXCOLOR(0xF23730);
        [oneRegionView addSubview:self.priceTFd1];
        [self.priceTFd1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceLbl1.mas_right).offset(5);
            make.centerY.equalTo(@0);
            make.width.mas_equalTo(100);
        }];
        UIView *lineview1 = [self getLineView];
        [oneRegionView addSubview:lineview1];
        [lineview1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(oneRegionView);
            make.height.mas_equalTo(0.5);
        }];

        
        UILabel *label2 = [self getLabelWithFont:JHFont(14) andColor:HEXCOLOR(0x333333) andText:@"入手价"];
        [twoRegionView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0).offset(20);
            make.centerY.equalTo(@0);
        }];
        UILabel *priceLbl2 = [self getLabelWithFont:JHFont(14) andColor:HEXCOLOR(0x999999) andText:@"￥"];
        [twoRegionView addSubview:priceLbl2];
        [priceLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0).offset(85);
            make.centerY.equalTo(@0);
        }];

        self.orignPriceTFd1 = [self getTextField];
        [twoRegionView addSubview:self.orignPriceTFd1];
        [self.orignPriceTFd1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceLbl2.mas_right).offset(5);
            make.centerY.equalTo(@0);
            make.width.mas_equalTo(100);
        }];
        UIView *lineview2 = [self getLineView];
        [twoRegionView addSubview:lineview2];
        [lineview2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(twoRegionView);
            make.height.mas_equalTo(0.5);
        }];


        UILabel *label3 = [self getLabelWithFont:JHFont(14) andColor:HEXCOLOR(0x333333) andText:@"* 运费"];
        NSMutableAttributedString *attText3 = [[NSMutableAttributedString alloc] initWithString:label3.text];
        [attText3 addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xF23730) range:NSMakeRange(0, 1)];
        label3.attributedText = attText3;
        [thirdRegionView addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0).offset(20);
            make.centerY.equalTo(@0);
        }];
        UILabel *priceLbl3 = [self getLabelWithFont:JHFont(14) andColor:HEXCOLOR(0x999999) andText:@"￥"];
        [thirdRegionView addSubview:priceLbl3];
        [priceLbl3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0).offset(85);
            make.centerY.equalTo(@0);
        }];

        self.postPriceTFd1 = [self getTextField];
        [thirdRegionView addSubview:self.postPriceTFd1];
        [self.postPriceTFd1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceLbl3.mas_right).offset(5);
            make.centerY.equalTo(@0);
            make.width.mas_equalTo(100);
        }];
        UIView *lineview3 = [self getLineView];
        [thirdRegionView addSubview:lineview3];
        [lineview3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(thirdRegionView);
            make.height.mas_equalTo(0.5);
        }];
        
        [thirdRegionView addSubview:self.postBtn];
        [self.postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.right.equalTo(@0).offset(-15);
            make.width.mas_equalTo(60);
        }];
        
        
        _bottom1View = view;
    }
    return _bottom1View;
}

- (UIView *)bottom2View{
    if (!_bottom2View) {
        UIView *view = [UIView new];
        view.hidden = YES;
        view.backgroundColor = UIColor.whiteColor;
        
        UIView *oneRegionView = [UIView new];
        UIView *twoRegionView = [UIView new];
        UIView *thirdRegionView = [UIView new];
        [view addSubview:oneRegionView];
        [view addSubview:twoRegionView];
        [view addSubview:thirdRegionView];
        [oneRegionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(@0);
            make.height.mas_equalTo(@51);
        }];
        [twoRegionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(oneRegionView.mas_bottom);
            make.height.mas_equalTo(@51);
        }];
        [thirdRegionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(@0);
            make.top.equalTo(twoRegionView.mas_bottom);
        }];

        
        UILabel *label1 = [self getLabelWithFont:JHFont(14) andColor:HEXCOLOR(0x333333) andText:@"* 起拍价(包邮)"];
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:label1.text];
        [attText addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xF23730) range:NSMakeRange(0, 1)];
        label1.attributedText = attText;
        [oneRegionView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0).offset(20);
            make.centerY.equalTo(@0);
        }];
        UILabel *priceLbl1 = [self getLabelWithFont:JHBoldFont(20) andColor:HEXCOLOR(0xF23730) andText:@"￥"];
        [oneRegionView addSubview:priceLbl1];
        [priceLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label1.mas_right).offset(15);
            make.centerY.equalTo(@0);
        }];
        

        self.priceTFd2 = [self getTextField];
        self.priceTFd2.font = [UI getDINBoldFont:20];
        self.priceTFd2.textColor = HEXCOLOR(0xF23730);
        [oneRegionView addSubview:self.priceTFd2];
        [self.priceTFd2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceLbl1.mas_right).offset(5);
            make.centerY.equalTo(@0);
            make.width.mas_equalTo(100);
        }];
        UIView *lineview1 = [self getLineView];
        [oneRegionView addSubview:lineview1];
        [lineview1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(oneRegionView);
            make.height.mas_equalTo(0.5);
        }];

        
        UILabel *label2 = [self getLabelWithFont:JHFont(14) andColor:HEXCOLOR(0x333333) andText:@"* 加价幅度"];
        NSMutableAttributedString *attText2 = [[NSMutableAttributedString alloc] initWithString:label2.text];
        [attText2 addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xF23730) range:NSMakeRange(0, 1)];
        label2.attributedText = attText2;
        [twoRegionView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0).offset(20);
            make.centerY.equalTo(@0);
        }];
        UILabel *priceLbl2 = [self getLabelWithFont:JHFont(14) andColor:HEXCOLOR(0x999999) andText:@"￥"];
        [twoRegionView addSubview:priceLbl2];
        [priceLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label2.mas_right).offset(15);
            make.centerY.equalTo(@0);
        }];

        self.orignPriceTFd2 = [self getTextField];
        [twoRegionView addSubview:self.orignPriceTFd2];
        [self.orignPriceTFd2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceLbl2.mas_right).offset(5);
            make.centerY.equalTo(@0);
            make.width.mas_equalTo(80);
        }];
        UIView *lineview2 = [self getLineView];
        [twoRegionView addSubview:lineview2];
        [lineview2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(twoRegionView);
            make.height.mas_equalTo(0.5);
        }];

        UIView *vLineview = [self getLineView];
        [twoRegionView addSubview:vLineview];
        [vLineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0).offset((kScreenWidth - 20)/2.0);
            make.centerY.equalTo(@0);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(20);
        }];


//        UILabel *label3 = [self getLabelWithFont:JHFont(12) andColor:HEXCOLOR(0x333333) andText:@"买家保证金"];
        [twoRegionView addSubview:self.depositButton];
        [self.depositButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(vLineview).offset(12);
            make.centerY.equalTo(@0);
            make.width.mas_equalTo(80);
        }];
        UILabel *priceLbl3 = [self getLabelWithFont:JHFont(14) andColor:HEXCOLOR(0x999999) andText:@"￥"];
        [twoRegionView addSubview:priceLbl3];
        [priceLbl3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.depositButton.mas_right).offset(5);
            make.centerY.equalTo(@0);
        }];

        self.postPriceTFd2 = [self getTextField];
        [twoRegionView addSubview:self.postPriceTFd2];
        [self.postPriceTFd2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceLbl3.mas_right).offset(5);
            make.centerY.equalTo(@0);
            make.width.mas_equalTo(80);
        }];
        
        UIView *lineview3 = [self getLineView];
        [thirdRegionView addSubview:lineview3];
        [lineview3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(thirdRegionView);
            make.height.mas_equalTo(0.5);
        }];
        
        //加*
        UILabel *lab = [[UILabel alloc]init];
        lab.text = @"*";
        lab.textColor = HEXCOLOR(0xF23730);
        lab.font = JHFont(14);
        [thirdRegionView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(@0).offset(8);
            
        }];
        
        [thirdRegionView addSubview:self.begionTimeBtn];
        [self.begionTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(@0).offset(20);

        }];
        
        //加*
        UILabel *lab2 = [[UILabel alloc]init];
        lab2.text = @"*";
        lab2.textColor = HEXCOLOR(0xF23730);
        lab2.font = JHFont(14);
        [thirdRegionView addSubview:lab2];
        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(@0).offset((kScreenWidth - 20)/2.0 );
        }];
        
        [thirdRegionView addSubview:self.endTimeBtn];
        [self.endTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(@0).offset((kScreenWidth - 20)/2.0 + 12);
        }];

        _bottom2View = view;
    }
    return _bottom2View;
}

- (void)alertButtonClick{
    JHC2CSureMoneyAlertController *vc = [JHC2CSureMoneyAlertController new];
    [self presentViewController:vc animated:NO completion:nil];
}


- (UILabel*)getLabelWithFont:(UIFont*)font andColor:(UIColor*)color andText:(NSString*)text{
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = color;
    label.text = text;
    return label;
}
- (UIView *)getLineView{
    UIView *view = [UIView new];
    view.backgroundColor = HEXCOLOR(0xD8D8D8);
    return view;
}

- (UITextField *)getTextField{
    UITextField *tfd = [UITextField new];
    tfd.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    tfd.autocorrectionType = UITextAutocorrectionTypeNo;
    tfd.spellCheckingType = UITextSpellCheckingTypeNo;
    tfd.returnKeyType = UIReturnKeyDone;
    tfd.inputAccessoryView = [UIView new];
    tfd.tintColor = HEXCOLOR(0xFFD70F);
//        UIView *keyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
//        keyView.backgroundColor = UIColor.getRandomColor;
    tfd.inputView = [UIView new];
    tfd.delegate = self;
    tfd.placeholder = @"0.00";
    return tfd;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//}

- (UIButton *)postBtn{
    if (!_postBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"push_order_select"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"push_order_selected"] forState:UIControlStateSelected];
        [btn setTitle:@"包邮" forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(14);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(postActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _postBtn = btn;
    }
    return _postBtn;
}

- (UIButton *)begionTimeBtn{
    if (!_begionTimeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"选择开始时间" forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(14);
        [btn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(showBegionTimeFill) forControlEvents:UIControlEventTouchUpInside];
//        [btn setImage:[UIImage imageNamed:@"c2c_up_arrow"] forState:UIControlStateNormal];
//        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:17];
        _begionTimeBtn = btn;
    }
    return _begionTimeBtn;
}
- (UIButton *)endTimeBtn{
    if (!_endTimeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"选择结束时间" forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateSelected];
        btn.titleLabel.font = JHFont(14);
        [btn addTarget:self action:@selector(showEndTimeFill) forControlEvents:UIControlEventTouchUpInside];
//        [btn setImage:[UIImage imageNamed:@"c2c_up_arrow"] forState:UIControlStateNormal];
//        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:17];
//
        _endTimeBtn = btn;
    }
    return _endTimeBtn;
}


- (JHNumberKeyboard *)keyboardView {
    if (_keyboardView == nil) {
        _keyboardView = [[JHNumberKeyboard alloc] init];
        _keyboardView.frame = CGRectMake(0, 0, kScreenWidth, 209 + UI.bottomSafeAreaHeight);
        @weakify(self);
        _keyboardView.handler = ^(NSString * _Nonnull text) {
            @strongify(self);
            [self textFieldChanged:text];
        };
    }
    return _keyboardView;
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

@end

