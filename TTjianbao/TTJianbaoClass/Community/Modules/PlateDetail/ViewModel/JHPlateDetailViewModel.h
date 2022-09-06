//
//  JHPlateDetailViewModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/9/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewModel.h"
#import "JHPlateDetailReqModel.h"
#import "JHPlateDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPlateDetailViewModel : JHBaseViewModel

@property (nonatomic, strong) JHPlateDetailBaseReqModel *reqModel;

@property (nonatomic, strong) JHPlateDetailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
