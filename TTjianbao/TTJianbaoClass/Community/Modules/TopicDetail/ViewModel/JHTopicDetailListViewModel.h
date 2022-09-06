//
//  JHTopicDetailListViewModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/8/31.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewModel.h"
#import "JHTopicDetailReqModel.h"
#import "JHSQModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHTopicDetailListViewModel : JHBaseViewModel

@property (nonatomic, strong) JHTopicDetailListReqModel *reqModel;

@property (nonatomic, strong) NSMutableArray *playVideoUrls;

///372新增 为视频详情代理方法中请求更多数据提供的方法 ---TODO lihui
- (void)requestMoreData:(HTTPCompleteBlock)completeBlock;

@end

NS_ASSUME_NONNULL_END
