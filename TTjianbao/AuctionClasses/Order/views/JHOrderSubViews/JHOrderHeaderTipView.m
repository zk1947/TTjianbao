//
//  JHOrderTitleView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/7/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderHeaderTipView.h"
@interface JHOrderHeaderTipView ()
//@property(nonatomic,strong) UILabel * titlelLabel;
@end

@implementation JHOrderHeaderTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[CommHelp  toUIColorByStr:@"#FFFFFF"];
        
    }
    return self;
}
-(void)initContent:(NSString *)title andDesc:(NSString*)desc{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView  *back=[UIView new];
    [self addSubview:back];
    [ back  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
    
    UIImageView *logo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_title_tip_icon"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [back addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(back);
    }];
    
//    UILabel * titlelLabel= [[UILabel alloc] init];
//    titlelLabel.numberOfLines =1;
//    titlelLabel.textAlignment = NSTextAlignmentLeft;
//    titlelLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    titlelLabel.textColor=kColor333;
//    titlelLabel.text = @"";
//    titlelLabel.font=[UIFont fontWithName:kFontMedium size:12];
//    [back addSubview:titlelLabel];
//    [ titlelLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(logo);
//        make.left.equalTo(logo.mas_right).offset(5);
//    }];
    
    UILabel *descLabel= [[UILabel alloc] init];
    descLabel.numberOfLines =0;
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descLabel.textColor=kColor333;
    descLabel.text = @"";
    descLabel.preferredMaxLayoutWidth = ScreenW-40;
    descLabel.font=[UIFont fontWithName:kFontNormal size:12];
    [back addSubview:descLabel];
    [ descLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(back);
        make.top.equalTo(logo.mas_bottom).offset(5);
        make.bottom.equalTo(back);
    }];
    
  //  titlelLabel.text = [NSString stringWithFormat:@"%@",title?:@""];
    descLabel.text = [NSString stringWithFormat:@"%@",desc?:@""];
    //    NSString *content = [NSString stringWithFormat:@"%@%@",title?:@"",desc?:@""];
    //     NSRange range = [content rangeOfString:title];
    //     titlelLabel.attributedText=[content attributedFont:[UIFont fontWithName:kFontMedium size:12.f] color:kColor333 range:range];
    
}
-(void)initContentWithPrice:(NSString *)price{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel * partialRefundTip = [[UILabel alloc]init];
    partialRefundTip.backgroundColor = HEXCOLOR(0xFFFAF2);
    partialRefundTip.textColor = HEXCOLOR(0xFF6A00);
    partialRefundTip.font = JHFont(12);
    partialRefundTip.textAlignment = NSTextAlignmentCenter;
    [self addSubview:partialRefundTip];
    partialRefundTip.text = price;
    [partialRefundTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.height.offset(37);
        make.bottom.equalTo(self);
    }];
    
}
@end
