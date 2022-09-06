//
//  JHOrderDetailView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrderDetailView.h"
#import "NSString+AttributedString.h"
#import "JHItemMode.h"
#import "TTjianbaoHeader.h"
#import "EnlargedImage.h"
#import "BYTimer.h"
#import "JHGrowingIO.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHWebImage.h"

#define headViewRate (float) 250/750
@interface JHOrderDetailView ()<UITextViewDelegate>
{
    UITextView *noteTextview;
    UILabel * titleTip;
    BYTimer *timer;
}
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) UIView * remainTimeView;
@property(nonatomic,strong) UIView * addressView;
@property(nonatomic,strong) UIView *productView;
@property(nonatomic,strong) UIView *orderInfoView;
@property(nonatomic,strong) UIView *payListView;
@property(nonatomic,strong) UIView *buttonBackView;
@property(nonatomic,strong) UIView *serviceView;
@property(nonatomic,strong) UIImageView * orderStatusLogo;
@property(nonatomic,strong) UILabel * remainTime;
@property(nonatomic,strong) UILabel * orderStatusLabel;
@property (strong, nonatomic)  UILabel* userName;
@property (strong, nonatomic)  UILabel *address;
@property (strong, nonatomic)  UILabel *userPhoneNum;
@property (strong, nonatomic)  UILabel *sallerName;
@property (strong, nonatomic)  UILabel *productPrice;
@property (strong, nonatomic)  UILabel *productTitle;
@property (strong, nonatomic)  UIImageView *productImage;
@property (strong, nonatomic)  UIImageView *sallerHeadImage;
@property (strong, nonatomic)  UILabel *allPrice;
@property (strong, nonatomic)  UILabel *coponPrice;
@property (strong, nonatomic)  UILabel *cashPacketPrice;
@property (strong, nonatomic)  UILabel *balance;
@property (strong, nonatomic)  UIView *feeView;

@end
@implementation JHOrderDetailView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initScrollview];
        [self initBottomView];
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
        make.bottom.equalTo(self).offset(-50-UI.bottomSafeAreaHeight);
        make.left.right.equalTo(self);
        
    }];
    
    [self initTitleView];
    [self initProductView];
    [self initAddressView];
    [self initPayListView];
    [self initOrderInfoView];
    [self initServeView];
    
}
-(void)initTitleView{
    
    _remainTimeView=[[UIView alloc]init];
    _remainTimeView.backgroundColor=[CommHelp  toUIColorByStr:@"#fffbdb"];
    [self.contentScroll addSubview:_remainTimeView];
    
    [_remainTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.width.offset(ScreenW);
    }];
    
    UIImageView * headerImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_detail_head_back"]];
    [_remainTimeView addSubview:headerImage];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(_remainTimeView);
        make.width.offset(ScreenW);
        make.height.offset(ScreenW*headViewRate);
    }];
    
    _orderStatusLogo=[[UIImageView alloc]init];
    _orderStatusLogo.contentMode = UIViewContentModeScaleAspectFit;
    // _orderStatusLogo.image=[UIImage imageNamed:@"order_detail_pay"];
    [_remainTimeView addSubview:_orderStatusLogo];
    
    [_orderStatusLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_remainTimeView).offset(20);
        make.centerX.equalTo(_remainTimeView);
    }];
    
    UIView  *back=[UIView new];
    [_remainTimeView addSubview:back];
    [ back  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderStatusLogo.mas_bottom).offset(20);
        make.centerX.equalTo(_remainTimeView);
    }];
    
    _orderStatusLabel = [[UILabel alloc] init];
    _orderStatusLabel.numberOfLines =1;
    _orderStatusLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _orderStatusLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _orderStatusLabel.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _orderStatusLabel.text = @"";
    _orderStatusLabel.font=[UIFont boldSystemFontOfSize:15];
    [back addSubview:_orderStatusLabel];
    
    [ _orderStatusLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back).offset(5);
        make.centerY.equalTo(back);
    }];
    
    _remainTime=[[UILabel alloc]init];
    _remainTime.text=@"";
    _remainTime.font=[UIFont boldSystemFontOfSize:15];
    _remainTime.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _remainTime.numberOfLines = 1;
    _remainTime.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _remainTime.lineBreakMode = NSLineBreakByWordWrapping;
    [back addSubview:_remainTime];
    
    [_remainTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderStatusLabel.mas_right).offset(5);
        make.right.equalTo(back.mas_right);
        make.centerY.equalTo(_orderStatusLabel);
    }];
}
-(void)initProductView{
    
    _productView=[[UIView alloc]init];
    _productView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_productView];
    
    [_productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remainTimeView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        //        make.height.offset(120);
    }];
    
    _sallerHeadImage=[[UIImageView alloc]initWithImage:kDefaultAvatarImage];
    _sallerHeadImage.layer.masksToBounds =YES;
    _sallerHeadImage.layer.cornerRadius =10;
    _sallerHeadImage.userInteractionEnabled=YES;
    [_sallerHeadImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap:)]];
    [_productView addSubview:_sallerHeadImage];
    
    [_sallerHeadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(7);
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.left.offset(15);
    }];
    
    _sallerName=[[UILabel alloc]init];
    _sallerName.text=@"";
    _sallerName.font=[UIFont systemFontOfSize:15];
    _sallerName.backgroundColor=[UIColor clearColor];
    _sallerName.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _sallerName.numberOfLines = 1;
    _sallerName.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _sallerName.lineBreakMode = NSLineBreakByWordWrapping;
    _sallerName.userInteractionEnabled=YES;
    [_sallerName addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap:)]];
    [_productView addSubview:_sallerName];
    
    [_sallerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_sallerHeadImage);
        make.left.equalTo(_sallerHeadImage.mas_right).offset(10);
    }];
    
    UIView * line=[[UIView alloc]init];
    line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
    [_productView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(_sallerHeadImage.mas_bottom).offset(7);
        make.right.equalTo(self).offset(0);
        make.height.offset(1);
    }];
    
    _productImage=[[UIImageView alloc]init];
    _productImage.contentMode = UIViewContentModeScaleAspectFill;
    _productImage.layer.masksToBounds=YES;
    [_productView addSubview:_productImage];
    _productImage.userInteractionEnabled=YES;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
    [_productImage addGestureRecognizer:tapGesture];
    
    [_productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(7);
        make.left.equalTo(_sallerHeadImage);
        make.size.mas_equalTo(CGSizeMake(100, 100));
        
    }];
    
    
    _productTitle=[[UILabel alloc]init];
    _productTitle.text=@"";
    _productTitle.font=[UIFont boldSystemFontOfSize:15];
    _productTitle.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _productTitle.numberOfLines = 2;
    _productTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _productTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:_productTitle];
    
    [_productTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productImage).offset(0);
        make.left.equalTo(_productImage.mas_right).offset(5);
        make.right.equalTo(_productView.mas_right).offset(-5);
    }];
    
    _feeView=[[UIView alloc]init];
    _feeView.backgroundColor=[UIColor whiteColor];
    _feeView.layer.masksToBounds=YES;
    [_productView addSubview:_feeView];
    [_feeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productImage.mas_bottom).offset(15);
        make.left.equalTo(_productView).offset(0);
        make.right.equalTo(_productView).offset(0);
    }];
    
    
    //    UILabel* allmoneyTitle=[[UILabel alloc]init];
    //    allmoneyTitle.text=@"订单总额";
    //    allmoneyTitle.font=[UIFont systemFontOfSize:15];
    //    allmoneyTitle.textColor=[CommHelp toUIColorByStr:@"#333333"];
    //    allmoneyTitle.numberOfLines = 1;
    //    allmoneyTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    //    allmoneyTitle.lineBreakMode = NSLineBreakByWordWrapping;
    //    [_productView addSubview:allmoneyTitle];
    //
    //    [allmoneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(_feeView.mas_bottom).offset(10);
    //        make.left.equalTo(_productImage).offset(5);
    //    }];
    //
    //    _allPrice=[[UILabel alloc]init];
    //    _allPrice.text=@"¥0";
    //    _allPrice.font=[UIFont systemFontOfSize:16];
    //    _allPrice.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
    //    _allPrice.numberOfLines = 1;
    //    _allPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
    //    _allPrice.lineBreakMode = NSLineBreakByWordWrapping;
    //    [_productView addSubview:_allPrice];
    //
    //    [_allPrice mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(allmoneyTitle).offset(0);
    //        make.right.equalTo(_productView.mas_right).offset(-10);
    //
    //    }];
    
    UILabel* coponPriceTitle=[[UILabel alloc]init];
    coponPriceTitle.text=@"代金券抵扣";
    coponPriceTitle.font=[UIFont systemFontOfSize:13];
    coponPriceTitle.textColor=kColor999;
    coponPriceTitle.numberOfLines = 1;
    coponPriceTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    coponPriceTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:coponPriceTitle];
    
    [coponPriceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_feeView.mas_bottom).offset(10);
        make.left.equalTo(_productImage).offset(0);
        
    }];
    
    _coponPrice=[[UILabel alloc]init];
    _coponPrice.text=@"¥0";
    _coponPrice.font=[UIFont systemFontOfSize:13];
    _coponPrice.textColor=kColor999;
    _coponPrice.numberOfLines = 1;
    _coponPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _coponPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:_coponPrice];
    
    [_coponPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(coponPriceTitle).offset(0);
        make.right.equalTo(_productView.mas_right).offset(-10);
        
    }];
    
    UILabel* cashPacketPriceTitle=[[UILabel alloc]init];
    cashPacketPriceTitle.text=@"红包抵扣";
    cashPacketPriceTitle.font=[UIFont systemFontOfSize:13];
    cashPacketPriceTitle.textColor=kColor999;
    cashPacketPriceTitle.numberOfLines = 1;
    cashPacketPriceTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    cashPacketPriceTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:cashPacketPriceTitle];
    
    [cashPacketPriceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coponPriceTitle.mas_bottom).offset(15);
        make.left.equalTo(_productImage).offset(0);
        
    }];
    
    _cashPacketPrice=[[UILabel alloc]init];
    _cashPacketPrice.text=@"¥0";
    _cashPacketPrice.font=[UIFont systemFontOfSize:13];
    _cashPacketPrice.textColor=kColor999;
    _cashPacketPrice.numberOfLines = 1;
    _cashPacketPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _cashPacketPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:_cashPacketPrice];
    
    [_cashPacketPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(cashPacketPriceTitle).offset(0);
        make.right.equalTo(_productView.mas_right).offset(-10);
        
    }];
    
    UILabel* balanceTitle=[[UILabel alloc]init];
    balanceTitle.text=@"津贴抵扣";
    balanceTitle.font=[UIFont systemFontOfSize:13];
    balanceTitle.textColor=kColor999;
    balanceTitle.numberOfLines = 1;
    balanceTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    balanceTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:balanceTitle];
    
    [balanceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cashPacketPriceTitle.mas_bottom).offset(15);
        make.left.equalTo(_productImage).offset(0);
        
    }];
    
    _balance=[[UILabel alloc]init];
    _balance.text=@"¥0";
    _balance.font=[UIFont systemFontOfSize:13];
    _balance.textColor=kColor999;
    _balance.numberOfLines = 1;
    _balance.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _balance.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:_balance];
    
    [_balance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(balanceTitle).offset(0);
        make.right.equalTo(_productView.mas_right).offset(-10);
        
    }];
    
    UIView *line2=[[UIView alloc]init];
    line2.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
    [_productView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productView).offset(15);
        make.top.equalTo(balanceTitle.mas_bottom).offset(10);
        make.right.equalTo(_productView).offset(0);
        make.height.offset(1);
    }];
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"实付金额:";
    title.font=[UIFont systemFontOfSize:14];
    //    title.backgroundColor=[UIColor greenColor];
    title.textColor=kColor333;
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:title];
    
    _productPrice=[[UILabel alloc]init];
    _productPrice.text=@"¥0";
    _productPrice.font = [UIFont fontWithName:@"DINAlternate-Bold" size:22.f];
    _productPrice.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
    _productPrice.numberOfLines = 1;
    _productPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _productPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:_productPrice];
    
    [_productPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(balanceTitle.mas_bottom).offset(20);
        make.right.equalTo(_productView.mas_right).offset(-10);
    }];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_productPrice).offset(0);
        make.left.equalTo(_productView.mas_left).offset(15);
        make.bottom.equalTo(_productView.mas_bottom).offset(-15);
    }];
    
}
-(void)initAddressView{
    
    _addressView=[[UIView alloc]init];
    _addressView.backgroundColor=[UIColor whiteColor];
    _addressView.clipsToBounds=YES;
    [self.contentScroll addSubview:_addressView];
    [_addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(120);
    }];
    
    UILabel * title=[[UILabel alloc]init];
    title.text=@"收货地址";
    title.font=[UIFont boldSystemFontOfSize:14];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[CommHelp toUIColorByStr:@"#222222"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_addressView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_addressView).offset(15);
        make.left.equalTo(_addressView).offset(15);
        
    }];
    
    _userName=[[UILabel alloc]init];
    _userName.text=@"";
    _userName.font=[UIFont systemFontOfSize:14];
    _userName.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _userName.numberOfLines = 1;
    _userName.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _userName.lineBreakMode = NSLineBreakByWordWrapping;
    [_addressView addSubview:_userName];
    
    _userPhoneNum=[[UILabel alloc]init];
    _userPhoneNum.text=@"";
    _userPhoneNum.font=[UIFont systemFontOfSize:14];
    _userPhoneNum.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _userPhoneNum.numberOfLines = 1;
    _userPhoneNum.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _userPhoneNum.lineBreakMode = NSLineBreakByWordWrapping;
    [_addressView addSubview:_userPhoneNum];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title);
        make.top.equalTo(title.mas_bottom).offset(10);
        
    }];
    
    [_userPhoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userName);
        make.left.equalTo(_userName.mas_right).offset(10);
        
    }];
    
    _address=[[UILabel alloc]init];
    _address.text=@"";
    _address.font=[UIFont systemFontOfSize:14];
    _address.backgroundColor=[UIColor clearColor];
    _address.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _address.numberOfLines = 2;
    _address.lineBreakMode = NSLineBreakByTruncatingTail;
    _address.textAlignment = UIControlContentHorizontalAlignmentCenter;
    [_addressView addSubview:_address];
    
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userName.mas_bottom).offset(10);
        make.left.equalTo(title);
        make.right.equalTo(_addressView).offset(-10);
    }];
}
-(void)initPayListView{
    
    
    _payListView=[[UIView alloc]init];
    _payListView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_payListView];
    [_payListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
    }];
    
}
-(void)initOrderInfoView{
    
    _orderInfoView=[[UIView alloc]init];
    _orderInfoView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_orderInfoView];
    
    [_orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payListView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
    }];
    
}
-(void)initServeView{
    
    _serviceView=[[UIView alloc]init];
    _serviceView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_serviceView];
    
    [_serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderInfoView.mas_bottom).offset(1);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(40);
        make.bottom.equalTo(self.contentScroll);
    }];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"order_contactService_icon"] forState:UIControlStateNormal];//
    [button setTitle:@"联系客服" forState:UIControlStateNormal];
    [button setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:13];
    button.tag=JHOrderButtonTypeContact;
    [button addTarget:self action:@selector(ClickService:) forControlEvents:UIControlEventTouchUpInside];
    [_serviceView addSubview:button];
    [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                            imageTitleSpace:5];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_serviceView);
    }];
    
}
-(void)initFeeSubViews:(NSArray*)titles{
    
    UIView * lastView;
    for (int i=0; i<[titles count]; i++) {
        
        JHItemMode * item =titles[i];
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [_feeView addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.backgroundColor=[UIColor clearColor];
        [title setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        title.numberOfLines = 1;
        title.textColor=kColor999;
        title.font=[UIFont systemFontOfSize:14.f];
        title.text=item.title;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UILabel  *desc=[[UILabel alloc]init];
        desc.backgroundColor=[UIColor clearColor];
        [desc setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        desc.numberOfLines = 1;
        desc.textColor=kColor999;
        desc.font=[UIFont systemFontOfSize:14.f];
        desc.text=item.value;;
        desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:desc];
        
        if (i==titles.count-1) {
            title.textColor=kColor333;
            title.font=[UIFont systemFontOfSize:14.f];
            desc.textColor=kColor333;
            desc.font=[UIFont systemFontOfSize:14.f];
        }
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.top.bottom.equalTo(view);
        }];
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(view);
            make.right.equalTo(view.mas_right).offset(-10);
        }];
        
        if (i==[titles count]-1) {
            UIView * line=[[UIView alloc]init];
            line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
            [view addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(15);
                make.bottom.equalTo(view.mas_bottom).offset(0);
                make.right.equalTo(view).offset(0);
                make.height.offset(1);
            }];
        }
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_feeView);
            make.height.offset(30);
            if (i==0) {
                make.top.equalTo(_feeView).offset(0);
            }
            else{
                make.top.equalTo(lastView.mas_bottom).offset(0);
            }
            if (i==[titles count]-1) {
                make.bottom.equalTo(_feeView).offset(0);
            }
            
        }];
        
        lastView= view;
    }
    
}
-(void)initPayListSubviews:(NSArray*)arr{
    
    
    UILabel  * payTitle=[[UILabel alloc]init];
    payTitle.text=@"订单支付明细";
    payTitle.font=[UIFont systemFontOfSize:15];
    payTitle.backgroundColor=[UIColor whiteColor];
    payTitle.textColor=kColor333;
    payTitle.numberOfLines = 1;
    payTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    payTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [_payListView addSubview:payTitle];
    
    [payTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payListView).offset(10);
        make.left.equalTo(_payListView).offset(10);
        make.right.equalTo(_payListView).offset(0);
    }];
    UIView * lastView;
    for (int i=0; i<[arr count]; i++) {
        
        OrderFriendAgentPayMode * mode=arr[i];
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.payListView addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.font=[UIFont systemFontOfSize:14];
        title.backgroundColor=[UIColor clearColor];
        title.textColor=kColor666;
        title.numberOfLines = 1;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UILabel  *desc=[[UILabel alloc]init];
        
        desc.font=[UIFont systemFontOfSize:9];
        desc.backgroundColor=[UIColor clearColor];
        desc.textColor=kColor999;
        desc.numberOfLines = 1;
        desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:desc];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.top.equalTo(view).offset(5);
        }];
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.bottom.equalTo(view).offset(-10);
        }];
        
        UIImageView * logo=[[UIImageView alloc]init];
        logo.contentMode = UIViewContentModeScaleAspectFit;
        [logo setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [logo setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [view addSubview:logo];
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title.mas_right).offset(10);
            make.centerY.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(25,25));
        }];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.contentMode=UIViewContentModeScaleAspectFit;
        button.titleLabel.font= [UIFont systemFontOfSize:12];
        button.layer.cornerRadius = 2;
        button.tag=i;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderColor = kColor222.CGColor;
        button.layer.borderWidth = 0.5f;
        [button setTitle:@"找他代付" forState:UIControlStateNormal];
        [button setTitleColor:kColor222 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(OrderAgentpayShare:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
         button.hidden=YES;
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-20);
            make.centerY.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(72,30));
        }];
        if (mode.payResult==0||mode.payResult==-1) {
            title.text=[NSString stringWithFormat:@"%@暂未付款 ¥%@",mode.payChannelName,mode.cash];
            desc.text=[NSString stringWithFormat:@"剩余支付时间:%@",[CommHelp getHMSWithSecond:[CommHelp dateRemaining:mode.expireTime]]];
          //  button.hidden=NO;
        }
        else  if (mode.payResult==1) {
            title.text=[NSString stringWithFormat:@"%@ 成功支付 ¥%@",mode.payChannelName,mode.cash];
            desc.text=[NSString stringWithFormat:@"支付时间:%@",mode.payTime];
            logo.image=[UIImage imageNamed:@"friend_agnet_pay_success"];
          //  button.hidden=YES;
        }
        else  if (mode.payResult==2){
            title.text=[NSString stringWithFormat:@"%@ 未帮您支付 ¥%@",mode.payChannelName,mode.cash];
            desc.text=[NSString stringWithFormat:@"支付失效时间:%@",mode.expireTime];
            logo.image=[UIImage imageNamed:@"friend_agnet_pay_fail"];
          //  button.hidden=NO;
        }
        if ([mode.targetUrl length]>0) {
            button.hidden=NO;
        }
        else{
             button.hidden=YES;
        }
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        [view addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(view).offset(15);
            make.bottom.equalTo(view).offset(0);
            make.right.equalTo(view).offset(-15);
            make.height.offset(1);
        }];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50);
            make.left.right.equalTo(self.payListView);
            if (i==0) {
                make.top.equalTo(payTitle.mas_bottom).offset(10);
            }
            else{
                make.top.equalTo(lastView.mas_bottom);
            }
            if (i==[arr count]-1) {
                
                make.bottom.equalTo(self.payListView);
            }
        }];
        
        lastView= view;
        [view layoutIfNeeded];
        if (title.width>=desc.width) {
            [logo mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_right).offset(5);
                make.centerY.equalTo(view);
                make.size.mas_equalTo(CGSizeMake(25,25));
            }];
        }
        else{
            [logo mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(desc.mas_right).offset(5);
                make.centerY.equalTo(view);
                make.size.mas_equalTo(CGSizeMake(25,25));
            }];
        }
    }
}
-(void)setupOrderInfo:(NSArray*)titles{
    
    //    NSArray * titles=@[@"订单号",@"下单时间",@"支付时间",@"卖家发货",@"平台发货"];
    
    UIView * lastView;
    for (int i=0; i<[titles count]; i++) {
        
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [_orderInfoView addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.backgroundColor=[UIColor clearColor];
        [title setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        //  title.font=[UIFont systemFontOfSize:14];
        //  title.textColor=[CommHelp toUIColorByStr:@"#999999"];
        title.numberOfLines = 2;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        NSRange range = [[titles objectAtIndex:i] rangeOfString:@":"];
        NSString * substring=[[titles objectAtIndex:i] substringToIndex:range.location+1];
        title.attributedText=[[titles objectAtIndex:i] attributedSubString:substring font:[UIFont systemFontOfSize:14] color:[CommHelp toUIColorByStr:@"#999999"] allColor:[CommHelp toUIColorByStr:@"#222222"] allfont:[UIFont systemFontOfSize:14] ];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.top.bottom.equalTo(view);
            make.right.equalTo(view.mas_right).offset(-10);
        }];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(_orderInfoView);
            if (i==0) {
                make.top.equalTo(_orderInfoView).offset(10);
            }
            else{
                make.top.equalTo(lastView.mas_bottom).offset(10);
            }
            if (i==[titles count]-1) {
                make.bottom.equalTo(_orderInfoView).offset(-10);
            }
            
        }];
        
        lastView= view;
    }
    
}
-(void)initBottomView{
    
    _buttonBackView=[[UIView alloc]init];
    _buttonBackView.backgroundColor=[CommHelp toUIColorByStr:@"#f7f7f7"];
    [self addSubview:_buttonBackView];
    [_buttonBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).offset(0);
        make.height.offset(50+UI.bottomSafeAreaHeight);
        make.bottom.equalTo(self);
    }];
}
-(void)setUpButtons:(NSArray*)buttonArr{
    
    [_buttonBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIButton * lastView;
    for (int i=0; i<[buttonArr count]; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[[buttonArr objectAtIndex:i]objectForKey:@"buttonTitle"] forState:UIControlStateNormal];
        button.tag=[[[buttonArr objectAtIndex:i]objectForKey:@"buttonTag"] intValue];
        button.titleLabel.font= [UIFont systemFontOfSize:12];
        // [button setBackgroundImage:[UIImage imageNamed:@"orderList_cell_button"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 2.0;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderColor = [[CommHelp toUIColorByStr:@"#222222"] colorWithAlphaComponent:0.5].CGColor;
        button.layer.borderWidth = 0.5f;
        [button setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.contentMode=UIViewContentModeScaleAspectFit;
        [_buttonBackView addSubview:button];
        
        if  (button.tag==JHOrderButtonTypePay||
             button.tag==JHOrderButtonTypeCommit||
             button.tag==JHOrderButtonTypeReceive||
             button.tag==JHOrderButtonTypeReturnGood||
             button.tag==JHOrderButtonTypeAppraiseIssue)
        {
            [button setBackgroundColor:[CommHelp toUIColorByStr:@"#fee100"]];
            button.layer.borderWidth = 0;
        }
        if (button.tag==JHOrderButtonTypeSend) {
            button.layer.borderWidth = 0;
            [button setBackgroundColor:[CommHelp toUIColorByStr:@"#fee100"]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        if (button.tag==JHOrderButtonTypeComment) {
            button.layer.borderColor = [CommHelp toUIColorByStr:@"#fee100"].CGColor;
            button.layer.borderWidth = 1.0;
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setImage:[UIImage imageNamed:@"order_receivePadge"] forState:UIControlStateNormal];
            
        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (button.tag==JHOrderButtonTypeComment){
                make.size.mas_equalTo(CGSizeMake(95, 30));
            }
            else if (button.tag==JHOrderButtonTypeAppraiseIssue){
                make.size.mas_equalTo(CGSizeMake(108, 30));
            }
            else{
                make.size.mas_equalTo(CGSizeMake(72, 30));
            }
            make.centerY.equalTo(_buttonBackView);
            
            if (i==0) {
                make.right.equalTo(_buttonBackView).offset(-10);
            }
            else{
                make.right.equalTo(lastView.mas_left).offset(-10);
            }
        }];
        
        if (button.tag==JHOrderButtonTypeComment){
            [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                                    imageTitleSpace:5];
        }
        
        
        lastView= button;
    }
}

-(void)setFriendAgentpayArr:(NSArray *)friendAgentpayArr{
    
    _friendAgentpayArr=friendAgentpayArr;
    if (_friendAgentpayArr.count>0) {
        [_payListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addressView.mas_bottom).offset(10);
        }];
    }
    [self initPayListSubviews:_friendAgentpayArr];
    
}
-(void)setOrderMode:(OrderMode *)orderMode{
    
    _orderMode=orderMode;
    
    [_sallerHeadImage jhSetImageWithURL:[NSURL URLWithString:_orderMode.sellerImg] placeholder:kDefaultAvatarImage];
    [_productImage jhSetImageWithURL:[NSURL URLWithString: ThumbSmallByOrginal(_orderMode.goodsUrl)]];
    _sallerName.text=_orderMode.sellerName;
    // _productTitle.text=_orderMode.goodsTitle;
    UserInfoRequestManager * manager = [UserInfoRequestManager sharedInstance];
         NSString * url=[manager findValue:manager.orderCategoryIcons byKey:_orderMode.orderCategory];
    if (url) {
        JH_WEAK(self)
        [JHWebImage downloadImageWithURL:[NSURL URLWithString:url] completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            JH_STRONG(self)
            if (image) {
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:(self.orderMode.goodsTitle?: @"")];
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = image;
                attch.bounds = CGRectMake(0, -2,33, 15);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri insertAttributedString:string atIndex:0];
                [attri insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:1];
                self.productTitle.attributedText = attri;
            }
            else{
                self.productTitle.text=self.orderMode.goodsTitle;
            }
        }];
    }
    else{
        _productTitle.text=_orderMode.goodsTitle;
    }
    _productPrice.text=[@"¥ " stringByAppendingString:OBJ_TO_STRING(orderMode.orderPrice)];
    _allPrice.text=[@"¥ " stringByAppendingString:OBJ_TO_STRING(_orderMode.originOrderPrice)];
    if ([_orderMode.sellerDiscountAmount doubleValue]>0) {
        NSString * string=[NSString stringWithFormat:@"-¥%@",_orderMode.sellerDiscountAmount];
        NSRange  range1 =[string rangeOfString:@"优惠券抵扣"];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
        [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range1];
        [attString addAttribute:NSForegroundColorAttributeName value:[CommHelp toUIColorByStr:@"#333333"] range:range1];
        _coponPrice.attributedText=attString;
    }
    if ([_orderMode.discountAmount doubleValue]>0) {
        NSString * string=[NSString stringWithFormat:@"-¥%@",_orderMode.discountAmount];
        NSRange  range1 =[string rangeOfString:@"红包抵扣"];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
        [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range1];
        [attString addAttribute:NSForegroundColorAttributeName value:[CommHelp toUIColorByStr:@"#333333"] range:range1];
        _cashPacketPrice .attributedText=attString;
        
    }
    if ([_orderMode.bountyAmount doubleValue]>0) {
        NSString * string=[NSString stringWithFormat:@"-¥%@",_orderMode.bountyAmount];
        NSRange  range1 =[string rangeOfString:@"津贴抵扣"];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
        [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range1];
        [attString addAttribute:NSForegroundColorAttributeName value:[CommHelp toUIColorByStr:@"#333333"] range:range1];
        _balance.attributedText=attString;
        
    }
    
    if (_orderMode.shippingReceiverName&&_orderMode.shippingPhone) {
        _userName.text=_orderMode.shippingReceiverName;
        _userPhoneNum.text=[_orderMode.shippingPhone stringByReplacingOccurrencesOfString:[_orderMode.shippingPhone substringWithRange:NSMakeRange(3,4)]withString:@"****"];
        _address.text=[NSString stringWithFormat:@"%@ %@ %@ %@",_orderMode.shippingProvince,_orderMode.shippingCity,_orderMode.shippingCounty,_orderMode.shippingDetail];
        [_addressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(120);
            make.top.equalTo(_productView.mas_bottom).offset(10);
        }];
        
    }
    else{
        [_addressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
            make.top.equalTo(_productView.mas_bottom).offset(0);
        }];
    }
    
    [self handleOrderData:_orderMode];
    [self handleFeeData:_orderMode];
    
    NSMutableArray * buttons=[NSMutableArray array];
    if ([_orderMode.orderStatus isEqualToString:@"waitack"]) {
        
        self.orderStatusLabel.text=@"待付款";
        _orderStatusLogo.image=[UIImage imageNamed:@"order_detail_pay"];
        [buttons addObject:@{@"buttonTitle":@"支付订单",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeCommit]}];
        //        [buttons addObject:@{@"buttonTitle":@"联系客服",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeContact]}];
        
        [self timeCountDown];
    }
    else if ([_orderMode.orderStatus isEqualToString:@"waitpay"]) {
        
        self.orderStatusLabel.text=@"待付款";
        _orderStatusLogo.image=[UIImage imageNamed:@"order_detail_pay"];
        [buttons addObject:@{@"buttonTitle":@"支付订单",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypePay]}];
        [buttons addObject:@{@"buttonTitle":@"取消订单",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeCancle]}];
        //        [buttons addObject:@{@"buttonTitle":@"联系客服",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeContact]}];
        [self timeCountDown];
    }
    else  if ([_orderMode.orderStatus isEqualToString:@"waitsellersend"]) {
        
        self.orderStatusLabel.text=@"待发货";
        _orderStatusLogo.image=[UIImage imageNamed:@"order_detail_waitsend"];
        
        [buttons addObject:@{@"buttonTitle":@"联系客服",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeContact]}];
    }
    else  if ([_orderMode.orderStatus isEqualToString:@"sellersent"]) {
        
        _orderStatusLabel.text=@"待验货";
        _orderStatusLogo.image=[UIImage imageNamed:@"order_detail_waitsend"];
        
        //        [buttons addObject:@{@"buttonTitle":@"联系客服",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeContact]}];
    }
    else  if ([_orderMode.orderStatus isEqualToString:@"waitportalappraise"]) {
        
        self.orderStatusLabel.text=@"待验货";
        _orderStatusLogo.image=[UIImage imageNamed:@"order_detail_look"];
        
        [buttons addObject:@{@"buttonTitle":@"联系客服",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeContact]}];
    }
    else  if ([_orderMode.orderStatus isEqualToString:@"waitportalsend"]) {
        
        self.orderStatusLabel.text=@"待验货";
        _orderStatusLogo.image=[UIImage imageNamed:@"order_detail_look"];
        
        if (_orderMode.haveReport) {
            [buttons addObject:@{@"buttonTitle":@"鉴定详情",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeDetail]}];
        }
        //        [buttons addObject:@{@"buttonTitle":@"联系客服",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeContact]}];
    }
    
    else  if ([_orderMode.orderStatus isEqualToString:@"portalsent"]) {
        
        self.orderStatusLabel.text=@"待收货";
        _orderStatusLogo.image=[UIImage imageNamed:@"order_detail_recive"];
        
        
        [buttons addObject:@{@"buttonTitle":@"确认收货",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeReceive]}];
        if (_orderMode.haveReport){
            [buttons addObject:@{@"buttonTitle":@"鉴定详情",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeDetail]}];
        }
        [buttons addObject:@{@"buttonTitle":@"查看物流",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLogistics]}];
        //        [buttons addObject:@{@"buttonTitle":@"联系客服",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeContact]}];
        
    }
    else  if ([_orderMode.orderStatus isEqualToString:@"buyerreceived"]) {
        
        self.orderStatusLabel.text=@"已完成";
        _orderStatusLogo.image=[UIImage imageNamed:@"order_detail_complete"];
        
        //        [buttons addObject:@{@"buttonTitle":@"联系客服",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeContact]}];
        if (_orderMode.haveReport){
            [buttons addObject:@{@"buttonTitle":@"鉴定详情",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeDetail]}];
        }
        if (_orderMode.commentStatus){
            [buttons addObject:@{@"buttonTitle":@"已评价",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLookComment]}];
        }
        else{
            if (_orderMode.commentStatusShow) {
                [buttons addObject:@{@"buttonTitle":@"评价领红包",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeComment]}];
            }
        }
        
    }
    else  if ([_orderMode.orderStatus isEqualToString:@"cancel"]) {
        
        _orderStatusLogo.image=[UIImage imageNamed:@"order_detail_cancle"];
        _orderStatusLabel.text=@"订单已取消";
        
        [buttons addObject:@{@"buttonTitle":@"联系客服",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeContact]}];
    }
    
    else  if ([_orderMode.orderStatus isEqualToString:@"refunding"]) {
        _orderStatusLabel.text=_orderMode.workorderDesc;
        _orderStatusLogo.image=[UIImage imageNamed:@"order_return_icon"];
        [buttons addObject:@{@"buttonTitle":@"退货详情",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeReturnDetail]}];
        //        [buttons addObject:@{@"buttonTitle":@"联系客服",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeContact]}];
        if (_orderMode.refundButtonShow ){
            [buttons addObject:@{@"buttonTitle":(_orderMode.directDelivery?@"退货至商家":@"退货至平台"),@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeReturnGood]}];
        }
        [self timeCountDown];
    }
    else  if ([_orderMode.orderStatus isEqualToString:@"refunded"]) {
        _orderStatusLabel.text=_orderMode.workorderDesc;
        _orderStatusLogo.image=[UIImage imageNamed:@"order_return_icon"];
        [buttons addObject:@{@"buttonTitle":@"退货详情",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeReturnDetail]}];
        //        [buttons addObject:@{@"buttonTitle":@"联系客服",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeContact]}];
        
    }
    else {
        _orderStatusLabel.text=_orderMode.workorderDesc;
    }
    
    if (_orderMode.changeCustomerAddressShow) {
        [buttons addObject:@{@"buttonTitle":@"修改地址",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeAlterAddress]}];
    }
    if (_orderMode.couldRefundShow) {
        [buttons addObject:@{@"buttonTitle":@"退货退款",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeApplyReturn]}];
    }
    if (_orderMode.problemBtn) {
        [buttons addObject:@{@"buttonTitle":@"鉴定问题处理",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeAppraiseIssue]}];
    }
    
    [self setUpButtons:buttons];
    
}
-(void)handleFeeData:(OrderMode*)mode{
    
    NSMutableArray * titles=[NSMutableArray array];
    //加工单
    if ([mode.orderCategory isEqualToString:@"processingOrder"]) {
        if (mode.goodsPrice) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=@"宝贝价格";
            item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.goodsPrice)];
            [titles addObject:item];
        }
        if (mode.materialCost) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=@"材料费";
            item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.materialCost)];
            [titles addObject:item];
        }
        if (mode.manualCost) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=@"手工费";
            item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.manualCost)];
            [titles addObject:item];
        }
        if (mode.originOrderPrice) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=@"订单总额";
            item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.originOrderPrice)];
            [titles addObject:item];
        }
        
    }
    //加工服务单
  else  if ([mode.orderCategory isEqualToString:@"processingGoods"]) {
        if (mode.materialCost) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=@"材料费";
            item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.materialCost)];
            [titles addObject:item];
        }
        if (mode.manualCost) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=@"手工费";
            item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.manualCost)];
            [titles addObject:item];
        }
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=@"加工费";
      //  float price=[mode.manualCost floatValue]+[mode.materialCost floatValue];
      //  NSString * string=[NSString stringWithFormat:@"%.2f",price];
        item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.originOrderPrice)];
        [titles addObject:item];
    }
  else{
      if (mode.goodsPrice) {
          JHItemMode * item =[[JHItemMode alloc]init];
          item.title=@"宝贝价格";
          item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.goodsPrice)];
          [titles addObject:item];
      }
      if (mode.originOrderPrice) {
          JHItemMode * item =[[JHItemMode alloc]init];
          item.title=@"订单总额";
          item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.originOrderPrice)];
          [titles addObject:item];
      }
  }
    [self initFeeSubViews:titles];
    
}
-(void)handleOrderData:(OrderMode*)mode{
    
    NSMutableArray * titles=[NSMutableArray array];
    if (mode.orderCode) {
        [titles addObject: [@"订单编号:  " stringByAppendingString:OBJ_TO_STRING(mode.orderCode)]];
    }
    if (mode.orderCreateTime) {
        [titles addObject: [@"下单时间:  " stringByAppendingString:OBJ_TO_STRING(mode.orderCreateTime)]];
    }
    if (mode.payTime) {
        [titles addObject: [@"支付时间:  " stringByAppendingString:OBJ_TO_STRING(mode.payTime)]];
    }
    if (mode.sellerSentTime) {
        [titles addObject: [@"卖家发货:  " stringByAppendingString:OBJ_TO_STRING(mode.sellerSentTime)]];
    }
    if (mode.portalSentTime) {
        [titles addObject: [@"平台发货:  " stringByAppendingString:OBJ_TO_STRING(mode.portalSentTime)]];
    }
    
    [self setupOrderInfo:titles];
    
}
-(void)timeCountDown{
    
    if (self.orderMode) {
        //        if ([self.sellerOrderMode.orderStatus isEqualToString:@"waitpay"]) {
        //            _remainTime.text=[CommHelp getHMSWithSecond:[CommHelp dateRemaining:self.orderMode.payExpireTime]];
        //            if (!timer) {
        //                timer=[[BYTimer alloc]init];
        //            }
        //            [timer createTimerWithTimeout:[CommHelp dateRemaining:self.orderMode.payExpireTime] handlerBlock:^(int presentTime) {
        //                weakSelf.remainTime.text=[CommHelp getHMSWithSecond:presentTime];
        //            } finish:^{
        //                weakSelf.remainTime.text = @"订单已取消";
        //            }];
        //        }
        NSString * expireTime;
        if ([self.orderMode.orderStatus isEqualToString:@"waitack"]||[self.orderMode.orderStatus isEqualToString:@"waitpay"]) {
            expireTime=self.orderMode.payExpireTime;
        }
        else if ([self.orderMode.orderStatus isEqualToString:@"refunding"]) {
            expireTime=self.orderMode.refundExpireTime;
        }
        _remainTime.text=[CommHelp getHMSWithSecond:[CommHelp dateRemaining:expireTime]];
        JH_WEAK(self)
        if (!timer) {
            timer=[[BYTimer alloc]init];
        }
        [timer createTimerWithTimeout:[CommHelp dateRemaining:expireTime] handlerBlock:^(int presentTime) {
            JH_STRONG(self)
            self.remainTime.text=[CommHelp getHMSWithSecond:presentTime];
        } finish:^{
            JH_STRONG(self)
            if ([self.orderMode.orderStatus isEqualToString:@"waitack"]||[self.orderMode.orderStatus isEqualToString:@"waitpay"]) {
                self.remainTime.text = @"订单已取消";
            }
            else if ([self.orderMode.orderStatus isEqualToString:@"refunding"]) {
                self.remainTime.text = @"";
            }
            
        }];
        
    }
    else if (self.sellerOrderMode) {
        
        NSString * expireTime;
        if ([self.sellerOrderMode.orderStatus isEqualToString:@"waitack"]||[self.sellerOrderMode.orderStatus isEqualToString:@"waitpay"]) {
            expireTime=self.sellerOrderMode.payExpireTime;
        }
        else if ([self.sellerOrderMode.orderStatus isEqualToString:@"waitsellersend"]) {
            expireTime=self.sellerOrderMode.sellerSentExpireTime;
        }
        
        _remainTime.text=[CommHelp getHMSWithSecond:[CommHelp dateRemaining:expireTime]];
        JH_WEAK(self)
        if (!timer) {
            timer=[[BYTimer alloc]init];
        }
        [timer createTimerWithTimeout:[CommHelp dateRemaining:expireTime] handlerBlock:^(int presentTime) {
            JH_STRONG(self)
            self.remainTime.text=[CommHelp getHMSWithSecond:presentTime];
        } finish:^{
            JH_STRONG(self)
            self.remainTime.text = @"订单已取消";
        }];
    }
    
}
-(void)imageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    UIImageView * imageview=(UIImageView*)gestureRecognizer.view;
    NSMutableArray * arr;
    if (self.orderMode) {
        arr=[NSMutableArray arrayWithArray:@[self.orderMode.goodsUrl]];
    }
    else  if (self.sellerOrderMode) {
        arr=[NSMutableArray arrayWithArray:@[self.sellerOrderMode.goodsUrl]];
        
    }
    [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:0 result:^(NSInteger index) {
        
    }];
    
}
-(void)headImageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    if (self.orderMode.orderType ==0) {
        [JHRootController EnterLiveRoom:self.orderMode.channelLocalId fromString:JHLiveFromorderDetail];
    }
    else  if (self.orderMode.orderType ==1){
        ///enter UserInfo page
        [JHRootController enterUserInfoPage:self.orderMode.sellerCustomerId from:@""];
    }
}
-(void)buttonPress:(UIButton*)button{
    
    if (self.delegate) {
        [self.delegate buttonPress:button];
    }
    
}
-(void)OrderAgentpayShare:(UIButton*)button{
    
    OrderFriendAgentPayMode * mode=self.friendAgentpayArr[button.tag];
    if (self.shareHandle) {
        self.shareHandle(mode, nil);
    }
}
#pragma mark =============== delegate ===============

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
- (void)ClickService:(UIButton*)button{
    
    if (self.delegate) {
        [self.delegate buttonPress:button];
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [titleTip setHidden:NO];
    }else{
        [titleTip setHidden:YES];
    }
}
- (void)dealloc
{
    NSLog(@"detailView dealloc");
    [timer stopGCDTimer];
}
@end


