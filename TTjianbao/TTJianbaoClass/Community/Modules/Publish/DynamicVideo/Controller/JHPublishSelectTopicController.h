//
//  JHPublishSelectTopicController.h
//  TTjianbao
//  Description:选择话题
//  Created by jesee on 17/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHPublishTopicDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHPublishSelectTopicController : JHBaseViewController

@property (nonatomic, copy) void(^selectDataBlock)(NSArray <JHPublishTopicDetailModel *> *sender);

//选中话题传值
- (void)prepareSelectedTopicArray:(NSArray*)selectedArray;
@end

NS_ASSUME_NONNULL_END
