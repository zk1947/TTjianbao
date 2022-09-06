//
//  CustomToolsBar.m
//  TaoDangPuMall
//
//  Created by jiangchao on 2016/12/26.
//  Copyright © 2016年 jiangchao. All rights reserved.
//

#import "CustomToolsBar.h"
#import "TTjianbaoHeader.h"

@implementation CustomToolsBar
- (id)initWithFrame:(CGRect)frame
{    
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor clearColor];
        self.hh = 20.0;
        if (UI.bottomSafeAreaHeight>0) {
            self.hh = 44;
        }

        _ImageView= [[UIView alloc] init];
        _ImageView.frame = frame;
        _ImageView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
//        _ImageView.layer.shadowColor = [CommHelp toUIColorByStr:@"#eeeeee"].CGColor;
//        _ImageView.layer.shadowOffset = CGSizeMake(0,1);
//        _ImageView.layer.shadowOpacity = 1;
//        _ImageView.layer.shadowRadius = 0;

        [self addSubview:_ImageView];
        
        
      //  _ImageView.image = [UIImage imageNamed:@"bg copy.png"];
       
        self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-(self.frame.size.width-80)/2, self.hh+(self.frame.size.height-self.hh - 20)/2,self.frame.size.width-80, 20)];
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.backgroundColor = [UIColor clearColor];
        self.titleLbl.font = [UIFont fontWithName:kFontMedium size:18.f];
        self.titleLbl.textColor=[UIColor blackColor];
        [self addSubview:self.titleLbl];
    }
    return self;
}

-(void)setJHBackgroundColor:(UIColor *)color
{
    _ImageView.backgroundColor = color;
    _ImageView.layer.shadowColor = color.CGColor;
}

-(void)setTitle:(NSString*)title{
    self.titleLbl.text = title;
}

-(void)setSpecialTitle:(NSString*)title{
    self.titleLbl.text = title;
    self.titleLbl.frame = CGRectMake(15, self.hh+(self.frame.size.height-self.hh - 26)/2, self.frame.size.width-30, 25);
    self.titleLbl.textAlignment = NSTextAlignmentLeft;
    self.titleLbl.font = [UIFont fontWithName:kFontBoldPingFang size:23];
    self.titleLbl.textColor = kColor333;
}

-(void)addBtn:(NSString*)title withImage:(UIImage*)image withHImage:(UIImage *)hImage withFrame:(CGRect)frame{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(frame.origin.x+5, self.hh+(self.frame.size.height-self.hh - frame.size.height)/2, frame.size.width, frame.size.height);
    [btn setImage:image forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor clearColor];
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btn setImage:hImage forState:UIControlStateHighlighted];
    [self addSubview:btn];
    self.comBtn = btn;
    
}

-(void)addrightBtn:(NSString*)title withImage:(UIImage*)image withHImage:(UIImage *)hImage withFrame:(CGRect)frame{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(frame.origin.x, self.hh+(self.frame.size.height-self.hh - frame.size.height)/2, frame.size.width, frame.size.height);
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
     btn.titleLabel.font=[UIFont systemFontOfSize:15];
    [btn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
     btn.backgroundColor=[UIColor clearColor];
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btn setImage:hImage forState:UIControlStateHighlighted];
    [self addSubview:btn];
    self.rightBtn = btn;
    
}

-(void)addNavImage:(UIImage*)image {
    
    UIImageView * titleIma=[[UIImageView alloc]initWithImage:image];
    [self addSubview:titleIma];
    titleIma.contentMode=UIViewContentModeScaleAspectFit;
    
    [titleIma mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
        make.top.equalTo(self).offset(self.hh);
        make.bottom.equalTo(self);
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
