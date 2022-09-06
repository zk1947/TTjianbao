//
//  JHAnniversaryViewModel.h
//  TTjianbao
//
//  Created by apple on 2020/3/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BannerMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAnniversaryViewModel : NSObject

+(void)requestOrderBannerViewBlock:(void(^)(BOOL isSuccess,  NSArray<BannerCustomerModel*> * _Nullable modelArray))bannerBlock;

@end

NS_ASSUME_NONNULL_END
