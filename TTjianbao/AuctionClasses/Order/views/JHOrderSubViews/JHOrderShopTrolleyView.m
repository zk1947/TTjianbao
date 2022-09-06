//
//  JHOrderShopTrolleyView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderShopTrolleyView.h"

@interface JHOrderShopTrolleyView ()
@property (strong, nonatomic)  UILabel *goodCountLabel;
@end


@implementation JHOrderShopTrolleyView
-(void)setSubViews{
    
      UILabel  *title=[[UILabel alloc]init];
      title.text=@"购买数量";
      title.font=[UIFont systemFontOfSize:13];
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

      _goodCountLabel=[[UILabel alloc]init];
      _goodCountLabel.text=@"0";
      _goodCountLabel.font=[UIFont fontWithName:kFontMedium size:14];
      _goodCountLabel.backgroundColor=[UIColor clearColor];
      _goodCountLabel.textColor=kColor333;
      _goodCountLabel.numberOfLines = 1;
      _goodCountLabel.textAlignment = NSTextAlignmentCenter;
      _goodCountLabel.lineBreakMode = NSLineBreakByWordWrapping;
      [self addSubview:_goodCountLabel];
      [_goodCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(self).offset(-15);
          make.centerY.equalTo(self);
       }];
    
    
}

-(void)setOrderMode:(JHOrderDetailMode *)orderMode{
    
    _orderMode=orderMode;
     self.goodCountLabel.text=[NSString stringWithFormat:@"x%ld",(long)_orderMode.goodsCount];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
