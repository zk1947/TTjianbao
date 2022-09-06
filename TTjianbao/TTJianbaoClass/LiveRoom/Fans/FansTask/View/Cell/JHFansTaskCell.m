//
//  JHFansTaskCell.m
//  TTjianbao
//
//  Created by jiangchao on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansTaskCell.h"
@interface JHFansTaskCell()
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UILabel *taskRewardDescLabel;
@property(nonatomic,strong)UIButton *button;
@end
@implementation JHFansTaskCell

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
//        make.bottom.equalTo(self.contentView).offset(-14);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.left.offset(15);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"1232323";
    _titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
    _titleLabel.textColor = kColor333;
    _titleLabel.numberOfLines = 1;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_titleLabel];
    
    
    _descLabel=[[UILabel alloc]init];
    _descLabel.text=@"34343434";
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
        make.top.equalTo(_titleLabel.mas_bottom).offset(8);
        
    }];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.titleLabel.font= [UIFont fontWithName:kFontNormal size:13];
    [_button setTitle:@"" forState:UIControlStateNormal];
    _button.layer.cornerRadius = 18;
    [_button setBackgroundColor:kColorMain];
    [_button setTitleColor:kColor333 forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    _button.contentMode=UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:_button];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(69, 32));
    }];
    
    
    _taskRewardDescLabel = [[UILabel alloc]init];
    _taskRewardDescLabel.font = JHFont(11);
    _taskRewardDescLabel.textColor = HEXCOLOR(0xBFA36F);
    _taskRewardDescLabel.numberOfLines = 0;
    _taskRewardDescLabel.textAlignment = NSTextAlignmentLeft;
    _taskRewardDescLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_taskRewardDescLabel];
    [_taskRewardDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImage.mas_right).offset(15);
        make.right.equalTo(self.contentView).offset(-12);
        make.top.mas_equalTo(self.button.mas_bottom).offset(11);
    }];
    
    
    _line = [JHUIFactory createLine];
    _line.color = HEXCOLOR(0xededed);
    [self.contentView addSubview:_line];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_taskRewardDescLabel.mas_bottom).offset(8);
        make.right.equalTo(self.contentView).offset(0);
        make.height.equalTo(@0.5);
        make.left.equalTo(_titleLabel.mas_left);
        make.bottom.equalTo(self.contentView);
    }];

}
-(void)setFansTaskModel:(JHFansTaskModel *)fansTaskModel{
    
    _fansTaskModel = fansTaskModel;
    [_iconImage jh_setImageWithUrl:_fansTaskModel.taskImg];
    _titleLabel.text = _fansTaskModel.taskName;
    _descLabel.text= _fansTaskModel.taskRemark;
    [_button setTitle:_fansTaskModel.taskBtnDesc forState:UIControlStateNormal];
    _taskRewardDescLabel.text = _fansTaskModel.taskRewardDesc;
    if (_fansTaskModel.taskStatus == 2) {
        
        _button.layer.borderWidth = 0.5;
         [_button setBackgroundColor:kColorFFF];
         _button.layer.borderColor = kColor999.CGColor;
         [_button setTitleColor:kColor999 forState:UIControlStateNormal];
         [_button setTitle:@"已完成" forState:UIControlStateNormal];
    }
    else{
        [_button setBackgroundColor:kColorMain];
        _button.layer.borderWidth = 0;
        [_button setTitleColor:kColor333 forState:UIControlStateNormal];
    }
}

-(void)buttonPress:(UIButton*)button{
    
    if (self.fansTaskModel.taskStatus == 2) {
        return;
    }
    if (self.buttonAction) {
        self.buttonAction(self.fansTaskModel);
    }
    
}
@end
