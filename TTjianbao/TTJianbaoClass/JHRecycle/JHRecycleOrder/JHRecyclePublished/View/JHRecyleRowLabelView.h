//
//  JHRecyleRowLabelView.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecyleRowLabelView : BaseView

// 设定箭头的初始位置
- (void)drawArrowWithPoint:(CGFloat )beginPointX;
/** 小贴士*/
@property (nonatomic, strong) YYLabel *tipsLabel;

/** 背景色*/
@property (nonatomic, strong) UIColor *tipsbackColor;
@end

NS_ASSUME_NONNULL_END
