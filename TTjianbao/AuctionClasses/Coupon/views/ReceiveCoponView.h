//
//  ReceiveCoponView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/3/3.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTjianbaoMarcoKeyword.h"

@class CoponPackageMode;

@interface ReceiveCoponView : UIControl
@property (nonatomic, copy) JHActionBlock buttonClick;
@property (nonatomic, copy) CoponPackageMode *mode;
@property (nonatomic, copy) JHFinishBlock block;
- (void)show;
- (void)dismiss;
@end

