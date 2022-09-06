//
//  JHOrderRemainTimeView.m
//  TTjianbao
//
//  Created by jiang on 2020/5/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderRemainTimeView.h"
@interface JHOrderRemainTimeView ()
@property(nonatomic,strong) UILabel * remainTimeLabel;
@property(nonatomic,strong) UILabel * titlelLabel;
@end

@implementation JHOrderRemainTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[CommHelp  toUIColorByStr:@"#FFEDE7"];
         
    }
    return self;
}
-(void)setSubViews{
    
    UIView  *back=[UIView new];
    [self addSubview:back];
    [ back  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.centerX.equalTo(self);
        
    }];
    
    UIImageView *logo=[[UIImageView alloc]init];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image=[UIImage imageNamed:@"order_confirm_time_logo"];
    [back addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back);
        make.centerY.equalTo(back);
        make.size.mas_equalTo(CGSizeMake(13, 14));
    }];
    
    _titlelLabel = [[UILabel alloc] init];
    _titlelLabel.numberOfLines =1;
    _titlelLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _titlelLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titlelLabel.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
    _titlelLabel.text = @"";
    _titlelLabel.font=[UIFont systemFontOfSize:13];
    [back addSubview:_titlelLabel];
    
    [ _titlelLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logo.mas_right).offset(5);
        make.centerY.equalTo(logo);
    }];
    
    _remainTimeLabel=[[UILabel alloc]init];
    _remainTimeLabel.text=@"";
    _remainTimeLabel.font=[UIFont systemFontOfSize:13];
    _remainTimeLabel.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
    _remainTimeLabel.numberOfLines = 1;
    _remainTimeLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _remainTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [back addSubview:_remainTimeLabel];
    
    [_remainTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titlelLabel.mas_right).offset(5);
        make.right.equalTo(back.mas_right);
        make.centerY.equalTo(logo);
        
    }];
    
}
-(void)setTitle:(NSString *)title{
   
    _title = title;
    _titlelLabel.text=_title;
    
}
-(void)setTime:(NSString *)time{
    
    _time=time;
    self.remainTimeLabel.text=time;
}
@end
