//
//  ExpressTableViewCell.m
//  TaoDangPuMall
//
//  Created by jiangchao on 2017/2/14.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "JHExpressTableViewCell.h"
#import "ExpressMode.h"
#import "TTjianbaoHeader.h"

@interface JHExpressTableViewCell ()
{
    UIView * content;
    UIView *progressLogoBack;
}
@property (strong, nonatomic)  UILabel *expressTitle;
@property (strong, nonatomic)  UILabel *expressDesc;
@property (strong, nonatomic)  UILabel *expressDate;
@property (strong, nonatomic)  UILabel *expressTime;
@property (strong, nonatomic)  UIImageView *progressLogo;
@property (strong, nonatomic)  UIView *progressLine2;
@property (strong, nonatomic)  UIView *progressLine1;
@property (strong, nonatomic)  UIView *line;


@end
@implementation JHExpressTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = HEXCOLOR(0xf5f6fa);
        content = [[UIView alloc]init];
        content.backgroundColor = kColorFFF;
        //        content.layer.cornerRadius = 8;
        //        content.autoresizingMask = YES;
        [self.contentView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView).offset(0);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
        _expressDate=[[UILabel alloc]init];
        _expressDate.text=@"";
        _expressDate.font=[UIFont fontWithName:kFontNormal size:11];
        _expressDate.textColor=HEXCOLOR(0x999999);
        _expressDate.numberOfLines = 2;
        _expressDate.lineBreakMode = NSLineBreakByWordWrapping;
        _expressDate.textAlignment = NSTextAlignmentRight;
        [_expressDate setContentHuggingPriority:UILayoutPriorityRequired
                                        forAxis:UILayoutConstraintAxisHorizontal];
        [content addSubview:_expressDate];
        
        _expressTime=[[UILabel alloc]init];
        _expressTime.text=@"";
        _expressTime.font=[UIFont fontWithName:kFontNormal size:11];
        _expressTime.textColor=HEXCOLOR(0x999999);
        _expressTime.numberOfLines = 1;
        
        _expressTime.lineBreakMode = NSLineBreakByWordWrapping;
        _expressTime.textAlignment = NSTextAlignmentLeft;
        [content addSubview:_expressTime];
        
        
       progressLogoBack=[[UIView alloc]init];
        
        [content addSubview:progressLogoBack];
        
        _progressLogo=[[UIImageView alloc]init];
        _progressLogo.backgroundColor = kColorEEE;
        _progressLogo.layer.cornerRadius = 4;
        [progressLogoBack addSubview:_progressLogo];
        
        _expressTitle=[[UILabel alloc]init];
        _expressTitle.text=@"";
        _expressTitle.font=[UIFont fontWithName:kFontNormal size:12];
        _expressTitle.textColor=HEXCOLOR(0x999999);
        _expressTitle.numberOfLines = 0;
        // _expressTitle.backgroundColor = [UIColor redColor];
//        _expressTitle.preferredMaxLayoutWidth = ScreenW-135;
//        _expressTitle.lineBreakMode = NSLineBreakByWordWrapping;
        _expressTitle.textAlignment = NSTextAlignmentLeft;
        [content addSubview:_expressTitle];
        
        [progressLogoBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_expressTitle).offset(0);
            make.left.equalTo(content).offset(95);
            make.width.offset(20);
            make.height.offset(20);
        }];
        
        [_expressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(content).offset(10);
            make.left.equalTo(progressLogoBack.mas_right).offset(10);
            make.right.equalTo(content).offset(-10);
            make.bottom.equalTo(content).offset(-14);
        }];
        [_expressDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_progressLogo).offset(0);
            make.right.equalTo(progressLogoBack.mas_left).offset(-10);
            make.width.offset(65);
        }];
        
        [_progressLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(progressLogoBack).offset(0);
            // make.left.equalTo(_expressDate.mas_right).offset(10);
           // make.centerX.equalTo(progressLogoBack);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        
        [_expressTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_expressDate.mas_bottom).offset(5);
            make.right.equalTo(_expressDate).offset(0);
        }];
        
        _progressLine1=[[UIView alloc]init];
        _progressLine1.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
        [content addSubview:_progressLine1];
        
        [_progressLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(content).offset(0);
            make.bottom.equalTo(_progressLogo.mas_top).offset(0);
            make.width.offset(1);
            make.centerX.equalTo(_progressLogo);
        }];
        
        _progressLine2=[[UIView alloc]init];
        _progressLine2.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
        [content addSubview:_progressLine2];
        
        [_progressLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_progressLogo.mas_bottom).offset(0);
            make.bottom.equalTo(content).offset(0);
            make.width.offset(1);
            make.centerX.equalTo(_progressLogo);
        }];
    }
    return self;
}

- (void)setExpressMode:(ExpressRecord *)expressMode{
    
    _expressMode = expressMode;
    NSInteger time = [CommHelp timeSwitchTimestamp:_expressMode.ftime andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    _expressDate.text = [CommHelp timestampSwitchTime:time andFormatter:@"yyyy-MM-dd\n HH:mm:ss"];
   // _expressTime.text = [CommHelp timestampSwitchTime:time andFormatter:@"HH:mm:ss"];
    _expressTitle.text = expressMode.context?:@"";
    
}
-(void)setExpressAppraiseMode:(ExpressAppraiseMode *)expressAppraiseMode{
    
    _expressAppraiseMode = expressAppraiseMode;
    NSInteger time = [CommHelp timeSwitchTimestamp:_expressAppraiseMode.operTime andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    _expressDate.text = [CommHelp timestampSwitchTime:time andFormatter:@"yyyy-MM-dd\n HH:mm:ss"];
   // _expressTime.text = [CommHelp timestampSwitchTime:time andFormatter:@"HH:mm:ss"];
    _expressTitle.text = _expressAppraiseMode.opCodeDesc?:@"";
    
}
-(void)setOrderStatusLogMode:(orderStatusLogVosModel *)orderStatusLogMode{
    
    _orderStatusLogMode = orderStatusLogMode;
    NSInteger time = [CommHelp timeSwitchTimestamp:_orderStatusLogMode.createTime andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    _expressDate.text = [CommHelp timestampSwitchTime:time andFormatter:@"yyyy-MM-dd\n HH:mm:ss"];
   // _expressTime.text = [CommHelp timestampSwitchTime:time andFormatter:@"HH:mm:ss"];
    _expressTitle.text = _orderStatusLogMode.orderStatusDesc?:@"";
    
}
-(void)setCellIndex:(NSInteger)cellIndex andListCount:(NSInteger)count andViewMode:(JHOrderExpressViewMode*)viewMode andSectionType:(JHExpressSectionType)sectionType{
    
    if (cellIndex==count-1){
        [_expressTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(content).offset(-24);
        }];
    }
    else{
        [_expressTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(content).offset(-14);
        }];
    }
    
    if (cellIndex==0){
        if (count==1){
            [_progressLine1 setHidden:YES];
            [_progressLine2 setHidden:YES];
            [content yd_setCornerRadius:8 corners:UIRectCornerBottomLeft|UIRectCornerBottomRight];
        }
        else{
            [_progressLine1 setHidden:YES];
            [_progressLine2 setHidden:NO];
            [content yd_setCornerRadius:0 corners:UIRectCornerAllCorners];
        }
    }
    else  if (cellIndex==count-1){
        
        [_progressLine1 setHidden:NO];
        [_progressLine2 setHidden:YES];
        [content yd_setCornerRadius:8 corners:UIRectCornerBottomLeft|UIRectCornerBottomRight];
    }
    else {
        [_progressLine1 setHidden:NO];
        [_progressLine2 setHidden:NO];
        [content yd_setCornerRadius:0 corners:UIRectCornerAllCorners];
    }
    
    
    _progressLogo.backgroundColor = kColorEEE;
    _progressLogo.layer.cornerRadius = 4;
    _progressLogo.image = nil;
    _expressTitle.font=[UIFont fontWithName:kFontNormal size:12];
    _expressTitle.textColor=HEXCOLOR(0x999999);
    _expressDate.font=[UIFont fontWithName:kFontNormal size:11];
    _expressDate.textColor=HEXCOLOR(0x999999);
    [_progressLogo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    if (sectionType==JHExpressSectionSellerSend){
        if (viewMode.expressStep<1) {
            if (cellIndex==0) {
                
                _progressLogo.image = [UIImage imageNamed:@"order_express_circle"];
                _progressLogo.backgroundColor = [UIColor clearColor];
                [_progressLogo mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(14, 14));
                }];
                _expressTitle.font=[UIFont fontWithName:kFontMedium size:12];
                _expressTitle.textColor=HEXCOLOR(0xffbf10);
                _expressDate.font=[UIFont fontWithName:kFontMedium size:11];
                _expressDate.textColor=HEXCOLOR(0x333333);
                
            }
            
        }
        
    }
    else  if (sectionType==JHExpressSectionPlatAppraise){
        
        if (viewMode.expressStep<2) {
            if (cellIndex==0) {
                
                _progressLogo.image = [UIImage imageNamed:@"order_express_circle"];
                _progressLogo.backgroundColor = [UIColor clearColor];
                [_progressLogo mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(14, 14));
                }];
                _expressTitle.font=[UIFont fontWithName:kFontMedium size:12];
                _expressTitle.textColor=HEXCOLOR(0xffbf10);
                _expressDate.font=[UIFont fontWithName:kFontMedium size:11];
                _expressDate.textColor=HEXCOLOR(0x333333);
                
            }
            
        }
        
    }
    else  if (sectionType==JHExpressSectionPlatSend) {
        
        if ([viewMode.platSendExpressVo.state isEqualToString:@"已签收"]&&cellIndex==0) {
            
            _progressLogo.image = [UIImage imageNamed:@"order_express_receive_dot"];
            _progressLogo.backgroundColor = [UIColor clearColor];
            [_progressLogo mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(16, 16));
            }];
            _expressTitle.font=[UIFont fontWithName:kFontMedium size:12];
            _expressTitle.textColor=HEXCOLOR(0x333333);
            _expressDate.font=[UIFont fontWithName:kFontMedium size:11];
            _expressDate.textColor=HEXCOLOR(0x333333);
            
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

