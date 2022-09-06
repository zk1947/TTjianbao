//
//  JHAppraisePayCoponCell.m
//  TTjianbao
//
//  Created by jiangchao on 2021/6/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAppraisePayCoponCell.h"
#import "CoponPackageMode.h"
#import "TTjianbaoHeader.h"
#import "NSString+AttributedString.h"

#define topRate (float)90/345
#define bottomRate (float)41/345

@interface JHAppraisePayCoponCell ()
{
    
    UIImageView *topImageview;
    UIButton  * btn;
    UIImageView *statusImageView;
    UIImageView *introduceImage;
}
@property (strong, nonatomic)  UILabel *price;
@property (strong, nonatomic)  UILabel *title;
@property (strong, nonatomic)  UILabel *time;
@property (strong, nonatomic)  UILabel *condition;
@property (strong, nonatomic)  UILabel *introduce;
@property (strong, nonatomic)  UIImageView *selectImageView;
@end

@implementation JHAppraisePayCoponCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        self.backgroundColor=[UIColor clearColor];
        
        UIImageView *bottomImageview=[[UIImageView alloc]init];
        bottomImageview.image=[[UIImage imageNamed:@"coupon_package_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 50, 0, 50) resizingMode:UIImageResizingModeStretch];
        bottomImageview.contentMode = UIViewContentModeScaleToFill;
        bottomImageview.userInteractionEnabled=YES;
        [self.contentView addSubview:bottomImageview];
        
        [bottomImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo(topImageview.mas_bottom).offset(0);
            //            make.height.offset(roundf(bottomRate*(ScreenW-20)));
            make.left.offset(10);
            make.right.offset(-10);
            make.height.offset(119);
            make.bottom.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
        }];
        
        topImageview=[[UIImageView alloc]init];
        //   topImageview.backgroundColor=[UIColor greenColor];
        topImageview.image=[UIImage imageNamed:@"coupon_left_select"];
        topImageview.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:topImageview];
        
        [topImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomImageview).offset(0);
            make.size.mas_equalTo(CGSizeMake(36, 119));
            make.left.offset(10);
            make.bottom.equalTo(bottomImageview).offset(0);
        }];
        
        
        
        _title=[[UILabel alloc]init];
        _title.text=@"";
        _title.font=[UIFont boldSystemFontOfSize:14];
        _title.textColor=HEXCOLOR(0x222222);
        _title.numberOfLines = 1;
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        [bottomImageview addSubview:_title];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomImageview).offset(10);
            make.left.equalTo(topImageview.mas_right).offset(10);
        }];
        
       introduceImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"orderconfirm_introduce_icon"]];
        introduceImage.contentMode = UIViewContentModeCenter;
        introduceImage.userInteractionEnabled=YES;
        [introduceImage  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(showIntroduce)]];
        [bottomImageview addSubview:introduceImage];
        [introduceImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_title);
            make.left.equalTo(_title.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        _time=[[UILabel alloc]init];
        _time.text=@"";
        _time.font=[UIFont boldSystemFontOfSize:10];
        _time.textColor=HEXCOLOR(0x666666);
        _time.numberOfLines = 1;
        _time.textAlignment = NSTextAlignmentLeft;
        _time.lineBreakMode = NSLineBreakByWordWrapping;
        [bottomImageview addSubview:_time];
        
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title.mas_bottom).offset(8);
            make.left.equalTo(_title).offset(0);
        }];
        
        _selectImageView=[[UIImageView alloc]init];
        _selectImageView.contentMode = UIViewContentModeScaleAspectFit;
        _selectImageView.image = [UIImage imageNamed:@"appraisepaycopon_nomal"];
        [bottomImageview addSubview:_selectImageView];
        
        [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_title).offset(0);
            make.right.equalTo(bottomImageview).offset(-15);
        }];
        _selectImageView.hidden=YES;
        
        _price=[[UILabel alloc]init];
        _price.text=@"";
        _price.font=[UIFont fontWithName:kFontBoldDIN size:23.f];
        _price.textColor=kColorMainRed;
        _price.numberOfLines = 1;
        _price.textAlignment = NSTextAlignmentLeft;
        _price.lineBreakMode = NSLineBreakByWordWrapping;
        _price.adjustsFontSizeToFitWidth = YES;
        [bottomImageview addSubview:_price];
        
        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_selectImageView.mas_left).offset(-15);
            make.centerY.equalTo(_title).offset(0);
        }];
        
        _condition=[[UILabel alloc]init];
        _condition.text=@"";
        _condition.font=[UIFont systemFontOfSize:10];
        _condition.textColor=HEXCOLOR(0x777777);
        _condition.numberOfLines = 1;
        _condition.textAlignment = NSTextAlignmentLeft;
        _condition.lineBreakMode = NSLineBreakByTruncatingTail;
        [bottomImageview addSubview:_condition];
        
        [_condition mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_price).offset(0);
            make.centerY.equalTo(_time).offset(0);
        }];
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
        [bottomImageview addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topImageview.mas_right).offset(10);
            make.top.equalTo(_time.mas_bottom).offset(15);
            make.right.equalTo(bottomImageview).offset(-10);
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
            make.top.equalTo(line.mas_bottom).offset(13);
            make.size.mas_equalTo(CGSizeMake(70, 28));
        }];
        
        _introduce=[[UILabel alloc]init];
        _introduce.text=@"";
        _introduce.font=[UIFont boldSystemFontOfSize:10];
        _introduce.textColor=HEXCOLOR(0x999999);
        _introduce.numberOfLines = 2;
        //  _introduce.backgroundColor = [UIColor redColor];
        _introduce.textAlignment = NSTextAlignmentLeft;
        _introduce.lineBreakMode = NSLineBreakByTruncatingTail;
        [bottomImageview addSubview:_introduce];
        
        [_introduce mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_title).offset(0);
            make.right.equalTo(btn.mas_left).offset(-5);
            make.top.equalTo(line.mas_bottom).offset(0);
            make.bottom.equalTo(bottomImageview).offset(-5);
        }];
        
        statusImageView=[[UIImageView alloc]init];
        statusImageView.contentMode = UIViewContentModeScaleAspectFit;
        [bottomImageview addSubview:statusImageView];
        
        [statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_introduce);
            make.right.equalTo(btn);
        }];
        
        
     
        
    }
    return self;
}
-(void)setMode:(CoponMode *)mode{
    
    _mode=mode;
    _introduce.text=_mode.remark;
    _time.text=[NSString stringWithFormat:@"有效期至%@",_mode.endUseTime];
    _title.text=_mode.name;
      introduceImage.hidden=YES;
    
    if (_mode.joinSellerType==2) {
         introduceImage.hidden=NO;
    }
    UIColor *priceIconColor;
    if ([_mode.status isEqualToString:@"en"]) {
        _title.textColor=HEXCOLOR(0x222222);
        _price.textColor=kColorMainRed;
        _time.textColor=HEXCOLOR(0x666666);
        topImageview.image=[UIImage imageNamed:@"coupon_left_select"];
        [statusImageView setHidden:YES];
        [btn setHidden:NO];
        priceIconColor=kColorMainRed;
    }
    else  if ([_mode.status isEqualToString:@"ed"]) {
        
        _title.textColor=HEXCOLOR(0x999999);
        _price.textColor=HEXCOLOR(0x999999);
        _time.textColor=HEXCOLOR(0x999999);
        topImageview.image=[UIImage imageNamed:@"coupon_left_nomal"];
        [btn setHidden:YES];
        [statusImageView setHidden:NO];
        statusImageView.image=[UIImage imageNamed:@"coupon_segment_used"];
        priceIconColor=kColor999;
    }
    else  if ([_mode.status isEqualToString:@"un"]) {
        
        _title.textColor=HEXCOLOR(0x999999);
        _price.textColor=HEXCOLOR(0x999999);
        _time.textColor=HEXCOLOR(0x999999);
        topImageview.image=[UIImage imageNamed:@"coupon_left_nomal"];
        [btn setHidden:YES];
        [statusImageView setHidden:NO];
        statusImageView.image=[UIImage imageNamed:@"coupon_logo_expired"];
        priceIconColor=kColor999;
    }
    //折扣券
    if ([_mode.ruleType isEqualToString:@"OD"]) {
        NSString * string = [NSString stringWithFormat:@"%@折",_mode.viewValue];
        NSRange range = [string rangeOfString:@"折"];
        _price.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:21.f] color:priceIconColor range:range];
        _condition.text=[NSString stringWithFormat:@"满%@元可用",_mode.ruleFrCondition];
    }
    //每满减
    else if ([_mode.ruleType isEqualToString:@"EFR"]){
        NSString * string = [@"¥" stringByAppendingString:_mode.viewValue?:@""];
        NSRange range = [string rangeOfString:@"¥"];
        _price.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:15.f] color:priceIconColor range:range];
          _condition.text=[NSString stringWithFormat:@"每满%@元可用",_mode.ruleFrCondition];
    }
    //满减
    else if ([_mode.ruleType isEqualToString:@"FR"]){
        NSString * string = [@"¥" stringByAppendingString:_mode.viewValue?:@""];
        NSRange range = [string rangeOfString:@"¥"];
        _price.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:15.f] color:priceIconColor range:range];
          _condition.text=[NSString stringWithFormat:@"满%@元可用",_mode.ruleFrCondition];
    }
    
}
- (NSString*)removeAllZeroByString:(NSString *)number{
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(number.floatValue)];
    return outNumber;
}
-(void)buttonPress:(UIButton*)button{
    
    if (self.buttonClick) {
        self.buttonClick(button);
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.selectImageView.image = [UIImage imageNamed:@"appraisepaycopon_select"];
        
    }else {
        self.selectImageView.image = [UIImage imageNamed:@"appraisepaycopon_nomal"];
    }
}
-(void)setIsOrderCoupon:(BOOL)isOrderCoupon{
    
    _isOrderCoupon=isOrderCoupon;
    if (isOrderCoupon) {
        self.selectImageView.hidden=NO;
        btn.hidden=YES;
       //  introduceImage.hidden=YES;
        
    }
    else{
        self.selectImageView.hidden=YES;
        btn.hidden=NO;
      //  introduceImage.hidden=NO;
    }
    
}
-(void)showIntroduce{
    
    if (self.introduceClick) {
        self.introduceClick(self.cellIndex);
    }
}
@end

