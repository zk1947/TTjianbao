//
//  JHOrderExportSuccessView.h
//  TTjianbao
//
//  Created by jiang on 2019/8/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderExportSuccessView : BaseView
@property (nonatomic, assign)   BOOL isSuccess;
@property (nonatomic, copy)  JHFinishBlock handle;
@end

NS_ASSUME_NONNULL_END
