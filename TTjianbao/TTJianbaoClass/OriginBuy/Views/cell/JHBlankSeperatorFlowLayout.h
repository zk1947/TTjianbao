//
//  JHBlankSeperatorFlowLayout.h
//  TTjianbao
//
//  Created by lihui on 2020/8/6.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///用于去除collectionView多余分割线

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBlankSeperatorFlowLayout : UICollectionViewFlowLayout

///一行展示cell的个数
@property (nonatomic, assign) NSInteger itemCount;

@end

NS_ASSUME_NONNULL_END
