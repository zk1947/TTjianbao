//
//  JHJHMallGroupListViewModel.h
//  TTjianbao
//
//  Created by apple on 2020/3/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMallGroupListViewModel : JHBaseViewModel

@property (nonatomic, copy) NSArray *groupIdArray;

@property (nonatomic, copy) NSString *groupIdListStr;

@property (nonatomic, assign) BOOL isShowBigImage;

+(void)requestListWithParameters:(NSDictionary *)parameters block:(void(^)(BOOL success,NSArray *data))block;

@end

NS_ASSUME_NONNULL_END
