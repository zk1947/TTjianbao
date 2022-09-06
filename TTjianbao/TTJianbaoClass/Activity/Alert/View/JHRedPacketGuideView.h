//
//  JHRedPacketGuideView.h
//  TTjianbao
//
//  Created by apple on 2020/2/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRedPacketGuideModel.h"
#import "JHAPPAlertBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRedPacketGuideView : JHAPPAlertBaseView

+(void)showRedPacketGuideWithModel:(JHRedPacketGuideModel *)model removeBlock:(dispatch_block_t)removeBlock;

/// 主播不显示
+ (BOOL)isAnchor;

@end

NS_ASSUME_NONNULL_END
