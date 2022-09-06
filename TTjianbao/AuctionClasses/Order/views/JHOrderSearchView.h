//
//  JHOrderSearchView.h
//  TTjianbao
//
//  Created by jiang on 2019/11/3.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTjianbaoBussiness.h"

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderSearchView : BaseView
@property (nonatomic, copy)JHActionBlocks handle;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
