//
//  JHCustomWorksModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomWorksModel : NSObject

/** id*/
@property (nonatomic, copy) NSString *id;
/** 状态*/
@property (nonatomic, copy) NSString *status;
/** 封面*/
@property (nonatomic, copy) NSString *cover;
/** feeName*/
@property (nonatomic, copy) NSString *feeName;
/** 定制师名*/
@property (nonatomic, copy) NSString *anchorName;
/** customerId*/
@property (nonatomic, copy) NSString *customerId;
/** customizeOrderId*/
@property (nonatomic, copy) NSString *customizeOrderId;
@end

NS_ASSUME_NONNULL_END
