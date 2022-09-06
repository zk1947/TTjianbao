//
//  JHFansListViewModel.h
//  TTjianbao
//
//  Created by jiangchao on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHFansTaskViewModel.h"
#import "JHFansModel.h"
#import "JHFansClubBusiness.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHFansListViewModel : NSObject
@property (nonatomic, copy) NSString  *anchorId;
@property (nonatomic, strong) NSMutableArray <JHFansModel*>*listArr;
@property (nonatomic, strong) JHFansClubModel*fansClubModel;

@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

/// 获取粉丝列表
- (void)getFansListInfo;
/// 获取粉丝头信息
- (void)getFansHeaderInfo;
/// 刷新tableview
@property (nonatomic, strong) RACReplaySubject *refreshTableView;
@property (nonatomic, strong) RACReplaySubject *refreshHeaderView;

@end

NS_ASSUME_NONNULL_END
