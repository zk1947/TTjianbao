//
//  OrderDateChooseView.m
//  TTjianbao
//
//  Created by jiang on 2019/8/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "OrderDateChooseView.h"
#import "UIView+NTES.h"
#import "NTESDataManager.h"
#import "NIMAvatarImageView.h"
#import "NTESLiveManager.h"
#import "UIImage+GIF.h"
#import "HKClipperHelper.h"
#import "TTjianbaoHeader.h"
#import <QBImagePickerController/QBImagePickerController.h>
@interface OrderDateChooseView()
{
    UIImageView *photoImageView;
    
}
@property (nonatomic, strong)  UIView *back;
@property (nonatomic, strong)  UIView *pickerView;
@property (nonatomic, strong)  UIDatePicker *datePicker;

@property (nonatomic, strong)   UILabel *beginTime;
@property (nonatomic, strong)   UILabel *endTime;
@property (nonatomic, assign)   NSInteger selectIndex;
@end

@implementation OrderDateChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
         [self  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(onTapBackground)]];
          self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
          [self setupSuviews];
      
    }
    return self;
}
-(void)setupSuviews{
    
    _back=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenH-300, ScreenW, 340)];
    _back.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _back.layer.cornerRadius = 8;
    _back.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
    _back.layer.shadowOffset = CGSizeMake(0,-2);
    _back.layer.shadowOpacity = 1;
    _back.layer.shadowRadius = 7;
    [self addSubview:_back];
    
    UILabel *title = [[UILabel alloc] init];
    title.numberOfLines =1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    title.textColor=[CommHelp toUIColorByStr:@"#333333"];
    title.text = @"选择时间";
    title.font=[UIFont systemFontOfSize:18];
    [_back addSubview:title];
    
    [ title  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_back).offset(10);
        make.centerX.equalTo(_back);
    }];
    
    UIView * beginView=[[UIView alloc]init];
    [_back addSubview:beginView];
    beginView.userInteractionEnabled=YES;
    beginView.backgroundColor=[CommHelp toUIColorByStr:@"#f7f7f7"];
    beginView.tag=100;
    [beginView addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(showPicker:)]];
    
    [ beginView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_back).offset(40);
        make.left.equalTo(_back).offset(0);
          make.right.equalTo(_back).offset(0);
        make.height.offset(50);
    }];
    
    UILabel *beginLabel = [[UILabel alloc] init];
    beginLabel.numberOfLines =1;
    beginLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    beginLabel.lineBreakMode = NSLineBreakByWordWrapping;
    beginLabel.textColor=[CommHelp toUIColorByStr:@"#333333"];
    beginLabel.text = @"开始时间:";
    beginLabel.font=[UIFont systemFontOfSize:16];
    [beginView addSubview:beginLabel];
    [ beginLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(beginView);
        make.left.equalTo(beginView).offset(10);
    }];
    
    UIImageView *indicator1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_right_jiantou"]];
    indicator1.backgroundColor=[UIColor clearColor];
    [indicator1 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [indicator1 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    indicator1.contentMode = UIViewContentModeScaleAspectFit;
    [beginView addSubview:indicator1];
    
    [indicator1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(beginView).offset(-15);
        make.centerY.equalTo(beginView);
    }];
    
    _beginTime= [[UILabel alloc] init];
    _beginTime.numberOfLines =1;
    _beginTime.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _beginTime.lineBreakMode = NSLineBreakByWordWrapping;
    _beginTime.textColor=[CommHelp toUIColorByStr:@"#333333"];
    _beginTime.text = @"选择开始时间";
    _beginTime.font=[UIFont systemFontOfSize:14];
    [beginView addSubview:_beginTime];
    [ _beginTime  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(beginView);
        make.right.equalTo(beginView).offset(-40);
    }];
    
    UIView * endView=[[UIView alloc]init];
    endView.userInteractionEnabled=YES;
    endView.backgroundColor=[CommHelp toUIColorByStr:@"#f7f7f7"];
    endView.tag=200;
    [endView addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(showPicker:)]];
    [_back addSubview:endView];
    
    [ endView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(beginView.mas_bottom).offset(10);
        make.left.equalTo(_back).offset(0);
             make.right.equalTo(_back).offset(0);
        make.height.offset(50);
    }];
    
    UILabel *endLabel = [[UILabel alloc] init];
    endLabel.numberOfLines =1;
    endLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    endLabel.lineBreakMode = NSLineBreakByWordWrapping;
    endLabel.textColor=[CommHelp toUIColorByStr:@"#333333"];
    endLabel.text = @"结束时间:";
    endLabel.font=[UIFont systemFontOfSize:16];
    [endView addSubview:endLabel];
    
    [ endLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(endView);
        make.left.equalTo(endView).offset(10);
    }];
    
    _endTime= [[UILabel alloc] init];
    _endTime.numberOfLines =1;
    _endTime.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _endTime.lineBreakMode = NSLineBreakByWordWrapping;
    _endTime.textColor=[CommHelp toUIColorByStr:@"#333333"];
    _endTime.text = @"选择结束时间";
    _endTime.font=[UIFont systemFontOfSize:14];
    [endView addSubview:_endTime];
    [ _endTime  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(endView);
        make.right.equalTo(endView).offset(-40);
    }];
    
    UIImageView *indicator2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_right_jiantou"]];
    indicator2.backgroundColor=[UIColor clearColor];
    [indicator2 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [indicator2 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    indicator2.contentMode = UIViewContentModeScaleAspectFit;
    [endView addSubview:indicator2];
    
    [indicator2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(endView).offset(-15);
        make.centerY.equalTo(endView);
    }];
    
    UIButton  *button=[[UIButton alloc]init];
    [button setTitle:@"导出" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:18];
    [button setBackgroundImage:[UIImage imageNamed:@"order_downLoad_image"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"order_downLoad_image"] forState:UIControlStateSelected];
    [button setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor clearColor];
    [button addTarget:self action:@selector(export) forControlEvents:UIControlEventTouchUpInside];
    [_back addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_back);
        make.bottom.equalTo(_back).offset(-UI.bottomSafeAreaHeight-10);
    }];
    
    
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
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
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
-(UIDatePicker*)datePicker{
    
    if  (!_datePicker){
      _datePicker = [[UIDatePicker alloc] init];
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
        }
        //设置地区: zh-中国
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        //设置日期模式(Displays month, day, and year depending on the locale setting)
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        // 设置当前显示时间
        [_datePicker setDate:[NSDate date] animated:YES];
        // 设置显示最大时间（此处为当前时间）
        [_datePicker setMaximumDate:[NSDate date]];
        //设置时间格式
        //监听DataPicker的滚动
        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
      //  [datePicker setDate:maxDate animated:YES];
    }
    return _datePicker;
}

- (void)dateChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    NSLog(@"%@",dateStr);
    NSLog(@"ddd==%ld",(long)[CommHelp timeSwitchTimestamp:dateStr]);
    
}
- (void)onTapBackground
{
    [self dismiss];
}
-(void)complete{
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [formatter  stringFromDate:self.datePicker.date];
    NSLog(@"%@",dateStr);
    NSLog(@"ddd==%ld",(long)[CommHelp timeSwitchTimestamp:dateStr]);
    if ( self.selectIndex==0) {
        self.beginTime.text=dateStr;
    }
    if ( self.selectIndex==1) {
        if ([CommHelp timeSwitchTimestamp:dateStr]>=[CommHelp timeSwitchTimestamp:self.beginTime.text]) {
            self.endTime.text=dateStr;
        }
        else{
            [[UIApplication sharedApplication].keyWindow makeToast:@"结束时间必须大于开始时间" duration:1.0 position:CSToastPositionCenter];
            return;
        }
    }
    
     [UIView animateWithDuration:0.25 animations:^{
        self.pickerView.top =  self.height;
    } completion:^(BOOL finished) {
         [self.pickerView removeFromSuperview];
         self.pickerView=nil;
    }];
    
}
-(void)showPicker:(UITapGestureRecognizer*)tap{
    
     [self addSubview:self.pickerView];
     self.pickerView.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerView.bottom =  self.height;
    }];
    if (tap.view.tag==100) {
        self.selectIndex=0;
    }
    if (tap.view.tag==200) {
        self.selectIndex=1;
    }
}
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.back.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.back.bottom =  self.height;
    }];
}
- (void)export
{
    if ( [self.beginTime.text length]!=0&& [self.endTime.text length]!=0&& ![self.beginTime.text isEqual:@"选择开始时间"]&& ![self.endTime.text isEqual:@"选择结束时间"]) {
        if (self.handle) {
            self.handle(self.beginTime.text, self.endTime.text);
            }
            [self dismiss];
        }
    else{
        [[UIApplication sharedApplication].keyWindow makeToast:@"请选择时间" duration:1.0 position:CSToastPositionCenter];
   }
}
- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
         self.back.top =  self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (void)dealloc
{
    
    
}
@end



