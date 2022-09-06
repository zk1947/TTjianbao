//
//  OrderStatusTableViewCell.m
//  TaoDangPuMall
//
//  Created by jiangchao on 2017/2/7.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "JHAudienceOrderTableViewCell.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoBussiness.h"
#import "EnlargedImage.h"

@interface JHAudienceOrderTableViewCell ()
{
    UILabel* orderTimeLabel;
}
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UIImageView *displayImage;
@property (strong, nonatomic)  UILabel* name;
@property (strong, nonatomic)  UILabel* title;

@property (strong, nonatomic)  UILabel* orderCode;
@property (strong, nonatomic)  UILabel *price;
@property (strong, nonatomic)  UILabel *allPrice;
@property (strong, nonatomic)  UILabel *coponPrice;
@property (strong, nonatomic)  UILabel *orderTime;
@property (strong, nonatomic)  UILabel *orderStatusLabel;
@property (strong, nonatomic)  UIView *buttonBackView;
@property (strong, nonatomic)  NSMutableArray  <UIButton*> *buttons;
@end
@implementation JHAudienceOrderTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        
        UIView * backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.shadowColor = [UIColor blackColor].CGColor;
        // 设置阴影偏移量
        backView.layer.shadowOffset = CGSizeMake(0,0);
        // 设置阴影透明度
        backView.layer.shadowOpacity = 0.3;
        // 设置阴影半径
        backView.layer.shadowRadius = 2;
        backView.clipsToBounds = NO;
        [self.contentView addSubview:backView];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView).offset(0);
            make.bottom.equalTo(self.contentView).offset(-2);
        }];
        _headImage=[[UIImageView alloc]init];
        _headImage.image=kDefaultAvatarImage;
        _headImage.layer.masksToBounds =YES;
        _headImage.layer.cornerRadius =11;
        _headImage.userInteractionEnabled=YES;
        [backView addSubview:_headImage];
        
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(backView).offset(7);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.left.offset(15);
        }];
        
        _name=[[UILabel alloc]init];
        _name.text=@"";
        _name.font=[UIFont systemFontOfSize:14];
        _name.textColor=[CommHelp toUIColorByStr:@"#000000"];
        _name.numberOfLines = 1;
        _name.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _name.lineBreakMode = NSLineBreakByTruncatingTail;
        [backView addSubview:_name];
        
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headImage);
            make.left.equalTo(_headImage.mas_right).offset(7);
            make.width.lessThanOrEqualTo(@150);
        }];
        
        _orderStatusLabel=[[UILabel alloc]init];
        _orderStatusLabel.text=@"";
        _orderStatusLabel.font=[UIFont systemFontOfSize:13];
        _orderStatusLabel.backgroundColor=[UIColor clearColor];
        _orderStatusLabel.textColor=[CommHelp toUIColorByStr:@"#222222"];
        _orderStatusLabel.numberOfLines = 1;
        _orderStatusLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _orderStatusLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [backView addSubview:_orderStatusLabel];
        
        [_orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView).offset(-15);
            make.centerY.equalTo(_headImage);
        }];
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
        [backView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(15);
            make.top.equalTo(_headImage.mas_bottom).offset(7);
            make.right.equalTo(backView).offset(0);
            make.height.offset(1);
        }];
        
        _displayImage=[[UIImageView alloc]init];
        _displayImage.image=[UIImage imageNamed:@""];
        _displayImage.contentMode = UIViewContentModeScaleAspectFill;
        _displayImage.layer.masksToBounds=YES;
        _displayImage.userInteractionEnabled=YES;
        [backView addSubview:_displayImage];
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
        [_displayImage addGestureRecognizer:tapGesture];
        [_displayImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.left.equalTo(_headImage);
            
        }];
        
        _title=[[UILabel alloc]init];
        _title.text=@"";
        _title.font=[UIFont boldSystemFontOfSize:15];
        _title.backgroundColor=[UIColor clearColor];
        _title.textColor=[CommHelp toUIColorByStr:@"#222222"];
        _title.numberOfLines = 2;
        _title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        [backView addSubview:_title];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_displayImage);
            make.right.equalTo(backView).offset(-5);
            make.left.equalTo(_displayImage.mas_right).offset(10);
            
        }];
        
        UILabel* allmoneyTitle=[[UILabel alloc]init];
        allmoneyTitle.text=@"订单总额:";
        allmoneyTitle.font=[UIFont systemFontOfSize:14];
        allmoneyTitle.textColor=[CommHelp toUIColorByStr:@"#222222"];
        allmoneyTitle.numberOfLines = 1;
        allmoneyTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
        allmoneyTitle.lineBreakMode = NSLineBreakByWordWrapping;
        [backView addSubview:allmoneyTitle];
        
        [allmoneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title.mas_bottom).offset(10);
            make.left.equalTo(_title).offset(0);
            
        }];
        
        _allPrice=[[UILabel alloc]init];
        _allPrice.text=@"";
        _allPrice.font=[UIFont fontWithName:kFontBoldDIN size:18.f];
        _allPrice.textColor=[CommHelp toUIColorByStr:@"#222222"];
        _allPrice.numberOfLines = 1;
        _allPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _allPrice.lineBreakMode = NSLineBreakByWordWrapping;
        [backView addSubview:_allPrice];
        [_allPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(allmoneyTitle).offset(2);
            make.left.equalTo(allmoneyTitle.mas_right).offset(5);
        }];
        
        _coponPrice = [[UILabel alloc]init];
        _coponPrice.text = @"";
        _coponPrice.font = [UIFont systemFontOfSize:12];
        _coponPrice.textColor = [CommHelp toUIColorByStr:@"#ff4200"];
        _coponPrice.numberOfLines = 1;
        _coponPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _coponPrice.lineBreakMode = NSLineBreakByWordWrapping;
        [backView addSubview:_coponPrice];
        [_coponPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(allmoneyTitle).offset(2);
            make.right.equalTo(backView.mas_right).offset(-10);
        }];
        
        //        UIImageView *logo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_no_back"]];
        //        logo.contentMode = UIViewContentModeScaleAspectFit;
        //        [self addSubview:logo];
        //
        //        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(_title);
        //            make.bottom.equalTo(_displayImage.mas_bottom).offset(5);
        //        }];
        
        _orderTime = [[UILabel alloc]init];
        _orderTime.text = @"";
        _orderTime.font = [UIFont systemFontOfSize:12];
        _orderTime.textColor = [CommHelp toUIColorByStr:@"#999999"];
        _orderTime.numberOfLines = 1;
        _orderTime.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _orderTime.lineBreakMode = NSLineBreakByWordWrapping;
        [backView addSubview:_orderTime];
        [_orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
            // make.bottom.equalTo(logo.mas_top).offset(-5);
            make.bottom.equalTo(_displayImage).offset(5);
            make.left.equalTo(_displayImage.mas_right).offset(10);
        }];
        
        UIView * line2 = [[UIView alloc]init];
        line2.backgroundColor = [CommHelp toUIColorByStr:@"#eeeeee"];
        [backView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(15);
            make.top.equalTo(_displayImage.mas_bottom).offset(10);
            make.right.equalTo(backView).offset(0);
            make.height.offset(1);
        }];
        
        _orderCode = [[UILabel alloc]init];
        _orderCode.text = @"";
        _orderCode.font = [UIFont systemFontOfSize:12];
        _orderCode.backgroundColor = [UIColor clearColor];
        _orderCode.textColor = [CommHelp toUIColorByStr:@"#AAAAAA"];
        _orderCode.numberOfLines = 1;
        _orderCode.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _orderCode.lineBreakMode = NSLineBreakByWordWrapping;
        [backView addSubview:_orderCode];
        [_orderCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_displayImage);
            make.top.equalTo(line2.mas_bottom).offset(12);
            make.bottom.equalTo(backView).offset(-12);
        }];
    }
    return self;
}
-(void)setOrderMode:(OrderMode *)orderMode{
    _orderMode = orderMode;
    [_headImage jhSetImageWithURL:[NSURL URLWithString:_orderMode.sellerImg] placeholder:kDefaultAvatarImage];
    [_displayImage jhSetImageWithURL:[NSURL URLWithString:ThumbSmallByOrginal(_orderMode.goodsUrl)] placeholder:nil];
    _name.text=_orderMode.sellerName;
    _title.text=_orderMode.goodsTitle;
    _orderCode.text=[NSString stringWithFormat:@"订单编号:  %@",_orderMode.orderCode];
    _orderTime.text=_orderMode.orderCreateTime;
    _price.text = [NSString stringWithFormat:@"¥ %@",_orderMode.orderPrice];
    _allPrice.text = [NSString stringWithFormat:@"¥ %@",_orderMode.originOrderPrice];
    
    if ([_orderMode.orderStatus isEqualToString:@"waitack"]) {
        
        if ([CommHelp dateRemaining:_orderMode.payExpireTime]>0) {
            _orderStatusLabel.text=@"待付款 ";
        }
        else{
            _orderStatusLabel.text=@"订单已取消";
        }
      
    }
    else  if ([_orderMode.orderStatus isEqualToString:@"waitpay"]) {
        if ([CommHelp dateRemaining:_orderMode.payExpireTime]>0) {
            _orderStatusLabel.text = [NSString stringWithFormat:@"待付款 %@",[CommHelp getHMSWithSecond:[CommHelp dateRemaining:_orderMode.payExpireTime]]];
        }
        else{
            _orderStatusLabel.text=@"订单已取消";
        }
        
      
    }
    
    else  if ([_orderMode.orderStatus isEqualToString:@"waitsellersend"]) {
        
        _orderStatusLabel.text=@"待发货";
     
    }
    
    else  if ([_orderMode.orderStatus isEqualToString:@"sellersent"]) {
        
        _orderStatusLabel.text=@"待验货";
      
    }
    else  if ([_orderMode.orderStatus isEqualToString:@"waitportalappraise"]) {
        
        _orderStatusLabel.text=@"待验货";
      
    }
    else  if ([_orderMode.orderStatus isEqualToString:@"waitportalsend"]) {
        
        _orderStatusLabel.text=@"待验货";
        
      
        
    }
    else  if ([_orderMode.orderStatus isEqualToString:@"portalsent"]) {
        
        _orderStatusLabel.text=@"待收货";
      
    }
    
    else  if ([_orderMode.orderStatus isEqualToString:@"buyerreceived"]) {
        
        _orderStatusLabel.text=@"已完成";
        
      
    }
    else  if ([_orderMode.orderStatus isEqualToString:@"cancel"]) {
        
        _orderStatusLabel.text=@"订单已取消";
     
    
  }
}

-(void)imageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    UIImageView * imageview=(UIImageView*)gestureRecognizer.view;
    NSMutableArray * arr=[NSMutableArray arrayWithArray:@[self.orderMode.goodsUrl]];
    [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:0 result:^(NSInteger index) {
        
    }]; //使用
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


