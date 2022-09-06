//
//  JHMessageCenterData.m
//  TTjianbao
//  Description:消息中心数据管理
//  Created by Jesse on 2020/2/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessageCenterData.h"
#import "JHMsgCenterModel.h"
#import "JHQYChatManage.h"
#import "CommHelp.h"


#define kCheckPopupTimeStamp @"kCheckMessagePopupTimeStamp"

@interface JHMessageCenterData ()

@property (nonatomic, strong) NSMutableArray* commonCategoryData;

@end

@implementation JHMessageCenterData

- (instancetype)init
{
    if(self = [super init])
    {
        self.kefuNoticeCount = [JHQYChatManage unreadMessage];
//        [self reloadKefuData];
        [self bindData];
    }
    return self;
}

#pragma mark - request
+ (void)requestSyncMessage
{
//    return;
    JHMsgCenterSyncReqModel* syncReq = [JHMsgCenterSyncReqModel new];
    [JH_REQUEST asynGet:syncReq success:^(JHRespModel* respData) {
        NSLog(@">>success->%zd",respData.code);
    } failure:^(NSString *errorMsg) {
        NSLog(@">>fail->%@", errorMsg);
    }];
}

- (void)requestData:(JHActionBlocks)finish
{
    //未读数字
    JH_WEAK(self)
    [[self class] requestUnreadMessage:^(id obj, id data) {
        JH_STRONG(self)
        self.unReadModel = (JHMsgCenterUnreadModel*)obj;
        finish(self.unReadModel, data);
    }];
    
    JHMsgCenterReqModel* msg = [JHMsgCenterReqModel new];
    [JH_REQUEST asynGet:msg success:^(id respData) {
        JH_STRONG(self)
        NSArray *arr = [JHMsgCenterModel mj_objectArrayWithKeyValuesArray:respData];
        self.mainDataArray = [NSMutableArray array];
        self.commonCategoryData = [NSMutableArray array];
        for (JHMsgCenterModel* model in arr) {
            if(model.isTop == 1)
                [self.mainDataArray addObject:model];
            else
                [self.commonCategoryData addObject:model];
        }
        //按时间倒序
        [self sortDataArray];
        finish(self.dataArray, self.dataArray);
    } failure:^(NSString *errorMsg) {
        JH_STRONG(self)
        finish(([JHRespModel nullMessage]), self.dataArray);
    }];
}

- (void)removeCategeryByType:(NSString*)type finish:(JHActionBlock)finish
{
    JHMsgCenterRemoveReqModel* removeModel = [JHMsgCenterRemoveReqModel new];
    removeModel.msgType = type;
    [JH_REQUEST asynDelete:removeModel success:^(id respData) {
        finish([JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        finish(errorMsg);
    }];
}

//未读数字
+ (void)requestUnreadMessage:(JHActionBlocks)finish
{
    NSInteger sessionUnreadCount = [[JHSessionListManager sharedManager] getAllUnreadCount];
    JHMsgCenterUnreadReqModel* unread = [JHMsgCenterUnreadReqModel new];
    [JH_REQUEST asynGet:unread success:^(id respData) {
        JHMsgCenterUnreadModel* unReadModel = [JHMsgCenterUnreadModel mj_objectWithKeyValues:respData];
        unReadModel.total += sessionUnreadCount;
        finish(unReadModel, ([JHRespModel nullMessage]));
    } failure:^(NSString *errorMsg) {
        finish([JHRespModel nullMessage], [JHRespModel nullMessage]);
    }];
}

- (void)setUnreadModelWithModel:(JHMsgCenterModel*)model
{
    if (model)
    {
        for (JHMsgCenterSubUnreadModel* m in self.unReadModel.typeCounts)
        {
            if(model.type && [m.type isEqualToString:model.type])
            {
                m.count = 0;
                break;
            }
        }
    }
}

- (void)reloadKefuData
{
    [self sortDataArray];
}

- (void)sortDataArray
{
    NSArray* msgArray = [JHQYChatManage getChatSessionList]; //获取消息数组
    NSArray *sessionArr = [self getcenterList];
    NSMutableArray* mergeArray = [NSMutableArray arrayWithArray:self.commonCategoryData]; //其他请求回来数据
    [mergeArray addObjectsFromArray:sessionArr];
    [mergeArray addObjectsFromArray:msgArray];
    
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"updateDate" ascending:NO];//yes升序排列，no,降序排列
    
    NSArray* sortArray = [mergeArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDesc, nil]];
    self.dataArray = [NSMutableArray arrayWithArray:sortArray];
}

- (void)removeDataFromModel:(JHMsgCenterModel*)model
{
    if([self.dataArray containsObject:model])
    {
        [self.dataArray removeObject:model];//保证数据同步
        if([self.commonCategoryData containsObject:model])
          {
              [self.commonCategoryData removeObject:model];
          }
    }
}

#pragma mark - check need or not popup
- (void)checkShowPopupView:(JHActionBlock)active
{
    //1,是否已经开启 2,是否是首次进入 或者 不是首次时,距离上次提示超过两天
    if (![CommHelp isUserNotificationEnable] && [self needShowPopup])
    {
        active(@(YES));
    }
    else
    {
        active(@(NO));
    }
}

- (BOOL)needShowPopup
{
    BOOL ret = NO;
    NSTimeInterval nowTimestamp = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval oldTimestamp = [[NSUserDefaults standardUserDefaults] doubleForKey:kCheckPopupTimeStamp];
    NSInteger isHidden = [[NSUserDefaults standardUserDefaults] integerForKey:@"FirstShowMessage"];

    //1,没有存过时间戳,认为是第一次 2,时间差超过两天
    if(!isHidden || oldTimestamp < 1 || nowTimestamp - oldTimestamp > 2*24*60*60)
    {
        ret = YES;
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"FirstShowMessage"];
        [[NSUserDefaults standardUserDefaults] setInteger:nowTimestamp forKey:kCheckPopupTimeStamp];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return ret;
}

#pragma mark - model
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (JHMsgCenterUnreadModel *)unReadModel
{
    if(!_unReadModel)
    {
        _unReadModel = [JHMsgCenterUnreadModel new];
    }
    return _unReadModel;
}


#pragma mark - IM
- (void)bindData {
    @weakify(self)
    [self.sessionManager.reloadDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        [self.reloadDataSubject sendNext:nil];
    }];
    [self.sessionManager.insertDataSubject subscribeNext:^(JHSessionModel * _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        JHMsgCenterModel *model = [self getCenterModel:x];
        [self.dataArray insertObject:model atIndex:0];
        [self.reloadDataSubject sendNext:nil];
    }];
    [self.sessionManager.reloadSessionData subscribeNext:^(JHSessionModel * _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        JHMsgCenterModel *model = [self queryCenterModel:x];
        model.body = x.lastMessage;
        model.total = x.unreadCount;
        model.updateDate = x.dateText;
        [self.dataArray removeObject:model];
        [self.dataArray insertObject:model atIndex:0];
        [self.reloadDataSubject sendNext:nil];
    }];
}
- (JHMsgCenterModel *)getCenterModel : (JHSessionModel *)session {
    JHMsgCenterModel *model = [[JHMsgCenterModel alloc] init];
    model.session = session;
    model.type = @"imSession";
    model.icon = session.iconUrl;
    model.title = session.nikeName;
    model.body = session.lastMessage;
    model.total = session.unreadCount;
    model.updateDate = session.dateText;
    model.receiveAccount = session.receiveAccount;
    return model;
}
- (NSArray<JHMsgCenterModel *> *)getcenterList {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSArray *list = self.sessionManager.sessionList;
    for (JHSessionModel *session in list) {
        JHMsgCenterModel *model = [self getCenterModel:session];
        [arr addObject:model];
    }
    return arr;
}
- (JHMsgCenterModel *)queryCenterModel : (JHSessionModel *)session {
    NSArray *arr = [self.dataArray jh_filter:^BOOL(id  _Nonnull obj, NSUInteger idx) {
        JHMsgCenterModel *model = (JHMsgCenterModel *)obj;
        return [model.receiveAccount isEqualToString:session.receiveAccount];
    }];
    
    return arr.lastObject;
}
#pragma mark - LAZY
- (JHSessionListManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [JHSessionListManager sharedManager];
    }
    return _sessionManager;
}
- (RACReplaySubject *)reloadDataSubject {
    if (!_reloadDataSubject) {
        _reloadDataSubject = [RACReplaySubject subject];
    }
    return _reloadDataSubject;
}
@end
