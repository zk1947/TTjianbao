//
//  JHOrderConfirmCoponView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/1/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHOrderConfirmCoponView.h"

@interface JHOrderConfirmCoponView ()
@property(nonatomic,strong) UIView *cashPacketView;
@property(nonatomic,strong) UIView *balanceView;
@property(nonatomic,strong) UIView *cashView;
@end
@implementation JHOrderConfirmCoponView

-(void)setSubViews{
    
    self.layer.cornerRadius = 0;
}
-(void)initSubViews{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self initMallCoponView];
    [self initCoponView];
    [self initDiscountCoponView];
    
}
-(void)initMallCoponView{
    
    _mallCoponView=[[UIView alloc]init];
    _mallCoponView.backgroundColor=[UIColor whiteColor];
    _mallCoponView.userInteractionEnabled=YES;
    _mallCoponView.layer.masksToBounds=YES;
    [_mallCoponView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapMallCopon:)]];
    [self addSubview:_mallCoponView];
    
    [_mallCoponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.offset(50);
    }];
    JHCustomLine *line = [JHUIFactory createLine];
    [_mallCoponView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_mallCoponView).offset(-1);
        make.height.equalTo(@1);
        make.left.offset(15);
        make.right.offset(0);
    }];
    UIImageView *indicator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_right_jiantou"]];
    indicator.backgroundColor=[UIColor clearColor];
    [indicator setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [indicator setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    indicator.contentMode = UIViewContentModeScaleAspectFit;
    [_mallCoponView addSubview:indicator];
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_mallCoponView).offset(-15);
        make.centerY.equalTo(_mallCoponView);
        
    }];
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"代金券";
    title.font=[UIFont fontWithName:kFontNormal size:13];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=kColor999;
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_mallCoponView addSubview:title];
    
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mallCoponView).offset(15);
        make.centerY.equalTo(_mallCoponView);
    }];
    _mallDesc=[[UILabel alloc]init];
    _mallDesc.text=@"暂无可用";
    _mallDesc.font=[UIFont fontWithName:kFontNormal size:13];
    _mallDesc.backgroundColor=[UIColor clearColor];
    _mallDesc.textColor=kColor999;
    _mallDesc.numberOfLines = 1;
    _mallDesc.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _mallDesc.lineBreakMode = NSLineBreakByWordWrapping;
    [_mallCoponView addSubview:_mallDesc];
    
    [_mallDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.right.equalTo(indicator.mas_left).offset(-10);
    }];
}
-(void)initCoponView{
    
    _platformCoponView=[[UIView alloc]init];
    _platformCoponView.backgroundColor=[UIColor whiteColor];
    _platformCoponView.userInteractionEnabled=YES;
    _platformCoponView.layer.masksToBounds=YES;
    [_platformCoponView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapCopon:)]];
    [self addSubview:_platformCoponView];
    JHCustomLine *line = [JHUIFactory createLine];
    [_platformCoponView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_platformCoponView).offset(-1);
        make.height.equalTo(@1);
        make.left.offset(15);
        make.right.offset(0);
        
    }];
    
    [_platformCoponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mallCoponView.mas_bottom).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.offset(50);
    }];
    
    UIImageView *indicator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_right_jiantou"]];
    indicator.backgroundColor=[UIColor clearColor];
    [indicator setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [indicator setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    indicator.contentMode = UIViewContentModeScaleAspectFit;
    [_platformCoponView addSubview:indicator];
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_platformCoponView).offset(-15);
        make.centerY.equalTo(_platformCoponView);
        
    }];
    
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"红包";
    title.font=[UIFont fontWithName:kFontNormal size:13];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=kColor999;
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_platformCoponView addSubview:title];
    
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_platformCoponView).offset(15);
        make.centerY.equalTo(_platformCoponView);
    }];
    
    _platformDesc=[[UILabel alloc]init];
    _platformDesc.text=@"暂无可用";
    _platformDesc.font=[UIFont fontWithName:kFontNormal size:13];
    _platformDesc.backgroundColor=[UIColor clearColor];
    _platformDesc.textColor=kColor999;
    _platformDesc.numberOfLines = 1;
    _platformDesc.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _platformDesc.lineBreakMode = NSLineBreakByWordWrapping;
    [_platformCoponView addSubview:_platformDesc];
    
    [_platformDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.right.equalTo(indicator.mas_left).offset(-10);
    }];
}
-(void)initDiscountCoponView{
    
    _discountCoponView=[[UIView alloc]init];
    _discountCoponView.backgroundColor=[UIColor whiteColor];
    _discountCoponView.userInteractionEnabled=YES;
    _discountCoponView.layer.masksToBounds=YES;
    [_discountCoponView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapDiscountCopon:)]];
    [self addSubview:_discountCoponView];
    JHCustomLine *line = [JHUIFactory createLine];
    [_discountCoponView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_discountCoponView).offset(-1);
        make.height.equalTo(@1);
        make.left.offset(15);
        make.right.offset(0);
        
    }];
    
    [_discountCoponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_platformCoponView.mas_bottom).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.offset(50);
        make.bottom.equalTo(self);
    }];
    
    UIImageView *indicator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_right_jiantou"]];
    indicator.backgroundColor=[UIColor clearColor];
    [indicator setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [indicator setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    indicator.contentMode = UIViewContentModeScaleAspectFit;
    [_discountCoponView addSubview:indicator];
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_discountCoponView).offset(-15);
        make.centerY.equalTo(_discountCoponView);
        
    }];
    
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"折扣活动";
    title.font=[UIFont fontWithName:kFontNormal size:13];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=kColor999;
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_discountCoponView addSubview:title];
    
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_discountCoponView).offset(15);
        make.centerY.equalTo(_discountCoponView);
    }];
    _discountdDesc=[[UILabel alloc]init];
    _discountdDesc.text=@"暂无可用";
    _discountdDesc.font=[UIFont fontWithName:kFontNormal size:13];
    _discountdDesc.backgroundColor=[UIColor clearColor];
    _discountdDesc.textColor=kColor999;
    _discountdDesc.numberOfLines = 1;
    _discountdDesc.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _discountdDesc.lineBreakMode = NSLineBreakByWordWrapping;
    [_discountCoponView addSubview:_discountdDesc];
    
    [_discountdDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.right.equalTo(indicator.mas_left).offset(-10);
    }];
}

-(void)hiddenCoponView{
    
    [_mallCoponView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.offset(0);
    }];
    [_platformCoponView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mallCoponView.mas_bottom).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.offset(0);
    }];
    
    [_discountCoponView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_platformCoponView.mas_bottom).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.offset(0);
    }];
}
-(void)setOrderConfirmMode:(JHOrderDetailMode *)orderConfirmMode{
    
    _orderConfirmMode = orderConfirmMode;
}
-(void)tapCopon:(UIGestureRecognizer*)tap{
    
    if (self.coponHandle) {
        self.coponHandle(tap);
    }
}
-(void)tapMallCopon:(UIGestureRecognizer*)tap{
    if (self.mallCoponHandle) {
        self.mallCoponHandle(tap);
    }
}
-(void)tapDiscountCopon:(UIGestureRecognizer*)tap{
    if (self.discountCoponHandle) {
        self.discountCoponHandle(tap);
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

