//
//  OrderDateChooseView.h
//  TTjianbao
//
//  Created by jiang on 2019/8/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^OrderDatePickerHandler)( NSString * begin ,  NSString * end );

@interface OrderDateChooseView : BaseView
@property(strong,nonatomic)OrderDatePickerHandler handle;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
