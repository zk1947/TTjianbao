//
//  JHNewShopBaseViewModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopBaseViewModel : NSObject
@property (nonatomic, strong) RACSubject *updateShopSubject;
@property (nonatomic, strong) RACSubject *moreShopSubject;
@property (nonatomic, strong) RACSubject *errorRefreshSubject;
@property (nonatomic, strong) RACSubject *noMoreDataSubject;
@end

NS_ASSUME_NONNULL_END
