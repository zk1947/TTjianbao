//
//  JHMyCouponTableViewCell.m
//  TTjianbao
//
//  Created by jiangchao on 2019/3/2.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHMallCouponTableViewCell.h"
#import "TTjianbaoHeader.h"
#import "NSString+AttributedString.h"

#define topRate (float)134/712
#define bottomRate (float)104/712

@interface JHMallCouponTableViewCell ()
{
    
    UIImageView *topImageview;
    UIButton  * btn;
    UIImageView *statusImageView;
}
@property (strong, nonatomic)  UILabel *price;
@property (strong, nonatomic)  UILabel *title;
@property (strong, nonatomic)  UILabel *time;
@property (strong, nonatomic)  UILabel *condition;
@property (strong, nonatomic)  UILabel *introduce;
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UIImageView *selectImageView;
@end

@implementation JHMallCouponTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        
        topImageview=[[UIImageView alloc]init];
        topImageview.userInteractionEnabled=YES;
        topImageview.image=[UIImage imageNamed:@"mall_coupon_back_top"];
        // topImageview.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:topImageview];
        
        [topImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(0);
            make.height.offset(roundf((ScreenW-20)*topRate));
            make.left.offset(10);
            make.right.offset(-10);
            
        }];
        
        UIImageView *bottomImageview=[[UIImageView alloc]init];
        bottomImageview.image=[UIImage imageNamed:@"mall_coupon_back_bottom"];
        // bottomImageview.contentMode = UIViewContentModeScaleToFill;
        bottomImageview.userInteractionEnabled=YES;
        [self.contentView addSubview:bottomImageview];
        
        [bottomImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topImageview.mas_bottom).offset(0);
            make.height.offset(roundf(bottomRate*(ScreenW-20)));
            make.left.offset(10);
            make.right.offset(-10);
            make.bottom.equalTo(self.contentView);
        }];
        
        _headImage=[[UIImageView alloc]init];
        _headImage.image=kDefaultAvatarImage;
        _headImage.layer.masksToBounds =YES;
        _headImage.layer.cornerRadius =17;
        _headImage.userInteractionEnabled=YES;
        [topImageview addSubview:_headImage];
        
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topImageview);
            make.size.mas_equalTo(CGSizeMake(34,34));
            make.left.offset(15);
        }];
        
        _title=[[UILabel alloc]init];
        _title.text=@"";
        _title.font=[UIFont boldSystemFontOfSize:14];
        _title.textColor=HEXCOLOR(0x222222);
        _title.numberOfLines = 1;
        _title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        [topImageview addSubview:_title];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topImageview).offset(-10);
            make.left.equalTo(_headImage.mas_right).offset(5);
        }];
        
        _time=[[UILabel alloc]init];
        _time.text=@"";
        _time.font=[UIFont boldSystemFontOfSize:10];
        _time.textColor=HEXCOLOR(0x666666);
        _time.numberOfLines = 1;
        _time.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _time.lineBreakMode = NSLineBreakByWordWrapping;
        [topImageview addSubview:_time];
        
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title.mas_bottom).offset(5);
            make.left.equalTo(_title).offset(0);
        }];
        
        _price=[[UILabel alloc]init];
        _price.text=@"";
        _price.font=[UIFont fontWithName:kFontBoldDIN size:23.f];
        _price.textColor=kColorMainRed;
        _price.numberOfLines = 1;
        _price.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _price.lineBreakMode = NSLineBreakByWordWrapping;
        _price.adjustsFontSizeToFitWidth = YES;
        [topImageview addSubview:_price];
        
        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(topImageview).offset(-10);
            make.centerY.equalTo(_title).offset(0);
        }];
        
        _condition=[[UILabel alloc]init];
        _condition.text=@"";
        _condition.font=[UIFont systemFontOfSize:10];
        _condition.textColor=HEXCOLOR(0x777777);
        _condition.numberOfLines = 1;
        _condition.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _condition.lineBreakMode = NSLineBreakByTruncatingTail;
        [topImageview addSubview:_condition];
        
        [_condition mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_price).offset(0);
            make.centerY.equalTo(_time).offset(0);
        }];
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
        [bottomImageview addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topImageview).offset(15);
            make.top.equalTo(bottomImageview.mas_top).offset(1);
            make.right.equalTo(bottomImageview).offset(-15);
            make.height.offset(1);
        }];
        
        
        btn=[[UIButton alloc]init];
        btn.contentMode = UIViewContentModeScaleAspectFit;
        [btn setTitle:@"去使用" forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:12];
        [btn setTitleColor:[CommHelp toUIColorByStr:@"#ffffff"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"coupon_used_btn"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [bottomImageview addSubview:btn];
        [ btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomImageview.mas_right).offset(-10);
            make.centerY.equalTo(bottomImageview);
            make.size.mas_equalTo(CGSizeMake(70, 28));
        }];
        
        _introduce=[[UILabel alloc]init];
        _introduce.text=@"";
        _introduce.font=[UIFont boldSystemFontOfSize:10];
        _introduce.textColor=HEXCOLOR(0x999999);
        _introduce.numberOfLines = 2;
        //  _introduce.backgroundColor = [UIColor redColor];
        _introduce.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _introduce.lineBreakMode = NSLineBreakByWordWrapping;
        [bottomImageview addSubview:_introduce];
        
        [_introduce mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomImageview).offset(10);
            make.right.equalTo(btn.mas_left).offset(-5);
            make.top.equalTo(bottomImageview).offset(0);
            make.bottom.equalTo(bottomImageview).offset(-5);
        }];
        
        statusImageView=[[UIImageView alloc]init];
        statusImageView.contentMode = UIViewContentModeScaleAspectFit;
        [bottomImageview addSubview:statusImageView];
        
        [statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_introduce);
            make.right.equalTo(btn);
        }];
        
        _selectImageView=[[UIImageView alloc]init];
        _selectImageView.contentMode = UIViewContentModeScaleAspectFit;
        [bottomImageview addSubview:_selectImageView];
        
        [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bottomImageview).offset(-5);
            make.right.equalTo(bottomImageview).offset(-2);
        }];
        _selectImageView.hidden=YES;
        
    }
    return self;
}
-(void)setMode:(CoponMode *)mode{
    
    _mode=mode;
    _introduce.text=_mode.remark;
    _time.text = [NSString stringWithFormat:@"有效期至%@",_mode.endUseTime];;
    _title.text=_mode.name;
    [_headImage jhSetImageWithURL:[NSURL URLWithString:mode.img] placeholder:kDefaultAvatarImage];
    
    UIColor *priceIconColor;
    if ([_mode.status isEqualToString:@"en"]) {
        
        _title.textColor=HEXCOLOR(0x222222);
        _price.textColor=HEXCOLOR(0xff4200);
        _time.textColor=HEXCOLOR(0x666666);
        [statusImageView setHidden:YES];
        [btn setHidden:NO];
        priceIconColor=kColorMainRed;
    }
    else  if ([_mode.status isEqualToString:@"ed"]) {
        
        _title.textColor=HEXCOLOR(0x999999);
        _price.textColor=HEXCOLOR(0x999999);
        _time.textColor=HEXCOLOR(0x999999);
        [btn setHidden:YES];
        [statusImageView setHidden:NO];
        statusImageView.image=[UIImage imageNamed:@"coupon_segment_used"];
        priceIconColor=kColor999;
    }
    else  if ([_mode.status isEqualToString:@"un"]) {
        
        _title.textColor=HEXCOLOR(0x999999);
        _price.textColor=HEXCOLOR(0x999999);
        _time.textColor=HEXCOLOR(0x999999);
        [btn setHidden:YES];
        [statusImageView setHidden:NO];
        statusImageView.image=[UIImage imageNamed:@"coupon_logo_expired"];
        priceIconColor=kColor999;
    }
    
    //折扣券
    if ([_mode.ruleType isEqualToString:@"OD"]) {
        NSString * string=[OBJ_TO_STRING(_mode.viewValue) stringByAppendingString:@"折"];
        NSRange range = [string rangeOfString:@"折"];
        _price.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:21.f] color:priceIconColor range:range];
        _condition.text=[NSString stringWithFormat:@"满%@可用",_mode.ruleFrCondition];
    }
    //每满减
    else if ([_mode.ruleType isEqualToString:@"EFR"]){
        NSString * string=[@"¥" stringByAppendingString:_mode.viewValue?:@""];
        NSRange range = [string rangeOfString:@"¥"];
        _price.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:15.f] color:priceIconColor range:range];
        _condition.text=[NSString stringWithFormat:@"每满%@元可用",_mode.ruleFrCondition];
    }
    //满减
    else if ([_mode.ruleType isEqualToString:@"FR"]){
        NSString * string=[@"¥" stringByAppendingString:_mode.viewValue?:@""];
        NSRange range = [string rangeOfString:@"¥"];
        _price.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:15.f] color:priceIconColor range:range];
        _condition.text=[NSString stringWithFormat:@"满%@元可用",_mode.ruleFrCondition];
    }
    
}

-(void)buttonPress:(UIButton*)button{
    
    if (self.buttonClick) {
        self.buttonClick(button);
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.selectImageView.image = [UIImage imageNamed:@"coupon_cell_select"];
        
    }else {
        self.selectImageView.image = [UIImage imageNamed:@""];
    }
}
-(void)setIsOrderCoupon:(BOOL)isOrderCoupon{
    
    _isOrderCoupon=isOrderCoupon;
    if (isOrderCoupon) {
        self.selectImageView.hidden=NO;
        btn.hidden=YES;
    }
    else{
        self.selectImageView.hidden=YES;
        btn.hidden=NO;
    }
    
}
@end

