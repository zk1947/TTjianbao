//
//  JHCustomizeGuideTipView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/12/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHNewGuideTipsView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeGuideTipView : UIView
- (void)showGuideWithType:(JHTipsGuideType)type transparencyRect:(CGRect)rect;
@property(nonatomic,copy)JHFinishBlock  disMissHandle;
@end

NS_ASSUME_NONNULL_END
