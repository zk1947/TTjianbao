//
//  JHMallRecommendAdCell.m
//  TTjianbao
//
//  Created by wangjianios on 2020/12/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallRecommendAdCell.h"

@interface JHMallRecommendAdCell ()

@property (nonatomic, weak) UIImageView *coverView;

@end


@implementation JHMallRecommendAdCell

- (void)addSelfSubViews {
    _coverView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_coverView jh_cornerRadius:5];
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setImageUrl:(NSString *)imageUrl {
    
    _imageUrl = imageUrl;
    
    [_coverView jh_setImageWithUrl:_imageUrl];
}

@end
