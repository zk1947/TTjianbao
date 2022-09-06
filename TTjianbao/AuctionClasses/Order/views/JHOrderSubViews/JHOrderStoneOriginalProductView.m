//
//  JHOrderStoneOriginalProductView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderStoneOriginalProductView.h"

@implementation JHOrderStoneOriginalProductView
-(void)initStoneOriginalProductSubviews:(JHOrderDetailMode*)mode{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *stoneProductImage=[[UIImageView alloc]initWithImage:nil];
    stoneProductImage.contentMode = UIViewContentModeScaleAspectFill;
    stoneProductImage.layer.masksToBounds=YES;
    stoneProductImage.layer.cornerRadius = 4;
    [stoneProductImage jhSetImageWithURL:[NSURL URLWithString:mode.rootCoverUrl]];
    //   stoneProductImage.userInteractionEnabled=YES;
    //    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
    // [stoneProductImage addGestureRecognizer:tapGesture];
    [self addSubview:stoneProductImage];
    
    [stoneProductImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(@5);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.bottom.equalTo(self).offset(-10);
    }];
    
    UILabel * stoneProductTitle=[[UILabel alloc]init];
    stoneProductTitle.text=mode.rootGoodsName;
    stoneProductTitle.font=[UIFont systemFontOfSize:14];
    stoneProductTitle.textColor=[CommHelp toUIColorByStr:@"#222222"];
    stoneProductTitle.numberOfLines = 1;
    stoneProductTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    stoneProductTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:stoneProductTitle];
    
    [stoneProductTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(stoneProductImage);
        make.left.equalTo(stoneProductImage.mas_right).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
    }];
    UILabel * stoneProductPrice=[[UILabel alloc]init];
    stoneProductPrice.text=[@"¥ "stringByAppendingString:mode.rootPurchasePrice?:@""];
    stoneProductPrice.font=[UIFont fontWithName:kFontBoldDIN size:22.f];
    stoneProductPrice.textColor=[CommHelp toUIColorByStr:@"#222222"];
    stoneProductPrice.numberOfLines = 1;
    stoneProductPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
    stoneProductPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:stoneProductPrice];
    
    [stoneProductPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stoneProductTitle.mas_bottom).offset(8);
        make.left.equalTo(stoneProductTitle);
    }];
    UILabel * stoneProductOrderCode=[[UILabel alloc]init];
    stoneProductOrderCode.text=mode.rootOrderCode;
    stoneProductOrderCode.font=[UIFont systemFontOfSize:14];
    stoneProductOrderCode.textColor=[CommHelp toUIColorByStr:@"#222222"];
    stoneProductOrderCode.numberOfLines = 1;
    stoneProductOrderCode.textAlignment = UIControlContentHorizontalAlignmentCenter;
    stoneProductOrderCode.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:stoneProductOrderCode];
    
    [stoneProductOrderCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(stoneProductTitle.mas_top).offset(-5);
        make.left.equalTo(stoneProductTitle);
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
