//
//  JHGradientView.h
//  TTjianbao
//  Description:渐变view & line~~~
//  Created by Jesse on 2020/8/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JHGradientOrientation)
{
    JHGradientOrientationDefault,
    JHGradientOrientationHorizontal = JHGradientOrientationDefault,
    JHGradientOrientationVertical,
};

NS_ASSUME_NONNULL_BEGIN

//默认横向渐变
@interface JHGradientView : UIView
/**
 *1设置渐变色【从前到后】2渐变方向
 */
- (void)setGradientColor:(NSArray*)colors orientation:(JHGradientOrientation)orientation;
@end

NS_ASSUME_NONNULL_END
