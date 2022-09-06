//
//  JHTopicDetailReqModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/8/31.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

///话题头部信息
@interface JHTopicDetailBaseReqModel : JHRequestModel

@property (nonatomic, copy) NSString *topic_id;

@end

///话题列表信息
@interface JHTopicDetailListReqModel : JHTopicDetailBaseReqModel

/// 1 最新发布(默认) 2  最新回复
@property (nonatomic, assign) NSInteger sort;

@property (nonatomic, copy) NSString *cate_id;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) NSString *last_date;


@end


NS_ASSUME_NONNULL_END
