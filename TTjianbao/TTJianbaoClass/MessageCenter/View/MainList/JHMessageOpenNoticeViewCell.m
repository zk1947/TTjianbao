//
//  JHMessageOpenNoticeViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2020/2/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessageOpenNoticeViewCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"

@interface JHMessageOpenNoticeViewCell ()

@property (strong, nonatomic)  UIImageView* img;
@property (strong, nonatomic)  UILabel* title;
@property (strong, nonatomic)  UILabel* desc;
@end

@implementation JHMessageOpenNoticeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        
        _img = [[UIImageView alloc]init];
        _img.image = kDefaultAvatarImage;
        _img.layer.masksToBounds =YES;
        _img.layer.cornerRadius = 35/2.0;
        [self.contentView addSubview:_img];
        [_img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(4);
            make.size.mas_equalTo(CGSizeMake(35,35));
            make.left.offset(JHScaleToiPhone6(43));
        }];
    
        _title = [[UILabel alloc]init];
        _title.font = JHFont(15);
        _title.textColor = HEXCOLOR(0x333333);
        _title.numberOfLines = 1;
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(0);
            make.left.mas_equalTo(_img.mas_right).offset(20);
            make.right.mas_equalTo(self.contentView).offset(-30);
            make.height.offset(21);
        }];
        
        _desc = [[UILabel alloc]init];
        _desc.font = JHFont(12);
        _desc.textColor = HEXCOLOR(0x666666);
        _desc.textAlignment = NSTextAlignmentLeft;
        _desc.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_desc];
        [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_title.mas_bottom).offset(5);
            make.left.right.equalTo(_title);
            make.height.offset(17);
            make.bottom.mas_equalTo(self.contentView).offset(-15);
        }];
    }
    return self;
}

- (void)setModel:(JHMessageOpenNoticeModel*)model
{
//    [self.img jhSetImageWithURL:[NSURL URLWithString:model.image] placeholder:kDefaultAvatarImage];
    if(model.image)
        [self.img setImage:[UIImage imageNamed:model.image]];
    else
        [self.img setImage:kDefaultAvatarImage];
    self.title.text = model.title;
    self.desc.text = model.desc;
}

@end
