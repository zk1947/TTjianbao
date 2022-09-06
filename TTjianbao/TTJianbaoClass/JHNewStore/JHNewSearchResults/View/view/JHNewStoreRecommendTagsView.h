//
//  JHNewStoreRecommendTagsView.h
//  TTjianbao
//
//  Created by hao on 2021/10/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
// 推荐标签

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JHNewStoreRecommendTagsViewDelegate <NSObject>
- (void)didSelectItemOfIndex:(NSInteger )selectItem;

@end

@interface JHNewStoreRecommendTagsView : UIView
@property (nonatomic, weak) id<JHNewStoreRecommendTagsViewDelegate> recommendDelegate;
@property (nonatomic, copy) NSArray *tagsDataArray;

@end

NS_ASSUME_NONNULL_END
