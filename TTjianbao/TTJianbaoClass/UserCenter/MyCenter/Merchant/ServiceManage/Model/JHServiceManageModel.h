//
//  JHServiceManageModel.h
//  TTjianbao
//
//  Created by zk on 2021/7/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHServiceManageModel : NSObject

@property (nonatomic, copy) NSString *auditStatus;//如果有申请快捷回复，最后的审核状态 0待审核 1审核通过 2审核拒绝

@property (nonatomic, assign) BOOL haveQuickReply;//是否有申请快捷回复 true有 false没有

@property (nonatomic, copy) NSString *rejectReason;//如果有申请快捷回复，并且审核状态为2（2审核拒绝）的拒绝原因

@property (nonatomic, copy) NSString *shopId;//店铺ID

@property (nonatomic, strong) NSArray *termsList;//回复集合

@end

@interface JHServiceManageItemModel : NSObject

@property (nonatomic, copy) NSString *defaultTermsId;//默认回复ID

@property (nonatomic, copy) NSString *quickReplyTerms;//默认回复语KEY

@property (nonatomic, copy) NSString *defaultReply;//默认回复语VALUE

@property (nonatomic, copy) NSString *status;//是否勾选 0未勾选 1勾选

@end

NS_ASSUME_NONNULL_END
