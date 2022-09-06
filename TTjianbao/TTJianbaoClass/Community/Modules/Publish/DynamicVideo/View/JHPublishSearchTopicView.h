//
//  JHPublishSearchTopicView.h
//  TTjianbao
//  Description:搜索话题View(选择话题->search)
//  Created by jesee on 17/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPublishSearchTopicView : UIView

@property (nonatomic, copy) JHActionBlock searchTopicBlock;

//显示加载数据
- (void)updateData:(NSArray*)array;
@end

NS_ASSUME_NONNULL_END
