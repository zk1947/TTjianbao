//
//  JHIdentyPhotoInfoCollectionViewCell.h
//  TTjianbao
//
//  Created by lihui on 2020/4/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHUnionPayUserPhotoModel;

static NSString *kPhotoCollectionIdentifer = @"JHIdentyPhotoInfoCollectionViewCellIdentifer";

@interface JHIdentyPhotoInfoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) JHUnionPayUserPhotoModel *photoModel;


@end

NS_ASSUME_NONNULL_END
