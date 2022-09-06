//
//  JHKeyTypeCollectionViewCell.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHKeyTypeCollectionViewCell : UICollectionViewCell
//数据绑定
- (void)bindViewModel:(id)dataModel indexRow:(NSInteger)indexRow;
@end

NS_ASSUME_NONNULL_END
