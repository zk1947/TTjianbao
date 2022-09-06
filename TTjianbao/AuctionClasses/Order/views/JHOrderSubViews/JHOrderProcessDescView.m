//
//  JHOrderProcessDescView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderProcessDescView.h"
@implementation JHOrderProcessDescView
-(void)initProcessDescSubViews:(JHOrderDetailMode*)mode{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
       UILabel  * title=[[UILabel alloc]init];
       title.text=@"加工描述";
       title.font=[UIFont fontWithName:kFontMedium size:13];
       title.backgroundColor=[UIColor whiteColor];
       title.textColor=kColor333;
       title.numberOfLines = 1;
       title.textAlignment = NSTextAlignmentLeft;
       title.lineBreakMode = NSLineBreakByWordWrapping;
       [self addSubview:title];
       
       [title mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self).offset(10);
           make.left.equalTo(self).offset(10);
           make.right.equalTo(self).offset(0);
       }];
    
    UILabel  *desc=[[UILabel alloc]init];
    desc.text=mode.processingDes;
    desc.font=[UIFont fontWithName:kFontNormal size:13];
    desc.backgroundColor=[UIColor whiteColor];
    desc.textColor=kColor999;
    desc.numberOfLines = 0;
    desc.preferredMaxLayoutWidth = ScreenW-40;
    desc.textAlignment = NSTextAlignmentLeft;
    desc.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:desc];
    
    [desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(10);
         make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(0);
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
