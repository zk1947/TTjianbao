//
//  JHAccountReqModel.h
//  TTjianbao
//  Description:账户相关请求基类:默认为获取账户信息
//  Created by Jesse on 2019/12/6.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAccountReqModel : JHReqModel

@property (nonatomic, strong) NSString* customerId;
@property (nonatomic, strong) NSString* customerType;

@end

NS_ASSUME_NONNULL_END
