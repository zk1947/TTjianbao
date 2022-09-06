//
//  JHAddResourceCollectionView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/12/2.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPhotoCollectionView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHAddResourceCollectionView : JHPhotoCollectionView
@property (nonatomic, copy) JHActionBlock deleteBlock;

@property (nonatomic, assign) CGFloat itemSizeWidth;

@end

NS_ASSUME_NONNULL_END
