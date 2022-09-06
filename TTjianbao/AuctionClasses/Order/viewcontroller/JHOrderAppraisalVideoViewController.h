//
//  JHOrderAppraisalVideoViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2019/2/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NELivePlayerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderAppraisalVideoViewController : NELivePlayerViewController
- (instancetype)initWithStreamUrl:(NSString *)url;
@property (nonatomic, assign)NSInteger from;//6是商家回放列表 其他都是鉴定报告
@property (nonatomic, copy)NSString *videoId;
@property (nonatomic, copy)NSString *liveId;

@end

NS_ASSUME_NONNULL_END
