//
//  JHFansTaskViewModel.h
//  TTjianbao
//
//  Created by jiangchao on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHFansClubModel.h"
#import "JHFansClubBusiness.h"
NS_ASSUME_NONNULL_BEGIN


@interface JHFansTaskViewModel : NSObject

@property (nonatomic, copy) NSString  *fansClubId;

@property (nonatomic, strong) JHFansClubModel *fansClubModel;
/// 刷新tableview
@property (nonatomic, strong) RACReplaySubject *refreshTableView;
/// 获取Task信息
- (void)getFansClubInfo;
@end

NS_ASSUME_NONNULL_END
