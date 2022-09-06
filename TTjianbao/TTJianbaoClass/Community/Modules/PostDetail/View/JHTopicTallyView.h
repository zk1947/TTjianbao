//
//  JHTopicTallyView.h
//  TTjianbao
//
//  Created by lihui on 2020/8/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *kTallyCellIdentifer = @"kJHTopicTallyViewIdentifer";

@class JHTopicInfo;

@interface JHTopicTallyView : UIView

///话题标签数组
@property (nonatomic, copy) NSArray <JHTopicInfo *>*topicInfos;
@property (nonatomic, assign) JHPageType pageType;

@end

NS_ASSUME_NONNULL_END
