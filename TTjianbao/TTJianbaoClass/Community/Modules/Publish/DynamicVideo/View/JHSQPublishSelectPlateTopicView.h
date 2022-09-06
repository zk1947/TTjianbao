//
//  JHSQPublishSelectPlateTopicView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/11/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHPublishTopicDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHSQPublishSelectPlateTopicView : UIView

@property (nonatomic, copy) NSString *plateName;
///是否在编辑状态
@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, copy) NSArray <JHPublishTopicDetailModel *> *topicArray;

/// 添加话题
@property (nonatomic, copy) dispatch_block_t addTopicBlock;

/// 添加版块
@property (nonatomic, copy) dispatch_block_t addCatePlateBlock;

/// 删除版块
@property (nonatomic, copy) dispatch_block_t deletePlateBlock;

/// 删除话题
@property (nonatomic, copy) void(^deleteTopicBlock)(NSInteger index);

+ (CGFloat)viewHeight;
@end

NS_ASSUME_NONNULL_END
