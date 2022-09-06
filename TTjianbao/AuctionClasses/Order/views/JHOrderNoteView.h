//
//  JHOrderNoteView.h
//  TTjianbao
//
//  Created by jiang on 2019/10/8.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderNoteView : BaseView
@property (nonatomic, strong) OrderMode * orderMode;
@end

NS_ASSUME_NONNULL_END
