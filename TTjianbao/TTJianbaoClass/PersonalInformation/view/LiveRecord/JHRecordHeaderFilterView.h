//
//  JHRecordHeaderFilterView.h
//  TTjianbao
//
//  Created by lihui on 2021/3/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHRecordFilterModel;
@class JHRecordFilterMenuModel;

typedef NS_ENUM(NSInteger, JHFilterType) {
    JHFilterTypeAssessment = 0,
    JHFilterTypeRecommend,
    JHFilterTypeTimeRange,
    JHFilterTypeRemark,
};

@interface JHRecordHeaderFilterView : UIView
+ (CGFloat)viewHeight;
- (instancetype)initWithFrame:(CGRect)frame filterCount:(NSInteger)filterCount;
@property (nonatomic, copy) NSArray <JHRecordFilterModel *>*filterModels;
@property (nonatomic, copy) void(^selectBlock)(JHRecordFilterMenuModel *tagModel,JHFilterType filterType);
@end

NS_ASSUME_NONNULL_END
