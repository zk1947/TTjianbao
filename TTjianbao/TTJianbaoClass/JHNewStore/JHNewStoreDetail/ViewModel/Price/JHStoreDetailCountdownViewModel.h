//
//  JHJHStoreDetailCountdownViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 倒计时

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailCountdownViewModel : NSObject

@property (nonatomic, copy) NSString *titleText;
/// 时间
@property (nonatomic, assign) NSUInteger timeStamp;
@end

NS_ASSUME_NONNULL_END
