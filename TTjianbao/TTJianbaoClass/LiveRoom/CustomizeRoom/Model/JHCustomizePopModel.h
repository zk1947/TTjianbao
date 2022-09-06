//
//  JHCustomizePopModel.h
//  TTjianbao
//
//  Created by apple on 2020/11/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//orderDesc (string, optional): 描述 ,
//orderId (integer, optional): 订单id ,
//orderType (string, optional): 类型描述
@interface JHCustomizePopModel : NSObject
@property (nonatomic, copy) NSString *connectCount;  //连麦数量
@property (nonatomic, copy) NSString *goodsTitle;
@property (nonatomic, copy) NSString *goodsUrl;
@property (nonatomic, copy) NSString *orderCategory;  //订单品类
@property (nonatomic, copy) NSString *orderDesc;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, assign) BOOL connectFlag;//否可以连麦  0否，1是

@end

NS_ASSUME_NONNULL_END
