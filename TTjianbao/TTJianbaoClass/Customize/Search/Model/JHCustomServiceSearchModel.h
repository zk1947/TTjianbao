//
//  JHCustomServiceSearchModel.h
//  TTjianbao
//  Description:定制服务-搜索结果请求
//  Created by Jesse on 2020/9/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomServiceSearchModel : JHReqModel

@property (nonatomic, assign) NSUInteger pageNo;  //页码
@property (nonatomic, assign) NSUInteger pageSize;  //每页大小
@property (nonatomic, copy) NSString* anchorName;  //定制师名称
@end

NS_ASSUME_NONNULL_END
