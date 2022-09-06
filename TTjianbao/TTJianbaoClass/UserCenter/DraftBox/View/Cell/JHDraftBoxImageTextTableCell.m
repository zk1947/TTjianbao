//
//  JHDraftBoxImageTextTableCell.m
//  TTjianbao
//
//  Created by jesee on 29/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHDraftBoxImageTextTableCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "NSString+Common.h"

#define kImageWidth (ScreenWidth - kLeftRightMargin*2)
#define kImageSize CGSizeMake(kImageWidth, kImageWidth * 194/345.0)

@implementation JHDraftBoxImageTextTableCell
{
    UILabel* titleLabel; //仅text&image样式使用
}

- (void)drawSubviews
{
    [super drawSubviews];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel);
        make.right.equalTo(self.bgView).offset(0 - kLeftRightMargin);
        make.bottom.mas_equalTo(self.timeLabel.mas_top).offset(0 - kVerticalMargin);
    }];
    
    titleLabel = [UILabel new];
    titleLabel.textColor = HEXCOLOR(0x333333);
    titleLabel.font = JHMediumFont(18);
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel);
        make.right.equalTo(self.bgView).offset(0 - kLeftRightMargin);
        make.bottom.mas_equalTo(self.contentLabel.mas_top).offset(0 - kVerticalMargin);
    }];
    
    self.contentImage = [UIImageView new];
    self.contentImage.layer.masksToBounds = YES;
    self.contentImage.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImage.layer.cornerRadius = 8;
    [self.bgView addSubview:self.contentImage];
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(kLeftRightMargin);
        make.left.equalTo(self.timeLabel);
        make.right.equalTo(self.bgView).offset(0 - kLeftRightMargin);
        make.size.mas_equalTo(kImageSize);
        make.bottom.mas_equalTo(titleLabel.mas_top).offset(0 - kVerticalMargin);
    }];
}

#pragma mark - event
- (void)updateData:(JHDraftBoxModel*)model
{
    [super updateData:model];
    
    if([NSString isEmpty:model.content])
    {
        [self.contentLabel setHidden:YES];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel);
            make.right.equalTo(self.bgView).offset(self.editingMargin - kLeftRightMargin);
            make.bottom.mas_equalTo(self.timeLabel.mas_top).offset(0);
            make.height.mas_equalTo(0);
        }];
    }
    else
    {
        [self.contentLabel setHidden:NO];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel);
            make.right.equalTo(self.bgView).offset(self.editingMargin - kLeftRightMargin);
            make.bottom.mas_equalTo(self.timeLabel.mas_top).offset(0 - kVerticalMargin);
        }];
    }
    
    if([NSString isEmpty:model.title])
    {
        [titleLabel setHidden:YES];
        [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel);
            make.right.equalTo(self.bgView).offset(self.editingMargin - kLeftRightMargin);
            make.bottom.mas_equalTo(self.contentLabel.mas_top).offset(0);
            make.height.mas_equalTo(0);
        }];
    }
    else
    {
        [titleLabel setHidden:NO];
        titleLabel.text = model.title;
        [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel);
            make.right.equalTo(self.bgView).offset(self.editingMargin - kLeftRightMargin);
            make.bottom.mas_equalTo(self.contentLabel.mas_top).offset(0 - kVerticalMargin);
        }];
    }
    
    if(!model.imageData)
    {
        [self.contentImage setHidden:YES];
        [self.contentImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(kLeftRightMargin);
            make.left.equalTo(self.timeLabel);
            make.right.equalTo(self.bgView).offset(self.editingMargin - kLeftRightMargin);
            make.height.mas_equalTo(0);
            make.bottom.mas_equalTo(titleLabel.mas_top).offset(0);
        }];
    }
    else
    {
        [self.contentImage setHidden:NO];
        if(model.coverImageData)
        {
            self.contentImage.image = [UIImage imageWithData:model.coverImageData];
        }
        else
        {
            self.contentImage.image = kDefaultCoverImage;
        }
        [self.contentImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(kLeftRightMargin);
            make.left.equalTo(self.timeLabel);
            make.right.equalTo(self.bgView).offset(self.editingMargin - kLeftRightMargin);
            make.size.mas_equalTo(kImageSize);
            make.bottom.mas_equalTo(titleLabel.mas_top).offset(0 - kVerticalMargin);
        }];
    }
}
    
@end
