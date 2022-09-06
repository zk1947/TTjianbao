//
//  JHAllowanceListViewModel.h
//  TTjianbao
//
//  Created by apple on 2020/2/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewModel.h"
#import "JHAllowanceTotalModel.h"
@class JHAllowanceListModel;
NS_ASSUME_NONNULL_BEGIN
/// 津贴 vm
@interface JHAllowanceListViewModel : JHBaseViewModel

/// type: 0 全部，1 获取，2 支出;
@property (nonatomic, assign) NSInteger type;

+(void)requestAllowanceTotalBlock:(void(^)(JHAllowanceTotalModel *model))block;

///获取活动内容
+ (void)requestActivityBlock:(void(^)(NSString *imgUrl,NSString *webUrl))block;

@end

NS_ASSUME_NONNULL_END
