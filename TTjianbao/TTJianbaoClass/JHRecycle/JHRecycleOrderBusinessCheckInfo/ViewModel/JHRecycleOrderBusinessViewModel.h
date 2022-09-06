//
//  JHRecycleOrderBusinessViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleOrderBusinessSectionViewModel.h"
#import "JHRecycleOrderBusinessDesViewModel.h"
#import "JHRecycleOrderBusinessVideoViewModel.h"
#import "JHRecycleOrderBusinessImageViewModel.h"
#import "JHRecycleOrderBusinessCheck.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderBusinessViewModel : NSObject
@property (nonatomic, strong) JHRecycleOrderBusinessSectionViewModel *sectionViewModel;
/// 订单ID
@property (nonatomic, copy) NSString *orderId;
/// toast
@property (nonatomic, copy) NSString *toastMsg;
/// 刷新tableview
@property (nonatomic, strong) RACSubject *refreshTableView;
/// 加载完成
@property (nonatomic, strong) RACSubject *endRefreshing;

@property (nonatomic, strong) NSMutableArray *mediumList;
@property (nonatomic, strong) NSMutableArray *bigList;
@property (nonatomic, strong) NSMutableArray *originList;

- (void)getBusinessInfo;
@end

NS_ASSUME_NONNULL_END
