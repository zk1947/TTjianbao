//
//  JHPlateDetailListViewModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/9/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewModel.h"
#import "JHPlateDetailReqModel.h"
#import "JHSQModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPlateDetailListViewModel : JHBaseViewModel

@property (nonatomic, strong) JHPlateDetailListReqModel *reqModel;
@property (nonatomic, strong) NSMutableArray *playVideoUrls;

@end

NS_ASSUME_NONNULL_END
