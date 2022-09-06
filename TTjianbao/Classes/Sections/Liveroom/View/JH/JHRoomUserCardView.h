//
//  JHRoomUserCardView.h
//  TTjianbao
//  Description:飞单
//  Created by mac on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPopBaseView.h"
#import "NTESMicConnector.h"
NS_ASSUME_NONNULL_BEGIN
@class NTESMessageModel;

typedef NS_ENUM(NSInteger,RoomUserCardViewType){
    RoomUserCardViewTypeNormal,
    RoomUserCardViewTypeCustomize,//定制
    RoomUserCardViewTypeRecycle,  //回收
};

@interface JHRoomUserCardView : JHPopBaseView

@property (nonatomic, strong) NTESMessageModel *model;
//@property (nonatomic, copy) JHActionBlock clickImage;
@property (copy, nonatomic) NSString *anchorId;
//@property (copy, nonatomic) NSString *customerId;
@property (copy, nonatomic) NSString *roomId;
//@property (copy, nonatomic, nullable) NSString *biddingId;
//@property (assign, nonatomic) BOOL isLaughOrder;//哄场单
@property (assign, nonatomic) BOOL isAssistant;//助理
//@property (assign, nonatomic) BOOL isAnction;//创建竞拍
@property (nonatomic, copy) JHActionBlock auctionUploadFinish;
@property (nonatomic, copy) JHActionBlock sendWish;
@property (nonatomic, copy) JHActionBlock topAction;
@property (nonatomic, copy) JHActionBlocks orderAction;
@property (nonatomic, copy) JHActionBlock laughOrderAction;

@property (strong, nonatomic) NSMutableArray *tagArray;
@property (nonatomic, assign) RoomUserCardViewType cardType;
//是否可以发定制单:意向单&服务单

- (instancetype)initFromCustomize;
- (void)canSendCustomizeOrder:(NTESMicConnector *)connector;


@end

NS_ASSUME_NONNULL_END
