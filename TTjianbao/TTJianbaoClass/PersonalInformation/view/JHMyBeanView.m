//
//  JHMyBeanView
//  TTjianbao
//
//  Created by jiangchao on 2018/1/3.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "JHMyBeanView.h"
#import "JHBeanMoneyMode.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoBussiness.h"
#import "UIButton+ImageTitleSpacing.h"

#define headViewRate (float) 326/750

@interface JHMyBeanView ()
{
     UIView *agreeBack;
    JHBeanMoneyMode* currentBeanMoneyMode;
}
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) UIView * photoView;
@property(nonatomic,strong) UIView * headerView;
@property(nonatomic,strong) UILabel * beanCountLabel;
@property(nonatomic,strong) UIButton * completeButton;
@property(strong,nonatomic)UIButton* agreementBtn;
@end

@implementation JHMyBeanView
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
    self.contentScroll.backgroundColor =[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    self.contentScroll.scrollEnabled=YES;
    self.contentScroll.alwaysBounceVertical=YES;
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self);
        
    }];
    
    [self initHeaderView];
    [self initPhotoView];
    
    [self.contentScroll addSubview:self.completeButton];
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_photoView.mas_bottom).offset(50);
        make.left.equalTo(self.contentScroll).offset(20);
        make.right.equalTo(self.contentScroll).offset(-20);
        make.height.offset(50);
        
    }];
    
    [self initAgreeView];
    
       User *user = [UserInfoRequestManager sharedInstance].user;
       _beanCountLabel.text=user.balance;
    
}
-(void)initHeaderView{
    
    _headerView=[[UIView alloc]init];
    _headerView.backgroundColor=[UIColor clearColor];
    [self.contentScroll addSubview:_headerView];
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(headViewRate*ScreenW);
        make.width.offset(ScreenW);
        
    }];
    
    UIImageView *backImage=[[UIImageView alloc]init];
    backImage.contentMode = UIViewContentModeScaleAspectFit;
    backImage.image=[UIImage imageNamed:@"mybean_back"];
    [_headerView addSubview:backImage];
    
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_headerView);
       
    }];
    
    UIImageView *logo=[[UIImageView alloc]init];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image=[UIImage imageNamed:@"beanlogo"];
    [_headerView addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerView);
        make.top.offset(10);
    }];
 
    UILabel * title=[[UILabel alloc]init];
    title.text=@"我的鉴豆";
    title.font=[UIFont systemFontOfSize:18];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[CommHelp toUIColorByStr:@"#333333"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_headerView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logo.mas_bottom).offset(10);
        make.centerX.equalTo(_headerView);
        
    }];
    
    _beanCountLabel=[[UILabel alloc]init];
    _beanCountLabel.font=[UIFont boldSystemFontOfSize:25];
    _beanCountLabel.backgroundColor=[UIColor clearColor];
    _beanCountLabel.textColor=[CommHelp toUIColorByStr:@"#333333"];
    _beanCountLabel.numberOfLines = 1;
    _beanCountLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _beanCountLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_headerView addSubview:_beanCountLabel];
    
    [_beanCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(5);
        make.centerX.equalTo(_headerView);
        
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"鉴豆记录" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_bean_record_arrow"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [btn addTarget:self action:@selector(recordBean) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                            imageTitleSpace:10];
    [_headerView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerView);
        make.top.equalTo(_beanCountLabel.mas_bottom).offset(-10);
        make.height.equalTo(@40);
    }];
    
    
}
-(void)initPhotoView{
    
    
    UILabel * title=[[UILabel alloc]init];
    title.text=@"充值金额";
    title.font=[UIFont systemFontOfSize:15];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[CommHelp toUIColorByStr:@"#666666"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_headerView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(_headerView.mas_bottom).offset(20);
        make.left.equalTo(self.contentScroll).offset(10);
        
    }];
    
    _photoView=[[UIView alloc]init];
    [self.contentScroll addSubview:_photoView];
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        
    }];
    
    
}
-(UIButton*)completeButton{
    
    if (!_completeButton) {
        _completeButton=[UIButton new];
//        _completeButton.contentMode=UIViewContentModeScaleAspectFit;
        [_completeButton setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
        _completeButton.titleLabel.font=[UIFont systemFontOfSize:17];
        _completeButton.backgroundColor = kGlobalThemeColor;
        _completeButton.layer.cornerRadius = 2;
        _completeButton.layer.masksToBounds = YES;

        [_completeButton addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
        [_completeButton setTitle:@"立即充值" forState:UIControlStateNormal];
        
        
    }
    return _completeButton;
}
-(void)initAgreeView{
    
    agreeBack=[UIView new];
    agreeBack.backgroundColor=[UIColor clearColor];
    [self.contentScroll addSubview:agreeBack];
    
    [ agreeBack  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.completeButton.mas_bottom).offset(20);
        make.height.offset(30);
        make.centerX.equalTo(self.contentScroll);
        make.bottom.equalTo(self.contentScroll);
    }];
    
    UIImageView *logo=[[UIImageView alloc]init];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image=[UIImage imageNamed:@"bean_agree"];
    [agreeBack addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agreeBack);
        make.centerY.equalTo(agreeBack);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
   
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines =1;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment = UIControlContentHorizontalAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor=[UIColor yellowColor];
    label.text = @"已知晓并同意";
    label.font=[UIFont systemFontOfSize:11];
    label.textColor = [UIColor colorWithRed:0.48f green:0.58f blue:0.61f alpha:1.00f];
    [agreeBack addSubview:label];
    
    [ label  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logo.mas_right).offset(5);
        make.centerY.equalTo(logo);
        
    }];
    
     [agreeBack addSubview:self.agreementBtn];
    
    [ self.agreementBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right);
        make.right.equalTo(agreeBack);
        make.centerY.equalTo(label);
        make.right.equalTo(agreeBack);
    }];
    
}
-(UIButton*)agreementBtn{
    
    if (_agreementBtn==nil) {
        _agreementBtn=[[UIButton alloc]init];
        [_agreementBtn setTitle:@"《用户充值协议》" forState:UIControlStateNormal];
        _agreementBtn.titleLabel.font=[UIFont systemFontOfSize:11];
        [_agreementBtn setTitleColor:[UIColor colorWithRed:0.22f green:0.60f blue:0.85f alpha:1.00f] forState:UIControlStateNormal];
        _agreementBtn.backgroundColor=[UIColor clearColor];
        [_agreementBtn addTarget:self action:@selector(agreeMent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _agreementBtn;
    
}
-(void)setBeanMoneyModes:(NSArray<JHBeanMoneyMode *> *)beanMoneyModes{

    _beanMoneyModes=beanMoneyModes;
    
    [_photoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger margin = 10;//设置相隔距离
    float imaWidth=(ScreenW-margin*4)/3;
    float imaHeight=imaWidth*(float)74/110;
    UIButton * lastView ;;
    
    for (int i=0; i<[_beanMoneyModes count]; i++) {
        
        UIButton * cellBtn=[[UIButton alloc]init];
        cellBtn.layer.masksToBounds =YES;
        cellBtn.layer.cornerRadius =5;
        [_photoView addSubview:cellBtn];
        JHBeanMoneyMode  *beanMoney=_beanMoneyModes[i];
//            [cellBtn  setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
             cellBtn.backgroundColor=[UIColor whiteColor];
            [cellBtn  setBackgroundImage:[UIImage imageNamed:@"bean_button_back"] forState:UIControlStateSelected];
            [cellBtn addTarget:self action:@selector(photoImageSelect:) forControlEvents:UIControlEventTouchUpInside];
            cellBtn.selected=NO;
            cellBtn.tag=200+i;
            if (i==0 ) {
                cellBtn.selected=YES;
                currentBeanMoneyMode=beanMoney;
            }
        
        UILabel * beanCount=[[UILabel alloc]init];
        beanCount.text=[NSString stringWithFormat:@"%@ 鉴豆",beanMoney.coinAmount];
        beanCount.font=[UIFont systemFontOfSize:15];
        beanCount.backgroundColor=[UIColor clearColor];
        beanCount.textColor=[CommHelp toUIColorByStr:@"#333333"];
        beanCount.numberOfLines = 1;
        beanCount.textAlignment = UIControlContentHorizontalAlignmentCenter;
        beanCount.lineBreakMode = NSLineBreakByWordWrapping;
        [cellBtn addSubview:beanCount];
        
        [beanCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cellBtn).offset(-10);
            make.centerX.equalTo(cellBtn);
            
        }];
        
        UILabel * beanPrice=[[UILabel alloc]init];
        beanPrice.text=[NSString stringWithFormat:@"¥ %@",beanMoney.price];
        beanPrice.font=[UIFont systemFontOfSize:15];
        beanPrice.backgroundColor=[UIColor clearColor];
        beanPrice.textColor=[CommHelp toUIColorByStr:@"#a7a7a7"];
        beanPrice.numberOfLines = 1;
        beanPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
        beanPrice.lineBreakMode = NSLineBreakByWordWrapping;
        [cellBtn addSubview:beanPrice];
        
        [beanPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cellBtn).offset(10);
            make.centerX.equalTo(cellBtn);
            
        }];
        
        
        [cellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.offset(imaWidth);
            make.height.offset(imaHeight);
            
            if (i/3==0) {
                
                make.top.equalTo(_photoView.mas_top).offset(10);
            }
            else{
                
                NSInteger  rate= i/3;
                make.top.equalTo(_photoView.mas_top).offset(imaHeight*rate+10*(rate)+10);
                
            }
            
            if (i%3 == 0) {
                make.left.offset(margin);
                
            }else{
                
                make.left.equalTo(lastView.mas_right).offset(margin);
            }
            
            if (i%3 == 2) {
                make.right.offset(-margin);
            }
            
            if (i == [_beanMoneyModes count] - 1){
                make.bottom.equalTo(_photoView).offset(-10);
            }
        }];
        
          lastView= cellBtn;
    }
}
-(void)reloadBeanCount{

    self.beanCountLabel.text=[UserInfoRequestManager sharedInstance].user.balance;
}
-(void)photoImageSelect:(UIButton*)button{
    
    for (UIView *view in _photoView.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton * btn=(UIButton*)view;
                btn.selected=NO;
        }
    }
    
    button.selected=YES;
    currentBeanMoneyMode=self.beanMoneyModes[button.tag-200];
    
}

-(void)complete{
    if ([self.delegate respondsToSelector:@selector(Complete:)]) {
        [self.delegate Complete:currentBeanMoneyMode];
    }
    
}
-(void)agreeMent:(UIButton*)button{
    
    if ([self.delegate respondsToSelector:@selector(agreeMent)]) {
            [self.delegate agreeMent];
        }
    
}

- (void)recordBean {
    if ([self.delegate respondsToSelector:@selector(didBeanRecod)]) {
        [self.delegate didBeanRecod];
    }
}
@end

