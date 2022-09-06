//
//  ExpressMode.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ExpressMode : NSObject
@property (strong,nonatomic)NSString * expressName;
@property (strong,nonatomic)NSString* expressNo;
@property (strong,nonatomic)NSString* expressState;
@property (strong,nonatomic)NSArray *  express;
@end

@interface ExpressRecord : NSObject
@property (copy, nonatomic)NSString *context;
@property (copy, nonatomic)NSString *ftime;
@property (copy, nonatomic)NSString *time;
@end

@interface ExpressVo : NSObject
@property (copy, nonatomic)NSString *com;//公司
@property (copy, nonatomic)NSString *nu;//订单号
@property (copy, nonatomic)NSString *state;
@property (copy, nonatomic)NSString *status;
@property (copy, nonatomic)NSArray<ExpressRecord*> *data;
@end


@interface ExpressAppraiseMode : NSObject
@property (copy, nonatomic)NSString *com;
@property (copy, nonatomic)NSString *opName;
@property (copy, nonatomic)NSString *shipperName;
@property (copy, nonatomic)NSString *expressNumber;
@property (copy, nonatomic)NSString *opCodeDesc;
@property (copy, nonatomic)NSString *operTime;
@end


@interface orderStatusLogVosModel  :  NSObject

@property (copy, nonatomic)NSString *createTime;
@property (copy, nonatomic)NSString *orderStatus;
@property (copy, nonatomic)NSString *orderStatusDesc;

@end

@interface ExpressOrderStatusModel : NSObject
@property (strong, nonatomic)NSArray<orderStatusLogVosModel*> *orderStatusLogVos;
@end





