//
//  JHRichTextCompleteController.h
//  TTjianbao
//
//  Created by wangjianios on 2020/11/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

@class JHPublishTopicDetailModel;
@class JHPlateSelectData;
@class JHSQPublishModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHRichTextCompleteController : JHBaseViewController
/// 已编辑内容
@property (nonatomic, strong) JHSQPublishModel *model;

@property (nonatomic, strong) NSMutableArray * richTextArr;

/** 封面*/
@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, copy) NSString *coverUrl;

/** 板块视图*/
@property (nonatomic, strong) NSMutableArray <JHPublishTopicDetailModel *> *topicArray;
/** 点击返回后的回调*/
@property (nonatomic, copy) void(^backActionBlock)(JHSQPublishModel *model,  UIImage *_Nullable coverImage, NSMutableArray *topicArray);

/// 二次编辑
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, copy) NSString *pageFrom;

@end

NS_ASSUME_NONNULL_END
