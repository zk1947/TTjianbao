//
//  JHCustomizeOrderIndicateView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/11/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeOrderIndicateView.h"

@interface JHCustomizeOrderIndicateView ()

@end

@implementation JHCustomizeOrderIndicateView
-(void)setSubViews{
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 0;
    self.userInteractionEnabled = YES;
    [self  addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressAction)]];
    
    UIImageView *indicateImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"customize_order_indicate"]];
    indicateImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:indicateImage];
     
      [indicateImage mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(self);
         make.right.equalTo(self.mas_right).offset(-5);
     }];
    
    _titleLabel=[[UILabel alloc]init];
    _titleLabel.text=@"";
    _titleLabel.font=[UIFont fontWithName:kFontNormal size:13];
    _titleLabel.backgroundColor=[UIColor whiteColor];
    _titleLabel.textColor=kColor333;
    _titleLabel.numberOfLines = 1;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(self);
           make.right.equalTo(indicateImage.mas_left).offset(-5);
       }];
    
}
-(void)setTitle:(NSString *)title{
    
    _title = title;
    _titleLabel.text = _title;
    
}
-(void)pressAction{
    
    if (self.pressActionBlock) {
        self.pressActionBlock();
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
