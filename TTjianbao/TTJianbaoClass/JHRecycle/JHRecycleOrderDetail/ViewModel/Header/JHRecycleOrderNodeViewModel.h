//
//  JHRecycleOrderNodeViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleOrderNodeBaseViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderNodeViewModel : NSObject
@property (nonatomic, strong) NSMutableArray<JHRecycleOrderNodeBaseViewModel *> *itemList;
@property (nonatomic, strong) RACReplaySubject *refreshView;
@end

NS_ASSUME_NONNULL_END
