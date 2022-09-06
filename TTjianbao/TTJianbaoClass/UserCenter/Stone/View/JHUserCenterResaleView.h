//
//  JHUserCenterResaleView.h
//  TTjianbao
//
//  Created by Jesse on 2019/11/25.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSegmentPageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUserCenterResaleView : JHSegmentPageView

//设置选中index
@property (nonatomic, assign) NSUInteger selectedIndex;

- (void)drawSubviews:(NSString*)mChannelId;
@end

NS_ASSUME_NONNULL_END
