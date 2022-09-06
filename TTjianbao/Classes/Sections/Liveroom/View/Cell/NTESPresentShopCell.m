//
//  NTESPresentShopCell.m
//  TTjianbao
//
//  Created by chris on 16/3/29.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESPresentShopCell.h"
#import "UIView+NTES.h"

@interface NTESPresentShopCell()

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *nameLabel;

@end

@implementation NTESPresentShopCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:13.f];
        self.nameLabel.textColor = HEXCOLOR(0xffffff);
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor blackColor];
        self.selectedBackgroundView = view;
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)refreshPresent:(NTESPresent *)present
{
    UIImage *image = [UIImage imageNamed:present.icon];
    self.imageView.image = image;
    [self.imageView sizeToFit];
    
    self.nameLabel.text = present.name;
    [self.nameLabel sizeToFit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat top = 15.f * ScreenW / 320;
    CGFloat bottom = 5.f * ScreenW / 320;
    self.imageView.top = top;
    self.imageView.centerX = self.width * .5f;
    
    self.nameLabel.bottom  = self.height - bottom;
    self.nameLabel.centerX = self.width * .5f;
}

@end
