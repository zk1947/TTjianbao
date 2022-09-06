//
//  JHChatOrderViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHChatOrderInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHChatOrderViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<JHChatOrderInfoModel *> *dataSource;
@property (nonatomic, strong) RACSubject *endRefreshing;
@property (nonatomic, strong) RACReplaySubject *reloadData;
@property (nonatomic, strong) RACSubject<NSString *> *toast;
- (instancetype)initWithAccount : (NSString *)account receiveAccount : (NSString *)receiveAccount;

- (void)loadNewData;
- (void)loadNextPageData;
@end

NS_ASSUME_NONNULL_END
