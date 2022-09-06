//
//  JHRecycleCategoryCollectionViewCell.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/4/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleCategoryCollectionViewCell : UICollectionViewCell
//数据绑定
- (void)bindViewModel:(id)dataModel indexRow:(NSInteger)indexRow;

@end

NS_ASSUME_NONNULL_END
