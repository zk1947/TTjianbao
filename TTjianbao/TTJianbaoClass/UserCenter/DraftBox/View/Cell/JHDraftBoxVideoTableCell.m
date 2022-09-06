//
//  JHDraftBoxVideoTableCell.m
//  TTjianbao
//
//  Created by jesee on 28/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHDraftBoxVideoTableCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "NSString+Common.h"

@implementation JHDraftBoxVideoTableCell
{
    UIImageView* playImage;
    UILabel* durationLabel;
}

- (void)drawSubviews
{
    [super drawSubviews];
    
    self.contentImage = [UIImageView new];
    self.contentImage.layer.masksToBounds = YES;
    self.contentImage.layer.cornerRadius = 8;
    [self.bgView addSubview:self.contentImage];
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel);
        make.size.mas_equalTo(CGSizeMake(160, 213));
        make.bottom.mas_equalTo(self.timeLabel.mas_top).offset(0 - kVerticalMargin);
    }];
    
    playImage = [UIImageView new];
    playImage.image = [UIImage imageNamed:@"icon_video_play_white"];
    [self.contentImage addSubview:playImage];
    [playImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentImage);
        make.centerY.equalTo(self.contentImage);
        make.size.mas_equalTo(CGSizeMake(12.5, 14.5));
    }];
    
    durationLabel = [UILabel new];
    durationLabel.textColor = HEXCOLOR(0xFFFFFF);
    durationLabel.font = JHFont(12);
    durationLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentImage addSubview:durationLabel];
    [durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentImage).offset(kVerticalMargin);
        make.bottom.equalTo(self.contentImage).offset(-4);
        make.height.mas_equalTo(17);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel);
        make.top.equalTo(self.bgView).offset(kLeftRightMargin);
        make.right.equalTo(self.bgView).offset(0 - kLeftRightMargin);
        make.bottom.mas_equalTo(self.contentImage.mas_top).offset(0 - kVerticalMargin);
    }];
}

#pragma mark - event
- (void)updateData:(JHDraftBoxModel*)model
{
    [super updateData:model];
    if(model.imageData)
    {
        self.contentImage.image = [UIImage imageWithData:model.imageData];
    }
    else
    {
        self.contentImage.image = kDefaultCoverImage;
    }
    
    durationLabel.text = model.durationStr;
    if([NSString isEmpty:model.content])
    {
        [self.contentLabel setHidden:YES];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel);
            make.top.equalTo(self.bgView).offset(kLeftRightMargin);
            make.right.equalTo(self.bgView).offset(self.editingMargin - kLeftRightMargin);
            make.bottom.mas_equalTo(self.contentImage.mas_top).offset(0);
            make.height.mas_equalTo(0);
        }];
    }
    else
    {
        [self.contentLabel setHidden:NO];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel);
            make.top.equalTo(self.bgView).offset(kLeftRightMargin);
            make.right.equalTo(self.bgView).offset(self.editingMargin - kLeftRightMargin);
            make.bottom.mas_equalTo(self.contentImage.mas_top).offset(0 - kVerticalMargin);
        }];
    }
}

@end
