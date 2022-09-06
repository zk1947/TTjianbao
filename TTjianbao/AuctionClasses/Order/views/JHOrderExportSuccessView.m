//
//  JHOrderExportSuccessView.m
//  TTjianbao
//
//  Created by jiang on 2019/8/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrderExportSuccessView.h"
#import "TTjianbaoHeader.h"

@interface JHOrderExportSuccessView ()
{
    UIButton *  sureBtn;
}
@property (nonatomic, strong)   UILabel* title;
@property (nonatomic, strong)   UIImageView* imageView;
@end

@implementation JHOrderExportSuccessView
- (instancetype)init{
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        
        UIView *showview =  [[UIView alloc]init];
        showview.center=self.center;
        showview.contentMode=UIViewContentModeScaleAspectFit;
        showview.userInteractionEnabled=YES;
        showview.layer.cornerRadius = 4;
        showview.backgroundColor=[CommHelp toUIColorByStr:@"#f8f8f8"];
        [self addSubview:showview];
        
        [showview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@260);
            make.center.equalTo(self);
            
        }];
        _imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"exportSuccess_iamge"]];
        [showview addSubview:_imageView];
        _imageView.contentMode=UIViewContentModeScaleAspectFit;
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showview.mas_top).offset(10);
            make.centerX.equalTo(showview).offset(0);
        }];
        
        _title=[[UILabel alloc]init];
        _title.text=@"成功";
        _title.font=[UIFont boldSystemFontOfSize:15];
        _title.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _title.numberOfLines = 1;
        _title.textAlignment = UIControlContentHorizontalAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        [showview addSubview:_title];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_bottom).offset(10);
            make.left.equalTo(showview).offset(30);
            make.right.equalTo(showview).offset(-30);
        }];
        
//       UIButton * closeBtn=[[UIButton alloc]init];
//        [closeBtn setBackgroundImage:[UIImage imageNamed:@"copon_close.png"] forState:UIControlStateNormal];
//        [closeBtn addTarget:self action:@selector(dimiss) forControlEvents:UIControlEventTouchUpInside];
//        closeBtn.contentMode=UIViewContentModeScaleAspectFit;
//        [self addSubview:closeBtn];
//
//        [ closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(showview.mas_top).offset(0);;
//            make.right.equalTo(showview.mas_right).offset(0);
//        }];
        
       sureBtn=[[UIButton alloc]init];
        sureBtn.contentMode=UIViewContentModeScaleAspectFit;
        [sureBtn setTitle:@"预览" forState:UIControlStateNormal];
        sureBtn.layer.cornerRadius = 4;
        sureBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        // [_sureBtn setBackgroundImage:[UIImage imageNamed:@"Mic_right_button.png"] forState:UIControlStateNormal];
        [sureBtn setBackgroundColor:[CommHelp toUIColorByStr:@"fee100"]];
        [sureBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:sureBtn];
        
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_title.mas_bottom).offset(10);
            make.bottom.equalTo(showview.mas_bottom).offset(0);
            make.left.right.offset(0);
            make.size.mas_equalTo(CGSizeMake(260, 44));
        }];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }
    return self;
}
-(void)complete{
    
    if (self.handle) {
        self.handle();
    }
    [self dimiss];
    
}
-(void)dimiss{
    
    [self removeFromSuperview];
}
-(void)setIsSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
           _title.text=@"成功";
             _imageView.image=[UIImage imageNamed:@"exportSuccess_iamge"];
    }
    else{
        
          _title.text=@"失败";
          _imageView.image=[UIImage imageNamed:@"exportfail_iamge"];
           sureBtn.hidden=YES;
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
