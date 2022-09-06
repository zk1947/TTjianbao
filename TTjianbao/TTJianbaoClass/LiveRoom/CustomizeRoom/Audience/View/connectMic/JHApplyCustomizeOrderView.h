//
//  JHApplyCustomizeOrderView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/9/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHApplyCustomizeOrderView : UIView
@property(nonatomic,copy)JHFinishBlock cameraBlock;
@property(nonatomic,copy)JHActionBlock clickBlock;
@property(nonatomic,strong) NSMutableArray<OrderMode *> * dataModes;
@end

NS_ASSUME_NONNULL_END
