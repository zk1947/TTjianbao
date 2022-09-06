//
//  CSearchKeyModel.h
//  Cooking-Home
//
//  Created by Wuyd on 2018/7/15.
//  Copyright © 2018 Wuyd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CSearchKeyData;
@class JHHotWordModel;

NS_ASSUME_NONNULL_BEGIN

@interface CSearchKeyModel : NSObject

@property (nonatomic, strong) NSMutableArray <JHHotWordModel*>*hotList; //热门搜索
@property (nonatomic, strong) NSMutableArray <CSearchKeyData*>*historyList; //历史搜索

/** 读取历史搜索 */
+ (NSArray *)loadHistoryList;

/** 保存历史搜索 */
+ (void)saveHistoryData:(CSearchKeyData *)data;

/** 删除所有历史搜索 */
+ (void)removeAllHistory;

@end


#pragma mark -
#pragma mark -
@interface CSearchKeyData : NSObject
@property (nonatomic, copy) NSString *keyword;
@end


NS_ASSUME_NONNULL_END
