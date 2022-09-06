//
//  JHDefaultCollectionViewCell.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHDefaultCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *subLabel;

- (void)displaySubLabel;
@end

NS_ASSUME_NONNULL_END
