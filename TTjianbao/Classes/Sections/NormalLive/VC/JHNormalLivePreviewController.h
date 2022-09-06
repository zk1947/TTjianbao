//
//  JHNormalLivePreviewController.h
//  TTjianbao
//  Description:卖场直播间>直播卖货、回血主播>pre开始直播
//  Created by jiang on 2019/9/2.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NMCLiveStreaming/NMCLiveStreaming.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNormalLivePreviewController : JHBaseViewController
/**
 0 直播鉴定(appraise) 1 直播卖货(sell), 还有偷窥者：sell_hide \ appraise_hide
 */
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
