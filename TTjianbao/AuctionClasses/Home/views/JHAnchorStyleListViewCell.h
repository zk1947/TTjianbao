//
//  JHAnchorStyleListViewCell.h
//  TTjianbao
//
//  Created by Donto on 2020/7/6.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecommendAppraiserListItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHAnchorStyleListViewCellDelegate <NSObject>

- (void)followAnchor:(JHRecommendAppraiserListItem *)model;
- (void)applyAnchor:(JHRecommendAppraiserListItem *)model;

@end

@interface JHAnchorStyleListViewCell : UICollectionViewCell

@property (nonatomic, strong) JHRecommendAppraiserListItem *model;
@property (nonatomic, weak) id<JHAnchorStyleListViewCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
