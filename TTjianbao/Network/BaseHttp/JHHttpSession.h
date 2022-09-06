//
//  JHHttpSession.h
//  TTjianbao
//   Description:网络请求
//  Created by Jesse on 2020/8/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHHttpSession : NSObject

///可以自己设置超时,默认20 s
@property (nonatomic, assign) NSTimeInterval sessionTimeoutInterval;

///是否需要网络返回子线程
- (void)setSessionCompleteQueue:(BOOL)isSubQueue;

///get->仅有参数
- (void)getWithModel:(JHReqModel*)request success:(JHSuccess)success failure:(JHFailure)failure;

///post->仅有参数
- (void)postWithModel:(JHReqModel*)request success:(JHSuccess)success failure:(JHFailure)failure  requestSerializerType:(RequestSerializerType)serializerType;

///post->有参数+有上传进度回调的方法
- (void)postWithModel:(JHReqModel*)request success:(JHSuccess)success failure:(JHFailure)failure uploadProgress:(uploadProgressBlock)progressBlock requestSerializerType:(RequestSerializerType)serializerType;

///post->有参数+有加密
- (void)postWithModel:(JHReqModel*)request success:(JHSuccess)success failure:(JHFailure)failure encrypt:(BOOL)isEncrypt requestSerializerType:(RequestSerializerType)serializerType;

///put(放置到服务器固定路径)->有参数
- (void)putWithModel:(JHReqModel*)request success:(JHSuccess)success failure:(JHFailure)failure  requestSerializerType:(RequestSerializerType)serializerType;

///delete(删除服务器资源)->有参数
- (void)deleteWithModel:(JHReqModel*)request success:(JHSuccess)success failure:(JHFailure)failure  requestSerializerType:(RequestSerializerType)serializerType;

@end

