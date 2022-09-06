//
//  JHOnlineTopicHeader.h
//  TTjianbao
//
//  Created by lihui on 2021/1/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHOnlineAppraiseModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHOnlineTopicHeader : UICollectionReusableView
@property (nonatomic, copy) NSArray <JHOnlineAppraiseModel *>*topicInfo;
@end

NS_ASSUME_NONNULL_END
