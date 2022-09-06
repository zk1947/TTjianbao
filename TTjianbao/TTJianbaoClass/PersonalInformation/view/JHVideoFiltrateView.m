//
//  JHVideoFiltrateView.m
//  TTjianbao
//
//  Created by mac on 2019/11/2.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHVideoFiltrateView.h"
#import "OrderMode.h"
#import "TTjianbaoHeader.h"

@interface JHVideoFiltrateView ()<UITextFieldDelegate>
{
    UILabel  *beginTitle;
    UILabel  *endTitle;
    UIView *  dateTagView;
}
@property (nonatomic, strong)UIView *backView;
@property(nonatomic,strong) UIView * dateView;
@property(nonatomic,strong) NSString * dateTag;
@property (strong, nonatomic)  NSMutableArray *dateTagArr;
@property (nonatomic, strong)  UIView *pickerView;
@property (nonatomic, strong)  UIDatePicker *datePicker;
@property (nonatomic, assign)   NSInteger selectIndex;
@property (nonatomic, strong)   OrderSearchParamMode * paramMode;
@end


@implementation JHVideoFiltrateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLORA(0x000000, 0.2);
        self.backView = [UIView new];
        self.backView.frame=CGRectMake(0, 0, ScreenW, 200);
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.clipsToBounds = YES;
        [self addSubview:self.backView];
       
        self.dateTagArr=[NSMutableArray arrayWithArray:@[@{@"title":@"最近3天",@"code":@"3"},
                                                        @{@"title":@"最近7天",@"code":@"7"},
                                                        @{@"title":@"最近15天",@"code":@"15"}]];
        [self initDateView];
        [self initBottomView];
        
        

        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAlert)]];
    }
    return self;
}
-(void)initDateView{
    
    _dateView=[[UIView alloc]init];
    _dateView.backgroundColor=[UIColor whiteColor];
    [self.backView addSubview:_dateView];
    
    [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(0);
        make.left.equalTo(self.backView).offset(0);
        make.right.equalTo(self.backView).offset(0);
    }];
    
    //
    UILabel  *title=[self getTitleLabel:@"日期筛选"];
    [_dateView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dateView).offset(10);
        make.left.equalTo(_dateView).offset(10);
    }];
    
    
    UIView *beginView=[self getInPutView];
    beginView.userInteractionEnabled=YES;
    [beginView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dateChoose:)]];
    beginView.tag=10;
    [_dateView addSubview:beginView];
    [beginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(20);
        make.left.equalTo(title);
        make.width.offset(137);
        make.height.offset(33);
    }];
    beginTitle=[self getTitleLabel:@"开始日期"];
    beginTitle.textColor=[CommHelp toUIColorByStr:@"#cccccc"];
    [beginView addSubview:beginTitle];
    [beginTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(beginView);
        make.left.equalTo(beginView).offset(20);
        
    }];
    
    UIImageView * logo1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchdatePicker_image"]];
    logo1.contentMode = UIViewContentModeScaleAspectFit;
    
    [beginView addSubview:logo1];
    [logo1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(beginView).offset(-10);
        make.centerY.equalTo(beginView);
    }];
    
    UIView * line1=[[UIView alloc]init];
    line1.backgroundColor=kColorCCC;
    [_dateView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beginView.mas_right).offset(10);
        make.centerY.equalTo(beginView);
        make.size.mas_equalTo(CGSizeMake(14, 2));
        
    }];
    
    UIView *endView=[self getInPutView];
    endView.userInteractionEnabled=YES;
    endView.tag=20;
    [endView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dateChoose:)]];
    [_dateView addSubview:endView];
    [endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(20);
        make.left.equalTo(line1.mas_right).offset(10);
        make.width.offset(137);
        make.height.offset(33);
        
    }];
    endTitle=[self getTitleLabel:@"结束日期"];
    endTitle.textColor=[CommHelp toUIColorByStr:@"#cccccc"];
    [endView addSubview:endTitle];
    [endTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(endView);
        make.left.equalTo(endView).offset(20);
        
    }];
    UIImageView * logo2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchdatePicker_image"]];
    logo2.contentMode = UIViewContentModeScaleAspectFit;
    
    [endView addSubview:logo2];
    [logo2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(endView).offset(-10);
        make.centerY.equalTo(endView);
    }];
    
    dateTagView=[[UIView alloc]init];
    [self.dateView addSubview:dateTagView];
    
    [dateTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(endView.mas_bottom).offset(10);
        make.left.equalTo(self.dateView).offset(0);
        make.right.equalTo(self.dateView).offset(0);
        make.bottom.equalTo(self.dateView).offset(-10);
    }];
    
    NSInteger margin = 10;
    float imaWidth=(ScreenW-margin*5)/4;
    float imaHeight=33;
    UIButton * lastView ;
    for (int i=0; i<[self.dateTagArr count]; i++) {
        UIButton * button=[[UIButton alloc]init];
        button.layer.masksToBounds =YES;
        button.layer.cornerRadius =5;
        button.backgroundColor=kColorEEE;
        [button setTitle:[self.dateTagArr[i]objectForKey:@"title"] forState:UIControlStateNormal];
        button.selected=NO;
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        [button setTitleColor:kColor666 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dateButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=100+i;
        //        if (i==0 ) {
        //            button.selected=YES;
        //            button.backgroundColor=kColorMain;
        //        }
        [dateTagView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(imaWidth);
            make.height.offset(imaHeight);
            //上下位置
            if (i/4==0) {
                make.top.equalTo(dateTagView.mas_top).offset(10);
            }
            else{
                NSInteger  rate= i/4;
                make.top.equalTo(dateTagView.mas_top).offset(imaHeight*rate+10*(rate)+10);
            }
            //左右位置
            if (i%4 == 0) {
                make.left.offset(margin);
                
            }else{
                make.left.equalTo(lastView.mas_right).offset(margin);
            }
            if (i%4 == 3) {
                make.right.offset(-margin);
            }
            //底部高度
            if (i == [self.dateTagArr count] - 1){
                make.bottom.equalTo(dateTagView).offset(-10);
            }
        }];
        lastView= button;
    }
}
-(void)initBottomView{
    
    UIView * bottom=[[UIView alloc]init];
    [self.backView addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
      //  make.top.equalTo(_dateView.mas_bottom).offset(50);
        make.left.equalTo(self.backView).offset(0);
        make.right.equalTo(self.backView).offset(0);
        make.bottom.equalTo(self.backView).offset(-10);
    }];
    
    UIButton * resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    resetButton.layer.masksToBounds =YES;
    resetButton.layer.cornerRadius =18;
    resetButton.backgroundColor=kColorEEE;
    resetButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [resetButton setTitleColor:kColor666 forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:resetButton];
    
    [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottom).offset(-ScreenW/2-10);
        make.top.equalTo(bottom).offset(5);
        make.height.offset(35);
        make.width.offset(110);
    }];
    
    UIButton * completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    completeBtn.layer.masksToBounds =YES;
    completeBtn.layer.cornerRadius =18;
    completeBtn.backgroundColor=kColorMain;
    completeBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [completeBtn setTitleColor:kColor666 forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:completeBtn];
    
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottom).offset(ScreenW/2+10);
        make.top.equalTo(bottom).offset(5);
        make.height.offset(35);
        make.width.offset(110);
        make.bottom.equalTo(bottom);
    }];
}
-(void)dateChoose:(UITapGestureRecognizer*)tap{
    
    [self addSubview:self.pickerView];
    self.pickerView.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerView.bottom =  self.height;
    }];
    
    if (tap.view.tag==10) {
        self.selectIndex=0;
        if ([beginTitle.text length]>0&&![beginTitle.text isEqualToString:@"开始日期"]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            [self.datePicker setDate:[formatter dateFromString:beginTitle.text] animated:YES];
        }
        else{
              [_datePicker setDate:[NSDate date] animated:YES];
        }
        
    }
    if (tap.view.tag==20) {
        self.selectIndex=1;
        if ([endTitle.text length]>0&&![endTitle.text isEqualToString:@"结束日期"]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            [self.datePicker setDate:[formatter dateFromString:endTitle.text] animated:YES];
        }
        else{
              [_datePicker setDate:[NSDate date] animated:YES];
        }
        
    }
}
-(void)dateButtonPress:(UIButton*)button{
    [self resetDateTag];
    button.selected=YES;
    button.backgroundColor=kColorMain;
    NSInteger day=[[self.dateTagArr[button.tag-100] objectForKey:@"code"] integerValue];
    self.dateTag=[self.dateTagArr[button.tag-100] objectForKey:@"title"];
    NSDate *datenow = [NSDate date];
    NSDate *newDate = [datenow dateByAddingTimeInterval:-24 * 60 * 60  * day];
    endTitle.text=[CommHelp getDateStringFromDate:datenow];
    beginTitle.text=[CommHelp getDateStringFromDate:newDate];
    
}

-(void)reset{
    
    beginTitle.text=@"开始日期";
    endTitle.text=@"结束日期";
    self.dateTag=nil;
    [self resetDateTag];
    self.paramMode=nil;
    if (self.handle) {
        self.handle(self.paramMode, nil);
    }
}
-(void)resetDateTag{
    for (UIView *subView in dateTagView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)subView;
            btn.selected=NO;
            btn.backgroundColor=kColorEEE;
        }
    }
}
-(UIView*)pickerView{
    if (!_pickerView) {
        _pickerView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenH-300, ScreenW,300)];
        _pickerView.backgroundColor=[UIColor whiteColor];
        //
        UIView * header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
        header.backgroundColor=[CommHelp toUIColorByStr:@"#dddddd"];
        [_pickerView addSubview:header];
        UIButton *complete = [UIButton buttonWithType:UIButtonTypeCustom];
        complete.frame=CGRectMake(ScreenW-70, 0, 60, 44);
        complete.backgroundColor=[UIColor clearColor];
        complete.titleLabel.font= [UIFont systemFontOfSize:14];
        [complete setTitle:@"确定" forState:UIControlStateNormal];
        [complete setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
        [complete addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:complete];
        _datePicker = [[UIDatePicker alloc] init];
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
        }
        _datePicker.frame = CGRectMake(0, 44, ScreenW, 226);
        //设置地区: zh-中国
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        //设置日期模式(Displays month, day, and year depending on the locale setting)
        _datePicker.datePickerMode = UIDatePickerModeDate;
        // 设置当前显示时间
        [_datePicker setDate:[NSDate date] animated:YES];
        // 设置显示最大时间（此处为当前时间）
        [_datePicker setMaximumDate:[NSDate date]];
        //设置时间格式
        //监听DataPicker的滚动
        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        
        [_pickerView addSubview:_datePicker];
    }
    
    return _pickerView;
}

- (void)dateChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    NSLog(@"%@",dateStr);
    NSLog(@"ddd==%ld",(long)[CommHelp timeSwitchDatestamp:dateStr]);
}
-(void)complete{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter  stringFromDate:self.datePicker.date];
    NSLog(@"%@",dateStr);
    NSLog(@"ddd==%ld",(long)[CommHelp timeSwitchDatestamp:dateStr]);
    if ( self.selectIndex==0) {
        beginTitle.text=dateStr;
    }
    if ( self.selectIndex==1) {
        if ([CommHelp timeSwitchDatestamp:dateStr]>=[CommHelp timeSwitchDatestamp:beginTitle.text]) {
            endTitle.text=dateStr;
        }
        else{
            [[UIApplication sharedApplication].keyWindow makeToast:@"结束时间不能小于开始时间" duration:1.0 position:CSToastPositionCenter];
            return;
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerView.top =  self.height;
    } completion:^(BOOL finished) {
        [self.pickerView removeFromSuperview];
        self.pickerView=nil;
    }];
    
    [self resetDateTag];
    
}
- (void)showAlert {
    self.hidden = NO;
    self.backView.height = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.height = 200;
    }completion:^(BOOL finished) {

    }];
}

- (void)hiddenAlert {
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.height = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
-(void)submit{
    
    if (![beginTitle.text isEqualToString:@"开始日期"]) {
        self.paramMode.startTime=beginTitle.text;
    }
    if (![endTitle.text isEqualToString:@"结束日期"]) {
        self.paramMode.endTime=endTitle.text;
    }
    if (self.handle) {
        self.handle(self.paramMode, nil);
    }
    
    [self hiddenAlert];
    
}
-(UILabel*)getTitleLabel:(NSString*)text{
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=text;
    title.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
    title.textColor=[CommHelp toUIColorByStr:@"#333333"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    
    return title;
}

-(UITextField*)getTextField:(NSString*)placeText{
    
    UITextField  *textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.placeholder = placeText;
    textField.textColor = kColor333;
    textField.font = [UIFont fontWithName:kFontNormal size:14.0];
    textField.backgroundColor = [UIColor clearColor];
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    return textField;
}

-(UIView*)getInPutView{
    
    UIView  *view = [[UIView alloc] init];
    view.layer.cornerRadius = 4;
    view.backgroundColor=[UIColor clearColor];
    view.layer.borderColor = [CommHelp toUIColorByStr:@"#dddddd"].CGColor;
    view.layer.borderWidth = 0.5;
    return view;
}
#pragma --get
-(OrderSearchParamMode*)paramMode{
    if (!_paramMode) {
        _paramMode=[[OrderSearchParamMode alloc]init];
    }
    return _paramMode;
}
@end
