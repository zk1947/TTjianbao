//
//  JHQueryAnnounceContentModel.h
//  TTjianbao
//  Description:根据公告id查询富文本内容
//  Created by Jesse on 2020/3/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHQueryAnnounceContentModel : JHRespModel

@end

@interface JHQueryAnnounceContentReqModel : JHReqModel

@property (nonatomic, copy) NSString* announceId;//公告id
@property (nonatomic, assign) NSInteger isAppendHtml;//是否拼接html，0 否(默认) 1 拼接
@end

NS_ASSUME_NONNULL_END

