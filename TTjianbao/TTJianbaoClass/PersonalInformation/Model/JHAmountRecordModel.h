//
//  JHAmountRecordModel.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/29.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHAmountRecordModel : NSObject
@property (nonatomic, strong) NSString *changeAmount;// (number, optional): 变动量 ,
@property (nonatomic, strong) NSString *changeType;// (string, optional): 变动类型 ,
@property (nonatomic, strong) NSString *createDate;// (string, optional): 发生时间 ,
@property (nonatomic, strong) NSString *describe;// (string, optional): 描述 ,
@property (nonatomic, strong) NSString *name;// (string, optional): 名称

@property (nonatomic, strong) NSString *status;
@end

NS_ASSUME_NONNULL_END
