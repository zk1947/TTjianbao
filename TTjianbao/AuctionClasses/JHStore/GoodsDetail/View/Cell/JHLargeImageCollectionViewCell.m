//
//  JHLargeImageCollectionViewCell.m
//  TTjianbao
//
//  Created by lihui on 2020/3/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//


#import "JHLargeImageCollectionViewCell.h"
#import "CGoodsDetailModel.h"
#import "UIImageView+JHWebImage.h"

@interface JHLargeImageCollectionViewCell ()

@property (nonatomic,strong) UIImageView *largeImageView;

@end



@implementation JHLargeImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initViews];
    }
    return self;
}

- (void)setGoodsInfo:(CGoodsInfo *)goodsInfo {
    if (!goodsInfo) {
        return;
    }
    _goodsInfo = goodsInfo;
    [_largeImageView jhSetImageWithURL:[NSURL URLWithString:_goodsInfo.safeHeadImgInfo.url]];
}

- (void)initViews {
    if (!_largeImageView) {
        _largeImageView = [[UIImageView alloc] init];
        _largeImageView.image = [UIImage imageNamed:@""];
        _largeImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_largeImageView];
        [_largeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
}

@end
