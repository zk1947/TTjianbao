//
//  JHOffSaleTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHOffSaleTableViewCell.h"
#import "JHUIFactory.h"

@implementation JHOffSaleTableViewCell
{
    UIImageView* ctxImage;  //内容，左边image
    UIImageView* playImage; //ctxImage上面的播放图标，表示视频
    UILabel* idLabel;
    UILabel* goodIdLabel; //货架号
    UILabel* descpLabel;
    UILabel* timeLabel;
    UILabel* priceLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self drawOffSaleviews];
    }
    
    return self;
}

- (void)drawOffSaleviews
{
    ctxImage = [JHUIFactory createImageView];
    [self.background addSubview:ctxImage];
    [ctxImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.background).offset(10);
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
    
    idLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(13) textAlignment:NSTextAlignmentLeft preTitle:@"编号："];
    [self.background addSubview:idLabel];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ctxImage).offset(3);
        make.left.mas_equalTo(ctxImage.mas_right).offset(10);
    }];
    
    goodIdLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(12) textAlignment:NSTextAlignmentLeft preTitle:@"货架："];
    [self.background addSubview:goodIdLabel];
    [goodIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(idLabel).offset(1);
        make.right.equalTo(self.background).offset(-10);
    }];
    
    descpLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(13) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:descpLabel];
    [descpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ctxImage).offset(26);
        make.left.mas_equalTo(ctxImage.mas_right).offset(10);
        make.right.equalTo(self.background).offset(-14);
    }];
    
    timeLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentLeft preTitle:@"下架时间："];
    [self.background addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(descpLabel);
        make.top.mas_equalTo(descpLabel.mas_bottom).offset(5);
    }];
    
    priceLabel = [JHUIFactory createJHLabelWithTitle:@"0.00" titleColor:HEXCOLOR(0xFC4200) font:JHFont(15) textAlignment:NSTextAlignmentLeft preTitle:@"￥"];
    [self.background addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel);
        make.top.mas_equalTo(timeLabel.mas_bottom).offset(5);
    }];
}

- (void)updateCell:(JHOffSaleGoodsModel*)model
{
    [ctxImage jhSetImageWithURL:[NSURL URLWithString:model.goodsUrl ? : @""] placeholder:kDefaultCoverImage];//网络图片

    idLabel.text = model.goodsCode;
    goodIdLabel.text = model.depositoryLocationCode;
    descpLabel.text = model.goodsTitle;
    timeLabel.text = model.unshelveTime;
    priceLabel.text = model.salePrice;
}

@end
