//
//  JHStoneSendGoodsViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoneSendGoodsViewController : JHBaseViewController
@property(nonatomic,strong) NSString *goodId;
@property(strong,nonatomic)JHActionBlock sendSuccessBlock;
@end

NS_ASSUME_NONNULL_END
