//
//  TTjianbao
//
//  Created by jiangchao on 2020/6/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"

@class JHDraftBoxModel;
@class JHPublishTopicDetailModel;
@class JHPlateSelectData;
NS_ASSUME_NONNULL_BEGIN

@interface JHRichTextEditViewController : JHBaseViewExtController
@property (nonatomic, strong) JHDraftBoxModel* draftBoxModel;

/// 话题进来
@property (nonatomic, strong) JHPublishTopicDetailModel *topic;
@property (nonatomic, copy) NSString *pageFrom;

/// 板块进来
@property (nonatomic, strong) JHPlateSelectData *plate;

///编辑传入的ID
@property (nonatomic, copy) NSString *itemId;

@end

NS_ASSUME_NONNULL_END

