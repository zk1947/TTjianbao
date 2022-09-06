//
//  JHMessageCommonViewCell.m
//  TTjianbao
//  Description:店铺结算 样式
//  Created by Jesse on 2020/2/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessageCommonViewCell.h"
#import "UIImageView+JHWebImage.h"
#import "UserInfoRequestManager.h"
#import "TTjianbaoMarcoUI.h"

@implementation JHMessageCommonViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.backgroundsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.width.equalTo(self.contentView).offset(-15*2);
            make.top.equalTo(self.contentView);
            make.height.equalTo(self.contentView).offset(-10);
            make.height.mas_greaterThanOrEqualTo(60+20);
        }];
        
        self.imgView=[[UIImageView alloc]init];
        self.imgView.layer.masksToBounds =YES;
        self.imgView.layer.cornerRadius = 8;
        [self.backgroundsView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backgroundsView).offset(10);
            make.centerY.equalTo(self.backgroundsView);
            make.size.mas_equalTo(CGSizeMake(60,60));
        }];
        
        _title = [[UILabel alloc]init];
        _title.font = JHMediumFont(15);
        _title.textColor = HEXCOLOR(0x333333);
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        [self.backgroundsView addSubview:_title];
        
        _desc = [[UILabel alloc]init];
        _desc.font = JHFont(12);
        _desc.textColor = HEXCOLOR(0x666666);
        _desc.textAlignment = NSTextAlignmentLeft;
        _desc.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.backgroundsView addSubview:_desc];
    }
    return self;
}

- (void)updateData:(JHMsgSubListNormalModel*)model
{
    //title > titleRowLimit: -1不限制，0表示没有，大于0为实际行数
    if(model.titleRowLimit == -1)
    {//任意行数
        [_title setHidden:NO];
        _title.text = model.title;
        _title.numberOfLines = 0;
        [_title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundsView).offset(15);
            make.left.mas_equalTo(self.imgView.mas_right).offset(10);
            make.right.equalTo(self.backgroundsView).offset(-10);
        }];
    }
    else if(model.titleRowLimit > 0)
    {//实际行数
        [_title setHidden:NO];
        _title.text = model.title;
        _title.numberOfLines = model.titleRowLimit;
        [_title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundsView).offset(15);
            make.left.mas_equalTo(self.imgView.mas_right).offset(10);
            make.right.equalTo(self.backgroundsView).offset(-10);
        }];
    }
    else //隐藏
    {
        [_title setHidden:YES];
        [_title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundsView).offset(15);
            make.left.mas_equalTo(self.imgView.mas_right).offset(10);
            make.right.equalTo(self.backgroundsView).offset(-10);
            make.height.mas_offset(0);
        }];
    }
    
    //desc > textRowLimit: -1不限制，0表示没有，大于0为实际行数
    if(model.textRowLimit == -1)
    {//任意行数
        [_desc setHidden:NO];
        _desc.text = model.body;
        _desc.numberOfLines = 0;
        [_desc mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_title.mas_bottom).offset(2);
            make.left.right.equalTo(_title);
            make.bottom.equalTo(self.backgroundsView).offset(-11);
        }];
    }
    else if(model.textRowLimit > 0)
    {//实际行数
        [_desc setHidden:NO];
        _desc.text = model.body;
        _desc.numberOfLines = model.textRowLimit;
        [_desc mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_title.mas_bottom).offset(2);
            make.left.right.equalTo(_title);
            make.bottom.equalTo(self.backgroundsView).offset(-11);
        }];
    }
    else //隐藏
    {
        [_desc setHidden:YES];
    }
    //image 显示
    [_imgView jhSetImageWithURL:[NSURL URLWithString:model.iconUrl ? : @""] placeholder:kDefaultCoverImage];
//    if(model.titleRowLimit == 0 && model.textRowLimit == 0)
//    {
//        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.backgroundsView).offset(10);
//            make.bottom.equalTo(self.backgroundsView).offset(-10);
//            make.left.equalTo(self.backgroundsView).offset(10);
//            make.size.mas_equalTo(CGSizeMake(60,60));
//        }];
//    }
//    else
//    {
//        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.backgroundsView).offset(0);
//            make.centerY.equalTo(self.backgroundsView);
//            make.size.mas_equalTo(CGSizeMake(60,60));
//        }];
//    }
}

@end
