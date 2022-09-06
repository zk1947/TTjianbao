//
//  JHLiveAnimationView.h
//  TTjianbao
//
//  Created by LiHui on 2020/3/6.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YYControl.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,JHLiveAnimationSourceType) {
    JHLiveAnimationSourceTypeImg,
    JHLiveAnimationSourceTypeURL,
    JHLiveAnimationSourceTypeGif,
};

@interface JHLiveAnimationView : YYControl

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, assign) JHLiveAnimationSourceType sourceType;




@end

NS_ASSUME_NONNULL_END
