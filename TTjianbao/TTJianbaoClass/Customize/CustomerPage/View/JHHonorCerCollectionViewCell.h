//
//  JHHonorCerCollectionViewCell.h
//  TTjianbao
//
//  Created by user on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHHonorCerCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *watermarkImageView;
- (void)setViewModel:(id)viewModel;
@end

NS_ASSUME_NONNULL_END
