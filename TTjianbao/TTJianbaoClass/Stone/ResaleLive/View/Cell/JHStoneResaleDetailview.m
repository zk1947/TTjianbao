//
//  JHStoneResaleDetailview.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneResaleDetailview.h"
#import "JHUIFactory.h"

#define kTextColor HEXCOLORA(0xFFFFFF, 0.8)

@implementation JHStoneResaleDetailview
@synthesize headImg, nameLabel, timeLabel, priceLabel, offerStatusImg;

- (instancetype)init
{
    if(self = [super init])
    {
        self.layer.cornerRadius = 20;
//        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = HEXCOLORA(0xFFFFFF, 0.1).CGColor;
        
        [self drawSubviews];
    }
    
    return self;
}

- (void)drawSubviews
{
    headImg = [JHUIFactory createImageView];
    headImg.layer.cornerRadius = 30/2.0;
    [self addSubview:headImg];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(7);
        make.top.equalTo(self).offset(5);
        make.size.mas_equalTo(30);
    }];
    
    nameLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:kTextColor font:JHMediumFont(12) textAlignment:NSTextAlignmentLeft];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.mas_equalTo(headImg.mas_right).offset(10);
        make.height.mas_offset(17);
    }];
    
    timeLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLORA(0x999999, 0.8) font:JHFont(9) textAlignment:NSTextAlignmentLeft];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel);
        make.top.mas_equalTo(nameLabel.mas_bottom);
    }];
    
    UILabel* priceTag = [JHUIFactory createLabelWithTitle:@"出价 " titleColor:kTextColor font:JHFont(15) textAlignment:NSTextAlignmentLeft];
    [self addSubview:priceTag];

    priceLabel = [JHUIFactory createJHLabelWithTitle:@"*******" titleColor:HEXCOLOR(0xFFFFFF) font:JHMediumFont(15) textAlignment:NSTextAlignmentLeft preTitle:@"￥"];
    [self addSubview:priceLabel];
    
    offerStatusImg = [JHUIFactory createImageView];
    [self addSubview:offerStatusImg];
    [offerStatusImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(4);
        make.right.mas_equalTo(self).offset(-3);
        make.size.mas_equalTo(CGSizeMake(33, 32));
    }];
    
    [priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(offerStatusImg.mas_left).offset(-15);
    }];
    
    [priceTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.priceLabel.mas_left).offset(-5);
    }];
}

- (void)updateCell:(JHStoneResaleDetailSubModel*)model
{
    detailModel = model;

    [headImg jhSetImageWithURL:[NSURL URLWithString:model.headImg ? : @""] placeholder:kDefaultAvatarImage];

    nameLabel.text = model.name;
    timeLabel.text = [CommHelp timeForJHShowTime:model.time];

    //出价状态 1-出价中 4-已拒绝 7 or 8 -失效
    if(model.offerStatus == JHStoneOfferStatusOffering || model.offerStatus == JHStoneOfferStatusWillOffer)
    {
        offerStatusImg.image = [UIImage imageNamed:@"resale_stone_offer_price"];
    }
    else  if(model.offerStatus == JHStoneOfferStatusReject)
    {
        offerStatusImg.image = [UIImage imageNamed:@"resale_stone_refuse"];
    }
    else  if(model.offerStatus == JHStoneOfferStatusFinished)
    {
        offerStatusImg.image = [UIImage imageNamed:@"resale_stone_success"];
    }
    else //offerStatus =7 or 8 or other
    {
        offerStatusImg.image = [UIImage imageNamed:@"resale_stone_invalid"];
    }
}

@end
