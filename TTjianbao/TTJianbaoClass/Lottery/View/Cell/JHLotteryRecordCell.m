//
//  JHLotteryRecordCell.m
//  TTjianbao
//
//  Created by jiangchao on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryRecordCell.h"
#import "NSString+AttributedString.h"

@interface JHLotteryRecordCell ()
@property (strong, nonatomic)  UIImageView *displayImage;
@property (strong, nonatomic)  UILabel *lotteryTitle;
@property (strong, nonatomic)  UILabel *price;
@property (strong, nonatomic)  UILabel *oldPrice;
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel *code;
@property (strong, nonatomic)  UILabel *period;
@end

@implementation JHLotteryRecordCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        UIView *contentBack = [[UIView alloc]init];
        contentBack.backgroundColor = [UIColor whiteColor];
        contentBack.layer.cornerRadius = 8;
        contentBack.layer.masksToBounds = YES;
        [self.contentView addSubview:contentBack];
        [contentBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(0);
            make.bottom.equalTo(self.contentView).offset(0);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            
        }];
        
        _displayImage=[[UIImageView alloc]init];
        _displayImage.image=kDefaultCoverImage;
        _displayImage.contentMode = UIViewContentModeScaleAspectFill;
        _displayImage.layer.masksToBounds=YES;
        _displayImage.layer.cornerRadius = 8.0;
        [contentBack addSubview:_displayImage];
        [_displayImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentBack.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(90, 90));
            make.left.equalTo(contentBack).offset(10);
            
        }];
        _lotteryTitle=[[UILabel alloc]init];
        _lotteryTitle.text=@"";
        _lotteryTitle.font=[UIFont fontWithName:kFontNormal size:14];
        _lotteryTitle.backgroundColor=[UIColor clearColor];
        _lotteryTitle.textColor=kColor333;
        _lotteryTitle.numberOfLines = 2;
        _lotteryTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        _lotteryTitle.textAlignment = NSTextAlignmentLeft;
        [contentBack addSubview:_lotteryTitle];
        
        [_lotteryTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_displayImage);
            make.right.equalTo(contentBack).offset(-5);
            make.left.equalTo(_displayImage.mas_right).offset(10);
            
        }];
        
        _price=[[UILabel alloc]init];
        _price.text=@"";
        _price.font=[UIFont fontWithName:kFontBoldDIN size:18.f];
        _price.textColor=kColorMainRed;
        _price.numberOfLines = 1;
        _price.textAlignment = NSTextAlignmentLeft;
        _price.lineBreakMode = NSLineBreakByWordWrapping;
        [contentBack addSubview:_price];
        
        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_displayImage).offset(0);
            make.left.equalTo(_displayImage.mas_right).offset(5);
            
        }];
        
        UILabel  *oldPriceTitle=[[UILabel alloc]init];
        oldPriceTitle.text=@"市场价";
        oldPriceTitle.font=[UIFont fontWithName:kFontNormal size:12];
        oldPriceTitle.textColor=kColor999;
        oldPriceTitle.numberOfLines = 1;
        oldPriceTitle.textAlignment = NSTextAlignmentLeft;
        oldPriceTitle.lineBreakMode = NSLineBreakByWordWrapping;
        [contentBack addSubview:oldPriceTitle];
        
        [oldPriceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_price).offset(0);
            make.left.equalTo(_price.mas_right).offset(5);
        }];
        
        _oldPrice=[[UILabel alloc]init];
        _oldPrice.text=@"";
        _oldPrice.font=[UIFont fontWithName:kFontNormal size:12];
        _oldPrice.textColor=kColor999;
        _oldPrice.numberOfLines = 1;
        _oldPrice.textAlignment = NSTextAlignmentLeft;
        _oldPrice.lineBreakMode = NSLineBreakByWordWrapping;
        [contentBack addSubview:_oldPrice];
        
        [_oldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_price).offset(0);
            make.left.equalTo(oldPriceTitle.mas_right).offset(5);
        }];
        
        UIView  *line=[[UIView alloc]init];
        line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
        [contentBack addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentBack).offset(10);
            make.top.equalTo(_displayImage.mas_bottom).offset(10);
            make.right.equalTo(contentBack).offset(0);
            make.height.offset(1);
        }];
        
        _headImage = [[UIImageView alloc]init];
        _headImage.image = kDefaultAvatarImage;
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius = 8;
        _headImage.userInteractionEnabled=YES;
        [contentBack addSubview:_headImage];
        
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.left.offset(10);
            make.bottom.equalTo(contentBack).offset(-10);
        }];
        
        UILabel *codeLabel=[[UILabel alloc]init];
        codeLabel.text=@"中奖号码";
        codeLabel.font=[UIFont fontWithName:kFontNormal size:12];
        codeLabel.backgroundColor=[UIColor clearColor];
        codeLabel.textColor=kColor333;
        codeLabel.numberOfLines = 1;
        codeLabel.textAlignment = NSTextAlignmentLeft;
        codeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [contentBack addSubview:codeLabel];
        
        [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImage.mas_right).offset(5);
            make.centerY.equalTo(_headImage);
            
        }];
        
        _code=[[UILabel alloc]init];
        _code.text=@"";
        _code.font=[UIFont fontWithName:kFontNormal size:12];
        _code.backgroundColor=[UIColor clearColor];
        _code.textColor=kColor333;
        _code.numberOfLines = 1;
        _code.textAlignment = NSTextAlignmentLeft;
        _code.lineBreakMode = NSLineBreakByWordWrapping;
        [contentBack addSubview:_code];
        
        [_code mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(codeLabel.mas_right).offset(5);
            make.centerY.equalTo(_headImage);
            
        }];
        
        _period=[[UILabel alloc]init];
        _period.text=@"";
        _period.font=[UIFont fontWithName:kFontNormal size:12.f];
        _period.textColor=kColor333;
        _period.numberOfLines = 1;
        _period.textAlignment = NSTextAlignmentLeft;
        _period.lineBreakMode = NSLineBreakByWordWrapping;
        [contentBack addSubview:_period];
        
        [_period mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headImage);
            make.right.equalTo(contentBack).offset(-10);
            
        }];
        
    }
    
    return self;
}
-(void)setLotteryData:(JHLotteryData *)lotteryData{
    
    _lotteryData = lotteryData;
    JHLotteryActivityData * actData = _lotteryData.activityList[0];
    _lotteryTitle.text=[NSString stringWithFormat:@"%@",actData.prizeName ? : @""];
    [_displayImage jhSetImageWithURL:[NSURL URLWithString: _lotteryData.img ? : @""] placeholder:kDefaultCoverImage];
    [_headImage jhSetImageWithURL:[NSURL URLWithString: actData.hitUserImg ? : @""] placeholder:kDefaultCoverImage];
    //_price.text=[NSString stringWithFormat:@"%@",actData.price ? : @""];
      NSString * string=[@"¥ " stringByAppendingString:actData.price?:@""];
          NSRange range = [string rangeOfString:@"¥"];
    _price.attributedText=[string attributedFont:[UIFont fontWithName:kFontMedium size:11.f] color:kColorMainRed range:range];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",actData.prizePrice ? : @""] attributes:attribtDic];
    _oldPrice.attributedText = attribtStr;
    _code.text=[NSString stringWithFormat:@"%@",actData.hitCode ? : @""];
    _period.text=[NSString stringWithFormat:@"%@期",actData.activityDate ? : @""];
    
}
-(void)imageTap{
    
    
}
@end
