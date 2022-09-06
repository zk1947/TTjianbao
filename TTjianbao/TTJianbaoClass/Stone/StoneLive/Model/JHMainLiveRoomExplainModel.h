//
//  JHMainLiveRoomExplainModel.h
//  TTjianbao
//  Description:讲解
//  Created by Jesse on 4/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMainLiveRoomExplainModel : JHReqModel

@property (nonatomic, assign) NSInteger explainingFlag; //讲解操作，0开始讲解，1停止讲解 ,
@property (nonatomic, copy) NSString *stoneRestoreId;//原石回血ID

- (void)asynRequestWithResponse:(JHResponse)response;
@end

NS_ASSUME_NONNULL_END
