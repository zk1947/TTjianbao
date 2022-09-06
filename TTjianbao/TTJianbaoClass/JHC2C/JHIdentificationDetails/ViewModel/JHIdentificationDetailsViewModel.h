//
//  JHIdentificationDetailsViewModel.h
//  TTjianbao
//
//  Created by miao on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHIdentificationDetailsModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHIdentificationDetailsViewModel : NSObject

/// 网络请求
@property (nonatomic, strong) RACCommand *identDetailsCommand;

/// 请求结果
@property (nonatomic, strong) RACSubject<JHIdentificationDetailsModel *> *identDetailsSubject;

/// 数据源
@property (nonatomic, strong) JHIdentificationDetailsModel *identetailsModel;

@end

NS_ASSUME_NONNULL_END
