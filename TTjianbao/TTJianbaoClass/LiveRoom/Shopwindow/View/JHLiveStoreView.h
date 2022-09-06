//
//  JHLiveStoreView.h
//  TTjianbao
//
//  Created by YJ on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,JHLiveStoreViewType){
    JHLiveStoreViewTypeUser,            //用户
    JHLiveStoreViewTypeSaler,           //主播
};

@interface JHLiveStoreView : UIView

- (instancetype)initWithType:(JHLiveStoreViewType)type channel:(ChannelMode * __nullable)channel;

@end

NS_ASSUME_NONNULL_END
