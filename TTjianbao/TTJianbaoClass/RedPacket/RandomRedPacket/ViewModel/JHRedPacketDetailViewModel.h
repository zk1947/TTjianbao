//
//  JHRedPacketDetailViewModel.h
//  TTjianbao
//
//  Created by apple on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewModel.h"
#import "JHGetRedpacketModel.h"
NS_ASSUME_NONNULL_BEGIN
/// 红包详情 vm
@interface JHRedPacketDetailViewModel : JHBaseViewModel

@property (nonatomic, copy) NSString *redPacketId;

@property (nonatomic, strong) JHGetRedpacketModel *dataSources;

+(void)openRedPacketWithRedPacketId:(NSString *)redPacketId CompleteBlock:(void(^)(BOOL isSuccess, JHGetRedpacketModel *data,NSString *errorMsg))completeBlock;

@end

NS_ASSUME_NONNULL_END
