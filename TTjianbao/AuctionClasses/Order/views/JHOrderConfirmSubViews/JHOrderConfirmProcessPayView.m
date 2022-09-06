//
//  JHOrderConfirmProcessPayView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/1/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHOrderConfirmProcessPayView.h"
@interface JHOrderConfirmProcessPayView ()
@property(nonatomic,strong) UIView *cashView;
@end

@implementation JHOrderConfirmProcessPayView

-(void)initSubViews{
    
    _cashView=[[UIView alloc]init];
    _cashView.backgroundColor=[UIColor whiteColor];
    _cashView.userInteractionEnabled=YES;
    _cashView.layer.masksToBounds =YES;
    [self addSubview:_cashView];
    [_cashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self).offset(150);
       // make.height.offset(100);
        make.bottom.equalTo(self);
    }];
//    JHCustomLine *topLine = [JHUIFactory createLine];
//    [_cashView addSubview:topLine];
//    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_cashView).offset(0);
//        make.height.equalTo(@1);
//        make.left.offset(15);
//        make.right.offset(0);
//    }];
    
//    UIImageView *indicator=[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"orderConfirm_tip_line"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 200, 0,0) resizingMode:UIImageResizingModeStretch]];
//    indicator.contentMode = UIViewContentModeScaleToFill;
//    [_cashView addSubview:indicator];
//    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_cashView).offset(-50);
//        make.height.equalTo(@6);
//        make.left.offset(15);
//        make.right.offset(0);
//
//    }];
    
    UILabel * title=[[UILabel alloc]init];
    title.text=@"优惠后金额";
    title.font=[UIFont boldSystemFontOfSize:13];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=kColor333;
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_cashView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cashView).offset(15);
        make.top.equalTo(_cashView).offset(15);
    }];
    UIImageView *icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"orderconfirm_introduce_icon"]];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [_cashView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.left.equalTo(title.mas_right).offset(5);
    }];
    
    _deductionFinishPrice=[[UILabel alloc]init];
    _deductionFinishPrice.text=@"";
    _deductionFinishPrice.font = [UIFont fontWithName:kFontMedium size:13.f];
    //    _allPrice.backgroundColor=[UIColor yellowColor];
    _deductionFinishPrice.textColor=kColor333;
    _deductionFinishPrice.numberOfLines = 1;
    [_deductionFinishPrice setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    _deductionFinishPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _deductionFinishPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [_cashView addSubview:_deductionFinishPrice];
    
    [_deductionFinishPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title).offset(2);
        make.right.equalTo(_cashView.mas_right).offset(-5);
    }];
    
    UIView * indicator=[[UIView alloc]init];
    indicator.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
    [_cashView addSubview:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(15);
        make.height.equalTo(@1);
        make.left.offset(15);
        make.right.offset(0);
    }];
    
    UILabel * tip=[[UILabel alloc]init];
    tip.font=[UIFont systemFontOfSize:13];
    tip.backgroundColor=[UIColor clearColor];
    tip.textColor=kColor999;
    tip.numberOfLines = 1;
    tip.textAlignment = UIControlContentHorizontalAlignmentCenter;
    tip.lineBreakMode = NSLineBreakByWordWrapping;
    [_cashView addSubview:tip];
    
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cashView).offset(15);
        make.top.equalTo(indicator.mas_bottom).offset(15);
        make.bottom.equalTo(_cashView).offset(-15);
    }];
    tip.text=@"优惠后金额=宝贝价格-红包-代金券-折扣活动";

    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
