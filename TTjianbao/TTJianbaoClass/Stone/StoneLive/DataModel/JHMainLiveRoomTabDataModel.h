//
//  JHMainLiveRoomTabDataModel.h
//  TTjianbao
//  Description:主播直播间tab~data model
//  Created by Jesse on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHMainLiveRoomTabType)
{
    JHMainLiveRoomTabTypeLastSale,       //最近售出
    JHMainLiveRoomTabTypeWillSale,      //待上架原石
    JHMainLiveRoomTabTypeToSee,    //宝友求看
    JHMainLiveRoomTabTypeOffSale,     //宝友下架
    JHMainLiveRoomTabTypeResaleStoneTab,     //独立tab：寄售原石
    JHMainLiveRoomTabTypeResaleStone,     //独立controller：寄售原石
    JHMainLiveRoomTabTypeWillSaleFromUserCenter      //复用一下：主播-个人中心-待上架-列表
};

@protocol JHMainLiveRoomTabDataDelegate <NSObject>

@optional
- (void)responsePage:(JHMainLiveRoomTabType)type error:(NSString*)errorMsg;

@end

@interface JHMainLiveRoomTabDataModel : NSObject

@property (nonatomic, weak) id<JHMainLiveRoomTabDataDelegate>delegate;
@property (nonatomic, strong, readonly) NSMutableArray* dataArray;

//根据类型发送请求
- (void)requestByPage:(JHMainLiveRoomTabType)type channelId:(NSString*)mChannelId pageIndex:(NSUInteger)index keyword:(NSString*)keyword;
//本地查询上架状态,补充到数据数组
- (void)queryWillSaleOnshelfState:(JHMainLiveRoomTabType)type stoneId:(NSString*)stoneId;
@end

NS_ASSUME_NONNULL_END
