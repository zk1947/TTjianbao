//
//  JHGoodsReqModel.h
//  TTjianbao
//  Description:跟商品相关~请求基类字段
//  Created by Jesse on 2019/12/3.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodsReqModel : JHRequestModel

@property (nonatomic, copy) NSString* channelId;
@property (nonatomic, strong) NSString* keyword;

@end

NS_ASSUME_NONNULL_END
