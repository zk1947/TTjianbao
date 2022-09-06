//
//  JHPayView.m
//  TTjianbao
//
//  Created by jiang on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPayView.h"
#import "PayMode.h"
#import "TTjianbaoHeader.h"
#import "JHQYChatManage.h"

@interface JHPayView ()
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) UIView *allPriceView;
@property(nonatomic,strong) UIView *payWayView;
@property (strong, nonatomic)  UILabel *allPrice;
@property (strong, nonatomic)  PayWayMode *payWayMode;
@end
@implementation JHPayView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initScrollview];
    }
    
    return self;
}
-(void)initScrollview{
    
    self.contentScroll=[[UIScrollView alloc]init];
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = YES;
    self.contentScroll.backgroundColor =[CommHelp toUIColorByStr:@"#f7f7f7"];
    self.contentScroll.scrollEnabled=NO;
    self.contentScroll.alwaysBounceVertical=YES;
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self);
    }];
    
    [self initPayPriceView];
    [self initPayWayView];
    [self initBottomView];
    
}
-(void)initPayPriceView{
    
    _allPriceView=[[UIView alloc]init];
    _allPriceView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_allPriceView];
    
    [_allPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll.mas_top).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.width.offset(ScreenW);
        make.height.offset(50);
    }];
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"支付金额:";
    title.font=[UIFont systemFontOfSize:14];
    title.textColor=[CommHelp toUIColorByStr:@"#666666"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_allPriceView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_allPriceView);
        make.left.equalTo(_allPriceView).offset(10);
    }];
    
    _allPrice=[[UILabel alloc]init];
    _allPrice.text=@"¥";
    _allPrice.font = [UIFont fontWithName:kFontBoldDIN size:22.f];
    _allPrice.textColor=kColor222;
    _allPrice.numberOfLines = 1;
    [_allPrice setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    _allPrice.textAlignment = NSTextAlignmentRight;
    _allPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [_allPriceView addSubview:_allPrice];
    
    [_allPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.left.equalTo(title.mas_right).offset(5);
        make.right.equalTo(_allPriceView.mas_right).offset(-10);
    }];
}

-(void)initPayWayView{
    
    UILabel  *viewTitle=[[UILabel alloc]init];
    viewTitle.text=@"付款方式";
    viewTitle.font=[UIFont systemFontOfSize:13];
    viewTitle.backgroundColor=[CommHelp toUIColorByStr:@"#f7f7f7"];
    viewTitle.textColor=[CommHelp toUIColorByStr:@"#999999"];
    viewTitle.numberOfLines = 1;
    viewTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    viewTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentScroll addSubview:viewTitle];
    
    [viewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allPriceView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(30);
    }];
    
    _payWayView=[[UIView alloc]init];
    _payWayView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_payWayView];
    
    [_payWayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewTitle.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.bottom.equalTo(self.contentScroll).offset(0);
    }];
    
}
-(void)initPayWaySubviews:(NSArray*)arr{
    UIView * lastView;
    for (int i=0; i<[arr count]; i++) {
        
        PayWayMode * payMode =arr[i];
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(payWayViewTap:)]];
        [_payWayView addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.text=payMode.name;
        title.font=[UIFont systemFontOfSize:15];
        title.backgroundColor=[UIColor clearColor];
        title.textColor=[CommHelp toUIColorByStr:@"#222222"];
        title.numberOfLines = 1;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UIImageView * logo=[[UIImageView alloc]init];
        [logo jhSetImageWithURL:[NSURL URLWithString:payMode.icon] placeholder:nil];
        logo.contentMode = UIViewContentModeScaleAspectFit;
        [logo setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [logo setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [view addSubview:logo];
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(view).offset(10);
            make.centerY.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(25,40));
        }];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(logo.mas_right).offset(5);
            make.centerY.equalTo(view);
        }];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"order_pay_button"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"order_pay_button_select"] forState:UIControlStateSelected];
        button.contentMode=UIViewContentModeScaleAspectFit;
        button.userInteractionEnabled=NO;
        [view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-20);
            make.centerY.equalTo(view);
        }];
        button.selected=NO;
//        if (payMode.isDefault) {
//            button.selected=YES;
//            self.payWayMode=payMode;
//        }
        if (i==0) {
            button.selected=YES;
            self.payWayMode=payMode;
        }
        
        UILabel  *tip=[[UILabel alloc]init];
        tip.text=payMode.remarks;
        tip.font=[UIFont systemFontOfSize:12];
        tip.backgroundColor=[UIColor clearColor];
        tip.textColor=kColor999;
        tip.numberOfLines = 1;
        tip.textAlignment = UIControlContentHorizontalAlignmentCenter;
        tip.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(button.mas_left).offset(-5);
            make.centerY.equalTo(view);
        }];
        
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
            make.left.right.equalTo(_payWayView);
            if (i==0) {
                make.top.equalTo(_payWayView);
            }
            else{
                make.top.equalTo(lastView.mas_bottom);
            }
            if (i==[arr count]-1) {
                
                make.bottom.equalTo(_payWayView);
            }
            
        }];
        
        lastView= view;
    }
    
}
-(void)initBottomView{
    
    UIView * bottom=[[UIView alloc]init];
    [self addSubview:bottom];
    
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.top.equalTo(_payWayView.mas_bottom).offset(50);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.bottom.equalTo(self).offset(-30-UI.bottomSafeAreaHeight);
    }];
    
    UIView * backView=[[UIView alloc]init];
    [bottom addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottom).offset(10);
        make.centerX.equalTo(bottom);
        make.height.equalTo(@30);
    }];
    
    UILabel  *serveTitle=[[UILabel alloc]init];
    serveTitle.text=@"支付遇到问题？请联系";
    serveTitle.font=[UIFont systemFontOfSize:13];
    serveTitle.backgroundColor=[UIColor clearColor];
    serveTitle.textColor=[CommHelp toUIColorByStr:@"#999999"];
    serveTitle.numberOfLines = 1;
    serveTitle.textAlignment = UIControlContentHorizontalAlignmentLeft;
    serveTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [backView addSubview:serveTitle];
    
    [serveTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView);
        make.left.equalTo(backView).offset(10);
    }];
    
    UIButton  *serverBtn=[[UIButton alloc]init];
    [serverBtn setTitle:@"官方客服" forState:UIControlStateNormal];
    serverBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [serverBtn setTitleColor:[UIColor colorWithRed:0.22f green:0.60f blue:0.85f alpha:1.00f] forState:UIControlStateNormal];
    serverBtn.backgroundColor=[UIColor clearColor];
    [serverBtn addTarget:self action:@selector(Contact) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:serverBtn];
    
    [serverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView);
        make.right.equalTo(backView).offset(-5);
        make.left.equalTo(serveTitle.mas_right).offset(0);
    }];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"支付" forState:UIControlStateNormal];
    [button setTitleColor:kColor222 forState:UIControlStateNormal];
    button.backgroundColor=kColorMain;
    button.layer.masksToBounds=YES;
    button.layer.cornerRadius = 22;
    [button addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottom).offset(10);
        make.right.equalTo(bottom).offset(-10);
        make.top.equalTo(backView.mas_bottom).offset(5);
        make.height.offset(44);
        make.bottom.equalTo(bottom);
    }];
}
-(void)Contact{
    
    [[JHQYChatManage shareInstance] showChatWithViewcontroller:self.viewController];
    
}
-(void)payWayViewTap:(UITapGestureRecognizer*)tap{
    
    [self cancleButtonSelect:self.payWayView];
    
    UITapGestureRecognizer *tapView=(UITapGestureRecognizer*)tap;
    for (UIView * view in tapView.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn=(UIButton*)view;
            btn.selected=YES;
        }
    }
    self.payWayMode=self.payWayArray[tap.view.tag];
    
}
- (void)cancleButtonSelect:(UIView *)view
{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)subView;
            btn.selected=NO;
        } else {
            [self cancleButtonSelect:subView];
        }
    }
}

-(void)setPrice:(NSString *)price{
    _price=price;
    _allPrice.text=[NSString stringWithFormat:@"¥ %.2f",[_price doubleValue]];
}
-(void)setPayWayArray:(NSArray *)payWayArray{
    _payWayArray=payWayArray;
    [self initPayWaySubviews: _payWayArray];
}

-(void)onClickBtnAction:(UIButton*)sender{
    
     if (self.delegate&&[self.delegate respondsToSelector:@selector(Complete:andPayMoney:)]) {
        [self.delegate Complete:self.payWayMode andPayMoney:[self.allPrice.text doubleValue]];
    }
}
- (void)dealloc
{
    NSLog(@"dealloc");
}
@end
