//
//  JHCustomizeStuffDetailController.h
//  TTjianbao
//
//  Created by jiangchao on 2020/12/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"
#import "JHMeterialsCategoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeStuffDetailController : JHBaseViewExtController
@property (nonatomic, copy) JHFinishBlock saveBlock; //保存完成回调
@end

NS_ASSUME_NONNULL_END
