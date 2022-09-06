//
//  JHPlateDetailReqModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/9/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///版块头部信息
@interface JHPlateDetailBaseReqModel : JHRequestModel

@property (nonatomic, copy) NSString *channel_id;

@end

///版块列表信息
@interface JHPlateDetailListReqModel : JHPlateDetailBaseReqModel

/// 1 最新发布(默认) 2  最新回复
@property (nonatomic, assign) NSInteger sort;

@property (nonatomic, copy) NSString *cate_id;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) NSString *last_date;

@end


///版块关注
@interface JHPlateDetailFocusReqModel : JHRequestModel
@property (nonatomic, assign) NSInteger channel_id;
@end

NS_ASSUME_NONNULL_END
