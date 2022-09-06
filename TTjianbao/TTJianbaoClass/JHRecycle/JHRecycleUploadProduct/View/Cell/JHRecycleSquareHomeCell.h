//
//  JHRecycleSquareHomeCell.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHRecycleSquareHomeListModel;

@interface JHRecycleSquareHomeCell : UICollectionViewCell

- (void)refreshWithHomeSquareModel:(JHRecycleSquareHomeListModel*)model;

- (void)setHasRead;
@end

NS_ASSUME_NONNULL_END
