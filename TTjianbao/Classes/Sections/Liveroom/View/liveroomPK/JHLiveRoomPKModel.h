//
//  JHLiveRoomPKModel.h
//  TTjianbao
//
//  Created by apple on 2020/8/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHLiveRoomPKUserModel : NSObject
@property (nonatomic, strong) NSString *headImg;
@property (nonatomic, strong) NSString *rankTip;
@property (nonatomic, strong) NSString *ranking;
@end

@interface JHLiveRoomPKInfoModel : NSObject
@property (nonatomic, strong) NSString *ranking;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *increase;
@property (nonatomic, strong) NSString *isOpen;
@property (nonatomic, strong) NSString *rankTip;
@property (nonatomic, strong) NSString *channelId;
@end

@interface JHLiveRoomPKModel : NSObject
@property (nonatomic, strong) JHLiveRoomPKUserModel *user;
@property (nonatomic, strong) JHLiveRoomPKInfoModel *channel;
@property (nonatomic, copy) NSString *summaryTitle;
@property (nonatomic, strong) NSMutableArray <JHLiveRoomPKInfoModel *>*summaryRanking;
@property (nonatomic, copy) NSString *increaseTitle;
@property (nonatomic, strong) NSMutableArray <JHLiveRoomPKInfoModel *>*increaseRanking;
@property (nonatomic, copy) NSString *fansTitle;
@property (nonatomic, strong) NSMutableArray <JHLiveRoomPKInfoModel *>*fansRanking;

+ (void)requestEditDetailWithId:(NSString *)channelId successBlock:(void(^)(RequestModel * _Nonnull reqModel))succBlock failBlock:(void(^)(RequestModel * _Nonnull reqModel))failBlock;

@end

@interface JHLiveRoomPKCategoryModel : NSObject
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *rankName;
+ (void)requestPKCategory:(NSString *)channelId successBlock:(void(^)(NSString * _Nonnull category,NSString * _Nonnull rankName))succBlock;
@end

NS_ASSUME_NONNULL_END
