//
//  JHTopicDetailViewModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/8/31.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewModel.h"
#import "JHTopicDetailReqModel.h"
#import "JHTopicDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHTopicDetailViewModel : JHBaseViewModel

@property (nonatomic, strong) JHTopicDetailBaseReqModel *reqModel;

@property (nonatomic, strong) JHTopicDetailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
