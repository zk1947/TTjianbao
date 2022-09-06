//
//  JHFansListCell.m
//  TTjianbao
//
//  Created by jiangchao on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansListCell.h"
@interface JHFansListCell()

@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UIImageView *fansGradeImage;
@property(nonatomic,strong)UILabel *fansGradeLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UIButton *button;
@end
@implementation JHFansListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    
    _iconImage = [[UIImageView alloc]init];
    _iconImage.image = kDefaultAvatarImage;
    _iconImage.layer.masksToBounds = YES;
    _iconImage.layer.cornerRadius = 11;
    _iconImage.userInteractionEnabled = YES;
    [self.contentView addSubview:_iconImage];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(14);
        make.bottom.equalTo(self.contentView).offset(-14);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.left.offset(15);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"";
    _titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
    _titleLabel.textColor = kColor333;
    _titleLabel.numberOfLines = 1;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_titleLabel];
    
    _descLabel=[[UILabel alloc]init];
    _descLabel.text=@"";
    _descLabel.font=[UIFont fontWithName:kFontNormal size:11];
    _descLabel.backgroundColor=[UIColor clearColor];
    _descLabel.textColor=kColor999;
    _descLabel.numberOfLines = 1;
    _descLabel.textAlignment = NSTextAlignmentLeft;
    _descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:_descLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImage.mas_right).offset(15);
        make.top.equalTo(_iconImage);
    }];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        
    }];
    
    
    
    _fansGradeImage = [[UIImageView alloc]init];
    _fansGradeImage.image = [[UIImage imageNamed:@"fans_list_grade10"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,30,0,5)resizingMode:UIImageResizingModeStretch];
    _fansGradeImage.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_fansGradeImage];
    
    [_fansGradeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
       // make.width.mas_greaterThanOrEqualTo(49);
        make.height.mas_equalTo(17);
    }];
    
    _fansGradeLabel = [[UILabel alloc]init];
  //  _fansGradeLabel.text = @"新粉";
    _fansGradeLabel.font = [UIFont fontWithName:kFontBoldPingFang size:10];
    _fansGradeLabel.textColor = kColorFFF;
    _fansGradeLabel.numberOfLines = 1;
    _fansGradeLabel.textAlignment = NSTextAlignmentRight;
    _fansGradeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_fansGradeImage addSubview:_fansGradeLabel];
    
    [_fansGradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_fansGradeImage);
        make.right.equalTo(_fansGradeImage).offset(-5);
        make.left.equalTo(_fansGradeImage).offset(28);
    }];
    
   
}
-(void)setFansModel:(JHFansModel *)fansModel{
    
    _fansModel = fansModel;
    [_iconImage jh_setImageWithUrl:_fansModel.fansImg];
    _titleLabel.text = _fansModel.fansName;
   // _descLabel.text= _fansModel.fansName;
    _fansGradeImage.image = [[UIImage imageNamed:[NSString stringWithFormat:@"fans_list_grade%@",_fansModel.levelType]] resizableImageWithCapInsets:UIEdgeInsetsMake(0,30,0,5)resizingMode:UIImageResizingModeStretch];
    
    // shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 0;
    shadow.shadowColor = [UIColor colorWithRed:116/255.0 green:61/255.0 blue:0/255.0 alpha:0.4];
    shadow.shadowOffset =CGSizeMake(0,0.5);
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_fansModel.levelName?:@"" attributes: @{NSFontAttributeName: [UIFont fontWithName:kFontBoldPingFang size:10],NSForegroundColorAttributeName: kColorFFF, NSShadowAttributeName: shadow}];

    _fansGradeLabel.attributedText = string;
    
}
-(void)buttonPress:(UIButton*)button{
    
    
}
@end
