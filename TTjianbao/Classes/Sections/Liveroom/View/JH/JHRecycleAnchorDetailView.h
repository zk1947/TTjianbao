//
//  JHRecycleAnchorDetailView.h
//  TTjianbao
//
//  Created by user on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHAnchorInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleAnchorDetailView : BaseView
- (void)refreshViewWithChannelLocalId:(NSString *)channelLocalId
                             roleType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
