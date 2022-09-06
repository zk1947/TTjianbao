//
//  JHRecycleOrderDetailToolbarViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-工具条ViewModel

#import <Foundation/Foundation.h>
#import "JHRecycleOrderDetail.h"
#import "JHRecycleOrderDetailModel.h"
#import "JHRecycleOrderToolbarViewModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailToolbarViewModel : NSObject
@property (nonatomic, strong) JHRecycleOrderToolbarViewModel *toolbarViewModel;

@property (nonatomic, strong) RACSubject *clickEvent;

@property (nonatomic, strong) NSArray<NSNumber *> *buttonList;

- (void)setupButtonListWithInfo : (JHRecycleOrderButtonInfo *)buttonInfo;
//
//- (void)didClickWithType : (RecycleOrderButtonType) type;
@end

NS_ASSUME_NONNULL_END
