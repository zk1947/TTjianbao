//
//  JHReportAddressManagerCell.m
//  TTjianbao
//
//  Created by 张坤 on 2021/5/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHReportAddressManagerCell.h"
#import "TTjianbaoHeader.h"
#import "UIButton+ImageTitleSpacing.h"

@interface JHReportAddressManagerCell()

@property(strong,nonatomic) UIView *contentBack;
@property(strong,nonatomic) UILabel *name;
@property(strong,nonatomic) UILabel *phoneNum;
@property(strong,nonatomic) UILabel *adress;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation JHReportAddressManagerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentBack=[[UIView alloc]init];
        self.contentBack.backgroundColor=[UIColor whiteColor];
        self.contentBack.layer.cornerRadius = 8;
        self.contentBack.layer.masksToBounds = YES;
        [self.contentView addSubview:self.contentBack];
        [self.contentBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(0);
            make.bottom.equalTo(self.contentView).offset(0);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
        [self.contentView addSubview:self.titleLabel];
        
        _name=[[UILabel alloc] init];
        _name.text=@"";
        _name.font=[UIFont fontWithName:kFontNormal size:14];
        _name.backgroundColor=[UIColor clearColor];
       
        _name.textColor= HEXCOLOR(0x333333);
        //saleName.adjustsFontSizeToFitWidth = YES;
        _name.numberOfLines = 0;
        _name.textAlignment = NSTextAlignmentLeft;
        _name.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentBack addSubview:_name];
        
        _phoneNum=[[UILabel alloc]init];
        _phoneNum.text=@"";
        _phoneNum.font=[UIFont fontWithName:kFontNormal size:14];
        _phoneNum.backgroundColor=[UIColor clearColor];
        _phoneNum.textColor= HEXCOLOR(0x333333);
        //saleName.adjustsFontSizeToFitWidth = YES;
        _phoneNum.numberOfLines = 1;
        _phoneNum.textAlignment = NSTextAlignmentLeft;
        _phoneNum.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentBack addSubview:_phoneNum];
        
        _adress=[[UILabel alloc]init];
        _adress.text=@"";
        _adress.font=[UIFont fontWithName:kFontNormal size:12];
        _adress.backgroundColor=[UIColor clearColor];
        _adress.preferredMaxLayoutWidth=ScreenW;
        _adress.textColor= HEXCOLOR(0xFF333333);
        _adress.numberOfLines = 0;
        _adress.preferredMaxLayoutWidth = ScreenW-20;
        _adress.textAlignment = NSTextAlignmentLeft;
        _adress.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentBack addSubview:_adress];
        
//        UIView *line=[[UIView alloc] init];
//        line.backgroundColor = [UIColor colorWithRed:0.92f green:0.91f blue:0.92f alpha:1.00f];
//        [self.contentBack addSubview:line];
    
        UIImageView *addressIV = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"icon_buy_gary_address"] addToSuperview:self.contentBack];
        
        UIImageView *bankCardIconIV = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"goods_collect_list_icon_shop_arrow"] addToSuperview:self.contentBack];
        
        [bankCardIconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentBack);
            make.right.mas_equalTo(-12);
        }];
        
        [addressIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-30);
            make.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(14, 16));
        }];
    
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.equalTo(addressIV);
        }];
        
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.left.equalTo(addressIV.mas_right).offset(10);
            // make.right.equalTo(self.content).offset(-10);
            
        }];
        
        [_phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_name);
            make.left.equalTo(_name.mas_right).offset(5);
        
        }];
        
        [_adress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_name.mas_bottom).offset(10);
            
            make.left.equalTo(self.name).offset(0);
            make.right.equalTo(self.contentBack).offset(-10);
            
        }];
        
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(_adress.mas_bottom).offset(10);
//            make.right.equalTo(self.contentBack);
//            make.left.equalTo(_name);
//            make.height.equalTo(@0.5);
//
//        }];
    
    }
    return self;
}

-(void)setAdressMode:(AdressMode *)adressMode {
    _adressMode=adressMode;
    _adress.text=[NSString stringWithFormat:@"%@ %@ %@ %@",_adressMode.province,_adressMode.city,_adressMode.county,_adressMode.detail];
    _phoneNum.text=_adressMode.phone;
    _name.text=_adressMode.receiverName;
}

-(void)setCellIndex:(NSInteger)cellIndex{
    _cellIndex=cellIndex;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"退货地址";
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    }
    return _titleLabel;
}
@end
