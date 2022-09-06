//
//  JHMarketOrderListViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketOrderListViewController : JHBaseViewController
/** 0=我发布的, 1=我买到的, 2=我卖出的*/
@property (nonatomic, copy) NSString *outItemIndex;
/** 0=出售中, 1=已下架*/
@property (nonatomic, copy) NSString *innerItemIndex;
@end

NS_ASSUME_NONNULL_END
