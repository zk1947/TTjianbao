//
//  JHOnSaleTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHOnSaleTableViewCell.h"
#import "NSString+Common.h"

#define kIconWidth 25.0
#define kIconOffset 5.0

@implementation JHOnSaleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews
{
    self.headImage = [JHUIFactory createImageView];
    [_headImage setHidden:YES];
    _headImage.layer.cornerRadius = 16/2.0;
    [self.background addSubview:_headImage];
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.background).offset(11);
        make.top.equalTo(self.background).offset(0);//默认0，需要时=10
        make.size.mas_equalTo(0);//默认0，需要时=16
    }];
    
    self.ctxImage = [JHUIFactory createImageView];
    [self.background addSubview:_ctxImage];
    [_ctxImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headImage.mas_bottom).offset(12);
        make.left.equalTo(_headImage);
        make.size.mas_equalTo(90);
    }];
    
    self.playImage = [JHUIFactory createImageView];
    self.playImage.userInteractionEnabled = NO;
    self.playImage.image = [UIImage imageNamed:@"stone_video_play"];
    [self.ctxImage addSubview:self.playImage];
    [self.playImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.ctxImage);
        make.size.mas_equalTo(23);
    }];
    
    self.idLabel = [JHUIFactory createLabelWithTitle:@"编号：" titleColor:HEXCOLOR(0x333333) font:JHFont(13) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:_idLabel];
    [_idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ctxImage.mas_top).offset(2);
        make.left.mas_equalTo(_ctxImage.mas_right).offset(10);
        make.height.mas_equalTo(15);
    }];
    
    self.descpLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(13) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:_descpLabel];
    [_descpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_idLabel.mas_bottom).offset(8);
        make.left.equalTo(_idLabel);
        make.height.mas_equalTo(18);
        make.right.equalTo(self.background).offset(-14);
    }];
    
    self.moneyImage = [JHUIFactory createImageView];
    [self.background addSubview:_moneyImage];
    _moneyImage.image = [UIImage imageNamed:@"stone_sale_times"];
    [_moneyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_descpLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_ctxImage.mas_right).offset(11);
        make.size.mas_equalTo(12);
    }];
    
    self.saleLabel = [JHUIFactory createLabelWithTitle:@"第1次交易" titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:_saleLabel];
    [_saleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_descpLabel.mas_bottom).offset(7);
        make.left.mas_equalTo(_moneyImage.mas_right).offset(4);
        make.height.mas_equalTo(17);
    }];
    
    self.finalPriceLabel = [JHUIFactory createJHLabelWithTitle:@"0.00" titleColor:HEXCOLOR(0xFC4200) font:JHMediumFont(15) textAlignment:NSTextAlignmentLeft preTitle:@"￥"];
    [self.background addSubview:_finalPriceLabel];
    [_finalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_saleLabel.mas_bottom).offset(3);
        make.left.mas_equalTo(_ctxImage.mas_right).offset(8);
        make.height.mas_equalTo(21);
    }];
    
    self.headerIcon1 = [JHUIFactory createImageView];
    [_headerIcon1 setImage:kDefaultAvatarImage];
    _headerIcon1.layer.cornerRadius = kIconWidth/2.0;
    [self.background addSubview:_headerIcon1];
    [_headerIcon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ctxImage);
        make.top.mas_equalTo(_ctxImage.mas_bottom).offset(20);
        make.size.mas_equalTo(kIconWidth);
    }];
    [_headerIcon1 setHidden:YES];
    
    self.headerIcon2 = [JHUIFactory createImageView];
    [_headerIcon2 setImage:kDefaultAvatarImage];
    _headerIcon2.layer.cornerRadius = kIconWidth/2.0;
    [self.background addSubview:_headerIcon2];
    [_headerIcon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headerIcon1.mas_right).offset(-kIconOffset);
        make.top.equalTo(_headerIcon1);
        make.size.equalTo(_headerIcon1);
    }];
    [_headerIcon2 setHidden:YES];
    
    self.headerIcon3 = [JHUIFactory createImageView];
    [_headerIcon3 setImage:kDefaultAvatarImage];
    _headerIcon3.layer.cornerRadius = kIconWidth/2.0;
    [self.background addSubview:_headerIcon3];
    [_headerIcon3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headerIcon2.mas_right).offset(-kIconOffset);
        make.top.equalTo(_headerIcon2);
        make.size.equalTo(_headerIcon2);
    }];
    [_headerIcon3 setHidden:YES];
    
    self.headerIcon4 = [JHUIFactory createImageView];
    [_headerIcon4 setImage:kDefaultAvatarImage];
    _headerIcon4.layer.cornerRadius = kIconWidth/2.0;
    [self.background addSubview:_headerIcon4];
    [_headerIcon4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headerIcon3.mas_right).offset(-kIconOffset);
        make.top.equalTo(_headerIcon3);
        make.size.equalTo(_headerIcon3);
    }];
    [_headerIcon4 setHidden:YES];
    
    self.seeLabel = [JHUIFactory createLabelWithTitle:@"0人\n热度" titleColor:HEXCOLOR(0x333333) font:JHFont(9) textAlignment:NSTextAlignmentCenter];
    _seeLabel.backgroundColor = [UIColor whiteColor];
    [self.background addSubview:_seeLabel];
    _seeLabel.layer.cornerRadius = 26/2.0;
    _seeLabel.layer.masksToBounds = YES;
    _seeLabel.layer.borderColor = HEXCOLOR(0xFEE100).CGColor;
    _seeLabel.layer.borderWidth = 1;
    _seeLabel.numberOfLines = 2;
    [_seeLabel setHidden:YES];
}

- (void)setCellDataModel:(JHGoodsExtModel*)model
{
    if(!model)
    {
        DDLogInfo(@"%@------model is nil!!!", NSStringFromClass([self class]));
        return;
    }
    [_ctxImage jhSetImageWithURL:[NSURL URLWithString:model.goodsUrl ? : @""] placeholder:kDefaultCoverImage];////网络图片
    
    _idLabel.text = [NSString stringWithFormat:@"编号：%@", model.goodsCode?:@""];
    _descpLabel.text = model.goodsTitle;
    _finalPriceLabel.text = [NSString stringWithFormat:@"%@", model.salePrice?:@""];
    _saleLabel.text = [NSString stringWithFormat:@"第%@次交易", model.dealSequence ? : @"0"];
    
    //需要根据头像个数判断显示!!!!!
    NSInteger count = [model.seekCustomerImgList count];
    [_headerIcon1 setHidden:YES];
    [_headerIcon2 setHidden:YES];
    [_headerIcon3 setHidden:YES];
    [_headerIcon4 setHidden:YES];
    [_seeLabel setHidden:YES];
    if(count > 0)
    {
        if(![NSString isEmpty:model.seekCustomerImgList[0]])
            [_headerIcon1 jhSetImageWithURL:[NSURL URLWithString:model.seekCustomerImgList[0]] placeholder:kDefaultAvatarImage];
        [_headerIcon1 setHidden:NO];
    }
    if(count > 1)
    {
        if(![NSString isEmpty:model.seekCustomerImgList[1]])
            [_headerIcon2 jhSetImageWithURL:[NSURL URLWithString:model.seekCustomerImgList[1]] placeholder:kDefaultAvatarImage];
        [_headerIcon2 setHidden:NO];
    }
    if(count > 2)
    {
        if(![NSString isEmpty:model.seekCustomerImgList[2]])
            [_headerIcon3 jhSetImageWithURL:[NSURL URLWithString:model.seekCustomerImgList[2]] placeholder:kDefaultAvatarImage];
        [_headerIcon3 setHidden:NO];
    }
    if(count > 3)
    {
        if(![NSString isEmpty:model.seekCustomerImgList[3]])
            [_headerIcon4 jhSetImageWithURL:[NSURL URLWithString:model.seekCustomerImgList[3]] placeholder:kDefaultAvatarImage];
        [_headerIcon4 setHidden:NO];
    }
    if(count > 0)
    {
        UIImageView* leftView = nil;
        if(count == 2)
            leftView = _headerIcon2;
        else if(count == 3)
            leftView = _headerIcon3;
        else if(count == 4)
            leftView = _headerIcon4;
        else
            leftView = _headerIcon1;
        _seeLabel.text = [NSString stringWithFormat:@"%@人\n热度", model.seekCount ?:@"0"]; //两行显示
        [_seeLabel setHidden:NO];
        [_seeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(leftView);
          make.left.mas_equalTo(leftView.mas_right).offset(-kIconOffset);
          make.width.height.mas_equalTo(26);
        }];
    }
}

@end
