//
//  JHRecommendTopicListView.h
//  TTjianbao
//
//  Created by lihui on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHTopicInfo;

@interface JHRecommendTopicListView : UIView

@property (nonatomic, assign) BOOL showLine;
@property (nonatomic, strong) JHTopicInfo *topicInfo;

@end

NS_ASSUME_NONNULL_END
