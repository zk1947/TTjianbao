//
//  JHMessageCenterData.h
//  TTjianbao
//  Description:消息中心-数据管理
//  Created by Jesse on 2020/2/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHMsgCenterModel.h"
#import "JHSessionListManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMessageCenterData : NSObject

@property (nonatomic, strong) JHSessionListManager *sessionManager;
@property (nonatomic, assign) NSInteger kefuNoticeCount; //消息改多个分类后,消息中心基本用不到了
@property (nonatomic, strong) NSMutableArray *dataArray;//普通分类数据
@property (nonatomic, strong) NSMutableArray *mainDataArray;//重要分类数据
@property (nonatomic, strong) JHMsgCenterUnreadModel *unReadModel;
@property (nonatomic, strong) RACReplaySubject *reloadDataSubject;

//v启动时调用,同步聚合消息。暂时不用了
+ (void)requestSyncMessage;
//未读数字,客户未读需要单独获取
+ (void)requestUnreadMessage:(JHActionBlocks)finish;
- (void)requestData:(JHActionBlocks)finish;
- (void)removeCategeryByType:(NSString*)type finish:(JHActionBlock)finish; //根据type删除分类
- (void)removeDataFromModel:(JHMsgCenterModel*)model; //删除数据
- (void)reloadKefuData;
- (void)checkShowPopupView:(JHActionBlock)active;
- (void)setUnreadModelWithModel:(JHMsgCenterModel*)model;
@end

NS_ASSUME_NONNULL_END
