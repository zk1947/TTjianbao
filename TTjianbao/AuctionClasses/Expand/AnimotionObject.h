//
//  AnimotionObject.h
//  TTjianbao
//
//  Created by mac on 2019/6/5.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnimotionObject : NSObject
+ (CABasicAnimation *)scaleAnimationFrom:(CGFloat)from to:(CGFloat)to begintime:(CGFloat)beginTime;
+ (CAAnimationGroup *)beginAnimationGroup;
+ (CAAnimationGroup *)shakeAnimalGroup;
@end

NS_ASSUME_NONNULL_END
