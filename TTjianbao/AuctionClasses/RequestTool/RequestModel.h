//
//  RequestModel.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/15.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestModel : NSObject
@property(nonatomic, copy)NSString *message;
@property(nonatomic, copy)NSString *msg;
@property(nonatomic, assign)NSInteger code;
@property(nonatomic, strong)id data;

@end


@interface SignModel: NSObject

@property(nonatomic, strong) NSString *locality_Time;
@property(nonatomic, strong) NSString *encryption_Sign;
@property(nonatomic, strong) NSString *nonceStr;
@end
