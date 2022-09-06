//
//  JHUserInfoEvaluatViewModel.h
//  TTjianbao
//
//  Created by hao on 2021/6/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHUserInfoEvaluatViewModel : NSObject
@property (nonatomic, strong) RACCommand *userInfoEvaluatCommand;
@property (nonatomic, strong) NSMutableArray *evaluatListDataArray;

@property (nonatomic, strong) RACSubject *updateEvaluatListSubject;
@property (nonatomic, strong) RACSubject *moreEvaluatListSubject;
@property (nonatomic, strong) RACSubject *errorRefreshSubject;
@property (nonatomic, strong) RACSubject *noMoreDataSubject;
@end

NS_ASSUME_NONNULL_END
