//
//  JHBoxViewCell.h
//  TaodangpuAuction
//
//  Created by yuyue_mp1517 on 2020/8/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"
@class JHHotListModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^HeadScrollBlock)(BOOL isUp);

@interface JHBoxViewCell : JHBaseCollectionViewCell

@property (nonatomic, copy) HeadScrollBlock headScrollBlock;

@property (nonatomic, assign) BOOL isRefresh;

- (void)updateWithModel:(JHHotListModel *)model;

///页面消失（曝光买点）
- (void)viewDidDisappearMethod;

@end

NS_ASSUME_NONNULL_END
