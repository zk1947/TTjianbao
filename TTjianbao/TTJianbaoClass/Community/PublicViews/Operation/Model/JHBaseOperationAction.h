//
//  JHBaseOperationAction.h
//  TTjianbao
//
//  Created by jiangchao on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHBaseOperationModel.h"
#import "JHSQModel.h"
#import "JHShareInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBaseOperationAction : NSObject
 
+(void)operationAction:(JHOperationType)operationType operationMode:(JHPostData*)mode bolck:(JHFinishBlock)result;

/// 分享操作：webpage
/// @param type type description
/// @param shareInfo shareInfo description
+ (void)toShare:(JHOperationType)type operationShareInfo:(JHShareInfo*)shareInfo object_flag:(id)object_flag;
/// 分享操作：image
+ (void)toShareImage:(JHOperationType)type shareInfo:(JHShareInfo*)shareInfo;
/// 分享文本
+ (void)toShareText :(JHOperationType)type shareInfo: (JHShareInfo*)shareInfo;
@end

NS_ASSUME_NONNULL_END
