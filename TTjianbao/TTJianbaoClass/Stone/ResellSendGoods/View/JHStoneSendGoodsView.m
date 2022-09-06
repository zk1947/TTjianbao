//
//  JHStoneSendGoodsView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHStoneSendGoodsView.h"
#import "BYTimer.h"
#import "JHOrderRemainTimeView.h"
#import "JHStoneSendGoodsTimerView.h"
#import "JHOrderSendExpressView.h"
#import "JHAddPhotoView.h"
#import "JHQRViewController.h"
#import "JHPickerView.h"
@interface JHStoneSendGoodsView ()<STPickerSingleDelegate>
{
    BYTimer *timer;
    NSInteger selectedIndex;
    
}
@property(nonatomic,strong)  UIView* titleView;
@property(nonatomic,strong)   UILabel * titlelLabel;

@property(nonatomic,strong)  JHStoneSendGoodsTimerView* timerView;
@property(nonatomic,strong)  JHOrderSendExpressView* addressView;
@property(nonatomic,strong)  JHAddPhotoView* addPhotoView;
@property(nonatomic,strong)  UIButton* button;
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) NSMutableArray *dataList;
@property(nonatomic,strong) JHPickerView *picker;
@end
@implementation JHStoneSendGoodsView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        selectedIndex=-1;
        [self initScrollview];
        [self getData];
    }
    return self;
}
-(void)initScrollview{
    
    self.contentScroll=[[UIScrollView alloc]init];
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = YES;
    self.contentScroll.backgroundColor =[CommHelp toUIColorByStr:@"#f7f7f7"];
    self.contentScroll.scrollEnabled=YES;
    self.contentScroll.alwaysBounceVertical=YES;
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self);
    }];
    
    [self initTitleView];
    [self initTimerView];
    [self initExpressView];
    [self initPhotoView];
    [self initButton];
}
-(void)initTitleView{
    
    _titleView=[[UIView alloc]init];
    _titleView.layer.cornerRadius = 8;
    _titleView.layer.masksToBounds = YES;
    _titleView.backgroundColor=[CommHelp  toUIColorByStr:@"#FFEDE7"];
    [self.contentScroll addSubview:_titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(30);
        make.width.offset(ScreenW-20);
    }];
     _titlelLabel = [[UILabel alloc] init];
    _titlelLabel.numberOfLines =1;
    _titlelLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _titlelLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titlelLabel.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
    _titlelLabel.text = @"";
    _titlelLabel.font=[UIFont fontWithName:kFontMedium size:12];
    [_titleView addSubview:_titlelLabel];
    [ _titlelLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_titleView);
    }];
    
}
-(void)initTimerView{
    
    _timerView=[[JHStoneSendGoodsTimerView alloc]init];
    [self.contentScroll addSubview:_timerView];
    [_timerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(50);
    }];;
    
}
-(void)initExpressView{
    
    _addressView=[[JHOrderSendExpressView alloc]init];
    _addressView.isStoneResellSend=YES;
    _addressView.titleString=@"平台地址，请放心邮寄";
    _addressView.isStoneResellSend=YES;
    [self.contentScroll addSubview:_addressView];
    [_addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timerView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    JH_WEAK(self)
    _addressView.buttonHandle = ^(id obj) {
        JH_STRONG(self)
        [self scanCode];
    };
    _addressView.chooseExpressHandle = ^(id obj) {
        JH_STRONG(self)
        [self.picker show];
    };
}

-(void)initPhotoView{
    
    _addPhotoView=[[JHAddPhotoView alloc]init];
    [self.contentScroll addSubview:_addPhotoView];
    [_addPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}
-(void)initButton{
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.backgroundColor = HEXCOLOR(0xfee100);
    _button.layer.cornerRadius = 22;
    _button.layer.masksToBounds = YES;
    [_button setTitle:@"发货" forState:UIControlStateNormal];
    [_button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont fontWithName:kFontMedium size:14];
    //  btn.frame = CGRectMake(ScreenW-(ScreenW/2-30/2),40, 120, 30);
    [_button addTarget:self action:@selector(SendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScroll addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addPhotoView.mas_bottom).offset(50);
        make.left.equalTo(self.contentScroll).offset(60);
        make.right.equalTo(self.contentScroll).offset(-60);
        make.height.offset(44);
        //   make.width.offset(256);
        make.bottom.equalTo(self.contentScroll).offset(-10);
    }];
}

#pragma mark ---get

-(NSMutableArray*)allPhotos{
    return self.addPhotoView.allPhotos;
}
-(NSString*)expressCode{
    
    return self.addressView.textField.text;
}
//-(NSString*)expressCompany{
//
//    return self.addressView.expressCompany.text;
//}
- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (JHPickerView *)picker {
    if (!_picker) {
        _picker = [[JHPickerView alloc] init];
        _picker.widthPickerComponent = 300;
        _picker.heightPicker = 240 + UI.bottomSafeAreaHeight;
        [_picker setDelegate:self];
    }
    return _picker;
}
#pragma mark ---action
- (void)scanCode{
    
    JHQRViewController *vc = [[JHQRViewController alloc] init];
    vc.titleString = @"扫描运单号";
    MJWeakSelf
    vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController *obj) {
        weakSelf.addressView.textField.text = scanString;
        [obj.navigationController popViewControllerAnimated:YES];
    };
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

-(void)chooseExpress{
    [self.picker show];
}
- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    if (![pickerSingle isKindOfClass:[JHPickerView class]]) {
        return;
    }
    selectedIndex = [pickerSingle.pickerView selectedRowInComponent:1];
    self.addressView.expressCompany.text= self.dataList[selectedIndex][@"name"];
    
}
-(void)SendAction:(UIButton*)button{
    
    if (self.addressView.expressCompany.text==0) {
        [self makeToast:@"请选择物流公司" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if ([self.expressCode length]==0) {
        [self makeToast:@"请输入运单号" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if ([self.allPhotos count]==0) {
        [self makeToast:@"至少上传一张图片" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    self.expressCompanyCode= self.dataList[selectedIndex][@"com"];
    if (self.completeBlock) {
        self.completeBlock(button);
    }
}
#pragma mark------request
- (void)getData {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/express/") Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.dataList = respondObject.data;
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dic in self.dataList) {
            [muArray addObject:dic[@"name"]];
        }
        self.picker.arrayData = muArray;
        selectedIndex=0;
        self.addressView.expressCompany.text= self.dataList[selectedIndex][@"name"];
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
-(void)setAddressModel:(JHGoodSendAddressMode *)addressModel{
    
    _addressModel=addressModel;
    self.titlelLabel.text = _addressModel.warnInfo;
    self.addressView.name.text=[NSString stringWithFormat:@"收货人: %@",_addressModel.deliverName];
    self.addressView.phoneNum.text=_addressModel.deliverMobile;
    self.addressView.address.text=[NSString stringWithFormat:@"%@%@%@%@",_addressModel.deliverProvince,_addressModel.deliverCity,_addressModel.deliverCounty,_addressModel.deliverAddress];
    [self.timerView setPayDeadline:_addressModel.payDeadline];
    
}
- (void)dealloc
{
    [timer stopGCDTimer];
    NSLog(@"dealloc");
}

@end


