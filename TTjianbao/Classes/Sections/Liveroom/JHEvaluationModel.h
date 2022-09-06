//
//  JHEvaluationModel.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/16.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHEvaluationModel : NSObject
@property (nonatomic, copy) NSString *commentContent;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *isPass;
@property (nonatomic, strong) NSArray *commentTagList;

@end
