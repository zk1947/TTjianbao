//
//  JHOrderConfirmShopTrolleyView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderConfirmShopTrolleyView.h"

@interface JHOrderConfirmShopTrolleyView ()
@end
@implementation JHOrderConfirmShopTrolleyView
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

       
       
          UIView  *buttonView=[[UIView alloc]init];
          buttonView.backgroundColor=[UIColor whiteColor];
          buttonView.userInteractionEnabled=YES;
          buttonView.layer.cornerRadius = 4;
          buttonView.layer.masksToBounds = YES;
          buttonView.layer.borderWidth = 1;
          buttonView.layer.borderColor = [kColorEEE CGColor];
          [self addSubview:buttonView];

         [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(self);
           make.right.equalTo(self).offset(-10);
           make.height.offset(22);
           make.width.offset(84);
       }];

       UIButton *subtractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       subtractBtn.backgroundColor=[UIColor clearColor];
       subtractBtn.tag=1;
       [subtractBtn setTitleColor:kColor999 forState:UIControlStateNormal];
       subtractBtn.titleLabel.font=[UIFont systemFontOfSize:13];
       [subtractBtn  setTitle:@"-" forState:UIControlStateNormal];
       subtractBtn.contentMode=UIViewContentModeScaleAspectFit;
       [subtractBtn addTarget:self action:@selector(changeGoodsCount:) forControlEvents:UIControlEventTouchUpInside];
       [buttonView addSubview:subtractBtn];

       [subtractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(buttonView).offset(0);
           make.top.bottom.equalTo(buttonView);
           make.width.offset(26);
       }];
       JHCustomLine *line1 = [JHUIFactory createLine];
       [buttonView addSubview:line1];
       [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.bottom.top.equalTo(buttonView).offset(0);
           make.width.equalTo(@1);
           make.left.equalTo(subtractBtn.mas_right);

       }];

       UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       addBtn.backgroundColor=[UIColor clearColor];
       [addBtn setTitleColor:kColor999 forState:UIControlStateNormal];
       addBtn.titleLabel.font=[UIFont systemFontOfSize:13];
       addBtn.tag=2;
       [addBtn  setTitle:@"+" forState:UIControlStateNormal];
       addBtn.contentMode=UIViewContentModeScaleAspectFit;
       [addBtn addTarget:self action:@selector(changeGoodsCount:) forControlEvents:UIControlEventTouchUpInside];
       [buttonView addSubview:addBtn];

       [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(buttonView).offset(0);
           make.top.bottom.equalTo(buttonView);
           make.width.offset(26);
       }];

       JHCustomLine *line2 = [JHUIFactory createLine];
       [buttonView addSubview:line2];
       [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.bottom.top.equalTo(buttonView).offset(0);
           make.width.equalTo(@1);
           make.right.equalTo(addBtn.mas_left);
       }];

       _goodCountLabel=[[UILabel alloc]init];
       _goodCountLabel.text=@"0";
       _goodCountLabel.font=[UIFont fontWithName:kFontMedium size:14];
       _goodCountLabel.backgroundColor=[UIColor clearColor];
       _goodCountLabel.textColor=kColor333;
       _goodCountLabel.numberOfLines = 1;
       _goodCountLabel.textAlignment = NSTextAlignmentCenter;
       _goodCountLabel.lineBreakMode = NSLineBreakByWordWrapping;
       [buttonView addSubview:_goodCountLabel];
       [_goodCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(line1).offset(0);
           make.right.equalTo(line2).offset(0);
           make.top.bottom.equalTo(buttonView);
       }];
}
-(void)changeGoodsCount:(UIButton*)button{
    
    if (self.buttonHandle) {
        self.buttonHandle(button);
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
