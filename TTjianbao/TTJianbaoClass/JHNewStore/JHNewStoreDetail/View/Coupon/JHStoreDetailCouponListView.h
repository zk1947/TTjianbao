//
//  JHStoreDetailCouponListView.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoreDetail.h"
#import "JHStoreDetailCouponListViewModel.h"
#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailCouponListView : UIView
@property (nonatomic, strong) JHStoreDetailCouponListViewModel *viewModel;
@property (nonatomic, strong) RACSubject *dismissSubject;
@end

NS_ASSUME_NONNULL_END
