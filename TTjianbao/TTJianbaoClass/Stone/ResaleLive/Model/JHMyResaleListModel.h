//
//  JHMyResaleListModel.h
//  TTjianbao
//  Description:用户-我的回血,不需要传直播间id-列表，该页面有取消寄售操作 +已完成
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsRespModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMyResaleListModel : JHGoodsExtModel

@end

@interface JHMyResaleListReqModel : JHReqModel

@property (nonatomic, assign) NSUInteger pageIndex;// (integer, optional),
@property (nonatomic, assign) NSUInteger pageSize;// (integer, optional)
@end

//用户-回血直播间-我的寄售-取消寄售
@interface JHCancelResaleReqModel : JHReqModel //无需返回model

@property (nonatomic, strong) NSString* channelCategory;// (string): 直播间类型：roughOrder-原石直播间、restoreStone-回血直播间
@property (nonatomic, strong) NSString* channelId;// (integer): 直播间ID ,
@property (nonatomic, strong) NSString* stoneRestoreId;// (integer): 原石回血ID

//请求:取消寄售
+ (void)requestCancelWithStoneId:(NSString*)mid channelId:(NSString*)channelId channelCategory:(NSString*)channelCategory fail:(JHFailure)failre;
@end

NS_ASSUME_NONNULL_END
