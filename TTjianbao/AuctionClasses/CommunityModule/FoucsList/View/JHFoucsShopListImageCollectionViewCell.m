//
//  JHFoucsShopListImageCollectionViewCell.m
//  TTjianbao
//
//  Created by apple on 2020/2/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHFoucsShopListImageCollectionViewCell.h"

@implementation JHFoucsShopListImageCollectionViewCell

-(void)addSelfSubViews
{
    _goodsView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.equalTo(self.contentView.mas_width);
    }];
    
    _goodsNameLabel = [UILabel jh_labelWithFont:12 textColor:RGB(51, 51, 51) addToSuperView:self.contentView];
    _goodsNameLabel.numberOfLines = 2;
    [_goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.goodsView.mas_bottom).offset(6);
    }];
}

@end
