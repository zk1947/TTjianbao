//
//  JHResaleLiveRoomTabDataModel.h
//  TTjianbao
//
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JHResaleLiveRoomTabType)
{
    JHResaleLiveRoomTabTypeStoneResale,       //原石回血
    JHResaleLiveRoomTabTypeOnSale,      //在售原石/我的寄售/我的回血
    JHResaleLiveRoomTabTypeBuyPrice,    //买家出价
    JHResaleLiveRoomTabTypeMyPrice,     //我的出价
};

NS_ASSUME_NONNULL_BEGIN

@protocol JHResaleLiveRoomTabDataDelegate <NSObject>

@optional
- (void)responseData:(NSMutableArray*)dataArray error:(NSString*)errorMsg;

@end

@interface JHResaleLiveRoomTabDataModel : NSObject

@property (nonatomic, weak) id<JHResaleLiveRoomTabDataDelegate>delegate;
@property (nonatomic, strong, readonly) NSMutableArray* dataArray;

//根据类型发送请求
- (void)requestByPage:(JHResaleLiveRoomTabType)type channelId:(NSString*)mChannelId pageIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
