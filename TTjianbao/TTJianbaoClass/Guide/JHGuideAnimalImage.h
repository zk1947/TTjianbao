//
//  JHGuideAnimalImage.h
//  TTjianbao
//  Description:JHBaseViewExtController中动画引导拆分到此
//  Created by Jesse on 2020/11/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHGuideAnimalImage : NSObject

- (void)animalImageWithSuperView:(UIView*)viewOfSuper;
- (void)animalImageWithTips:(NSString *)tips superView:(UIView*)viewOfSuper;
@end

NS_ASSUME_NONNULL_END
