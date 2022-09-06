//
//  JHBankCardManagerViewController.h
//  TTjianbao
//
//  Created by 张坤 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHBankCardModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^JHBankCardManagerBlock)(JHBankCardModel *bankCardModel);
@interface JHBankCardManagerViewController : JHBaseViewController
@property(nonatomic, copy) JHBankCardManagerBlock bankCardManagerBlock;
@end

NS_ASSUME_NONNULL_END
