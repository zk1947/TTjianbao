//
//  JHOrderDetailAppraiseStepView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHOrderDetailAppraiseStepView.h"
#import "JHWebViewController.h"

@implementation JHOrderDetailAppraiseStepView

-(void)setSubViews{
    
    UILabel *tilte =[[UILabel alloc]init];
    tilte.text=@"天天鉴宝 / 品控鉴定流程";
    tilte.font=[UIFont fontWithName:kFontMedium size:13];
    tilte.textColor=kColor333;
    tilte.numberOfLines = 1;
    tilte.textAlignment = NSTextAlignmentLeft;
    tilte.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:tilte];
    
    [tilte mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
    }];
    
    NSArray *titles = @[@"商家发货到平台",@"平台品控鉴定师鉴定",@"鉴定通过寄出"];
    UILabel *lastLabel;
    for (int i =0 ; i<titles.count; i++) {

        UILabel *desc =[[UILabel alloc]init];
        desc.text=titles[i];
        desc.font=[UIFont fontWithName:kFontNormal size:11];
        desc.textColor=kColor666;
        desc.numberOfLines = 1;
        desc.textAlignment = NSTextAlignmentLeft;
        desc.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:desc];
        if (i!=titles.count-1) {
            UIImageView *arrowImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_appraisestep_arrow"]];
            arrowImage.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:arrowImage];
            [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(desc);
                make.left.equalTo(desc.mas_right).offset(5);
            }];
        }
        
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0) {
                make.left.equalTo(tilte).offset(0);
            }
            else{
                make.left.equalTo(lastLabel.mas_right).offset(13);
            }
             make.bottom.equalTo(self).offset(-10);
        }];
        lastLabel = desc;
    }

    UIImageView *icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_detail_appraisestep_icon"]];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self.mas_right).offset(0);
    }];
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AppraiseStep:)]];
    
}
-(void)AppraiseStep:(UITapGestureRecognizer*)tap{

    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = H5_BASE_STRING(@"/jianhuo/app/identificationIntroduced/identificationIntroduced.html");
    [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
    
}
@end
