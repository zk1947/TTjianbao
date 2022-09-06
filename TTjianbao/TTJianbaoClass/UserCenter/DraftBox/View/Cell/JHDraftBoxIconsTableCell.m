//
//  JHDraftBoxIconsTableCell.m
//  TTjianbao
//
//  Created by jesee on 28/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHDraftBoxIconsTableCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "JHPreTitleLabel.h"
#import "NSString+Common.h"

//左右边距15,间隔6,三张图
#define kIconWH ((ScreenWidth - kLeftRightMargin * 2 - 6 * 2)/3.0)
#define kIconSize CGSizeMake(kIconWH, kIconWH)

@implementation JHDraftBoxIconsTableCell
{
    JHPreTitleLabel* numLabel;
    UIImageView* iconView1;
    UIImageView* iconView2;
    UIImageView* iconView3;
}

- (void)drawSubviews
{
    [super drawSubviews];
    
    iconView1 = [self makeImageView];
    [iconView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel);
        make.size.mas_equalTo(kIconSize);
        make.bottom.mas_equalTo(self.timeLabel.mas_top).offset(0 - kVerticalMargin);
    }];
    
    iconView2 = [self makeImageView];
    [iconView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconView1.mas_right).offset(6);
        make.size.mas_equalTo(kIconSize);
        make.bottom.equalTo(iconView1);
    }];
    
    iconView3 = [self makeImageView];
    [iconView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconView2.mas_right).offset(6);
        make.size.mas_equalTo(kIconSize);
        make.bottom.equalTo(iconView1);
    }];
    
    numLabel = [JHPreTitleLabel new];
    numLabel.textColor = HEXCOLOR(0xFFFFFF);
    numLabel.font = JHFont(15);
    numLabel.textAlignment = NSTextAlignmentCenter;
    [iconView3 addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconView3);
        make.centerY.equalTo(iconView3);
        make.height.mas_equalTo(21);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel);
        make.top.equalTo(self.bgView).offset(kLeftRightMargin);
        make.right.equalTo(self.bgView).offset(0 - kLeftRightMargin);
        make.bottom.mas_equalTo(iconView1.mas_top).offset(0 - kVerticalMargin);
    }];
}

- (UIImageView*)makeImageView
{
    UIImageView* image = [UIImageView jh_imageViewAddToSuperview:self.bgView];
    image.layer.masksToBounds = YES;
    image.layer.cornerRadius = 8;
    [image setHidden:YES];
    return image;
}

#pragma mark - event
- (void)updateData:(JHDraftBoxModel*)model
{
    [super updateData:model];
    
    [iconView1 setHidden:YES];
    [iconView2 setHidden:YES];
    [iconView3 setHidden:YES];
    NSInteger count = model.imageDataArray.count;
    if(count > 0)
    {
        [iconView1 setHidden:NO];
        
        iconView1.image = model.imageDataArray[0] ? [UIImage imageWithData:model.imageDataArray[0]] : kDefaultCoverImage;
        if(count > 1)
        {
            [iconView2 setHidden:NO];
            iconView2.image = model.imageDataArray[1] ? [UIImage imageWithData:model.imageDataArray[1]] : kDefaultCoverImage;
            if(count > 2)
            {
                [iconView3 setHidden:NO];
                iconView3.image = model.imageDataArray[2] ? [UIImage imageWithData:model.imageDataArray[2]] : kDefaultCoverImage;
                numLabel.preTitle = model.imageCount;
                numLabel.text = @"张";
            }
        }
    }
    
    if([NSString isEmpty:model.content])
    {
        [self.contentLabel setHidden:YES];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel);
            make.top.equalTo(self.bgView).offset(kLeftRightMargin);
            make.right.equalTo(self.bgView).offset(self.editingMargin - kLeftRightMargin);
            make.bottom.mas_equalTo(iconView1.mas_top).offset(0);
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
            make.bottom.mas_equalTo(iconView1.mas_top).offset(0 - kVerticalMargin);
        }];
    }
}

@end
