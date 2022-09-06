//
//  JHCollectionCell.m
//  TTjianbao
//
//  Created by jesee on 15/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCollectionCell.h"
#import "UIImageView+JHWebImage.h"

#define kImageBigSize 111

@implementation JHCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.bgView = [UIView new];
        self.bgView.layer.masksToBounds = YES;
        self.bgView.userInteractionEnabled = NO;
        [self.contentView addSubview:self.bgView];
        //image
        self.imageView = [UIImageView new];
        [self.bgView addSubview:self.imageView];
    }
    return self;
}

- (void)drawSubviews
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kImageBigSize, kImageBigSize));
    }];
    self.bgView.backgroundColor = HEXCOLOR(0xFFFFFF);
    self. bgView.layer.cornerRadius = 8.0;
    //image
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 8.0;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
}

#pragma mark - data
- (void)updateCellImage:(NSString*)image
{
    [self.imageView jhSetImageWithURL:[NSURL URLWithString:image ? : @""] placeholder:[UIImage imageNamed:@"cover_default_image"]];
}
//基类没有text,需重写
- (void)updateCellImage:(NSString*)image text:(NSString*)text
{
    [self updateCellImage:image];
}

@end
