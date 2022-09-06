//
//  JHRecycleOrderToolbarViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleOrderDetail.h"
#import "JHRecycleOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderButtonModel : NSObject
@property (nonatomic, assign) RecycleOrderButtonType type;
@property (nonatomic, assign) CGFloat width;
@end


@interface JHRecycleOrderToolbarViewModel : NSObject

@property (nonatomic, strong) RACSubject *clickEvent;

@property (nonatomic, strong) NSArray<NSNumber *> *buttonList;

- (void)setupButtonListWithInfo : (JHRecycleOrderButtonInfo *)buttonInfo;

- (void)didClickWithType : (RecycleOrderButtonType) type;
@end

NS_ASSUME_NONNULL_END
