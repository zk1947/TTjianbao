//
//  JHShopCouponTableViewCell.m
//  TTjianbao
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHShopCouponTableViewCell.h"
#import "TTjianbaoHeader.h"
#import "NSString+AttributedString.h"
#import "TTJianBaoColor.h"

//#define topRate (float)134/712
//#define bottomRate (float)104/712
#define topRate (float)182/702
#define bottomRate (float)110/702

@interface JHShopCouponTableViewCell ()
{
    
    UIImageView *topImageview;
    UIButton  * btn;
}
@property (strong, nonatomic)  UILabel *price;
@property (strong, nonatomic)  UILabel *title;
@property (strong, nonatomic)  UILabel *time;
@property (strong, nonatomic)  UILabel *condition;
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel *bottomLabel1;
@property (strong, nonatomic)  UILabel *bottomLabel2;
@property (strong, nonatomic)  UILabel *bottomLabel3;
@property (strong, nonatomic)  UIView *bottomView;
@property (strong, nonatomic)  UILabel *quanLabel;
@property (strong, nonatomic)  UIButton *pasteBtn;

@end

@implementation JHShopCouponTableViewCell
    
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        
        topImageview=[[UIImageView alloc]init];
        topImageview.userInteractionEnabled=YES;
        topImageview.image=[UIImage imageNamed:@"mall_coupon_back_top_new"];
        //topImageview.image=[UIImage imageNamed:@"mall_coupon_back_top"];
        [self.contentView addSubview:topImageview];
        
        [topImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(0);
            make.height.offset(roundf((ScreenW-20)*topRate));
            make.left.offset(10);
            make.right.offset(-10);
            
        }];
        
        UIImageView *bottomImageview=[[UIImageView alloc]init];
        bottomImageview.image=[UIImage imageNamed:@"mall_coupon_back_bottom_new"];
        //bottomImageview.image=[UIImage imageNamed:@"mall_coupon_back_bottom"];
        bottomImageview.userInteractionEnabled=YES;
        [self.contentView addSubview:bottomImageview];
        
        [bottomImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topImageview.mas_bottom).offset(0);
            make.height.offset(roundf(bottomRate*(ScreenW-20)));
            make.left.offset(10);
            make.right.offset(-10);
            make.bottom.equalTo(self.contentView);
        }];
        
        
        UIImageView *topline = [[UIImageView alloc] init];
        //topline.backgroundColor = [CommHelp toUIColorByStr:@"#eeeeee"];
        topline.image = [UIImage imageNamed:@"xu_line"];
        [topImageview addSubview:topline];
        [topline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topImageview).offset(15);
            make.top.equalTo(topImageview).offset(35);
            make.right.equalTo(topImageview).offset(-15);
            make.height.offset(1);
        }];
        
        self.pasteBtn = [[UIButton alloc] init];
        self.pasteBtn.layer.cornerRadius = 20/2;
        self.pasteBtn.layer.borderColor = [CommHelp toUIColorByStr:@"#BDBFC2"].CGColor;
        self.pasteBtn.layer.borderWidth = 0.5;
        [self.pasteBtn setTitle:@"复制" forState:UIControlStateNormal];
        [self.pasteBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
        [self.pasteBtn addTarget:self action:@selector(clickCopyBtn) forControlEvents:UIControlEventTouchUpInside];
        self.pasteBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:10.0f];
        [topImageview addSubview:self.pasteBtn];
        
        [self.pasteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topImageview).offset((35-20)/2);
            make.right.equalTo(topImageview).offset(-15);
            make.width.offset(38);
            make.height.offset(20);
        }];
        
        
        self.quanLabel = [[UILabel alloc] init];
        self.quanLabel.textColor = [CommHelp toUIColorByStr:@"#333333"];
        self.quanLabel.font = [UIFont fontWithName:kFontNormal size:12.0f];
        self.quanLabel.textAlignment = NSTextAlignmentRight;
        [topImageview addSubview:self.quanLabel];
        
        [self.quanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.pasteBtn);
            make.right.equalTo(self.pasteBtn.mas_left).offset(-10);
            make.left.equalTo(topImageview).offset(15);
            make.height.offset(20);
        }];
        
        _headImage=[[UIImageView alloc]init];
        _headImage.image=kDefaultAvatarImage;
        _headImage.layer.masksToBounds =YES;
        _headImage.layer.cornerRadius =17;
        _headImage.userInteractionEnabled=YES;
        [topImageview addSubview:_headImage];
        
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.centerY.equalTo(topImageview);
            make.top.equalTo(topImageview).with.offset(45);
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
            //make.centerY.equalTo(topImageview).offset(-10);
//            make.centerY.equalTo(topImageview).offset(8);
            make.top.equalTo(self.headImage.mas_top);
            make.left.equalTo(self.headImage.mas_right).offset(5);
        }];
        
        _time=[[UILabel alloc]init];
        _time.text=@"";
        _time.font=[UIFont fontWithName:kFontNormal size:10.0f];
        //_time.textColor=HEXCOLOR(0x666666);
        _time.textColor=[CommHelp toUIColorByStr:@"#666666"];
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
        _price.textColor=HEXCOLOR(0xff4200);
        _price.numberOfLines = 1;
        _price.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _price.lineBreakMode = NSLineBreakByWordWrapping;
        _price.adjustsFontSizeToFitWidth = YES;
        [topImageview addSubview:_price];
        
        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(topImageview).offset(-15.f);
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
        
        UIImageView * line = [[UIImageView alloc]init];
        //line.backgroundColor = [CommHelp toUIColorByStr:@"#eeeeee"];
        line.image = [UIImage imageNamed:@"xu_line"];
        [bottomImageview addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topImageview).offset(15);
            make.bottom.equalTo(topImageview.mas_bottom).offset(0);
            make.right.equalTo(bottomImageview).offset(-15);
            make.height.offset(1);
        }];
        
        btn=[[UIButton alloc]init];
        btn.contentMode = UIViewContentModeScaleAspectFit;
        [btn setTitle:@"停止发放" forState:UIControlStateNormal];
       
        btn.titleLabel.font=[UIFont systemFontOfSize:12];
        [btn setTitleColor:[CommHelp toUIColorByStr:@"#ffffff"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:kColorMainRed] forState:UIControlStateNormal];
        
        btn.layer.cornerRadius = 14;
        btn.clipsToBounds = YES;
        [btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [bottomImageview addSubview:btn];
        [ btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomImageview.mas_right).offset(-15.f);
            make.centerY.equalTo(bottomImageview);
            make.size.mas_equalTo(CGSizeMake(70, 28));
        }];
        
        UIView *bottom = [UIView new];
        bottom.backgroundColor = [UIColor clearColor];
        [bottomImageview addSubview:bottom];
        [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(bottomImageview);
            make.left.equalTo(bottomImageview).offset(17);
            make.right.equalTo(@(-115));
        }];
        
       
        _bottomLabel1 = [self creatLabel:@"发放人数\n0"];
        _bottomLabel2 = [self creatLabel:@"使用人数\n0"];
        _bottomLabel3 = [self creatLabel:@"发行量\n0"];
        [bottom addSubview:_bottomLabel1];
        [bottom addSubview:_bottomLabel2];
        [bottom addSubview:_bottomLabel3];
        [_bottomLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(bottom);
        }];
        [_bottomLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.equalTo(bottom);
        }];
        
        [_bottomLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(bottom);
            make.width.equalTo(_bottomLabel1.mas_width);
            make.width.equalTo(_bottomLabel3.mas_width);
        }];
    
        self.bottomView = bottom;

    }
    return self;
}

- (void)clickCopyBtn
{
    NSString *str = self.quanLabel.text;
    if ([str containsString:@"券ID："])
    {
        str = [str substringFromIndex:4];
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = str;

    [UITipView showTipStr:@"券ID复制成功"];
}

- (UILabel *)creatLabel:(NSString *)title {
    UILabel *label1 = [UILabel new];
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label1.textColor = HEXCOLOR(0x666666);
    label1.numberOfLines = 2;
    label1.lineBreakMode = NSLineBreakByClipping;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = title;
    return label1;
}



- (NSAttributedString *)setAttributedStr:(NSString *)AllString
                                frontStr:(NSString *)frontStr
                              nextString:(NSString *)nextString {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:AllString];
    NSRange range1 = [[str string] rangeOfString:frontStr];
//    [str addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x999999) range:range1];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontNormal size:14.f] range:range1];
    
    NSRange range2 = [[str string] rangeOfString:nextString];
//    [str addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x999999) range:range2];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontBoldDIN size:14.f] range:range2];
    return str;
}

- (void)setMode:(JHSaleCouponModel *)mode{
    
    _mode=mode;
    
  //  _condition.text=[NSString stringWithFormat:@"满%@可用",_mode.ruleFrCondition];
    _time.text=mode.usefulLife;
    _title.text=_mode.name;
    
    self.quanLabel.text = [NSString stringWithFormat:@"券ID：%@",mode.Id];
    _bottomLabel1.text = [NSString stringWithFormat:@"发放人数\n%zd", mode.getCount];
    _bottomLabel2.text = [NSString stringWithFormat:@"使用人数\n%zd", mode.useCount];
    _bottomLabel3.text = [NSString stringWithFormat:@"发行量\n%zd", mode.setCount];
    
    
    [_headImage jhSetImageWithURL:[NSURL URLWithString:mode.img] placeholder:kDefaultAvatarImage];
    
    //0无效 1有效 2发放
    if (self.state == 0) {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-17));
        }];
        _time.textColor=[CommHelp toUIColorByStr:@"#999999"];
        self.quanLabel.textColor = [CommHelp toUIColorByStr:@"#666666"];
        [self.pasteBtn setTitleColor:[CommHelp toUIColorByStr:@"#666666"] forState:UIControlStateNormal];
        _title.textColor=HEXCOLOR(0x999999);
        _price.textColor=HEXCOLOR(0x999999);
        _bottomLabel1.textColor = HEXCOLOR(0x999999);
        _bottomLabel2.textColor = HEXCOLOR(0x999999);
        _bottomLabel3.textColor = HEXCOLOR(0x999999);
        _headImage.alpha = 0.5;

        NSString * string=[@"¥" stringByAppendingString:_mode.price?:@""];
        NSRange range = [string rangeOfString:@"¥"];
        _price.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:15.f] color:HEXCOLOR(0x999999) range:range];
        [btn setHidden:YES];
        
    } else {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-115));
        }];
        
        _time.textColor=[CommHelp toUIColorByStr:@"#666666"];
        self.quanLabel.textColor = [CommHelp toUIColorByStr:@"#333333"];
        [self.pasteBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
        _title.textColor=HEXCOLOR(0x222222);
        _price.textColor=HEXCOLOR(0xff4200);
        _bottomLabel1.textColor = HEXCOLOR(0x666666);
        _bottomLabel2.textColor = HEXCOLOR(0x666666);
        _bottomLabel3.textColor = HEXCOLOR(0x666666);
        _headImage.alpha = 1;
        
        if ([mode.ruleType isEqualToString:@"OD"]) {
            NSString * string = [_mode.price?:@"" stringByAppendingString:@"折"];
            NSRange range = [string rangeOfString:@"折"];
            _price.attributedText = [string attributedFont:[UIFont fontWithName:kFontMedium size:10.f] color:HEXCOLOR(0xff4200) range:range];
        } else {
            NSString * string=[@"¥" stringByAppendingString:_mode.price?:@""];
            NSRange range = [string rangeOfString:@"¥"];
            _price.attributedText=[string attributedFont:[UIFont fontWithName:kFontMedium size:12.f] color:HEXCOLOR(0xff4200) range:range];
        }
        
        if (!mode.isShow) {//是否已停止发放，0：已停止 ，1：未停止
            btn.userInteractionEnabled = NO;
            [btn setTitle:@"已停止" forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:kColorCCC] forState:UIControlStateNormal];
        }else{
            if (mode.forbidStop == 1) {//是否禁止停止发放，1：禁止 ，0：允许
                btn.userInteractionEnabled = NO;
                [btn setTitle:@"停止发放" forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageWithColor:kColorCCC] forState:UIControlStateNormal];
            }else{
                btn.userInteractionEnabled = YES;
                
                [btn setTitle:@"停止发放" forState:UIControlStateNormal];
                [btn setTitleColor:[CommHelp toUIColorByStr:@"#ffffff"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageWithColor:kColorMainRed] forState:UIControlStateNormal];
            }
        }
//        forbidStop
    }
    
    //折扣券 或满减券
    if ([_mode.ruleType isEqualToString:@"OD"]||[_mode.ruleType isEqualToString:@"FR"]) {
        _condition.text=[NSString stringWithFormat:@"满%@可用",_mode.ruleFrCondition];
    }
    //每满减
    else if ([_mode.ruleType isEqualToString:@"EFR"]){
        _condition.text=[NSString stringWithFormat:@"每满%@元可用",_mode.ruleFrCondition];
    }
}
-(void)buttonPress:(UIButton*)button{
    
    if (self.buttonClick) {
        self.buttonClick(self.indexPath);
    }
    
}

- (void)setHeaderStyle {
    [btn setHidden:YES];
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-17));
    }];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
