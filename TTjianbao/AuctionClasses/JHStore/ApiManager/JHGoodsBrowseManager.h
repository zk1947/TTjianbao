//
//  JHGoodsBrowseManager.h
//  TTjianbao
//
//  Created by lihui on 2020/2/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHStasticsModel : NSObject

@property (nonatomic, copy) NSString *itemId;// 商品唯一标识
@property (nonatomic, assign) NSTimeInterval startTime;

@end

@interface JHGoodsBrowseManager : NSObject


//@property (nonatomic, copy) NSString *entryType;
@property (nonatomic, copy) NSString *entryType;
@property (nonatomic, assign) BOOL isTiming;  ///是否正在计时

///开启定时器
- (void)startTimer;

///暂停定时器
- (void)stopTimer;

///关闭定时器
- (void)invalidateTimer;

- (void)addGoodsItem:(NSString *)goodsId;
- (void)removeGoodsItem:(NSString *)goodsId;

///刷新数据前上报
- (void)uploadRecordBeforeRefresh;
///关闭页面前上报
- (void)uploadRecoredBeforeClose;

@end

NS_ASSUME_NONNULL_END
