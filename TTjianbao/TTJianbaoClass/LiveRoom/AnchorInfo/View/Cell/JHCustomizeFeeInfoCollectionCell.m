//
//  JHCustomizeFeeInfoCollectionCell.m
//  TTjianbao
//
//  Created by Jesse on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeFeeInfoCollectionCell.h"
#import "JHLiveRoomIntroduceModel.h"
#import "TTjianbaoMarcoUI.h"
#import "NSString+Common.h"
#import "UIImageView+JHWebImage.h"

@interface JHCustomizeFeeInfoCollectionCell ()
{
    UIImageView * imgView;
    UILabel* nameLabel;
    UILabel* priceLabel;
}

@end

@implementation JHCustomizeFeeInfoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self drawSubviews];
    }
    return self;
}

- (void)drawSubviews
{
    //header - 头像
    imgView = [[UIImageView alloc] init];
    [imgView setImage:kDefaultCoverImage];
    imgView.layer.cornerRadius = 8;
    imgView.layer.masksToBounds = YES;
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(40);
    }];
    
    nameLabel = [[UILabel alloc]init];
    nameLabel.font = JHFont(14);
    nameLabel.textColor = HEXCOLOR(0x333333);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(10);
        make.top.equalTo(imgView).offset(0);
        make.height.mas_equalTo(18);
    }];
    
    priceLabel = [[UILabel alloc] init];
    priceLabel.font = JHFont(11);
    priceLabel.textColor = HEXCOLOR(0x666666);
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel).offset(0);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2.0-80, 18));
    }];
}

#pragma mark - update data
- (void)updateData:(JHLiveRoomFeeInfoModel *)model {
    if ([model.img length] > 0) {
        [imgView jhSetImageWithURL:[NSURL URLWithString:model.img] placeholder:kDefaultCoverImage];
    }
    nameLabel.text = model.name;
    if (![NSString isEmpty:model.minPrice] && ![NSString isEmpty:model.maxPrice]) {
        priceLabel.text = [NSString stringWithFormat:@"￥%@-%@", model.minPrice, model.maxPrice];
    }
}

@end
