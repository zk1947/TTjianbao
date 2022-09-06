//
//  JHSoldTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSoldTableViewCell.h"
#import "JHUIFactory.h"

@interface JHSoldTableViewCell ()
{
    UIImageView* headImage;
    UIImageView* ctxImage;  //内容，左边image
    UIImageView* playImage; //ctxImage上面的播放图标，表示视频
    UILabel* headLabel;
    UILabel* idLabel;
    UILabel* descpLabel;
    UILabel* priceLabel;
    UILabel* finalPriceTag; //成交价
    UILabel* finalPriceLabel;
    UILabel* finalTimeLabel;
}
@end

@implementation JHSoldTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self drawSubviews];
    }
    
    return self;
}

- (void)drawSubviews
{
    headImage = [JHUIFactory createImageView];
    headImage.layer.cornerRadius = 16/2.0;
    [self.background addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.background).offset(11);
        make.top.equalTo(self.background).offset(10);
        make.size.mas_equalTo(16);
    }];
    
    headLabel = [JHUIFactory createLabelWithTitle:@"回血直播间：" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(12) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:headLabel];
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImage.mas_right).offset(5);
        make.top.equalTo(self.background).offset(9);
        make.height.mas_equalTo(17);
    }];
    
    ctxImage = [JHUIFactory createImageView];
    [self.background addSubview:ctxImage];
    [ctxImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImage.mas_bottom).offset(12);
        make.left.equalTo(headImage);
        make.size.mas_equalTo(90);
    }];
    
    playImage = [JHUIFactory createImageView];
    playImage.userInteractionEnabled = NO;
    playImage.image = [UIImage imageNamed:@"stone_video_play"];
    [ctxImage addSubview:playImage];
    [playImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(ctxImage);
        make.size.mas_equalTo(23);
    }];
    
    idLabel = [JHUIFactory createLabelWithTitle:@"编号：" titleColor:HEXCOLOR(0x333333) font:JHFont(13) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:idLabel];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headLabel.mas_bottom).offset(13);
        make.left.mas_equalTo(ctxImage.mas_right).offset(10);
        make.height.mas_equalTo(15);
    }];
    
    descpLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(13) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:descpLabel];
    [descpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(idLabel.mas_bottom).offset(8);
        make.left.equalTo(idLabel);
        make.height.mas_equalTo(18);
    }];
    
    priceLabel = [JHUIFactory createJHLabelWithTitle:@"1500,000" titleColor:HEXCOLOR(0x333333) font:JHFont(13) textAlignment:NSTextAlignmentLeft preTitle:@"￥"];
    [self.background addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(descpLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(ctxImage.mas_right).offset(9);
        make.height.mas_equalTo(18);
    }];
    
    finalPriceTag = [JHUIFactory createLabelWithTitle:@"成交价" titleColor:HEXCOLOR(0x333333) font:JHFont(13) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:finalPriceTag];
    [finalPriceTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(ctxImage.mas_right).offset(12);
        make.height.mas_equalTo(18);
    }];
    
    finalPriceLabel = [JHUIFactory createJHLabelWithTitle:@"0.0" titleColor:HEXCOLOR(0xFC4200) font:JHMediumFont(15) textAlignment:NSTextAlignmentLeft preTitle:@"￥"];
    [self.background addSubview:finalPriceLabel];
    [finalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceLabel.mas_bottom).offset(3);
        make.left.mas_equalTo(finalPriceTag.mas_right).offset(5);
        make.height.mas_equalTo(21);
    }];
    
    finalTimeLabel = [JHUIFactory createLabelWithTitle:@"成交时间：" titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:finalTimeLabel];
    [finalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ctxImage.mas_bottom).offset(14);
        make.left.equalTo(ctxImage);
    }];
}

- (void)updateCell:(JHUCSoldListModel*)model
{
    if(!model)
    {
        DDLogInfo(@"%@------model is nil!!!", NSStringFromClass([self class]));
        return;
    }

    [headImage jhSetImageWithURL:[NSURL URLWithString:model.anchorIcon ? : @""] placeholder:kDefaultAvatarImage];//网络图片
    
    headLabel.text = model.channelTitle;
    
    [ctxImage jhSetImageWithURL:[NSURL URLWithString:model.goodsUrl ? : @""] placeholder:kDefaultCoverImage];//网络图片
    
    idLabel.text = [NSString stringWithFormat:@"编号：%@", model.goodsCode];
    descpLabel.text = model.goodsTitle;
    priceLabel.text = model.salePrice;
    finalPriceLabel.text = model.dealPrice;
    finalTimeLabel.text = [NSString stringWithFormat:@"成交时间：%@", model.dealTime];
}

@end
