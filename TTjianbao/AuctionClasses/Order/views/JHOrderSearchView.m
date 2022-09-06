//
//  JHOrderSearchView.h
//  TTjianbao
//
//  Created by jiang on 2019/11/3.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrderSearchView.h"
#import "JHOrdePayGradationViewController.h"
#import "CommHelp.h"
#import "CustomToolsBar.h"

@interface JHOrderSearchView ()<UITextViewDelegate,UITextFieldDelegate>
{

     UIView *  dateTagView;
     UIView * statusTagView;
     UITextField * codeTextField;
     UITextField * nameTextField;
     UITextField * minPriceField;
     UITextField * maxPriceField;
     UILabel  *beginTitle;
     UILabel  *endTitle;
}
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) UIView * serchView;
@property(nonatomic,strong) UIView * dateView;
@property(nonatomic,strong) UIView * orderStatusView;
@property(nonatomic,strong) NSString * dateTag;
@property(nonatomic,strong) NSString * statusTag;
@property (strong, nonatomic)  NSMutableArray *dateTagArr;
@property (strong, nonatomic)  NSMutableArray *statusTagArr;

@property (nonatomic, strong)  UIView *pickerView;
@property (nonatomic, strong)  UIDatePicker *datePicker;
@property (nonatomic, assign)   NSInteger selectIndex;
@property (nonatomic, strong)   OrderSearchParamMode * paramMode;
@end
@implementation JHOrderSearchView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame=CGRectMake(0, 0, ScreenW, ScreenH);
    //self.dateTagArr=[NSMutableArray arrayWithArray:@[@"最近3天",@"最近7天",@"最近15天"]];
        self.dateTagArr=[NSMutableArray arrayWithArray:@[@{@"title":@"最近3天",@"code":@"3"},
                                                           @{@"title":@"最近7天",@"code":@"7"},
                                                            @{@"title":@"最近15天",@"code":@"15"}]];
    self.statusTagArr=[NSMutableArray arrayWithArray:@[@{@"title":@"全部",@"code":@"all"},
                                                    @{@"title":@"待付款",@"code":@"waitpay"},
                                                    @{@"title":@"待发货",@"code":@"waitsellersend"},
                                                    @{@"title":@"结算中",@"code":@"portalsent"},
                                                    @{@"title":@"已结算",@"code":@"buyerreceived"},
                                                    @{@"title":@"退款售后",@"code":@"refund"}]];
        [self  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)]];
        [self initToolsBar];
        [self initScrollview];
    }
    
    return self;
}

-(void)dismissKeyboard{
    
    [self endEditing:YES];
    
}
-(void)initScrollview{
    
    self.contentScroll=[[UIScrollView alloc]init];
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = YES;
    self.contentScroll.backgroundColor =[UIColor whiteColor];
    self.contentScroll.scrollEnabled=YES;
    self.contentScroll.alwaysBounceVertical=YES;
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(UI.statusBarHeight+44);
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self);
    }];
    
    [self initSearchView];
    [self initDateView];
    [self initStatusView];
    [self initBottomView];
    
}
-(void)initToolsBar{
    
    CustomToolsBar *navbar = [[CustomToolsBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, UI.statusBarHeight+44)];
    [self addSubview:navbar];
    [navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
    [navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backAction{
    
    [self dismiss];
}
-(void)initSearchView{
    
    _serchView=[[UIView alloc]init];
    //  _serchView.backgroundColor=[UIColor redColor];
    [self.contentScroll addSubview:_serchView];
    [_serchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.width.offset(ScreenW);
    }];
    
    //
    UILabel  *codeTitle=[self getTitleLabel:@"订单号"];
    [_serchView addSubview:codeTitle];
    [codeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_serchView).offset(30);
        make.left.equalTo(_serchView).offset(10);
    }];
    UIView *codeInputView=[self getInPutView];
    [_serchView addSubview:codeInputView];
    [codeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(codeTitle);
        make.left.equalTo(codeTitle.mas_right).offset(10);
        make.right.offset(-10);
        make.height.offset(33);
    }];
    
    codeTextField=[self getTextField:@"请输入订单编号"];
    [codeInputView addSubview:codeTextField];
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(codeInputView);
        make.left.equalTo(codeInputView).offset(10);
        make.right.offset(-10);
    }];
    //
    
    UILabel  *nameTitle=[self getTitleLabel:@"用户名"];
  
    [_serchView addSubview:nameTitle];
    [nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeTitle.mas_bottom).offset(40);
        make.left.equalTo(_serchView).offset(10);
    }];
    UIView *nameInputView=[self getInPutView];
    [_serchView addSubview:nameInputView];
    [nameInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameTitle);
        make.left.equalTo(nameTitle.mas_right).offset(10);
        make.right.offset(-10);
        make.height.offset(33);
    }];
    nameTextField=[self getTextField:@"请输入用户昵称"];
    nameTextField.keyboardType = UIKeyboardTypeDefault;
    [nameInputView addSubview:nameTextField];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(nameInputView);
        make.left.equalTo(nameInputView).offset(10);
        make.right.offset(-10);
    }];
    
    //
    UILabel  *priceTitle=[self getTitleLabel:@"价格区间"];
    [_serchView addSubview:priceTitle];
    [priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTitle.mas_bottom).offset(40);
        make.left.equalTo(_serchView).offset(10);
    }];
    
    UIView *minPriceView=[self getInPutView];
    [_serchView addSubview:minPriceView];
    [minPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceTitle.mas_bottom).offset(20);
        make.left.equalTo(priceTitle);
        make.width.offset(137);
        make.height.offset(33);
    }];
    minPriceField=[self getTextField:@"最低价"];
    [minPriceView addSubview:minPriceField];
    [minPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(minPriceView);
        make.centerX.equalTo(minPriceView);
        make.width.offset(50);
        
    }];
    
    UIView * line1=[[UIView alloc]init];
    line1.backgroundColor=kColorCCC;
    [_serchView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(minPriceView.mas_right).offset(10);
        make.centerY.equalTo(minPriceView);
        make.size.mas_equalTo(CGSizeMake(14, 2));
        
    }];
    
    UIView *maxPriceView=[self getInPutView];
    [_serchView addSubview:maxPriceView];
    [maxPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceTitle.mas_bottom).offset(20);
        make.left.equalTo(line1.mas_right).offset(10);
        make.width.offset(137);
        make.height.offset(33);
        make.bottom.equalTo(_serchView.mas_bottom).offset(-20);
    }];
    maxPriceField=[self getTextField:@"最高价"];
    [maxPriceView addSubview:maxPriceField];
    [maxPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(maxPriceView);
        make.centerX.equalTo(maxPriceView);
        make.width.offset(50);
        
    }];
    
    
}
-(void)initDateView{
    
    _dateView=[[UIView alloc]init];
    _dateView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_dateView];
    
    [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serchView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
    }];
    
    //
    UILabel  *title=[self getTitleLabel:@"订单日期"];
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

-(void)initStatusView{
    
    _orderStatusView=[[UIView alloc]init];
    _orderStatusView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_orderStatusView];
    [_orderStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
    }];
    //
    UILabel  *title=[self getTitleLabel:@"订单状态"];
    [_orderStatusView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderStatusView).offset(10);
        make.left.equalTo(_orderStatusView).offset(10);
    }];
    
    statusTagView=[[UIView alloc]init];
    [self.orderStatusView addSubview:statusTagView];
    
    [statusTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(10);
        make.left.equalTo(self.orderStatusView).offset(0);
        make.right.equalTo(self.orderStatusView).offset(0);
        make.bottom.equalTo(self.orderStatusView).offset(-10);
    }];
    
    
    NSInteger margin = 10;
    float imaWidth=(ScreenW-margin*5)/4;
    float imaHeight=33;
    UIButton * lastView ;
    for (int i=0; i<[self.statusTagArr count]; i++) {
        UIButton * button=[[UIButton alloc]init];
        button.layer.masksToBounds =YES;
        button.layer.cornerRadius =5;
        button.backgroundColor=kColorEEE;
        [button setTitle:[self.statusTagArr[i]objectForKey:@"title"] forState:UIControlStateNormal];
        button.selected=NO;
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        [button setTitleColor:kColor666 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(statusButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=200+i;
        if (i==0 ) {
            button.selected=YES;
            button.backgroundColor=kColorMain;
            self.statusTag=[self.statusTagArr[0] objectForKey:@"code"];
        }
        [statusTagView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(imaWidth);
            make.height.offset(imaHeight);
            //上下位置
            if (i/4==0) {
                make.top.equalTo(statusTagView.mas_top).offset(10);
            }
            else{
                NSInteger  rate= i/4;
                make.top.equalTo(statusTagView.mas_top).offset(imaHeight*rate+10*(rate)+10);
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
            if (i == [self.statusTagArr count] - 1){
                make.bottom.equalTo(statusTagView).offset(-10);
            }
        }];
        lastView= button;
    }
}

-(void)initBottomView{
    
    UIView * bottom=[[UIView alloc]init];
    [self.contentScroll addSubview:bottom];
    
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderStatusView.mas_bottom).offset(50);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.bottom.equalTo(self.contentScroll).offset(-10);
    }];
    
    UIButton * resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    resetButton.layer.masksToBounds =YES;
    resetButton.layer.cornerRadius =22;
    resetButton.backgroundColor=kColorEEE;
    resetButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [resetButton setTitleColor:kColor666 forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:resetButton];
    
    [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottom).offset(-ScreenW/2-10);
        make.top.equalTo(bottom).offset(5);
        make.height.offset(44);
        make.width.offset(140);
    }];
    
    UIButton * completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    completeBtn.layer.masksToBounds =YES;
    completeBtn.layer.cornerRadius =22;
    completeBtn.backgroundColor=kColorMain;
    completeBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [completeBtn setTitleColor:kColor666 forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:completeBtn];
    
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottom).offset(ScreenW/2+10);
        make.top.equalTo(bottom).offset(5);
        make.height.offset(44);
        make.width.offset(140);
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
-(void)statusButtonPress:(UIButton*)button{
    
    [self resetStatusTag];
    button.selected=YES;
    button.backgroundColor=kColorMain;
    self.statusTag=[self.statusTagArr[button.tag-200] objectForKey:@"code"];
}
-(void)reset{
    
    codeTextField.text=nil;
    nameTextField.text=nil;
    minPriceField.text=nil;
    maxPriceField.text=nil;
    beginTitle.text=@"开始日期";
    endTitle.text=@"结束日期";
    self.dateTag=nil;
    self.statusTag=nil;
    [self resetDateTag];
    [self resetStatusTag];
    self.paramMode=nil;
    UIButton * button=[self.orderStatusView viewWithTag:200];
    button.selected=YES;
    button.backgroundColor=kColorMain;
    self.statusTag=[self.statusTagArr[0] objectForKey:@"code"];
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
-(void)resetStatusTag{
     for (UIView *subView in statusTagView.subviews) {
          if ([subView isKindOfClass:[UIButton class]]) {
              UIButton *btn = (UIButton*)subView;
              btn.selected=NO;
              btn.backgroundColor=kColorEEE;
          }
      }
}
-(void)submit{
   
    self.paramMode.orderCode=codeTextField.text;
    self.paramMode.customerName=nameTextField.text;
    if (![beginTitle.text isEqualToString:@"开始日期"]) {
        self.paramMode.startTime=beginTitle.text;
    }
    if (![endTitle.text isEqualToString:@"结束日期"]) {
           self.paramMode.endTime=endTitle.text;
     }
    
    self.paramMode.searchStatus=self.statusTag;
    self.paramMode.minPrice=minPriceField.text;
    self.paramMode.maxPrice=maxPriceField.text;
    
    if (self.handle) {
        self.handle(self.paramMode, nil);
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
- (void)show
{
    self.left = self.width;
    [UIView animateWithDuration:0.4 animations:^{
        self.right = self.width;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.4 animations:^{
        self.left = self.width;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)dealloc
{
    NSLog(@"dealloc");
}
@end


