//
//  JHPayProtocolView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPayProtocolView.h"
#import "JHWebViewController.h"
@implementation JHPayProtocolView
-(void)setSubViews{
    
    self.backgroundColor=[UIColor clearColor];
    self.userInteractionEnabled=YES;
    [self  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(protocolAction)]];
    
      JHPreTitleLabel *label = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor666 font:[UIFont fontWithName:kFontMedium size:12] textAlignment:NSTextAlignmentLeft preTitle:@"我已同意"];
       [label setJHAttributedText:@"《天天鉴宝图文鉴定服务协议》" font:[UIFont fontWithName:kFontMedium size:12] color:HEXCOLOR(0x235E96)];
       label.userInteractionEnabled = NO;
       [self addSubview:label];
       
       _protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       [_protocolBtn setImage:[UIImage imageNamed:@"apprise_pay_protal_select"] forState:UIControlStateSelected];
       [_protocolBtn setImage:[UIImage imageNamed:@"apprise_pay_protal_nomal"] forState:UIControlStateNormal];
       _protocolBtn.contentMode=UIViewContentModeScaleAspectFit;
       [_protocolBtn addTarget:self action:@selector(onProtocolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
       [self addSubview:_protocolBtn];
       _protocolBtn.selected=YES;
       [_protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self.mas_left).offset(0);
           make.centerY.equalTo(self).offset(0);
           make.size.mas_equalTo(CGSizeMake(16, 16));
       }];
       [label mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.bottom.right.equalTo(self);
           make.left.equalTo(_protocolBtn.mas_right).offset(5);
           
       }];
    
}
- (void)onProtocolBtnAction:(UIButton*)button {
    button.selected=!button.selected;
}
- (void)protocolAction{
    
    if (self.protocalBlock) {
        self.protocalBlock();
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
