//
//  JHOrderGoodsPriceView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/1/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHOrderGoodsPriceView.h"
@interface JHOrderGoodsPriceView ()
@property (strong, nonatomic)  UILabel *goodsPriceLabel;
@end


@implementation JHOrderGoodsPriceView
-(void)setSubViews{
    
      UILabel  *title=[[UILabel alloc]init];
      title.text=@"宝贝价格";
      title.font=[UIFont fontWithName:kFontMedium size:13];
      title.backgroundColor=[UIColor clearColor];
      title.textColor=kColor333;
      title.numberOfLines = 1;
      title.textAlignment = UIControlContentHorizontalAlignmentCenter;
      title.lineBreakMode = NSLineBreakByWordWrapping;
      [self addSubview:title];
      [title mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self).offset(15);
          make.centerY.equalTo(self);
      }];

    _goodsPriceLabel=[[UILabel alloc]init];
    _goodsPriceLabel.text=@"0";
    _goodsPriceLabel.font=[UIFont fontWithName:kFontNormal size:13];
    _goodsPriceLabel.backgroundColor=[UIColor clearColor];
    _goodsPriceLabel.textColor=kColor333;
    _goodsPriceLabel.numberOfLines = 1;
    _goodsPriceLabel.textAlignment = NSTextAlignmentCenter;
    _goodsPriceLabel.lineBreakMode = NSLineBreakByWordWrapping;
      [self addSubview:_goodsPriceLabel];
      [_goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(self).offset(-15);
          make.centerY.equalTo(self);
       }];
}
-(void)setOrderMode:(JHOrderDetailMode *)orderMode{
    
       _orderMode=orderMode;
    self.goodsPriceLabel.text=[NSString stringWithFormat:@"¥%@",isEmpty(_orderMode.goodsPrice)?@"0":_orderMode.goodsPrice];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

