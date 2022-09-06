//
//  JHBuyAppraiseVideoController.h
//  TTjianbao
//  购物鉴定小视频
//  Created by wangjianios on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class JHBuyAppraiseModel;

@protocol JHBuyAppraiseVideoControllerDelegate <NSObject>

///获取更多数据
- (void)requestMoreAppraiseData:(void(^)(NSArray <JHBuyAppraiseModel *>*_Nullable videoArray))completateBlock;

@end

static NSString *const kbuyAppraiseVideoDetailIdentifer = @"kbuyAppraiseVideoDetailIdentifer";

///  购物鉴定小视频
@interface JHBuyAppraiseVideoController : JHBaseViewController
@property (nonatomic, weak) id<JHBuyAppraiseVideoControllerDelegate>delegate;
///当前展示的视频
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) NSArray <JHBuyAppraiseModel *>*appraiseArray;
///返回上个页面时需要确定滑动到哪个视频
@property (nonatomic, copy) void(^backBlock)(NSInteger currentIndex);
///请求数据的参数
@property (nonatomic, copy) NSDictionary *paramaters;
- (void)playTheIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
