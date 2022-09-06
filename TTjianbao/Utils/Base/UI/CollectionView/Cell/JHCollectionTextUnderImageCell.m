//
//  JHCollectionTextUnderImageCell.m
//  TTjianbao
//
//  Created by jesee on 18/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCollectionTextUnderImageCell.h"

#define kMarginWidth 5
#define kMarginHeight 3
#define kImageSmallSize 50
#define kImageTextSpace 5
#define kTextHeight 17

@interface JHCollectionTextUnderImageCell ()

@property (nonatomic, strong) UILabel* titleLabel;
@end

@implementation JHCollectionTextUnderImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        //text
        self.titleLabel = [UILabel new];
        self.titleLabel.font = JHMediumFont(12);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleLabel setTextColor:HEXCOLOR(0x333333)];
        [self.bgView addSubview:self.titleLabel];
    }
    return self;
}

- (void)drawSubviews
{
    self.bgView.backgroundColor = [UIColor clearColor];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.mas_equalTo(kTextUnderImageCellWidth);
        make.height.mas_equalTo(kTextUnderImageCellHeight);
    }];
   
    //image
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 8.0;
    [self.imageView setImage:[UIImage imageNamed:@"cover_default_image"]];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(kTextUnderImageCellOffset);//kLineSpace此间距在这里体现
        make.size.mas_offset(kImageSmallSize);
    }];
    
    //text
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(kImageTextSpace);
        make.centerX.equalTo(self.imageView);
        make.bottom.equalTo(self.bgView).offset(0);
    }];
}

#pragma mark - data
- (void)updateCellImage:(NSString*)image text:(NSString*)text
{
    [super updateCellImage:image];
    self.titleLabel.text = text;
}

@end
