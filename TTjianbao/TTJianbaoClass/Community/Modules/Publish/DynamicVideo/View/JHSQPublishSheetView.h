//
//  JHSQPublishSheetView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/6/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBottomAnimationView.h"
#import "JHPublishTopicDetailModel.h"
#import "JHPlateSelectModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHSQPublishSheetView : JHBottomAnimationView

/// 0-底导航  1-话题   2-板块
@property (nonatomic, assign) NSInteger type;

/// 0-底导航  1-话题   2-板块
+ (void)showPublishSheetViewWithType:(NSInteger)type
                               topic:(JHPublishTopicDetailModel * _Nullable)topic
                               plate:(JHPlateSelectData * _Nullable)plate
                        addSuperView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
