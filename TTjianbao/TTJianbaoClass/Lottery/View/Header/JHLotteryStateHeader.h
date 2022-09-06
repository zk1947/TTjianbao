//
//  JHLotteryStateHeader.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  0元抽奖 - 状态header视图
//

#import <UIKit/UIKit.h>
#import "JHLotteryModel.h"
#import "JHLotteryHomeInfoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLotteryStateHeader : UIView

///点击按钮进行活动状态事件处理： 0-未参与  1-参与未分享  2-分享未助力 3-分享满
@property (nonatomic, copy) void (^activityStateEventBlock) (NSInteger type);


///活动数据
@property (nonatomic, strong) JHLotteryActivityData *curData;
///当前抽奖码数量
@property (nonatomic, assign) NSInteger codeCount;

- (void)setActivityData:(JHLotteryActivityData *)data codeCount:(NSInteger)codeCount;

@property (nonatomic, copy) dispatch_block_t reloadBlock;

@end

NS_ASSUME_NONNULL_END
