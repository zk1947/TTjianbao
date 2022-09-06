//
//  JHCateUnfoldView.h
//  TTjianbao
//
//  Created by jiang on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCateMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCateUnfoldView : UIView
@property (nonatomic, copy) NSArray<VideoCateMode *> *titles;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, copy) JHActionBlock buttonClick;
@end

NS_ASSUME_NONNULL_END
