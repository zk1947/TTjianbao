//
//  JHUserCenterResaleDataModel.h
//  TTjianbao
//
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JHResaleSubPageType)
{
    JHResaleSubPageTypeBuyPrice,    //买家出价
    JHResaleSubPageTypeOnSale,      //在售原石
    JHResaleSubPageTypeSold,        //已售原石
};

NS_ASSUME_NONNULL_BEGIN

@protocol JHUserCenterResaleDataDelegate <NSObject>

@optional
- (void)responseData:(NSMutableArray*)dataArray error:(NSString*)errorMsg;

@end

@interface JHUserCenterResaleDataModel : NSObject

@property (nonatomic, weak) id<JHUserCenterResaleDataDelegate>delegate;
@property (nonatomic, strong) NSString* total;//总数
@property (nonatomic, strong) NSString* totalPrice;//总价

//根据类型发送请求
- (void)requestByPage:(JHResaleSubPageType)type channelId:(NSString*)mChannelId pageIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END

