//
//  JHEditPriceViewController.h
//  TTjianbao
//
//  Created by yaoyao on 2019/12/9.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHEditPriceViewController : JHBaseViewExtController
@property (nonatomic, copy) NSString *stoneId;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) JHActionBlock baseFinishBlock;
@end

NS_ASSUME_NONNULL_END
