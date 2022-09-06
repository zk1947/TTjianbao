//
//  JHPublishReportCollectionView.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHReportRecommendLabelModel;
@class JHReportCateModel;
@class JHReportCatePropertyModel;

@interface JHPublishReportCollectionView : UIView

@property (nonatomic, strong) NSMutableArray <JHReportRecommendLabelModel *> *recommendArray;

@property (nonatomic, strong) NSMutableArray <JHReportCateModel *> *cateArray;

@property (nonatomic, copy) void (^selectBlock) (NSInteger index);

@property (nonatomic, strong) JHReportCatePropertyModel *catePropertyModel;

@end

NS_ASSUME_NONNULL_END
