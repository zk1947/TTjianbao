//
//  JHStoneResaleHeaderView.m
//  TTjianbao
//
//  Created by jiang on 2019/12/1.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneResaleHeaderView.h"
#import "JHUIFactory.h"
#import "JHWebViewController.h"
#import "BYTimer.h"
#import "UIButton+ImageTitleSpacing.h"

@interface JHStoneResaleHeaderView ()
@property (strong, nonatomic)  UILabel *dealCount;
@property (strong, nonatomic)  UILabel *intentionCount;
@property (strong, nonatomic)  BYTimer *dealTimer;
@property (strong, nonatomic)  BYTimer *intentionTimer;
@end
@implementation JHStoneResaleHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
//        self.backgroundColor=[CommHelp toUIColorByStr:@"#f7f7f7"];
         self.backgroundColor = [UIColor clearColor];
        [self setupviews];
    }
    return self;
}
-(void)setupviews{
    
    //    UIImageView  *coverImage=[[UIImageView alloc]init];
    //    coverImage.image=[UIImage imageNamed:@""];
    //    coverImage.userInteractionEnabled=YES;
    //    coverImage.backgroundColor=[UIColor clearColor];
    //    coverImage.layer.cornerRadius = 0;
    //    coverImage.contentMode=UIViewContentModeScaleAspectFill;
    //    coverImage.layer.masksToBounds = YES;
    //    [self addSubview:coverImage];
    //    [coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.right.equalTo(self);
    //        make.height.offset((ScreenW - 0)*StoneHeaderImageRate);
    //        // make.height.offset(200);
    //    }];
    //    UILabel * title = [JHUIFactory createJHLabelWithTitle:@"天天鉴宝首创原石回血" titleColor:[CommHelp toUIColorByStr:@"#602600"] font:[UIFont fontWithName:kFontBoldPingFang size:16] textAlignment:NSTextAlignmentLeft preTitle:@""];
    //    [self addSubview:title];
    //    [title mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self).offset(17);
    //        make.left.equalTo(self).offset(17);
    //    }];
    //    UIImageView *icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"stoneresale_header_tip_icon"]];
    //    icon.contentMode=UIViewContentModeScaleAspectFit;
    //    [self addSubview:icon];
    //    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(title.mas_bottom).offset(5);
    //        make.left.equalTo(title);
    //    }];
    //    UILabel * desc = [JHUIFactory createJHLabelWithTitle:@"了解原石回血玩法" titleColor:[CommHelp toUIColorByStr:@"#602600"] font:[UIFont fontWithName:kFontBoldPingFang size:11] textAlignment:NSTextAlignmentLeft preTitle:@""];
    //    [self addSubview:desc];
    //    [desc mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(icon);
    //        make.left.equalTo(icon.mas_right).offset(5);
    //    }];

     UIView *back=[[UIView alloc]init];
    back.backgroundColor=[CommHelp toUIColorByStr:@"#f7f7f7"];
    [self addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(7);
    }];
    
    
    UIImageView *backView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"stone_mainview_headerback_icon"]];
    //backImageView.backgroundColor=[UIColor whiteColor];
//    backImageView.layer.cornerRadius = 8;
//    backImageView.layer.masksToBounds = YES;
    backView.userInteractionEnabled=YES;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
//        make.bottom.equalTo(@0);
        make.right.equalTo(@-0);
        make.height.offset((ScreenW -10)*StoneHeaderImageRate);
    }];
    
      UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        //      [button setBackgroundColor:[CommHelp randomColor]];
        button.backgroundColor = [UIColor clearColor];
    //    button.layer.cornerRadius = 15;
    //    button.layer.masksToBounds=YES;
        [button setTitle:@"天天鉴宝原石回血" forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:13];
        [button setTitleColor:kColor999 forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"stone_mainview_introduce_icon"] forState:UIControlStateNormal];
       // button.layer.borderColor = kColorEEE.CGColor;
      //  button.layer.borderWidth = 1.0;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView).offset(20);
            make.centerX.equalTo(backView);
            make.size.mas_equalTo(CGSizeMake(130, 30));
        }];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
        imageTitleSpace:5];
    
    UIView * dealView=[[UIView alloc]init];
   //  dealView.backgroundColor=[CommHelp randomColor];
    [backView addSubview:dealView];
    
    [dealView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView).offset(-10);
        make.left.equalTo(backView).offset(5);
        make.height.offset((ScreenW-10)*StoneHeaderImageRate*0.5);
        make.width.offset((ScreenW-10)/2);
    }];
    
    UILabel *dealLabel=[[UILabel alloc]init];
    dealLabel.text=@"累计宝友成交（单）";
    dealLabel.font=[UIFont fontWithName:kFontNormal size:13];
    dealLabel.textColor=kColor666;
    dealLabel.numberOfLines = 1;
    dealLabel.textAlignment = NSTextAlignmentLeft;
    dealLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [dealView addSubview:dealLabel];
    
    [dealLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(dealView.mas_bottom).offset(-15);
        make.centerX.equalTo(dealView);
    }];
    
    _dealCount=[[UILabel alloc]init];
   // _dealCount.text=@"123";
    _dealCount.font=[UIFont fontWithName:kFontBoldDIN size:30];
    _dealCount.textColor=kColor333;
    _dealCount.numberOfLines = 1;
    _dealCount.textAlignment = NSTextAlignmentLeft;
    _dealCount.lineBreakMode = NSLineBreakByWordWrapping;
    [dealView addSubview:_dealCount];
    
    [_dealCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(dealView);
        make.bottom.equalTo(dealLabel.mas_top).offset(-5);
    }];
    
    UIView * intentionView=[[UIView alloc]init];
   //  intentionView.backgroundColor=[CommHelp randomColor];
    [backView addSubview:intentionView];
    [intentionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView).offset(-10);
        make.right.equalTo(backView).offset(-5);
        make.width.offset((ScreenW-10)/2);
        make.height.offset((ScreenW-10)*StoneHeaderImageRate*0.5);
    }];
    
    UILabel *intentionLabel=[[UILabel alloc]init];
    intentionLabel.text=@"已为宝友回血（元）";
    intentionLabel.font=[UIFont fontWithName:kFontNormal size:13];
    intentionLabel.textColor=kColor666;
    intentionLabel.numberOfLines = 1;
    intentionLabel.textAlignment = NSTextAlignmentLeft;
    intentionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [dealView addSubview:intentionLabel];
    
    [intentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(intentionView);
        make.bottom.equalTo(intentionView.mas_bottom).offset(-15);
    }];
    
    _intentionCount=[[UILabel alloc]init];
    //_intentionCount.text=@"456";
    _intentionCount.font=[UIFont fontWithName:kFontBoldDIN size:30];
    _intentionCount.textColor=kColor333;
    _intentionCount.numberOfLines = 1;
    _intentionCount.textAlignment = NSTextAlignmentLeft;
    _intentionCount.lineBreakMode = NSLineBreakByWordWrapping;
    [intentionView addSubview:_intentionCount];
    
    [_intentionCount mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(intentionLabel.mas_top).offset(-5);
        make.centerX.equalTo(intentionView);
    }];
    
    JHCustomLine * line=[JHUIFactory createLine];
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.centerY.equalTo(backView).offset(15);
        make.size.mas_equalTo(CGSizeMake(1, 37));
    }];
}
-(void)setMode:(JHMainViewStoneHeaderInfoModel *)mode{
    
    _mode=mode;
    self.height = round((ScreenW -10)*StoneHeaderImageRate);
    [self AnimationDealCount:_mode.dealCount.doubleValue];
    [self AnimationIntentionCount:_mode.totalPrice.doubleValue];
}
-(void)buttonAction:(UIButton*)button{
    JHWebViewController *web = [[JHWebViewController alloc] init];
       web.urlString = StoneRestoreBuyRuleURL;
    [self.viewController.navigationController pushViewController:web animated:YES];
}
-(void)AnimationDealCount:(double)value{
    
    if (_dealTimer) {
        [_dealTimer stopGCDTimer];
        _dealTimer = nil;
    }
    _dealTimer=[[BYTimer alloc]init];
     double ratio = value /100.;
    __block  double lastValue= 0;
    JH_WEAK(self)
    [_dealTimer startGCDTimerOnMainQueueWithInterval:0.02 Blcok:^{
        JH_STRONG(self)
        double resValue = lastValue + ratio;
        if (resValue>= value) {
            self.dealCount.text = [NSString stringWithFormat:@"%.f", value];
            lastValue=value;
            [self.dealTimer stopGCDTimer];
            self.dealTimer = nil;
        }
        else{
            self.dealCount.text = [NSString stringWithFormat:@"%.f", resValue];
            lastValue=resValue;
        }
    }];
}
-(void)AnimationIntentionCount:(double)value{
    
    if (_intentionTimer) {
        [_intentionTimer stopGCDTimer];
        _intentionTimer = nil;
    }
    _intentionTimer=[[BYTimer alloc]init];
    double ratio = value /100.;
    __block  double lastValue= 0;
    JH_WEAK(self)
    [_intentionTimer startGCDTimerOnMainQueueWithInterval:0.02 Blcok:^{
        JH_STRONG(self)
        double resValue = lastValue + ratio;
        if (resValue>= value) {
            self.intentionCount.text = [NSString stringWithFormat:@"%.f", value];
            lastValue=value;
            [self.intentionTimer stopGCDTimer];
            self.intentionTimer = nil;
        }
        else{
            self.intentionCount.text = [NSString stringWithFormat:@"%.f", resValue];
            lastValue=resValue;
        }
    }];
    
}
@end
