//
//  JHResaleLiveRoomStretchView.h
//  TTjianbao
//
//  Created by Jesse on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHResaleLiveRoomTabView.h"

#define kResaleLiveShrinkHeight (121+23+UI.bottomSafeAreaHeight)

NS_ASSUME_NONNULL_BEGIN

@interface JHResaleLiveRoomStretchView : BaseView

- (void)drawSubviews:(NSString*)mChannelId action:(JHActionBlock)action;
- (void)setTabViewRedDotNum:(NSUInteger)num withIndex:(NSUInteger)index clickAction:(nullable JHActionBlock)action;
- (void)refreshTable;

@end

NS_ASSUME_NONNULL_END
