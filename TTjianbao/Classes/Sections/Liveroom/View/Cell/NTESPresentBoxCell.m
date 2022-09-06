//
//  NTESPresentBoxCell.m
//  TTjianbao
//
//  Created by chris on 16/3/31.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESPresentBoxCell.h"
#import "UIView+NTES.h"
#import "M80AttributedLabel.h"

@interface NTESPresentBoxCell()

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) M80AttributedLabel *nameLabel;

@end

@implementation NTESPresentBoxCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        self.nameLabel = [[M80AttributedLabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:13.f];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor blackColor];
        self.selectedBackgroundView = view;
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)refreshPresent:(NTESPresent *)present
                 count:(NSInteger)count
{
    UIImage *image = [UIImage imageNamed:present.icon];
    self.imageView.image = image;
    [self.imageView sizeToFit];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    
    [attr appendAttributedString:
     [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ x ",present.name]
                                                attributes:@{NSFontAttributeName:self.nameLabel.font,
                                                             NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    [attr appendAttributedString:
     [[NSAttributedString alloc] initWithString:@(count).stringValue
                                     attributes:@{NSFontAttributeName:self.nameLabel.font,
                                                  NSForegroundColorAttributeName:HEXCOLOR(0xffff66)}]];
    [self.nameLabel setAttributedText:attr];
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
