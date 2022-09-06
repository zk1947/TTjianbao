//
//  JHGoodsCollecitonCell.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsCollecitonCell.h"
#import "UIImageView+JHWebImage.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "JHGoodsInfoMode.h"

#define imageTitleSpace  7
#define space  8

@interface JHGoodsCollecitonCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation JHGoodsCollecitonCell

- (void)setGoodsInfo:(JHGoodsInfoMode *)goodsInfo {
    _goodsInfo = goodsInfo;
    if (!_goodsInfo) {
        return;
    }
    [_goodsImageView jhSetImageWithURL:[NSURL URLWithString:_goodsInfo.coverImage.url] placeholder:[UIImage imageNamed:@"cover_default_list"]];
    _titleLabel.text = _goodsInfo.name;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 4.f;
        self.layer.masksToBounds = YES;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    _goodsImageView = [[UIImageView alloc] init];
    _goodsImageView.backgroundColor = HEXCOLOR(0xF8F8F8);
    _goodsImageView.image = [UIImage imageNamed:@"cover_default_list"];
    [self.contentView addSubview:_goodsImageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"";
    _titleLabel.font = [UIFont fontWithName:kFontMedium size:12];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    _goodsImageView.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightEqualToWidth();
    
    _titleLabel.sd_layout
    .topSpaceToView(_goodsImageView, imageTitleSpace)
    .leftEqualToView(_goodsImageView)
    .rightEqualToView(_goodsImageView)
    .bottomSpaceToView(self.contentView, space);
    
}



@end
