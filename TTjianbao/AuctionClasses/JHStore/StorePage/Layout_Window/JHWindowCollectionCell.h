//
//  JHWindowCollectionCell.h
//  TTjianbao
//
//  Created by lihui on 2020/3/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHStoreHomeShowcaseModel;

static NSString *const kCellId_JHStoreHomeCollectionWindowId = @"JHStoreHomeWindowCollectionIdentifier";


@interface JHWindowCollectionCell : UICollectionViewCell


@property (nonatomic, strong) JHStoreHomeShowcaseModel *showcaseModel;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
